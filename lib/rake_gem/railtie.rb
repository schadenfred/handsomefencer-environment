class RakeGem::Railtie < Rails::Railtie
  rake_tasks do
    load 'tasks/environment/obfuscate.rake'
    load 'tasks/environment/expose.rake'
  end
end
