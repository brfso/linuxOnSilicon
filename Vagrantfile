Vagrant.configure("2") do |config|
  config.vm.box = "perk/ubuntu-2204-arm64"
  config.vm.provision :shell, path: "ntp.sh"
  config.vm.provision :shell, path: "k8s.sh"
  config.vm.provision :shell, path: "k8s-nginx.sh"
  config.vm.provider "qemu" do |qe|
    qe.ssh_port = "50022" # change ssh port as needed
  end
end
