name "appeng-mysql"

maintainer "AppEng EMEA"
description "AppEng wrappers for running RightScale MySQL recipes with RightLink 10"
version '0.0.10'


recipe "appeng-mysql::setup", "Setup inputs for usage"
recipe "appeng-mysql::default", "Sets up a standalone MySQL server"
recipe "appeng-mysql::master", "Sets up a MySQL master server"
recipe "appeng-mysql::slave", "Sets up a MySQL slave server"
recipe "appeng-mysql::backup", "Backup"
recipe "appeng-mysql::stripe", "Creates volumes, attaches them to the server, sets up a striped LVM, and moves the MySQL data to the volume"
recipe "appeng-mysql::decommision", "Destroys LVM conditionally, detaches and destroys volumes. This recipe should be used as a decommission recipe in a RightScale ServerTemplate."
recipe "appeng-mysql::dump_import", "Download and import mysql dump file."
recipe "appeng-mysql::volume", "Creates a volume, attaches it to the server, and moves the MySQL data to the volume"
recipe "appeng-mysql::schedule", "Enable/disable periodic backups based on appeng-mysql/schedule/enable"
recipe "appeng-mysql::collectd", "Sets up collectd monitoring for MySQL server"

depends 'rs-mysql'

attribute 'MYSQL_SERVER_USAGE',
  :display_name => 'Server Usage',
  :description => "The Server Usage method. It is either 'dedicated' or 'shared'. In a 'dedicated' server all" +
    " server resources are dedicated to MySQL. In a 'shared' server, MySQL utilizes only half of the resources." +
    " Example: 'dedicated'",
  :default => 'dedicated',
  :required => 'optional',
  :recipes => ['appeng-mysql::default', 'appeng-mysql::master', 'appeng-mysql::slave']

attribute 'MYSQL_BIND_INTERFACE',
  :display_name => 'MySQL Bind Network Interface',
  :description => "The network interface to use for MySQL bind. It can be either" +
    " 'private' or 'public' interface.",
  :default => 'private',
  :choice => ['public', 'private'],
  :required => 'optional',
  :recipes => ['appeng-mysql::default', 'appeng-mysql::master', 'appeng-mysql::slave']

attribute 'MYSQL_SERVER_ROOT_PASSWORD',
  :display_name => 'MySQL Root Password',
  :description => 'The root password for MySQL server. Example: cred:MYSQL_ROOT_PASSWORD',
  :required => 'required',
  :recipes => ['appeng-mysql::default', 'appeng-mysql::master', 'appeng-mysql::slave']

attribute 'MYSQL_APPLICATION_USERNAME',
  :display_name => 'MySQL Application Username',
  :description => 'The username of the application user. Example: cred:MYSQL_APPLICATION_USERNAME',
  :required => 'optional',
  :recipes => ['appeng-mysql::default', 'appeng-mysql::master', 'appeng-mysql::slave']

attribute 'MYSQL_APPLICATION_PASSWORD',
  :display_name => 'MySQL Application Password',
  :description => 'The password of the application user. Example: cred:MYSQL_APPLICATION_PASSWORD',
  :required => 'optional',
  :recipes => ['appeng-mysql::default', 'appeng-mysql::master', 'appeng-mysql::slave']

attribute 'MYSQL_APPLICATION_USER_PRIVILEGES',
  :display_name => 'MySQL Application User Privileges',
  :description => 'The privileges given to the application user. This can be an array of mysql privilege types.' +
    ' Example: select, update, insert',
  :required => 'optional',
  :type => 'array',
  :default => [:select, :update, :insert],
  :recipes => ['appeng-mysql::default', 'appeng-mysql::master', 'appeng-mysql::slave']

attribute 'MYSQL_DATABASE_NAME',
  :display_name => 'MySQL Database Name',
  :description => 'The name of the application database. Example: mydb',
  :required => 'optional',
  :recipes => ['appeng-mysql::default', 'appeng-mysql::master', 'appeng-mysql::slave']

attribute 'MYSQL_REPL_PASSWORD',
  :display_name => 'MySQL Slave Replication Password',
  :description => 'The replication password set on the master database and used by the slave to authenticate and' +
    ' connect. If not set, appeng-mysql/server_root_password will be used. Example cred:MYSQL_REPLICATION_PASSWORD',
  :required => 'optional',
  :recipes => ['appeng-mysql::default', 'appeng-mysql::master', 'appeng-mysql::slave']

attribute 'MYSQL_DEVICE_COUNT',
  :display_name => 'Device Count',
  :description => 'The number of devices to create and use in the Logical Volume. If this value is set to more than' +
    ' 1, it will create the specified number of devices and create an LVM on the devices.',
  :default => '2',
  :recipes => ['appeng-mysql::stripe', 'appeng-mysql::decommission'],
  :required => 'recommended'

attribute 'MYSQL_DEVICE_MPOINT',
  :display_name => 'Device Mount Point',
  :description => 'The mount point to mount the device on. Example: /mnt/storage',
  :default => '/mnt/storage',
  :recipes => ['appeng-mysql::volume', 'appeng-mysql::stripe', 'appeng-mysql::decommission'],
  :required => 'recommended'

attribute 'MYSQL_DEVICE_NICKNAME',
  :display_name => 'Device Nickname',
  :description => 'Nickname for the device. appeng-mysql::volume uses this for the filesystem label, which is' +
    ' restricted to 12 characters.  If longer than 12 characters, the filesystem label will be set to the' +
    ' first 12 characters. Example: data_storage',
  :default => 'data_storage',
  :recipes => ['appeng-mysql::volume', 'appeng-mysql::stripe', 'appeng-mysql::decommission'],
  :required => 'recommended'

attribute 'MYSQL_DEVICE_VOLUME_SIZE',
  :display_name => 'Device Volume Size',
  :description => 'Size of the volume or logical volume to create (in GB). Example: 10',
  :default => '10',
  :recipes => ['appeng-mysql::volume', 'appeng-mysql::stripe'],
  :required => 'recommended'

attribute 'MYSQL_DEVICE_IOPS',
  :display_name => 'Device IOPS',
  :description => 'IO Operations Per Second to use for the device. Currently this value is only used on AWS clouds.' +
    ' Example: 100',
  :recipes => ['appeng-mysql::volume', 'appeng-mysql::stripe'],
  :required => 'optional'

attribute 'MYSQL_VOLUME_TYPE',
  :display_name => 'Volume Type',
  :description => 'Volume Type to use for creating volumes. Example: gp2',
  :recipes => ['appeng-mysql::volume', 'appeng-mysql::stripe'],
  :required => 'optional'

attribute 'MYSQL_DEVICE_FILESYSTEM',
  :display_name => 'Device Filesystem',
  :description => 'The filesystem to be used on the device. Defaults are based on OS and determined in' +
    ' attributes/volume.rb. Example: ext4',
  :recipes => ['appeng-mysql::volume', 'appeng-mysql::stripe'],
  :required => 'optional'

attribute 'MYSQL_DEVICE_DETACH_TIMEOUT',
  :display_name => 'Detach Timeout',
  :description => 'Amount of time (in seconds) to wait for a single volume to detach at decommission. Example: 300',
  :default => '300',
  :recipes => ['appeng-mysql::volume', 'appeng-mysql::stripe'],
  :required => 'optional'

attribute 'MYSQL_DEVICE_DESTROY_ON_DECOMMISION',
  :display_name => 'Destroy on Decommission',
  :description => 'If set to true, the devices will be destroyed on decommission.',
  :default => 'false',
  :recipes => ['appeng-mysql::decommission'],
  :required => 'recommended'

attribute 'MYSQL_BACKUP_LINEAGE',
  :display_name => 'Backup Lineage',
  :description => 'The prefix that will be used to name/locate the backup of the MySQL database server.',
  :required => 'required',
  :recipes => ['appeng-mysql::default', 'appeng-mysql::master', 'appeng-mysql::slave', 'appeng-mysql::backup']

attribute 'MYSQL_RESTORE_LINEAGE',
  :display_name => 'Restore Lineage',
  :description => 'The lineage name to restore backups. Example: staging',
  :recipes => ['appeng-mysql::volume', 'appeng-mysql::stripe'],
  :required => 'recommended'

attribute 'MYSQL_RESTORE_TIMESTAMP',
  :display_name => 'Restore Timestamp',
  :description => 'The timestamp (in seconds since UNIX epoch) to select a backup to restore from.' +
    ' The backup selected will have been created on or before this timestamp. Example: 1391473172',
  :recipes => ['appeng-mysql::volume', 'appeng-mysql::stripe'],
  :required => 'recommended'

attribute 'MYSQL_BACKUP_KEEP_DAILIES',
  :display_name => 'Backup Keep Dailies',
  :description => 'Number of daily backups to keep. Example: 14',
  :default => '14',
  :recipes => ['appeng-mysql::backup'],
  :required => 'optional'

attribute 'MYSQL_BACKUP_KEEP_WEEKLIES',
  :display_name => 'Backup Keep Weeklies',
  :description => 'Number of weekly backups to keep. Example: 6',
  :default => '6',
  :recipes => ['appeng-mysql::backup'],
  :required => 'optional'

attribute 'MYSQL_BACKUP_KEEP_MONTHLIES',
  :display_name => 'Backup Keep Monthlies',
  :description => 'Number of monthly backups to keep. Example: 12',
  :default => '12',
  :recipes => ['appeng-mysql::backup'],
  :required => 'optional'

attribute 'MYSQL_BACKUP_KEEP_YEARLIES',
  :display_name => 'Backup Keep Yearlies',
  :description => 'Number of yearly backups to keep. Example: 2',
  :default => '2',
  :recipes => ['appeng-mysql::backup'],
  :required => 'optional'

attribute 'MYSQL_BACKUP_KEEP_LAST',
  :display_name => 'Backup Keep Last Snapshots',
  :description => 'Number of snapshots to keep. Example: 60',
  :default => '60',
  :recipes => ['appeng-mysql::backup'],
  :required => 'optional'

attribute 'MYSQL_BACKUP_SCHEDULE_ENABLE',
  :display_name => 'Backup Schedule Enable',
  :description => 'Enable or disable periodic backup schedule',
  :default => 'false',
  :choice => ['true', 'false'],
  :recipes => ['appeng-mysql::schedule'],
  :required => 'recommended'

attribute 'MYSQL_BACKUP_SCHEDULE_HOUR',
  :display_name => 'Backup Schedule Hour',
  :description => "The hour to schedule the backup on. This value should abide by crontab syntax. Use '*' for taking" +
    ' backups every hour. Example: 23',
  :recipes => ['appeng-mysql::schedule'],
  :required => 'required'

attribute 'MYSQL_BACKUP_SCHEDULE_MINUTE',
  :display_name => 'Backup Schedule Minute',
  :description => 'The minute to schedule the backup on. This value should abide by crontab syntax. Example: 30',
  :recipes => ['appeng-mysql::schedule'],
  :required => 'required'

attribute 'MYSQL_DNS_MASTER_FQDN',
  :display_name => 'MySQL Database FQDN',
  :description => 'The fully qualified domain name of the MySQL master database server.',
  :required => 'optional',
  :recipes => ['appeng-mysql::master']

attribute 'MYSQL_DNS_USER_KEY',
  :display_name => 'DNS User Key',
  :description => 'The user key to access/modify the DNS records.',
  :required => 'optional',
  :recipes => ['appeng-mysql::master']

attribute 'MYSQL_DNS_SECRET_KEY',
  :display_name => 'DNS Secret Key',
  :description => 'The secret key to access/modify the DNS records.',
  :required => 'optional',
  :recipes => ['appeng-mysql::master']

attribute 'MYSQL_IMPORT_SECRET_KEY',
  :display_name => 'Import Secret Key',
  :description => 'The private key to access the repository via SSH. Example: Cred:DB_IMPORT_KEY',
  :required => 'optional',
  :recipes => ['appeng-mysql::dump_import']

attribute 'MYSQL_IMPORT_REPOSITORY',
  :display_name => 'Import Repository URL',
  :description => 'The repository location containing the database dump file to import.' +
    ' Example: git://example.com/dbfiles/database_dumpfiles.git',
  :required => 'optional',
  :recipes => ['appeng-mysql::dump_import']

attribute 'MYSQL_IMPORT_REPOSITORY_REVISION',
  :display_name => 'Import Repository Revision',
  :description => 'The revision of the database dump file to import.' +
    ' Example: master',
  :required => 'optional',
  :recipes => ['appeng-mysql::dump_import']

attribute 'MYSQL_IMPORT_DUMP_FILE',
  :display_name => 'Import Filename',
  :description => 'Filename of the database dump file to import.' +
    ' Example: dumpfile_20140102.gz',
  :required => 'optional',
  :recipes => ['appeng-mysql::dump_import']
