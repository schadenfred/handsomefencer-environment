require 'openssl'
require 'base64'

module Handsomefencer
  module Environment
    class Crypto

      def initialize(data, options={})
        @cipher = options[:cipher].nil? ? 'aes-256-cbc' : cipher
        @key = options[:key].nil? ? get_master_key : get_key(options[:key])
        @iv = options[:iv].nil? ? '0'*16 : options[:iv]
        @data = data
        @source_directory = options[:dir].nil? ? nil : options[:dir]
      end

      def self.source_environment_files(directory=nil)
        default = Dir.glob(".env/**/*.env")
        directory.nil? ? default : Dir.glob(directory + '/**/*.env')
      end

      def self.source_encrypted_files(directory=nil)
        default = Dir.glob(".env/**/*.env.enc")
        if !directory.nil?
          byebug
        end
        directory.nil? ? default : Dir.glob(directory + '/**/*.env.enc')
      end

      def self.obfuscate(directory=nil, options={})
        directory = directory || nil
        source_environment_files(directory).each do |file|
          new(file).encrypt_file
        end
      end

      def encrypt
        c = OpenSSL::Cipher.new(@cipher).encrypt
        c.iv = @iv
        c.key = @key
        c.update(@data) + c.final
      end

      def encrypt_file
        unencrypted_document_name = @data
        data = File.read(@data)
        encrypted = Crypto.new(data).encrypt

        open unencrypted_document_name + ".enc", "w" do |io|
          io.write Base64.encode64(encrypted)
        end
      end

      def self.expose(options={})
        directory = options[:directory].nil? ? nil : options[:directory]
        source_encrypted_files(directory).each do |file|
          new(file).decrypt_file
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

      def decrypt
        c = OpenSSL::Cipher.new(@cipher).decrypt
        c.iv = @iv
        c.key = @key
        c.update(@data) + c.final
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

      def get_master_key
        ENV['RAILS_MASTER_KEY'] || get_key('config/master.key')
      end

      def get_key(key_file)
        File.read(key_file).strip
      end
    end
  end
end
