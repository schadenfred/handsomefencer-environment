require_relative '../../open_ssl_encryptor'

namespace :environment_files do

  desc "Obfuscates any file ending with .env in the .env/ directory"
  task obfuscate: :environment do
    Crypto.obfuscate
  end
end
