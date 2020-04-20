# -*- mode: ruby -*-
# vi: set ft=ruby :

# TODO multi provider
ENV['VAGRANT_DEFAULT_PROVIDER'] = 'virtualbox'

# Core : don't touch theses lines
require_relative '.settings/vagrant/bootstrap'
# make a project main path global
$__dir__ = __dir__
# ====== End Core =======

Vagrant.configure("2") do |vagrant|
  VagrantBootstrap.new(File.read(__dir__+'/config.json'), vagrant)
  # Add your own vagrant options
end