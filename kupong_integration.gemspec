# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'kupong_integration/version'

Gem::Specification.new do |spec|
  spec.name          = 'kupong_integration'
  spec.version       = KupongIntegration::VERSION
  spec.authors       = ['Zhuo-Fei Hui']
  spec.email         = ['zfhui@de.edenspiekermann.com']

  spec.summary       = %q{Integration of the Kupong.se API}
  spec.description   = %q{Kupong.se is a platform for the distribution of digital coupons.}
  spec.homepage      = 'https://github.com/edenspiekermann/kupong_integration'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.14'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'rest-client', '~> 2.0'
end
