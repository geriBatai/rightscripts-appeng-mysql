#!/bin/bash

echo 'cookbook_path "/var/spool/rightlink/cookbooks/"' > /tmp/appeng-config.rb

# Move cookbooks to directories named after them. Fixes problem with
# chef reporting templates missing.
for d in $(ls -d /var/spool/rightlink/cookbooks/*/) ; do
	dirname=$(basename $d)
	if [ -f "${d}/metadata.rb" ]; then
		cookbook_name=$(awk '/^name/{print $2}' ${d}/metadata.rb | tr -d "'" | tr -d '"')
		if [ "${cookbook_name}" != "${dirname}" ]; then
			mv ${d} $(dirname ${d})/${cookbook_name}
		fi
	fi
done

/opt/chef/embedded/bin/ruby <<EOF > /tmp/appeng-inputs.json
require 'rubygems'
require 'json'

def assign(k,v)
  k = v if v
end

attr = {}

attr['mysql'] = {}
assign attr['mysql']['server_root_password'], ENV['MYSQL_SERVER_ROOT_PASSWORD']
assign attr['mysql']['server_debian_password'], ENV['MYSQL_SERVER_ROOT_PASSWORD']
assign attr['mysql']['server_repl_password'], ENV['MYSQL_SERVER_REPL_PASSWORD']

attr['rs-mysql'] = {}
assign attr['rs-mysql']['server_root_password'],ENV['MYSQL_SERVER_ROOT_PASSWORD']
assign attr['rs-mysql']['bind_network_interface'], ENV['MYSQL_BIND_INTERFACE']
assign attr['rs-mysql']['server_usage'], ENV['MYSQL_SERVER_USAGE']
assign attr['rs-mysql']['application_username'], ENV['MYSQL_APPLICATION_USERNAME']
assign attr['rs-mysql']['application_password'], ENV['MYSQL_APPLICATION_PASSWORD']
assign attr['rs-mysql']['application_user_privileges'], ENV['MYSQL_APPLICATION_USER_PRIVILEGES']
assign attr['rs-mysql']['application_database_name'], ENV['MYSQL_DATABASE_NAME']
assign attr['rs-mysql']['server_repl_password'], ENV['MYSQL_SERVER_REPL_PASSWORD']

attr['rs-mysql']['device'] = {}
assign attr['rs-mysql']['device']['count'], ENV['MYSQL_DEVICE_COUNT']
assign attr['rs-mysql']['device']['mount_point'], ENV['MYSQL_DEVICE_MPOINT']
assign attr['rs-mysql']['device']['nickname'], ENV['MYSQL_DEVICE_NICKNAME']
assign attr['rs-mysql']['device']['volume_size'], ENV['MYSQL_DEVICE_VOLUME_SIZE']
assign attr['rs-mysql']['device']['iops'], ENV['MYSQL_DEVICE_IOPS']
assign attr['rs-mysql']['device']['volume_type'], ENV['MYSQL_DEVICE_VOLUME_TYPE']
assign attr['rs-mysql']['device']['filesystem'], ENV['MYSQL_DEVICE_FILESYSTEM']
assign attr['rs-mysql']['device']['detach_timeout'], ENV['MYSQL_DEVICE_DETACH_TIMEOUT']
assign attr['rs-mysql']['device']['destroy_on_decommision'], ENV['MYSQL_DEVICE_DESTROY_ON_DECOMMISION']

attr['rs-mysql']['backup'] = {}
assign attr['rs-mysql']['backup']['lineage'], ENV['MYSQL_BACKUP_LINEAGE']

attr['rs-mysql']['backup']['keep'] = {}
assign attr['rs-mysql']['backup']['keep']['dailies'], ENV['MYSQL_BACKUP_KEEP_DAILIES']
assign attr['rs-mysql']['backup']['keep']['weeklies'], ENV['MYSQL_BACKUP_KEEP_WEEKLIES']
assign attr['rs-mysql']['backup']['keep']['monthlies'], ENV['MYSQL_BACKUP_KEEP_MONTHLIES']
assign attr['rs-mysql']['backup']['keep']['yearlies'], ENV['MYSQL_BACKUP_KEEP_YEARLIES']
assign attr['rs-mysql']['backup']['keep']['last'], ENV['MYSQL_BACKUP_KEEP_LAST']

attr['rs-mysql']['backup']['schedule'] = {}
assign attr['rs-mysql']['backup']['schedule']['enable'], ENV['MYSQL_BACKUP_SCHEDULE_ENABLE']
assign attr['rs-mysql']['backup']['schedule']['hour'], ENV['MYSQL_BACKUP_SCHEDULE_HOUR']
assign attr['rs-mysql']['backup']['schedule']['minute'], ENV['MYSQL_BACKUP_SCHEDULE_MINUTE']

attr['rs-mysql']['restore'] = {}
assign attr['rs-mysql']['restore']['lineage'], ENV['MYSQL_RESTORE_LINEAGE']
assign attr['rs-mysql']['restore']['timestamp'], ENV['MYSQL_RESTORE_TIMESTAMP']

attr['rs-mysql']['dns'] = {}
assign attr['rs-mysql']['dns']['master_fqdn'], ENV['MYSQL_DNS_MASTER_FQDN']
assign attr['rs-mysql']['dns']['user_key'], ENV['MYSQL_DNS_USER_KEY']
assign attr['rs-mysql']['dns']['secret_key'], ENV['MYSQL_DNS_SECRET_KEY']

attr['rs-mysql']['import'] = {}
assign attr['rs-mysql']['import']['private_key'], ENV['MYSQL_IMPORT_PRIVATE_KEY']
assign attr['rs-mysql']['import']['repository'], ENV['MYSQL_IMPORT_REPOSITORY']
assign attr['rs-mysql']['import']['revision'], ENV['MYSQL_IMPORT_REPOSITORY_REVISION']
assign attr['rs-mysql']['import']['dump_file'], ENV['MYSQL_IMPORT_DUMP_FILE']
puts attr.to_json
EOF
