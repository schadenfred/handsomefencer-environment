require "test_helper"

describe Handsomefencer::Environment::Crypto do

  subject { Crypto }

  describe "base methods" do

    Given(:instantiated) { Crypto.new("message") }

    describe "#get_master_key" do

      Then { instantiated.get_master_key.length.must_equal 32}
    end

    describe "#get_key(key_file)" do

      Given(:some_key_file) { 'config/secondary_encrypted.key'}
      When(:instantiated) { Crypto.new("message", key: some_key_file ) }

      Then { instantiated.get_key(some_key_file).length.must_equal 32}
    end
  end

  describe "must encrypt and decrypt a string " do

    Given(:encrypted)  { Crypto.new("message").encrypt }

    Then { Crypto.new(encrypted).decrypt.must_equal "message" }
  end

  Given(:unencrypted_file) { '.env/circle.env' }
  Given(:encrypted_file) { '.env/circle.env.enc' }

  describe "must encrypt and decrypt a file" do

    Given { Crypto.new(unencrypted_file).encrypt_file }

    describe "encrypt must create an encrypted file .env.enc" do

      Then { assert File.exist? '.env/circle.env.enc' }
    end

    describe "decrypt must create a decrypted file .env" do

      Given { Crypto.new(encrypted_file).decrypt_file }

      Then { assert File.exist? '.env/circle.env' }

      describe "unencrypted file contents must match decrypted file contents" do

        Given(:expected) { File.read('.env/circle.env') }
        Given(:actual) { File.read('.env/circle.env') }

        Then { assert_equal actual, expected }
      end
    end
  end

  Given(:dummy_local) { 'test/dummy/local/.env' }

  describe "obfuscate variables" do

    describe "source_environment_files" do

      describe "with default directory" do

        Given(:first_level_file) { '.env/circle.env' }
        Given(:second_level_file) { '.env/development/web.env' }
        Given(:expected_files) { Crypto.source_environment_files }

        Then { expected_files.must_include first_level_file }
        And { expected_files.must_include second_level_file }
      end

      describe "with specified directory" do

        Given(:first_level_file) { dummy_local + '/circle.env' }
        Given(:second_level_file) { dummy_local + '/development/web.env'}
        Given(:actual) { Crypto.source_environment_files(dummy_local) }

        Then { actual.must_include first_level_file }
        And { actual.must_include second_level_file }
      end
    end

    describe "self.obfuscate()" do

      describe "default behavior" do

        Given(:first_level_file) { '.env/circle.env.enc' }
        Given(:second_level_file) { '.env/development/web.env.enc'}

        When { Crypto.obfuscate }

        Then { assert File.exist? first_level_file }
        And  { assert File.exist? second_level_file }
      end

      describe "with specified directory" do

        Given(:first_level_file) { dummy_local + '/circle.env.enc' }
        Given(:second_level_file) { dummy_local + '/development/web.env.enc'}
        Given { Crypto.obfuscate(dummy_local) }

        Then { assert File.exist? first_level_file }
        And  { assert File.exist? second_level_file }
      end
    end
  end

  Given(:dummy_server) { 'test/dummy/server/.env' }

  describe "expose variables" do

    describe "self.source_encrypted_files()" do

      describe "default" do

        Given(:file1) { '.env/circle.env.enc' }
        Given(:file2) { '.env/development/web.env.enc' }
        Given(:file3) { '.env/development/database.env.enc' }

        When { Crypto.source_encrypted_files }

        Then { assert File.exist? file1 }
        And  { assert File.exist? file2 }
        And  { assert File.exist? file3 }
      end

      describe "with specified directory" do

        Given(:file1) { dummy_server + '/circle.env.enc' }
        Given(:file2) { dummy_server + '/development/web.env.enc' }
        Given(:file3) { dummy_server + '/development/database.env.enc' }

        Given(:actual) { Crypto.source_encrypted_files(dummy_server) }

        Then { assert File.exist? file1 }
        And  { assert File.exist? file2 }
        And  { assert File.exist? file3 }
      end
    end

    describe "self.expose()" do

      describe "default" do

        Given(:file1) { '.env/circle.env' }
        Given(:file2) { '.env/development/web.env' }
        Given(:file3) { '.env/development/database.env' }

        When { Crypto.expose }

        Then { assert File.exist? file1 }
        And  { assert File.exist? file2 }
        And  { assert File.exist? file3 }
      end

      describe "with specified directory" do

        Given(:file1) { dummy_server + '/circle.env' }
        Given(:file2) { dummy_server + '/development/web.env' }
        Given(:file3) { dummy_server + '/development/database.env' }

        Given { Crypto.expose(dummy_server) }

        Then { assert File.exist? file1 }
        And  { assert File.exist? file2 }
        And  { assert File.exist? file3 }
      end
    end
  end

  Minitest.after_run do
    hash = {"local" => "env.enc", "server" => "env"}
    dir = "test/dummy"
    hash.each do |key, value|
      Dir.glob("#{dir}/#{key}/.env/**/*.#{value}").each { |f| File.delete(f)}
    end
  end
end
