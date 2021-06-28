$LOAD_PATH.push File.expand_path('../lib', __FILE__)

version = File.read(File.join(File.dirname(__FILE__), 'VERSION')).strip

Gem::Specification.new do |s|
  s.name = 'xip-facebook'
  s.summary = 'Facebook Messenger Xip Kit component'
  s.description = 'Facebook Messenger Xip Kit component.'
  s.homepage = 'https://github.com/xipkit/xip-facebook'
  s.licenses = ['MIT']
  s.version = version
  s.author = 'Mauricio Gomes'
  s.email = 'mauricio@edge14.com'

  s.add_dependency 'xip', '~> 2.0.0.beta'
  s.add_dependency 'http', '>= 4.4', '< 6.0'

  s.add_development_dependency 'rspec_junit_formatter', '~> 0.3'
  s.add_development_dependency 'rack-test', '~> 1.1'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
end
