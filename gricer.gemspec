Gem::Specification.new do |s|
  s.name = "gricer"
  s.summary = "Gricer web analysis tool engine"
  s.description = "Gricer web analysis tool engine"
  s.authors = ["Sven G. Broenstrup"]
  s.email = 'info@gricer.org'
  s.homepage = 'http://gricer.org/'
  s.files = Dir["app/**/*"] + Dir["lib/**/*"] + Dir["spec/**/*"] + Dir["db/migrate/*"]  + Dir["config/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc", "script/rails"]
  s.add_dependency 'rails', '>= 3.1.0'
  s.add_dependency 'coffee-rails'
  s.add_dependency 'compass-rails'
  s.add_dependency 'jquery-rails'
  s.version = "0.1.0"
end
