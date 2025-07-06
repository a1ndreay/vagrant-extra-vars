Gem::Specification.new do |spec|
  spec.name          = "vagrant-extra-vars"
  spec.version       = "0.1.0"
  spec.summary       = "provide way to pass variables into Vagrant from command line"
  spec.author        = "Andrey Zorkin"
  spec.email         = "a1handreay@gmail.com"
  spec.files         = Dir["lib/**/*.rb"]
  spec.require_paths = ["lib"]
  spec.license       = "MIT"

  spec.add_runtime_dependency "json"
end
