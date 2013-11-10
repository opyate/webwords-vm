#
# Cookbook Name:: webwords
# Recipe:: default
#
# Copyright (C) 2013 Juan Uys <opyate@gmail.com>
# 
# All rights reserved - Do Not Redistribute
#

include_recipe "git"
include_recipe "sbt"
include_recipe "mongodb::10gen_repo"
include_recipe "mongodb::default"
include_recipe "rabbitmq"

group node[:webwords][:group]

deploy_full = File.join(node[:webwords][:deploy_to], node[:webwords][:deploy_current])

#user node[:webwords][:user] do
#  group node[:webwords][:group]
#  system true
#  shell "/bin/bash"
#end

# TODO instead of grabbing the ZIP, just sync the git repo (see http://docs.opscode.com/resource_git.html)
#+ but the reason I started off with the ZIP is because that's usually what you'll get from your CI pipeline.
artifact_file "/tmp/download.zip" do
  location node[:webwords][:artifact_location] 
  owner node[:webwords][:user]
  group node[:webwords][:group]
  action :create
end

artifact_deploy "webwords" do
  version "1.0.0"
  artifact_location "/tmp/download.zip"
  deploy_to node[:webwords][:deploy_to]
  owner node[:webwords][:user]
  group node[:webwords][:group]
  action :deploy
end

# sbt
script_absolute_path = File.join(node['sbt-extras']['setup_dir'], node['sbt-extras']['script_name'])

bash 'sbt-stage' do
  cwd "#{deploy_full}"
  user node[:webwords][:user]
  environment ({"HOME" => "/home/#{node[:webwords][:user]}"})
  code <<-EOF
    # [[ -e #{deploy_full}/indexer/target/start ]] || #{script_absolute_path} -scala-version 2.9.0-1 -sbt-version 0.12.0 stage
    #{script_absolute_path} -scala-version 2.9.0-1 -sbt-version 0.12.0 stage
  EOF
  returns 0

  not_if do
    File.exists?("#{deploy_full}/indexer/target/start")
  end
end

# install foreman

package "rubygems" do
  action :install
end

git '/usr/local/src/foreman' do
  repository 'https://github.com/ddollar/foreman.git'
  revision "v0.63.0"
end

execute 'gem build foreman.gemspec' do
  cwd '/usr/local/src/foreman'
end

gem_package 'foreman' do
  source '/usr/local/src/foreman/foreman-0.63.0.gem'
  action :install
end

# export Upstart with foreman

script 'Update foreman configuration' do
  interpreter "bash"
  cwd "#{deploy_full}"
  code <<-EOH
    /usr/bin/foreman export upstart /etc/init -a webwords-app -u vagrant
  EOH
end

service "webwords-app" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true
  action [ :enable, :restart ]
end

