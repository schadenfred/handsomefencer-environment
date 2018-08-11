require 'openssl'
require 'base64'

class Handsomefencer::Environment::Crypto

  def dkfile
    "config/deploy.key"
  end

  def initialize
    @cipher = OpenSSL::Cipher::AES.new(128, :CBC)
  end

  def encrypt(file)
    @cipher.encrypt
    @key = @cipher.random_key
    encrypted = @cipher.update(File.read file) + @cipher.final
    write_to_file Base64.encode64(@key), dkfile
    write_to_file(Base64.encode64(encrypted), file + '.enc')
  end

  def decrypt(file)
    encoded = File.read file
    encrypted = Base64.decode64 encoded
    @decipher = OpenSSL::Cipher::AES.new(128, :CBC)
    @decipher.decrypt
    @key = Base64.decode64 File.read(dkfile)
    @decipher.key = @key

    decrypted = @decipher.update(encrypted) + @decipher.final
    decrypted_file = file.split('.enc').first
    write_to_file decrypted, decrypted_file
  end

  def generate_deploy_key
    key = Base64.encode64(@cipher.random_key)
    write_to_file(key, dkfile)
    unless File.read('.gitignore').match dkfile
      open('.gitignore', 'a') { |f| f << "/" + dkfile }
    end
    get_deploy_key
  end

  def write_to_file(data, filename)
    open filename, "w" do |io|
      io.write data
    end
  end

  def get_deploy_key

    file = 'config/deploy.key'
    if File.exist?(file)
      encoded = File.read(file)
    else

      # ENV['DEPLOY_KEY'].nil?
      generate_deploy_key
    end
    decoded = Base64.decode64(encoded)
  end

  def source_files(directory=nil, extension=nil)
    default = Dir.glob(".env/**/*#{extension}")
    directory.nil? ? default : Dir.glob(directory + "/**/*#{extension}")
  end

  def obfuscate(directory=nil, extension=nil)
    extension = extension || '.env'
    directory = directory || '.env'
    files = source_files(directory, extension)

    files.each do |file|
      encrypt(file)
    end
  end

  def expose(directory=nil, extension=nil)
    extension = extension || '.env.enc'
    directory = directory || '.env'
    files = source_files(directory, extension)
    files.each do |file|
      decrypt(file)
    end
  end
end
