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
attr = {}

attr['mysql'] = {}
attr['mysql']['server_root_password'] = ENV['MYSQL_SERVER_ROOT_PASSWORD'] if  ENV['MYSQL_SERVER_ROOT_PASSWORD']
attr['mysql']['server_debian_password'] = ENV['MYSQL_SERVER_ROOT_PASSWORD'] if  ENV['MYSQL_SERVER_ROOT_PASSWORD']
attr['mysql']['server_repl_password'] = ENV['MYSQL_SERVER_REPL_PASSWORD'] if  ENV['MYSQL_SERVER_REPL_PASSWORD']

attr['rs-mysql'] = {}
attr['rs-mysql']['server_root_password'] =ENV['MYSQL_SERVER_ROOT_PASSWORD'] if ENV['MYSQL_SERVER_ROOT_PASSWORD']
attr['rs-mysql']['bind_network_interface'] = ENV['MYSQL_BIND_INTERFACE'] if  ENV['MYSQL_BIND_INTERFACE']
attr['rs-mysql']['server_usage'] = ENV['MYSQL_SERVER_USAGE'] if  ENV['MYSQL_SERVER_USAGE']
attr['rs-mysql']['application_username'] = ENV['MYSQL_APPLICATION_USERNAME'] if  ENV['MYSQL_APPLICATION_USERNAME']
attr['rs-mysql']['application_password'] = ENV['MYSQL_APPLICATION_PASSWORD'] if  ENV['MYSQL_APPLICATION_PASSWORD']
attr['rs-mysql']['application_user_privileges'] = ENV['MYSQL_APPLICATION_USER_PRIVILEGES'] if  ENV['MYSQL_APPLICATION_USER_PRIVILEGES']
attr['rs-mysql']['application_database_name'] = ENV['MYSQL_DATABASE_NAME'] if  ENV['MYSQL_DATABASE_NAME']
attr['rs-mysql']['server_repl_password'] = ENV['MYSQL_SERVER_REPL_PASSWORD'] if  ENV['MYSQL_SERVER_REPL_PASSWORD']

attr['rs-mysql']['device'] = {}
attr['rs-mysql']['device']['count'] = ENV['MYSQL_DEVICE_COUNT'] if  ENV['MYSQL_DEVICE_COUNT']
attr['rs-mysql']['device']['mount_point'] = ENV['MYSQL_DEVICE_MPOINT'] if  ENV['MYSQL_DEVICE_MPOINT']
attr['rs-mysql']['device']['nickname'] = ENV['MYSQL_DEVICE_NICKNAME'] if  ENV['MYSQL_DEVICE_NICKNAME']
attr['rs-mysql']['device']['volume_size'] = ENV['MYSQL_DEVICE_VOLUME_SIZE'] if  ENV['MYSQL_DEVICE_VOLUME_SIZE']
attr['rs-mysql']['device']['iops'] = ENV['MYSQL_DEVICE_IOPS'] if  ENV['MYSQL_DEVICE_IOPS']
attr['rs-mysql']['device']['volume_type'] = ENV['MYSQL_DEVICE_VOLUME_TYPE'] if  ENV['MYSQL_DEVICE_VOLUME_TYPE']
attr['rs-mysql']['device']['filesystem'] = ENV['MYSQL_DEVICE_FILESYSTEM'] if  ENV['MYSQL_DEVICE_FILESYSTEM']
attr['rs-mysql']['device']['detach_timeout'] = ENV['MYSQL_DEVICE_DETACH_TIMEOUT'] if  ENV['MYSQL_DEVICE_DETACH_TIMEOUT']
attr['rs-mysql']['device']['destroy_on_decommision'] = ENV['MYSQL_DEVICE_DESTROY_ON_DECOMMISION'] if  ENV['MYSQL_DEVICE_DESTROY_ON_DECOMMISION']

attr['rs-mysql']['backup'] = {}
attr['rs-mysql']['backup']['lineage'] = ENV['MYSQL_BACKUP_LINEAGE'] if  ENV['MYSQL_BACKUP_LINEAGE']

attr['rs-mysql']['backup']['keep'] = {}
attr['rs-mysql']['backup']['keep']['dailies'] = ENV['MYSQL_BACKUP_KEEP_DAILIES'] if  ENV['MYSQL_BACKUP_KEEP_DAILIES']
attr['rs-mysql']['backup']['keep']['weeklies'] = ENV['MYSQL_BACKUP_KEEP_WEEKLIES'] if  ENV['MYSQL_BACKUP_KEEP_WEEKLIES']
attr['rs-mysql']['backup']['keep']['monthlies'] = ENV['MYSQL_BACKUP_KEEP_MONTHLIES'] if  ENV['MYSQL_BACKUP_KEEP_MONTHLIES']
attr['rs-mysql']['backup']['keep']['yearlies'] = ENV['MYSQL_BACKUP_KEEP_YEARLIES'] if  ENV['MYSQL_BACKUP_KEEP_YEARLIES']
attr['rs-mysql']['backup']['keep']['last'] = ENV['MYSQL_BACKUP_KEEP_LAST'] if  ENV['MYSQL_BACKUP_KEEP_LAST']

attr['rs-mysql']['backup']['schedule'] = {}
attr['rs-mysql']['backup']['schedule']['enable'] = ENV['MYSQL_BACKUP_SCHEDULE_ENABLE'] if  ENV['MYSQL_BACKUP_SCHEDULE_ENABLE']
attr['rs-mysql']['backup']['schedule']['hour'] = ENV['MYSQL_BACKUP_SCHEDULE_HOUR'] if  ENV['MYSQL_BACKUP_SCHEDULE_HOUR']
attr['rs-mysql']['backup']['schedule']['minute'] = ENV['MYSQL_BACKUP_SCHEDULE_MINUTE'] if  ENV['MYSQL_BACKUP_SCHEDULE_MINUTE']

attr['rs-mysql']['restore'] = {}
attr['rs-mysql']['restore']['lineage'] = ENV['MYSQL_RESTORE_LINEAGE'] if  ENV['MYSQL_RESTORE_LINEAGE']
attr['rs-mysql']['restore']['timestamp'] = ENV['MYSQL_RESTORE_TIMESTAMP'] if  ENV['MYSQL_RESTORE_TIMESTAMP']

attr['rs-mysql']['dns'] = {}
attr['rs-mysql']['dns']['master_fqdn'] = ENV['MYSQL_DNS_MASTER_FQDN'] if  ENV['MYSQL_DNS_MASTER_FQDN']
attr['rs-mysql']['dns']['user_key'] = ENV['MYSQL_DNS_USER_KEY'] if  ENV['MYSQL_DNS_USER_KEY']
attr['rs-mysql']['dns']['secret_key'] = ENV['MYSQL_DNS_SECRET_KEY'] if  ENV['MYSQL_DNS_SECRET_KEY']

attr['rs-mysql']['import'] = {}
attr['rs-mysql']['import']['private_key'] = ENV['MYSQL_IMPORT_PRIVATE_KEY'] if  ENV['MYSQL_IMPORT_PRIVATE_KEY']
attr['rs-mysql']['import']['repository'] = ENV['MYSQL_IMPORT_REPOSITORY'] if  ENV['MYSQL_IMPORT_REPOSITORY']
attr['rs-mysql']['import']['revision'] = ENV['MYSQL_IMPORT_REPOSITORY_REVISION'] if  ENV['MYSQL_IMPORT_REPOSITORY_REVISION']
attr['rs-mysql']['import']['dump_file'] = ENV['MYSQL_IMPORT_DUMP_FILE'] if  ENV['MYSQL_IMPORT_DUMP_FILE']
puts attr.to_json
EOF
