require "test_helper"
require "readline"

describe Handsomefencer::Environment::Crypto do

  subject { Crypto.new }

  # Given(:file1) { '.env/circle.env' }
  # Given(:file2) { '.env/file2.env' }
  # Given(:file3) { '.env/file3.env' }
  # # Given(:file3) { '.env/development/backup.env' }
  #
  # Then { assert FileUtils.compare_file(file1, file2) }
  # And  { assert FileUtils.compare_file(file2, file3) }
  # #
  describe "" do
  #
  #   Given { subject.obfuscate }
  #   Given { subject.expose }
  #   Then  { assert true }
    # Then { assert FileUtils.compare_file(file1, file2) }
    # And  { assert FileUtils.compare_file(file2, file3) }

  end

  # def backups
  #   ['.env/backup.env', '.env/development/dbackup.env']
  #} end
  #
  # backups.each do |backup|
  #   FileUtils.copy('.env/circle.env', backup)
  # end
  #
  # def remove_artifact(file)
  #   if File.exist?(file)
  #     File.delete file
  #   end
  # end

  # Given { ENV["DEPLOY_PASSWORD"] = "deploykeyfromenvironmentvariable" }
  # Given(:deploy_key) { { key: "0"*32} }

  # describe "#get_master_key" do
  #
  #   describe "when set" do
  #
  #     Given(:expected) { "railsmasterkeyfromenvvariable111" }
  #     Given { ENV["RAILS_MASTER_KEY"] = expected }
  #
  #     Then { subject.get_master_key.must_match expected }
  #   end
  #
  #   describe "when not set" do
  #
  #     Given(:expected) { "railsmasterkeyfrommasterkeyfile" }
  #     Given { ENV["RAILS_MASTER_KEY"] = nil }
  #
  #     Then { subject.get_master_key.must_match expected }
  #   end
  # end
  #
  # describe "#get_password" do
  #
  #   describe "default" do
  #
  #     Given { ENV["RAILS_MASTER_KEY"] = nil }
  #     Given(:master_key_from_file) { File.read('config/master.key').strip }
  #
  #     Then { subject.get_password.must_equal master_key_from_file}
  #   end
  #
  #   describe "with :password" do
  #
  #     Given(:expected) { "some-long-safe-password"}
  #     Given(:subject) { Crypto.new(password: expected)}
  #
  #     Then { subject.get_password.must_equal expected }
  #   end
  #
  #   describe "with :password_file" do
  #
  #     Given(:some_password_file) { 'config/secondary_encrypted.key'}
  #     Given(:subject) { Crypto.new(password_file: some_password_file) }
  #
  #     Then { subject.get_password.must_equal "somerandomkey"}
  #   end
  #
  #   describe "with :env_var_password" do
  #
  #     describe "when set" do
  #
  #       Given(:expected) { ENV["DEPLOY_PASSWORD"] }
  #       Given(:subject) { Crypto.new(env_var_password: "DEPLOY_PASSWORD")}
  #
  #       Then { subject.get_password.must_match expected}
  #     end
  #   end
  # end

  # describe "must encrypt and decrypt a string " do
  #
  #   Given(:plaintext) { "get some" }
  #   Given(:encrypted) { subject.encrypt(plaintext) }
  #
  #   Then { refute_equal plaintext, encrypted }
  #   And  { assert_equal encrypted.encoding.to_s, "ASCII-8BIT" }
  #
  #   describe "decrypt" do
  #
  #     Given(:decrypted) { subject.decrypt(encrypted) }
  #
  #     Then { assert_equal decrypted, plaintext }
  #   end
  # end

  # describe "must encrypt and decrypt a file " do
  #
  #   Given(:plaintext_file) { '.env/circle.env' }
  #   Given(:backed_up_file) { '.env/backup.env' }
  #   Given(:decrypted_file) { '.env/backup.env' }
  #   Given(:encrypted_file) { '.env/backup.env.enc' }
  #   Given(:actual)   { File.read(decrypted_file) }
  #   Given(:expected) { File.read(plaintext_file) }
  #
  #   describe "default" do
  #
  #     describe "#encrypt" do
  #
  #       Given { subject.encrypt(backed_up_file) }
  #
  #       Then { assert File.exist? encrypted_file }
  #
  #       describe "decrypt" do
  #
  #         Given { File.delete(decrypted_file) }
  #
  #         When { subject.decrypt(encrypted_file) }
  #
  #         Then { assert File.exist? plaintext_file}
  #         And  { assert_equal actual, expected  }
  #       end
  #     end
  #   end
  #
  #   describe "with password" do
  #
  #     describe "#encrypt" do
  #
  #       Given(:password) { "some-random-password" }
  #       Given(:cipher_with_password) { Crypto.new(password: password) }
  #       Given { cipher_with_password.encrypt(backed_up_file) }
  #
  #       Then { assert File.exist? encrypted_file }
  #
  #       describe "#decrypt" do
  #
  #         describe "with correct password" do
  #
  #           Given { remove_artifact(decrypted_file) }
  #           Given { cipher_with_password.decrypt(encrypted_file) }
  #
  #           Then { assert File.exist? decrypted_file}
  #           And  { assert_equal actual, expected  }
  #         end
  #
  #         describe "without password raises error" do
  #
  #           Given(:expected_error) { OpenSSL::Cipher::CipherError }
  #           Given(:called_with) { subject.decrypt(encrypted_file) }
  #
  #           Then { assert_raises(expected_error) { called_with } }
  #         end
  #
  #         describe "wrong password raises error" do
  #
  #           Given(:wrongpass) { Crypto.new(password: "wrongpass") }
  #           Given(:expected_error) { OpenSSL::Cipher::CipherError }
  #           Given(:called_with) { wrongpass.decrypt(encrypted_file) }
  #
  #           Then { assert_raises(expected_error) { called_with } }
  #         end
  #       end
  #     end
  #   end
  # end

  # describe "#source_files" do
  #
  #   Given(:file1) { '.env/circle.env' }
  #   Given(:file2) { '.env/development/web.env' }
  #
  #   describe "default" do
  #
  #     Given(:expected_files) { subject.source_files('.env') }
  #
  #     Then { expected_files.must_include file1 }
  #     And  { expected_files.must_include file2 }
  #   end
  #
  #   describe "with specified directory" do
  #
  #     Given(:expected_files) { subject.source_files('.env', '.env') }
  #
  #     Then { expected_files.must_include file1 }
  #     And  { expected_files.must_include file2 }
  #   end
  # end

  describe "#obfuscate()" do

    # Given(:subject) { Crypto.new}

    # Given(:file1) { '.env/circle.env.enc' }
    # Given(:file2) { '.env/backup.env.enc' }
    # Given(:file3) { '.env/development/backup.env.enc'}

    # describe "default" do

      # Given { subject.obfuscate }
      # Given { subject.expose }
      #
      # Then { assert File.exist? file1 }
      # And  { assert File.exist? file2 }
      # And  { assert File.exist? file3 }
    # end

    # describe "directory" do
    #
    #   Given(:local) { "test/handsomefencer/dummy/local/.env"}
    #   Given(:file3) { "#{local}/circle.env.enc" }
    #   Given(:file4) { "#{local}/development/web.env.enc"}
    #   Given { subject.obfuscate(local) }
    #
    #   Then { assert File.exist? file3 }
    #   And  { assert File.exist? file4 }
    # end
  # end
  #
  # describe "#expose()" do
    #
    # Given(:file1) { '.env/backup.env' }
    # Given(:file2) { '.env/development/backup.env'}
    # Given(:subject) { Crypto.new }
    #
    # Given { subject.obfuscate }
    #
    # describe "default" do
    #
    #   # Given { File.delete (file1 ) }
    #   # Given { File.delete (file2 ) }
    #   Given { subject.expose }
    #
    #   Then { assert File.exist? file1 }
      # And  { assert File.exist? file2 }
    # end

    # describe "directory" do
    #
    #   Given(:new_cipher) { Crypto.new }
    #   Given(:server) { "test/handsomefencer/dummy/server/.env"}
    #   Given(:file3) { "#{server}/backup.env" }
    #   # Given(:file4) { "#{server}/development/backup.env"}
    #   Given { new_cipher.expose(server) }
    #
    #   # Then { assert File.exist? file3 }
    #   # And  { assert File.exist? file4 }
    # end
  end

  Minitest.after_run do
    hash = {
      "test/dummy/local" => "env.enc",
      "test/dummy/server" => "env",
      "." => "env.enc"}
    hash.each do |key, value|
      Dir.glob("#{key}/.env/**/*.#{value}").each { |f| File.delete(f)}
    end
    # ['.env/backup.env', '.env/development/backup.env'].each do |file|
    #   FileUtils.copy('.env/circle.env', file)
    # end

  end
end
