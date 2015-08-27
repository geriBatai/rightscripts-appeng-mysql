#!/bin/sh

path=$(dirname $0)
${path}/setup.sh

/opt/chef/bin/chef-solo -c /tmp/appeng-config.rb -j /tmp/appeng-inputs.json -o 'recipe[rs-mysql::master]'
