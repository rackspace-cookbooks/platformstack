# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.require_version ">= 1.5.0"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.hostname = "platformstack-berkshelf"
  config.vm.box = "ubuntu-12.04"
  config.vm.box_url = "http://opscode-vm-bento.s3.amazonaws.com/vagrant/virtualbox/opscode_#{config.vm.box}_chef-provisionerless.box"
  config.omnibus.chef_version = :latest
  config.berkshelf.enabled = true

  config.vm.network :private_network, type: "dhcp"

  config.vm.provision :chef_solo do |chef|

    # Work around Chef nonsense when solo runs in Vagrant
    chef.custom_config_path = 'Vagrantfile.chefhacks'
    chef.json = {
      mysql: {
        server_root_password: 'rootpass',
        server_debian_password: 'debpass',
        server_repl_password: 'replpass'
      },
      "holland" => { "enabled" => "false" },
      "platformstack" => {
         "cloud_monitoring" => { "enabled" => "false" }
      }
    }

    chef.run_list = [
        "recipe[platformstack::default]"
    ]
  end
end
