$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)

require "minitest/autorun"
require "minitest/given"
require "byebug"
require "handsomefencer/environment"

include Handsomefencer::Environment

module HandsomeHelpers
  def rmfile(file)
    if File.exist? file
      FileUtils.rm(file)
    end
  end

  def rmcode(file, code)
    if File.read(file).match code
      text = File.read(file)
      content = text.gsub(code, "")
      File.open(file, "w") { |f| f << content }
    end
  end

  def assert_code(file, code)
    assert File.read(file).match code
  end

  def refute_code(file, code)
    text = File.read(file)
    refute text.match code

  end
end

include HandsomeHelpers

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
