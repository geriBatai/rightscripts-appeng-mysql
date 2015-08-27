#!/bin/sh

path=$(dirname $0)
/bin/sh ${path}/setup.sh

/opt/chef/bin/chef-solo -c /tmp/appeng-config.rb -j /tmp/appeng-inputs.json -o 'recipe[rs-mysql::dump_import]'
