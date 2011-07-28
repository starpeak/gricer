require 'i18n'
I18n.load_path += Dir.glob("#{File.dirname(__FILE__)}/../../config/locales/*.yml")
I18n.backend.reload!