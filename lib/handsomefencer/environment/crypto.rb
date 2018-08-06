require 'openssl'
require 'base64'

module Handsomefencer
  module Environment
    class Crypto

      def initialize(options={})
        @cipher = OpenSSL::Cipher.new 'AES-128-CBC'
        @cipher.encrypt
        @iv = @cipher.random_iv

        @pwd = 'some hopefully not to easily guessable password'
        @salt = OpenSSL::Random.random_bytes 16
        @iter = 20000
        @key_len = @cipher.key_len
        @digest = OpenSSL::Digest::SHA256.new

        @key = OpenSSL::PKCS5.pbkdf2_hmac(@pwd, @salt, @iter, @key_len, @digest)
        @cipher.key = @key
      end

      def read(data)
        File.read(data).split
      end

      def data_or_file?(data)
        File.exist?(data) ? true : false
      end

      def write_data_to_file
        # open unencrypted_document_name + ".enc", "w" do |io|
        #   io.write Base64.encode64(encrypted)
        # end

      end

      def encrypt(data=nil)
        data = data_or_file?(data) ? read(data) : data
        @encrypted = @cipher.update data
        @encrypted << @cipher.final
        # data_or_file?(data) ? write_data_to_file(data)
        # open unencrypted_document_name + ".enc", "w" do |io|
        #   io.write Base64.encode64(encrypted)
        # end

        # unencrypted_document_name = @data
        # data = File.read(@data)
        # encrypted = Crypto.new(data).encrypt
        #
        # open unencrypted_document_name + ".enc", "w" do |io|
        #   io.write Base64.encode64(encrypted)
        # end


      end

      def decrypt(encrypted=nil)
        @cipher = OpenSSL::Cipher.new 'AES-128-CBC'
        @cipher.decrypt
        @cipher.iv = @iv
        @digest = OpenSSL::Digest::SHA256.new
        @key = OpenSSL::PKCS5.pbkdf2_hmac(@pwd, @salt, @iter, @key_len, @digest)
        @cipher.key = @key

        @data = encrypted || @data
        decrypted = @cipher.update @data
        decrypted << @cipher.final
      end

      # def initialize(data, options={})
      #   @cipher = options[:cipher].nil? ? 'aes-256-cbc' : cipher
      #   @key = Crypto.get_key(options)
      #   @iv = options[:iv].nil? ? '0'*16 : options[:iv]
      #   @data = data
      #   @source_directory = options[:dir].nil? ? nil : options[:dir]
      # end

      # def encrypt
      #   c = OpenSSL::Cipher.new(@cipher).encrypt
      #   c.iv = @iv
      #   c.key = @key
      #   c.update(@data) + c.final
      # end

      # def decrypt
      #   c = OpenSSL::Cipher.new(@cipher).decrypt
      #   c.iv = @iv
      #   c.key = @key
      #   c.update(@data) + c.final
      # end

      def self.source_environment_files(directory=nil)
        default = Dir.glob(".env/**/*.env")
        directory.nil? ? default : Dir.glob(directory + '/**/*.env')
      end

      def self.source_encrypted_files(directory=nil)
        default = Dir.glob(".env/**/*.env.enc")
        directory.nil? ? default : Dir.glob(directory + '/**/*.env.enc')
      end

      def self.obfuscate(directory=nil, options={})
        directory = directory || nil
          new(file).encrypt_file
        end
      end

      def encrypt_file
        unencrypted_document_name = @data
        data = File.read(@data)
        encrypted = Crypto.new(data).encrypt

        open unencrypted_document_name + ".enc", "w" do |io|
          io.write Base64.encode64(encrypted)
        end
      end

      def self.expose(directory=nil, options={})
        directory = directory || nil
        source_encrypted_files(directory).each do |file|
          new(file, options).decrypt_file
        end
      end

      def decrypt_file
        encrypted_file_name = @data
        decrypted_file_name = encrypted_file_name.split(".enc").first
        encrypted_data = Base64.decode64(File.read(encrypted_file_name))
        decrypted_data = Crypto.new(encrypted_data).decrypt
        open decrypted_file_name, "w" do |io|
          io.write decrypted_data
        end
      end

      def encrypt_environment_files
        source_unencrypted_files.each do |file|
          encrypt_file(file)
        end
      end

      def decrypt_environment_files
        source_encrypted_files.each do |file|
          decrypt_file(file)
        end
      end

      def self.get_master_key
        ENV['RAILS_MASTER_KEY'] || get_key(key_file: 'config/master.key')
      end

      def self.get_key(options={})
        case
        when options.nil? || options.empty?
          Crypto.get_master_key
        when options[:key]
          options[:key]
        when options[:key_file]
          File.read(options[:key_file]).strip
        when options[:key_var]
          exception = "No env variable set with #{options[:key_var]} key."
          ENV[options[:key_var]].nil? ? exception : ENV[options[:key_var]]
        end
      end
    end
  end
end
