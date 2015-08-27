#!/bin/bash

echo 'cookbook_path "/var/spool/rightlink/cookbooks/"' > /tmp/appeng-config.rb

cat <<EOF >>/tmp/appeng-inputs.json
{
  "normal": {
    "rs-mysql": {
      "server_root_password": "$MYSQL_SERVER_ROOT_PASSWORD",
      "bind_network_interface": "$MYSQL_BIND_INTERFACE",
      "server_usage": $MYSQL_SERVER_USAGE",
      "application_username": "$MYSQL_APPLICATION_USERNAME",
      "application_password": $MYSQL_APPLICATION_PASSWORD",
      "application_user_privileges": "$MYSQL_APPLICATION_USER_PRIVILEGES",
      "application_database_name": "$MYSQL_DATABASE_NAME",
      "server_repl_password": "$MYSQL_REPL_PASSWORD"
      "device": {
        "count": "$MYSQL_DEVICE_COUNT",
        "mount_point": "$MYSQL_DEVICE_MPOINT",
        "nickname": "$MYSQL_DEVICE_NICKNAME",
        "volume_size": $MYSQL_DEVICE_VOLUME_SIZE",
        "iops": "$MYSQL_DEVICE_IOPS",
        "volume_type": "$MYSQL_VOLUME_TYPE",
        "filesystem": "$MYSQL_DEVICE_FILESYSTEM",
        "detach_timeout": "$MYSQL_DEVICE_DETACH_TIMEOUT",
        "destroy_on_decommision": "$MYSQL_DEVICE_DESTROY_ON_DECOMMISION"
      },
      "backup": {
        "lineage": "$MYSQL_BACKUP_LINEAGE",
        "keep": {
          "dailies": "$MYSQL_BACKUP_KEEP_DAILIES",
          "weeklies": "$MYSQL_BACKUP_KEEP_WEEKLIES",
          "monthlies": "$MYSQL_BACKUP_KEEP_MONTHLIES",
          "yearlies": "$MYSQL_BACKUP_KEEP_YEARLIES",
          "keep_last": "$MYSQL_BACKUP_KEEP_LAST"
        },
      },
      "restore": {
        "lineage": "$MYSQL_RESTORE_LINEAGE",
        "timestamp": "$MYSQL_RESTORE_TIMESTAMP"
      },
      "shedule": {
        "enable": "$MYSQL_BACKUP_SCHEDULE_ENABLE",
        "hour": "$MYSQL_BACKUP_SCHEDULE_HOUR",
        "minute": "$MYSQL_BACKUP_SCHEDULE_MINUTE"
      }
    },
    "dns": {
      "master_fqdn": "$MYSQL_DNS_MASTER_FQDN",
      "user_key": "$MYSQL_DNS_USER_KEY",
      "secret_key": "$MYSQL_DNS_SECRET_KEY"
    },
    "import": {
      "private_key": "$MYSQL_IMPORT_SECRET_KEY",
      "repository": "$MYSQL_IMPORT_REPOSITORY",
      "revision": "$MYSQL_IMPORT_REPOSITORY_REVISION",
      "dump_file": "$MYSQL_IMPORT_DUMP_FILE"
    }
  }
}
EOF
