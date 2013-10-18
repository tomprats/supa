SECRET_CONFIG = YAML.load_file("#{::Rails.root}/config/secret.yml")[::Rails.env]
