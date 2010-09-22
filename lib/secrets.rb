require "rails"
require "ostruct"

class Secrets < Rails::Railtie
  config.secrets_path = "config/secrets.yml"
  
  config.to_prepare do
    Secrets.load!
  end
  
  def self.load!
    Object.send(:remove_const, :Secret) if defined? Secret
    secrets = {}
    
    [config.secrets_path].each do |path|
      next unless File.exist?(Rails.root + path)

      YAML.load_file(Rails.root + config.secrets_path).each do |(key, value)|
        secrets[key] = OpenStruct.new value
      end

    end
    
    Object.send :const_set, :Secret, OpenStruct.new(secrets)
  end
end