# vagrant-extra-vars

Vagrant plugin that provide way to use JSON-formatted variables passed via the `--pass-var` vagrant CLI flag or the `VAGRANT_PASS_VARS` environment variable in Vagrantfile.

## Features

- Parses `--pass-var='{"key":"value"}'` from CLI.
- Falls back to `ENV['VAGRANT_PASS_VARS']` if `--pass-var` is not provided.

## Installation

run `vagrant plugin install vagrant-extra-vars`

## Usage

You may access variable with `VagrantExtraVars::Store.pass_vars['foo']}` where 'foo' - the `--pass-var` given key

## Example
Paste content below to your Vagrantfile:
```Vagrantfile
Vagrant.configure("2") do |config|
  config.vm.provider "virtualbox" do |vb|   
    host_port = VagrantExtraVars::Store.pass_vars['http_port_forward'].to_s
    rule      = "http,tcp,127.0.0.1,#{host_port},,80" 
    vb.customize ["modifyvm", :id, "--natpf1", rule]
  end

  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "playbook.yaml"
    ansible.raw_arguments = ["--extra-vars", "foo=#{VagrantExtraVars::Store.pass_vars['foo']}"]
  end
end
```

Then run vagrant:
```bash
vagrant --pass-var='{"http_port_forward":"8081","foo":"bar"}' up --provision
```
> [!NOTE]
> Make sure that the --pass-var option is specified before the vagrant command to avoid an invalid option validation error.

## Build

```bash
gem signin
gem build vagrant-extra-vars.gemspec
gem push vagrant-extra-vars-x.y.z.gem
```
