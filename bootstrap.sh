#!/bin/bash
# Script to prepare your Mac M1/M2
# Fernando Oliveira
# Created at: 2025-05-20


# Source: https://joachim8675309.medium.com/vagrant-with-macbook-mx-arm64-0f590fd7e48a

echo "* Installing QEMU and VAGRANT"
# install VM solution
brew install qemu

# install Vagrant with QEMU support
brew install --cask vagrant
vagrant plugin install vagrant-qemu
