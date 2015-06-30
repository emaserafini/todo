Vagrant.require_version ">= 1.6.5"

Vagrant.configure("2") do |config|
  config.vm.define "docker_todo"
  config.vm.box = "yungsang/boot2docker"
  config.vm.network "private_network", ip: ENV['BOOT2DOCKER_IP'] || "10.211.55.5"

  config.vm.provider "parallels" do |v, override|
    override.vm.box = "parallels/boot2docker"
    override.vm.network "private_network", type: "dhcp"
  end

  # Fix busybox/udhcpc issue
  config.vm.provision :shell do |s|
    s.inline = <<-EOT
      if ! grep -qs ^nameserver /etc/resolv.conf; then
        sudo /sbin/udhcpc
      fi
      cat /etc/resolv.conf
    EOT
  end

  # Adjust datetime after suspend and resume
  config.vm.provision :shell do |s|
    s.inline = <<-EOT
      sudo /usr/local/bin/ntpclient -s -h pool.ntp.org
      date
    EOT
  end

  # http
  config.vm.network "forwarded_port", guest: 80, host: 80, auto_correct: true
  config.vm.network "forwarded_port", guest: 443, host: 443, auto_correct: true

  # rack
  config.vm.network "forwarded_port", guest: 9292, host: 9292, auto_correct: true

  # config.vm.synced_folder "/Users/intinig/src", "/Users/intinig/src", type: "nfs", bsd__nfs_options: ["-maproot=0:0"], map_uid: 0, map_gid: 0
  # config.vm.synced_folder "/Users/intinig/src", "/src", type: "nfs", bsd__nfs_options: ["-maproot=0:0"], map_uid: 0, map_gid: 0
  config.vm.synced_folder "~/", "/src", type: "nfs", bsd__nfs_options: ["-maproot=0:0"], map_uid: 0, map_gid: 0
end
