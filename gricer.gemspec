Gem::Specification.new do |s|
  s.name = "gricer"
  s.summary = "Gricer web analysis tool engine"
  s.description = "Gricer web analysis tool engine"
  s.files = Dir["app/**/*"] + Dir["lib/**/*"] + Dir["spec/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc", "config/routes.rb"]
  s.add_dependency 'rails', '>= 3.1.0.rc5'
  s.add_dependency 'coffee-script'
  s.add_dependency 'sass-rails'
  s.add_dependency 'pjax-rails'
  s.version = "0.0.1"
end
