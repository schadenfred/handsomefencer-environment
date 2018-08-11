require 'openssl'
require 'base64'

class Handsomefencer::Environment::Crypto

  def initialize
    @cipher = OpenSSL::Cipher::AES.new(128, :CBC)
    @cipher.encrypt
    @nonce = @cipher.random_key
    @key == get_deploy_key ||= @nonce
  end

  def encrypt(file)
    data = File.read(file)
    encrypted = @cipher.update(data) + @cipher.final
    @cipher.reset
    write_to_file(Base64.encode64(encrypted), file + '.enc')
  end

  def decrypt(file)
    encrypted = Base64.decode64(File.read(file))
    @cipher = OpenSSL::Cipher::AES.new(128, :CBC)
    @cipher.decrypt
    @cipher.key = @key

    decrypted = @cipher.update(encrypted) + @cipher.final
    decrypted_file = file.split('.enc').first
    File.delete decrypted_file if File.exist? decrypted_file
    write_to_file(decrypted, decrypted_file)
    @cipher.reset
  end

  def generate_deploy_key
    file = 'config/deploy.key'
    File.delete file if File.exist? file
    key = Base64.encode64(@cipher.random_key)
    write_to_file(key, file)
    if File.exist? '.gitignore'
      open('.gitignore', 'a') do |f|
        f << "\/config\/deploy.key"
      end
    end
  end

  def write_to_file(data, filename)
    open filename, "w" do |io|
      io.write data
    end
  end

  def get_deploy_key
    encoded = ENV['DEPLOY_KEY'] || File.read('config/deploy.key')
byebug
    Base64.decode64(encoded)
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
