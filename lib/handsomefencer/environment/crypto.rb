require 'openssl'
require 'base64'

module Handsomefencer
  module Environment
    class Crypto

      def initialize
        @cipher = OpenSSL::Cipher::AES.new(128, :CBC)
        @cipher.encrypt
        @key = get_deploy_key || @cipher.random_key
        # @a = get_deploy_key
        @b = @cipher.random_key
        @c = Base64.decode64(a)
byebug
      end

      def encrypt(file)
        data = File.read(file)
        encrypted = @cipher.update(data) + @cipher.final

        write_to_file(Base64.encode64(encrypted), file + '.enc')

        # cipher = OpenSSL::Cipher::AES.new(128, :CBC)
        # cipher.encrypt
        # key = cipher.random_key
        # iv = cipher.random_iv

        # ...
        # decipher = OpenSSL::Cipher::AES.new(128, :CBC)
        # decipher.decrypt
        # decipher.key = key
        # decipher.iv = iv
        #
        # plain = decipher.update(encrypted) + decipher.final
        #
        # puts data == plain #=> true
      end

      # def encrypt(data=nil, options={})
      #
      #   @data = is_file?(data) ? read(data) : data
      #   @encrypted = @cipher.update @data
      #   @encrypted << @cipher.final
      # end


      def generate_deploy_key
        key = Base64.encode64(@key)
        write_to_file(@key, 'config/deploy.key')
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
        ENV['DEPLOY_KEY'] || File.read('config/deploy.key').strip
      end
      #
      # def get_password
      #   case
      #   when @options.nil? || @options.empty?
      #     get_master_key
      #   when @options[:password]
      #     @options[:password]
      #   when @options[:password_file]
      #     File.read(@options[:password_file]).strip
      #   when @options[:env_var_password]
      #     ENV[@options[:env_var_password]]
      #   end
      # end


      # def initialize(options={})
      #   @options = options
      #   @cipher = options[:cipher] || OpenSSL::Cipher.new('AES-128-CBC')
      #   @cipher.encrypt
      #   @iv = @cipher.random_iv
      #   @pwd = get_password
      #   @salt = options[:salt] || OpenSSL::Random.random_bytes(16)
      #   @iter = options[:iter] || 20000
      #   @key_len = @cipher.key_len
      #   @digest = options[:digest] || OpenSSL::Digest::SHA256.new
      #
      #   @key = OpenSSL::PKCS5.pbkdf2_hmac(@pwd, @salt, @iter, @key_len, @digest)
      #   @cipher.key = @key
      # end
      #
      # def encrypt(data=nil, options={})
      #
      #   @data = is_file?(data) ? read(data) : data
      #   @encrypted = @cipher.update @data
      #   @encrypted << @cipher.final
      #   is_file?(data) ? write_to_file(Base64.encode64(@encrypted)) : @encrypted
      # end
      #
      # def decrypt(data=nil)
      #   @data = is_file?(data) ? Base64.decode64(read(data)) : data
      #   @cipher = OpenSSL::Cipher.new 'AES-128-CBC'
      #   @cipher.decrypt
      #   @cipher.iv = @iv
      #   @digest = OpenSSL::Digest::SHA256.new
      #   @key = OpenSSL::PKCS5.pbkdf2_hmac(@pwd, @salt, @iter, @key_len, @digest)
      #   @cipher.key = @key
      #
      #   decrypted = @cipher.update @data
      #   decrypted << @cipher.final
      #   if is_file?(data)
      #     encrypted_file_name = data
      #     decrypted_file_name = encrypted_file_name.split(".enc").first
      #     open decrypted_file_name, "w" do |io|
      #       io.write decrypted
      #     end
      #   else
      #     decrypted
      #   end
      # end
      #
      # def source_files(directory=nil, extension=nil)
      #   default = Dir.glob(".env/**/*#{extension}")
      #   directory.nil? ? default : Dir.glob(directory + "/**/*#{extension}")
      # end
      #
      # def source_environment_files(directory=nil)
      #   source_files('.env', directory)
      # end
      #
      # def self.source_encrypted_files(directory=nil)
      #   default = Dir.glob(".env/**/*.env.enc")
      #   directory.nil? ? default : Dir.glob(directory + '/**/*.env.enc')
      # end
      #
      # def obfuscate(directory=nil, extension=nil)
      #   extension = extension || '.env'
      #   directory = directory || '.env'
      #   files = source_files(directory, extension)
      #
      #   files.each do |file|
      #     encrypt(file)
      #   end
      # end
      #
      # def expose(directory=nil, extension=nil)
      #   extension = extension || '.env.enc'
      #   directory = directory || '.env'
      #   files = source_files(directory, extension)
      #   files.each do |file|
      #     decrypt(file)
      #   end
      # end
      #

#
      # def encrypt_file
      #   unencrypted_document_name = @data
      #   data = File.read(@data)
      #   encrypted = Crypto.new(data).encrypt
      #
      #   open unencrypted_document_name + ".enc", "w" do |io|
      #     io.write Base64.encode64(encrypted)
      #   end
      # end

      # def decrypt_file
      #   encrypted_file_name = @data
      #   decrypted_file_name = encrypted_file_name.split(".enc").first
      #   encrypted_data = Base64.decode64(File.read(encrypted_file_name))
      #   decrypted_data = Crypto.new(encrypted_data).decrypt
      #   open decrypted_file_name, "w" do |io|
      #     io.write decrypted_data
      #   end
      # end

      # def encrypt_environment_files
      #   source_unencrypted_files.each do |file|
      #     encrypt_file(file)
      #   end
      # end
      #
      # def decrypt_environment_files
      #   source_encrypted_files.each do |file|
      #     decrypt_file(file)
      #   end
      # end

      # def read(data)
      #   File.read(data)
      # end
      #
      # def is_file?(data)
      #   @unencrypted_file = data
      #   File.exist?(data)
      # end
      #
      # def write_to_file(data)
      #   open @unencrypted_file + ".enc", "w" do |io|
      #     io.write data
      #   end
      # end
      #
      # def get_master_key
      #   ENV['RAILS_MASTER_KEY'] || read('config/master.key').strip
      # end
      #
      # def get_password
      #   case
      #   when @options.nil? || @options.empty?
      #     get_master_key
      #   when @options[:password]
      #     @options[:password]
      #   when @options[:password_file]
      #     File.read(@options[:password_file]).strip
      #   when @options[:env_var_password]
      #     ENV[@options[:env_var_password]]
      #   end
      # end
    end
  end
end
