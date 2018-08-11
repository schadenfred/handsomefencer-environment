require './lib/handsomefencer/environment'
cipher = Handsomefencer::Environment::Crypto.new
cipher.generate_deploy_key
cipher.obfuscate
