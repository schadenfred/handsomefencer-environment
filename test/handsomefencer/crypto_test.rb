require 'test_helper'
Dir.chdir 'test/handsomefencer/dummy'

describe Handsomefencer::Environment::Crypto do

  subject { Crypto.new }

  Given(:deploy_key) { 'config/deploy.key' }

  describe "#save_deploy_key" do

    describe "with existing 'config/deploy.key'" do

      Given { subject.save_deploy_key}

      Then { assert File.exist? deploy_key }
    end

    describe "without previously saved deploy.key" do

      Given { File.delete deploy_key }
      Given { subject.save_deploy_key }

      Then { assert File.exist? deploy_key }
    end
  end

  describe "#get_deploy_key" do

    describe "with 'config/deploy.key'" do

      Given { subject.get_deploy_key }

      Then { assert File.exist? 'config/deploy.key' }
    end

    describe "without 'config/deploy.key'" do

      describe "without ENV['DEPLOY_KEY']" do

        Given { File.delete 'config/deploy.key' }
        Given { ENV['DEPLOY_KEY'] = nil }
        Given { subject.get_deploy_key }

        Then { assert File.exist? 'config/deploy.key' }
      end

      describe "with ENV['DEPLOY_KEY'] set" do

        Given { ENV['DEPLOY_KEY'] = "some-new-deploy-password" }
        Given { subject.get_deploy_key }
        Given(:pass_phrase) { subject.instance_variable_get("@pass_phrase") }

        Then { assert_equal pass_phrase, "some-new-deploy-password" }
      end
    end
  end

  describe "#read_deploy_key" do

    Given { subject.save_deploy_key }
    Given(:new_key) { subject.instance_variable_get("@new_key")}

    Then { subject.read_deploy_key.must_equal new_key}
  end

  Given(:env_file)        { '.env/backup.env' }
  Given(:nested_env_file) { '.env/development/backup.env'}

  describe "#encrypt" do

    Given(:env_enc_file) { '.env/backup.env.enc' }
    Given { subject.encrypt env_file }

    Then { assert File.exist? env_enc_file }

    describe "#decrypt" do

      Given { File.delete env_file}
      Given { subject.decrypt env_enc_file }
      Given(:actual) { File.read env_file }
      Given(:expected) { File.read '.env/circle.env' }

      Then { assert File.exist? env_file }
      And { assert_equal actual, expected }
    end
  end

  describe "#source_files" do

    describe "default" do

      Given(:env_files) { subject.source_files('.env') }

      Then { env_files.must_include env_file }
      And  { env_files.must_include nested_env_file }
    end

    describe "with specified directory" do

      Given(:env_files) { subject.source_files('.env', '.env') }

      Then { env_files.must_include env_file }
      And  { env_files.must_include nested_env_file }
    end
  end

  describe "#obfuscate()" do

    Given { subject.obfuscate }

    Then { assert File.exist? env_file + '.enc' }
    And  { assert File.exist? nested_env_file + '.enc' }
  end

  describe "#expose" do

    Given { subject.obfuscate }
    Given { File.delete env_file }
    Given { File.delete nested_env_file }
    Given { subject.expose }

    Then { assert File.exist? env_file }
    And  { assert File.exist? nested_env_file }
  end
Minitest.after_run do
  samples = [
    '.env/circle.env',
    '.env/backup.env',
    '.env/development/backup.env'
  ]
  samples.each do |file|
    FileUtils.copy('../../sourcefiles/circle.env', file)
  end
end
end
