#!/bin/sh

# page: https://github.com/soko1/copyme
# email: nullbsd at gmail dot com
# donate: 1PEj2ArhenkvoaAdq1FvjNF8qF8d6ByxRF (bitcoin)

CONF=copyme.cfg

needpackage() {
    echo
    echo "I need $1."
    echo
    echo "Please, run:"
    echo "$ sudo apt-get install $1"
    echo
    echo "and try again."
    echo
    exit
}

# check configuration file
if [ -f $CONF ]; then
. ./$CONF
else
  echo
  echo "I need \"copyme.cfg\"."
  echo
  echo "Please, run:"
  echo "$ wget https://raw.githubusercontent.com/soko1/copyme/master/copyme.cfg.sample"
  echo "$ mv copyme.cfg.sample copyme.cfg"
  echo
  echo "and edit file \"copyme.cfg\"".
  echo
  exit
fi

# check permission
if [ `stat -c %a "$CONF"` -ne 600 ]; then
	echo
	echo "I need secure permission for file \"$CONF\"."
	echo "Please, run:\n"
	echo "$ chmod 600 $CONF\n"
	exit
fi

# check whether megatools package is installed
if ! type "megaput" > /dev/null; then
    needpackage "megatools"
fi
if ! type "gpg" > /dev/null; then
    ineedpackage "gnupg"
fi


# check needing dirs
if [ ! -d $BACKUP_DEST ]; then
    echo
    echo "$BACKUP_DEST not found!\n"
    echo "Please, run:\n$ mkdir $BACKUP_DEST"
    exit;
fi

# check and remove old archive
#if [ -f $BACKUP_DEST/$ARCHIVE.tgz.gpg ]; then
#        rm -f $BACKUP_DEST/$ARCHIVE.tgz.gpg
#fi

# pre backup commands
$PRE_BACKUP_COMMANDS

# backup
tar -cvpzf $BACKUP_DEST/$ARCHIVE.tgz $TARARGS $BACKUP_SOURCE

# encrypting
gpg -c --passphrase $GPG_PASSWD $BACKUP_DEST/$ARCHIVE.tgz

# fix permissions
chmod 600 $BACKUP_DEST/$ARCHIVE.tgz.gpg


# remove tar-achive 
rm -f $BACKUP_DEST/$ARCHIVE.tgz

# after backup commands
$AFTER_BACKUP_COMMANDS

# upload ecnrypt tar-archive to mega.nz
megaput -u $MEGAUSER -p $MEGAPASSWD $BACKUP_DEST/$ARCHIVE.tgz.gpg

