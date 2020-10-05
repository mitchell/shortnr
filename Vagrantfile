# -*- mode: ruby -*-
# vim: ft=ruby foldmethod=indent

# frozen_string_literal: true

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version. Please don't change it unless you know
# what you're doing.
Vagrant.configure('2') do |config| # rubocop:disable Metrics/BlockLength
  config.vm.define 'dev' do |dev| # rubocop:disable Metrics/BlockLength
    dev.vm.box = 'debian/buster64'

    dev.vm.network 'forwarded_port', guest: 8080, host: 8080
    dev.vm.network 'private_network', ip: '192.168.50.11'

    dev.vm.provider 'virtualbox' do |vb|
      vb.memory = '4096'
      vb.cpus = 4
    end

    dev.vm.synced_folder '.', '/vagrant', type: 'rsync',
                                          rsync__exclude: [
                                            '*.ez',
                                            '*.out',
                                            '*.tfstate',
                                            '*.tfstate.backup',
                                            '*.tfvars',
                                            '.elixir_ls/',
                                            '.fetch',
                                            '.terraform/',
                                            '_build/',
                                            'cover/',
                                            'deps/',
                                            'doc/',
                                            'erl_crash.dump',
                                            'service-*.tar'
                                          ]

    dev.vm.provision 'shell', inline: <<-SHELL
      ### personal ###
      # deps for my dotfiles
      apt-get update
      apt-get install -y git curl rsync

      ### fish shell ###
      # deps for installing fish
      apt-get install -y wget gpg

      # adding the fish repo and installing fish
      echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_10/ /' > /etc/apt/sources.list.d/shells:fish:release:3.list
      wget -nv https://download.opensuse.org/repositories/shells:fish:release:3/Debian_10/Release.key -O Release.key
      apt-key add - < Release.key
      rm Release.key
      apt-get update
      apt-get install -y fish

      # change vagrant user's default shell to fish
      chsh -s /usr/bin/fish vagrant

      ### docker ###
      # deps for docker
      apt-get install -y \
        apt-transport-https ca-certificates curl \
        gnupg2 software-properties-common

      # install docker-ce
      curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
      add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/debian \
        $(lsb_release -cs) \
        stable"
      apt-get update
      apt-get install -y docker-ce docker-ce-cli containerd.io

      # install docker-compose
      curl -L "https://github.com/docker/compose/releases/download/1.25.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
      chmod +x /usr/local/bin/docker-compose

      # add vagrant user to docker group
      adduser vagrant docker

      ### asdf-vm ###
      # deps for asdf-vm
      apt-get install -y \
        automake autoconf libreadline-dev \
        libncurses-dev libssl-dev libyaml-dev \
        libxslt-dev libffi-dev libtool \
        unixodbc-dev unzip curl

      # deps for asdf-erlang
      apt-get install -y \
        build-essential autoconf m4 \
        libncurses5-dev libwxgtk3.0-dev libgl1-mesa-dev \
        libglu1-mesa-dev libpng-dev libssh-dev \
        unixodbc-dev xsltproc fop
    SHELL

    dev.vm.provision 'shell', privileged: false, inline: <<-SHELL
      ### personal ###
      # run my dotfiles sync script
      curl -L mjfs.us/sync | fish

      ### asdf-vm ###
      # install asdf vm
      git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.7.7
      echo 'source ~/.asdf/asdf.fish' >> ~/.config/fish/config.fish
      cp ~/.asdf/completions/asdf.fish ~/.config/fish/completions

      # install various tools/languages with asdf
      . $HOME/.asdf/asdf.sh
      export PATH=$PATH:$HOME/.asdf/bin/

      asdf plugin add neovim
      asdf install neovim 0.4.3
      asdf global neovim 0.4.3

      asdf plugin add erlang
      asdf install erlang 22.3
      asdf global erlang 22.3

      asdf plugin add elixir
      asdf install elixir 1.10.2-otp-22
      asdf global elixir 1.10.2-otp-22
    SHELL
  end

  config.vm.define 'prod' do |prod|
    prod.vm.box = 'debian/buster64'

    prod.vm.network 'forwarded_port', guest: 8080, host: 8888
    prod.vm.network 'private_network', ip: '192.168.50.10'

    prod.vm.provider 'virtualbox' do |vb|
      vb.memory = '4096'
      vb.cpus = 4
    end

    prod.vm.synced_folder '.', '/vagrant', disabled: true

    prod.vm.provision 'shell', inline: <<-SHELL
      ### personal ###
      # deps for my dotfiles
      apt-get update
      apt-get install -y git curl rsync

      ### fish shell ###
      # deps for installing fish
      apt-get install -y wget gpg

      # adding the fish repo and installing fish
      echo 'deb http://download.opensuse.org/repositories/shells:/fish:/release:/3/Debian_10/ /' > /etc/apt/sources.list.d/shells:fish:release:3.list
      wget -nv https://download.opensuse.org/repositories/shells:fish:release:3/Debian_10/Release.key -O Release.key
      apt-key add - < Release.key
      rm Release.key
      apt-get update
      apt-get install -y fish

      ### asdf-vm ###
      # deps for asdf-vm
      apt-get install -y \
        automake autoconf libreadline-dev \
        libncurses-dev libssl-dev libyaml-dev \
        libxslt-dev libffi-dev libtool \
        unixodbc-dev unzip curl
    SHELL

    prod.vm.provision 'shell', privileged: false, inline: <<-SHELL
      ### personal ###
      # run my dotfiles sync script
      curl -L mjfs.us/sync | fish

      ### asdf-vm ###
      # install asdf vm
      git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.7.7
      echo 'source ~/.asdf/asdf.fish' >> ~/.config/fish/config.fish
      cp ~/.asdf/completions/asdf.fish ~/.config/fish/completions

      # install various tools/languages with asdf
      . $HOME/.asdf/asdf.sh
      export PATH=$PATH:$HOME/.asdf/bin/

      asdf plugin add neovim
      asdf install neovim 0.4.3
      asdf global neovim 0.4.3
    SHELL
  end
end
