require 'test_helper'

describe Handsomefencer::Environment::Crypto do

  subject { Crypto.new }

  Given(:file1) { '.env/circle.env' }
  Given(:file2) { '.env/backup.env' }
  Given(:file3) { '.env/development/backup.env' }

  Then { assert FileUtils.compare_file(file1, file2) }
  And  { assert FileUtils.compare_file(file2, file3) }

  describe "#generate_key" do

    Given { rmfile('config/deploy.key')}
    Given { rmcode('.gitignore', '/config/deploy.key')}
    Given { subject.generate_deploy_key }

    describe "generates config/deploy.key file" do

      Then { assert File.exist? 'config/deploy.key'}
    end

    describe "adds /config/deploy.key to .gitignore" do

      Then { assert_code '.gitignore', '/config/deploy.key' }
    end
  end

  Given { ENV["DEPLOY_KEY"] = "YkvlQHABzmPH+u9BHZgggA==" }

  describe "#get_deploy_key" do

    describe "when ENV set" do

      Given(:expected) { Base64.decode64(ENV['DEPLOY_KEY']) }

      Then { subject.get_deploy_key.must_match expected }
    end

    describe "when ENV not set" do

      Given { subject.generate_deploy_key }
      Given { ENV["DEPLOY_KEY"] = nil }
      Given(:actual) { Base64.encode64(subject.get_deploy_key) }
      Given(:expected) { File.read('config/deploy.key') }

      Then { actual.must_equal expected }
    end
  end

  describe "#encrypt" do

    Given { subject.encrypt('.env/circle.env') }

    Then { assert File.exist?('.env/circle.env.enc')}

    describe "#decrypt" do

      Given { FileUtils.copy file1, file2 }
      Given { assert File.exist? '.env/circle.env.enc'}
      Given { subject.decrypt '.env/circle.env.enc' }
      Then { assert File.exist? '.env/circle.env' }
    end
  end

  describe "#source_files" do

    describe "default" do

      Given(:expected_files) { subject.source_files('.env') }

      Then { expected_files.must_include file1 }
      And  { expected_files.must_include file2 }
    end

    describe "with specified directory" do

      Given(:expected_files) { subject.source_files('.env', '.env') }

      Then { expected_files.must_include file1 }
      And  { expected_files.must_include file2 }
    end
  end

  describe "default" do

    describe "#obfuscate()" do

      Given { subject.obfuscate }

      Then { assert File.exist? file1 + '.enc' }
      And  { assert File.exist? file2 + '.enc' }
      And  { assert File.exist? file3 + '.enc' }

      describe "#expose" do

        Given { subject.expose }

        Then { assert File.exist? file1 }
        And  { assert File.exist? file2 }
        And  { assert File.exist? file3 }
      end
    end
  end

  describe "specified directory" do

    describe "#obfuscate()" do

      Given(:dir) { 'test/handsomefencer/dummy/local/'}
      Given(:file4) { dir + file1 }
      Given(:file5) { dir + file2 }
      Given(:file6) { dir + file3 }
      Given(:file7) { file4 + '.enc' }
      Given(:file8) { file5 + '.enc' }
      Given(:file9) { file6 + '.enc' }

      Given { subject.obfuscate(dir + '/.env') }

      Then { assert File.exist? file4 }
      And  { assert File.exist? file5 }
      And  { assert File.exist? file6 }

      describe "#expose" do

        Given { subject.obfuscate(dir + '/.env') }

        Then { assert File.exist? file7 }
      end
    end
  end

  Minitest.after_run do

    samples = [
      '.env/circle.env',
      '.env/backup.env',
      '.env/development/backup.env',
      'test/handsomefencer/dummy/local/.env/circle.env',
      'test/handsomefencer/dummy/local/.env/backup.env',
      'test/handsomefencer/dummy/local/.env/development/backup.env'
    ]
    samples.each do |file|
      FileUtils.copy('sourcefiles/circle.env', file)
    end
  end
end
