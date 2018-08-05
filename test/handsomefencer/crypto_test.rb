require "test_helper"

describe Handsomefencer::Environment::Crypto do

  subject { Crypto }

  Given { ENV["DEPLOY_PASSWORD"] = "deploy8key8from8environment88var" }
  Given(:deploy_key) { { key: "0"*32} }

  describe "self.get_master_key" do

    describe "when set" do

      Given(:expected) { "railsmasterkeyfromenvvariable111" }
      Given { ENV["RAILS_MASTER_KEY"] = expected }

      Then { Crypto.get_master_key.must_match expected }
    end

    describe "when not set" do

      Given(:expected) { "railsmasterkeyfrommasterkeyfile" }
      Given { ENV["RAILS_MASTER_KEY"] = nil }

      Then { Crypto.get_master_key.must_match expected }
    end
  end

  describe "self.get_key(options)" do

    describe "default" do

      Given { ENV["RAILS_MASTER_KEY"] = nil }
      Given(:master_key_from_file) { File.read('config/master.key').strip }

      Then { Crypto.get_key.must_equal master_key_from_file}
    end

    describe "with 'key_file' option" do

      Given(:some_key_file) { 'config/secondary_encrypted.key'}

      Then { Crypto.get_key(key_file: some_key_file).must_equal "somerandomkey"}
    end

    describe "with environment variable argument" do

      describe "when previously set" do

        Given(:expected) { ENV["DEPLOY_PASSWORD"] }

        Then { Crypto.get_key(key_var: "DEPLOY_PASSWORD").must_match expected}
      end
    end
  end

  describe "must encrypt and decrypt a string " do

    describe "default" do

      Given(:encrypted)  { Crypto.new("message").encrypt }

      Then { Crypto.new(encrypted).decrypt.must_equal "message" }
    end

  #   describe "with key argument" do
  #
  #     Given(:encrypted) { Crypto.new("message", deploy_key).encrypt }
  #
  #     Then { Crypto.new(encrypted, deploy_key).decrypt.must_equal "message" }
  #
  #     describe "with wrong key on decrypt" do
  #
  #       Given(:expected_error) { "OpenSSL::Cipher::CipherError" }
  #       Given(:called_with) { Crypto.new(encrypted, key: "wrongkey").decrypt }
  #
  #       Then { assert_raises(expected_error) { called_with } }
  #     end
  #   end
  end

  describe "encrypt and decrypt a file" do
before { skip }
    describe "default" do

      # Given { File.delete('.env/circle.env.enc') }
      describe "#encrypt_file" do
        # Given(:file) { '.env/circle.env.enc' }
        # Given { File.delete(file) if File.exist?(file) }
        # Given { refute File.exist? '.env/circle.env.enc' }
        # Given { FileUtils.cp('.env/circle.env', '.env/backup.env') }
        Given { Crypto.new('.env/circle.env').encrypt_file }

        Then { assert File.exist? '.env/circle.env.enc' }

        describe "#decrypt_file" do

          Given { Crypto.new('.env/circle.env').decrypt_file }
          Given(:actual) { File.read('.env/circle.env') }
          Given(:expected) { File.read('.env/backup.env') }
          Then { assert_equal actual, expected }
        end
      end
    end

    describe "specified key" do

      describe "#encrypt_file" do
before { skip }
        Given { Crypto.new('.env/circle.env').encrypt_file }
        Given { Crypto.new('.env/backup.env', key: "2"*32).encrypt_file }
        Given(:encrypted1) { File.read('.env/circle.env.enc').strip }
        Given(:encrypted2) { File.read('.env/backup.env.enc').strip }

        Then  { refute_equal encrypted1, encrypted2 }

        describe "#decrypt_file" do

          Given { FileUtils.cp('.env/circle.env', '.env/backup.env') }
          Given { FileUtils.cp('.env/circle.env.enc', '.env/backup.env.enc') }
          Given { Crypto.new('.env/circle.env.enc').decrypt_file }

          Then { assert File.exist? '.env/circle.env' }
          And  { assert File.exist? '.env/backup.env.enc' }

          describe "with different key" do

            Given { Crypto.new(encrypted_file, key: "wrong").decrypt_file }
            Given(:actual) { File.read('.env/circle.env.enc') }
            Given(:expected) { File.read('.env/backup.env.enc') }
            # Then { refute_match actual, expected }
          end
        end
      end

      # before { skip }
      describe "unencrypted file contents must match decrypted file contents" do

        # Given(:expected) { File.read(unencrypted_file) }
        # Given(:actual) { File.read('.env/circle.env') }
        #
        # Then { assert_equal actual, expected }
      end
    end

    describe "specified key" do

      before { skip }
      describe "#encrypt_file" do

        Given { Crypto.new(unencrypted_file).encrypt_file }

        Then { assert File.exist? '.env/circle.env.enc' }

        describe "#decrypt_file" do

          Given { Crypto.new(encrypted_file, key).decrypt_file }
          Then { assert File.exist? '.env/circle.env' }
        end
      end

      describe "unencrypted file contents must match decrypted file contents" do

        Given(:expected) { File.read('.env/circle.env') }
        Given(:actual) { File.read('.env/circle.env') }

        Then { assert_equal actual, expected }
      end
    end
  end

  # describe "obfuscate variables" do
  #
  #   describe "source_environment_files" do
  #
  #     describe "with default directory" do
  #
  #       Given(:first_level_file) { '.env/circle.env' }
  #       Given(:second_level_file) { '.env/development/web.env' }
  #       Given(:expected_files) { Crypto.source_environment_files }
  #
  #       Then { expected_files.must_include first_level_file }
  #       And { expected_files.must_include second_level_file }
  #     end

  #     describe "with specified directory" do
  #
  #       Given(:first_level_file) { dummy_local + '/circle.env' }
  #       Given(:second_level_file) { dummy_local + '/development/web.env'}
  #       Given(:actual) { Crypto.source_environment_files(dummy_local) }
  #
  #       Then { actual.must_include first_level_file }
  #       And { actual.must_include second_level_file }
  #     end
  #   end
  #
  #   describe "self.obfuscate()" do
  #
  #     describe "default behavior" do
  #
  #       Given(:first_level_file) { '.env/circle.env.enc' }
  #       Given(:second_level_file) { '.env/development/web.env.enc'}
  #
  #       When { Crypto.obfuscate }
  #
  #       Then { assert File.exist? first_level_file }
  #       And  { assert File.exist? second_level_file }
  #     end
  #
  #     describe "with key from environment" do
  #
  #       Given(:first_level_file) { '.env/circle.env.enc' }
  #       Given(:second_level_file) { '.env/development/web.env.enc'}
  #
  #       When { Crypto.obfuscate(nil, key: "DEPLOY_PASSWORD") }
  #
  #       Then { assert File.exist? first_level_file }
  #       And  { assert File.exist? second_level_file }
  #     end
  #
  #     describe "with specified directory" do
  #
  #       Given(:first_level_file) { dummy_local + '/circle.env.enc' }
  #       Given(:second_level_file) { dummy_local + '/development/web.env.enc'}
  #       Given { Crypto.obfuscate(dummy_local) }
  #
  #       Then { assert File.exist? first_level_file }
  #       And  { assert File.exist? second_level_file }
  #     end
  #
  #     describe "with specified directory" do
  #
  #       Given(:first_level_file) { dummy_local + '/circle.env.enc' }
  #       Given(:second_level_file) { dummy_local + '/development/web.env.enc'}
  #       Given { Crypto.obfuscate(dummy_local, key: "DEPLOY_PASSWORD") }
  #
  #       Then { assert File.exist? first_level_file }
  #       And  { assert File.exist? second_level_file }
  #     end
  #   end
  # end
  #
  # Given(:dummy_server) { 'test/dummy/server/.env' }
  #
  # describe "expose variables" do
  #
  #   describe "self.source_encrypted_files()" do
  #
  #     describe "default" do
  #
  #       Given(:file1) { '.env/circle.env.enc' }
  #       Given(:file2) { '.env/development/web.env.enc' }
  #       Given(:file3) { '.env/development/database.env.enc' }
  #
  #       When { Crypto.source_encrypted_files }
  #
  #       Then { assert File.exist? file1 }
  #       And  { assert File.exist? file2 }
  #       And  { assert File.exist? file3 }
  #     end
  #
  #     describe "with specified directory" do
  #
  #       Given(:file1) { dummy_server + '/circle.env.enc' }
  #       Given(:file2) { dummy_server + '/development/web.env.enc' }
  #       Given(:file3) { dummy_server + '/development/database.env.enc' }
  #
  #       Given(:actual) { Crypto.source_encrypted_files(dummy_server) }
  #
  #       Then { assert File.exist? file1 }
  #       And  { assert File.exist? file2 }
  #       And  { assert File.exist? file3 }
  #     end
  #   end
  #
  #   describe "self.expose()" do
  #
  #     describe "default" do
  #
  #       Given(:file1) { '.env/circle.env' }
  #       Given(:file2) { '.env/development/web.env' }
  #       Given(:file3) { '.env/development/database.env' }
  #
  #       When { Crypto.expose }
  #
  #       Then { assert File.exist? file1 }
  #       And  { assert File.exist? file2 }
  #       And  { assert File.exist? file3 }
  #     end
  #
  #     describe "with specified directory" do
  #
  #       Given(:file1) { dummy_server + '/circle.env' }
  #       Given(:file2) { dummy_server + '/development/web.env' }
  #       Given(:file3) { dummy_server + '/development/database.env' }
  #
  #       Given { Crypto.expose(dummy_server) }
  #
  #       Then { assert File.exist? file1 }
  #       And  { assert File.exist? file2 }
  #       And  { assert File.exist? file3 }
  #     end
  #
  #     describe "with specified directory" do
  #
  #       Given(:file1) { dummy_server + '/circle.env' }
  #       Given(:file2) { dummy_server + '/development/web.env' }
  #       Given(:file3) { dummy_server + '/development/database.env' }
  #
  #       Given { Crypto.expose(dummy_server, key: "nonexiss") }
  #
  #       Then { assert File.exist? file1 }
  #       And  { assert File.exist? file2 }
  #       And  { assert File.exist? file3 }
  #     end
  #   end
  # end
  #
  Minitest.after_run do
    hash = {
      "test/dummy/local" => "env.enc",
      "test/dummy/server" => "env",
      "." => "env.enc"}
    hash.each do |key, value|
      Dir.glob("#{key}/.env/**/*.#{value}").each { |f| File.delete(f)}
    end
  end
end
