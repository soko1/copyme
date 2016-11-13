#!/bin/sh

# page: https://github.com/soko1/copyme
# email: nullbsd at gmail dot com
# donate: 1PEj2ArhenkvoaAdq1FvjNF8qF8d6ByxRF (bitcoin)


# check configuration file
if [ -f copyme.cfg ]; then
. ./copyme.cfg
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

# check needing dirs
if [ ! -d $BACKUP_DEST ]; then
    echo "$BACKUP_DEST not found!\n"
    echo "Please, run:\n$ mkdir $BACKUP_DEST"
    exit;
fi

# check and remove old archive
if [ -f $BACKUP_DEST/$ARCHIVE.tgz.gpg ]; then
        rm -f $BACKUP_DEST/$ARCHIVE.tgz.gpg
fi

# backup
tar -cvpzf $BACKUP_DEST/$ARCHIVE.tgz --exclude=$BACKUP_DEST --exclude=/swapfile --one-file-system $BACKUP_SOURCE

# encrypting
gpg -c --passphrase $GPG_PASSWD $BACKUP_DEST/$ARCHIVE.tgz

# remove tar-achive 
rm -f $BACKUP_DEST/$ARCHIVE.tgz

# upload ecnrypt tar-archive to mega.nz
megaput -u $MEGAUSER -p $MEGAPASSWD $BACKUP_DEST/$ARCHIVE.tgz.gpg

