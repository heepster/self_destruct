Gem::Specification.new do |s|
  s.name        = 'self_destruct'
  s.version     = '1.0.0'
  s.date        = '2010-11-25'
  s.description = "Adds the ability for ruby processes to die after some conditions are met."
  s.authors     = ["Kevin Huynh"]
  s.email       = 'me@khuynh.info'
  s.files       = ['lib/self_destruct.rb']
  s.license     = 'MIT'
  s.homepage    = 'https://github.com/heepster/self_destruct'
  s.add_development_dependency "rspec", '~> 0'
end
