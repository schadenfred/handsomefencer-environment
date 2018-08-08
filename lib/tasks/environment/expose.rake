require_relative '../../open_ssl_encryptor'

namespace :credentials do

  desc "Obfuscates any file ending with .env in the .env/ directory"
  task obfuscate: :environment do
    Crypto.obfuscate
  end

  desc "Exposes any file ending with .enc in the .env/ directory"
  task expose: :environment do
    Crypto.expose
  end
end
