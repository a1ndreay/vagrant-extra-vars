# vagrant-extra-vars

A simple Ruby helper to extract extra JSON-formatted variables passed via the `--pass-var` vagrant CLI flag or the `VAGRANT_PASS_VARS` environment variable to use in Vagrantfile.

## Features

- Parses `--pass-var '{"key":"value"}'` from CLI.
- Falls back to `ENV['VAGRANT_PASS_VARS']` if `--pass-var` is not provided.

## Installation

Add this line to your Gemfile:

```ruby
gem 'vagrant-extra-vars', git: 'https://github.com/your-username/vagrant-extra-vars'
```

Then run `bundle install`

## Usage
Paste content below to your Vagrantfile:
```Vagrantfile
require 'vagrant-extra-vars'

Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |vb|   
    host_port = VagrantExtraVars::Store.pass_vars['http_port_forward'].to_s
    rule      = "http,tcp,127.0.0.1,#{host_port},,80" 
    vb.customize ["modifyvm", :id, "--natpf1", rule]
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yaml"
    ansible.raw_arguments = ["--extra-vars", "foo=#{VagrantExtraVars::Store.pass_vars['bar']}"]
  end
end
```

Then run vagrant:
```bash
vagrant --pass-var '{"http_port_forward":"8081","foo":"bar"}' up --provision
```

