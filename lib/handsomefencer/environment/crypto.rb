require 'openssl'
require 'base64'

class Handsomefencer::Environment::Crypto

  def initialize
    @cipher = OpenSSL::Cipher.new 'AES-128-CBC'
    @salt = '8 octets'
    get_deploy_key
  end

  def get_deploy_key
    if ENV['DEPLOY_KEY'].nil?
      @pass_phrase = read_deploy_key.nil? ? save_deploy_key : read_deploy_key
    else
      @pass_phrase = ENV['DEPLOY_KEY']
    end
  end

  def save_deploy_key
    @new_key = @cipher.random_key
    write_to_file Base64.encode64(@new_key), dkfile
    ignore_sensitive_files
    read_deploy_key
  end

  def ignore_sensitive_files
    ["/#{dkfile}", "/.env/*"].each do |pattern|
      unless File.read('.gitignore').match pattern
        open('.gitignore', 'a') { |f| f << pattern }
      end
    end
  end

  def read_deploy_key
    File.exist?(dkfile) ? Base64.decode64(File.read dkfile) : nil
  end

  def encrypt(file)
    @cipher.encrypt.pkcs5_keyivgen @pass_phrase, @salt
    encrypted = @cipher.update(File.read file) + @cipher.final
    write_to_file(Base64.encode64(encrypted), file + '.enc')
  end

  def decrypt(file)
    encrypted = Base64.decode64 File.read(file)
    @cipher.decrypt.pkcs5_keyivgen @pass_phrase, @salt
    decrypted = @cipher.update(encrypted) + @cipher.final
    decrypted_file = file.split('.enc').first
    write_to_file decrypted, decrypted_file
  end

  def source_files(directory=nil, extension=nil)
    default = Dir.glob(".env/**/*#{extension}")
    directory.nil? ? default : Dir.glob(directory + "/**/*#{extension}")
  end

  def obfuscate(directory=nil, extension=nil)
    extension = extension || '.env'
    directory = directory || '.env'
    source_files(directory, extension).each { |file| encrypt file }
  end

  def expose(directory=nil, extension=nil)
    extension = extension || '.env.enc'
    directory = directory || '.env'
    source_files(directory, extension).each { |file| decrypt(file) }
  end

  private

    def dkfile
      "config/deploy.key"
    end

    def write_to_file(data, filename)
      open(filename, "w") { |io| io.write data }
    end

end
