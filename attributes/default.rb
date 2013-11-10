default[:webwords][:user] = "vagrant"
default[:webwords][:group] = "vagrant"
default[:webwords][:deploy_to] = "/srv/webwords"
default[:webwords][:deploy_current] = "/current/webwords-master"
default[:webwords][:artifact_location] = "https://codeload.github.com/typesafehub/webwords/zip/master"

# sbt
#node['sbt-extras']['download_url'] = "https://raw.github.com/paulp/sbt-extras/master/sbt"
node['sbt-extras']['download_url'] = "https://raw.github.com/opyate/sbt-extras/mktemp/sbt"

# This uses $HOME instead of ~, but ~ will work well if 'webwords' user is created before with the 'user' cookbook.
#+ so we just use 'vagrant' user: node['sbt-extras']['download_url'] = "http://sprunge.us/fgbM"

node['sbt-extras']['owner'] = "vagrant"
node['sbt-extras']['group'] = "vagrant"

# mongo
node.normal[:mongodb][:package_version] = "2.4.8-mongodb_1"
