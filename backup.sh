#!/bin/sh
source color.sh

# backup.sh - Simple backup script
# @author pbondoer
# @license CC0 - https://creativecommons.org/publicdomain/zero/1.0

# Log message colors
ERROR=$RED
INFO=$CYAN
FILE=$YELLOW
WARNING=$YELLOW
SUCCESS=$GREEN
TITLE=$MAGENTA

log() {
	tput setaf $1
	printf "$2" | tee -a $DIR/backup.log
}

# Configuration
BASEDIR=~
BACKUP_BASEDIR=/sgoinfre/goinfre/Perso/$USER
BACKUP_DIR=$BACKUP_BASEDIR/backup
BACKUPS=`find $BACKUP_DIR/* -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' '`
TODAY=`date +%y-%m-%d/%Hh%M`
DIR=$BACKUP_DIR/$TODAY

# Make and own our basedir
mkdir -p $BACKUP_BASEDIR
chmod 700 $BACKUP_BASEDIR
chown $USER $BACKUP_BASEDIR

# Make our backup directory
mkdir -p $DIR

# Check if it's there
if [ $? -ne 0 ] || [ ! -d $DIR ]
then
	log $ERROR "Error: Couldn't create base directory ($DIR).\n"
	exit 1
fi

# Create log files
touch $DIR/backup.log
touch $DIR/error.log

# Count the amount of backups
log $TITLE "// backup.sh //\n"
printf "Found $BACKUPS existing backups\n"
printf "Destination directory is $DIR\n\n"

# Check if our file list is there
if [ ! -f $BASEDIR/.backup ]
then
	log $ERROR "Error: couldn't find file list ($BASEDIR/.backup). Nothing to backup.\n"
	exit 1
fi

# Count our file list entries
file_count=`wc -l < $BASEDIR/.backup | tr -d ' '`
log $INFO "Backing up $file_count entries...\n"
i=1

# Read each entry
while read cur_file
do
	log $FILE "$cur_file"
	log $WHITE " ($i / $file_count) "
	# Check if it exists
	if [ ! -f $BASEDIR/$cur_file ] && [ ! -d $BASEDIR/$cur_file ]
	then
		log $ERROR "... does not exist\n"
	else
		# Determine in which directory to copy
		cur_dir=$DIR
		if [ -d $BASEDIR/$cur_file ]
		then
			cur_dir=$DIR/$cur_file
			mkdir -p $cur_dir
		fi
		# Magic
		rsync -a -W -r $BASEDIR/$cur_file $cur_dir 2>> $DIR/error.log
		# If wizardry fails, check why
		REASON=$?
		if [ $REASON -eq 0 ]
		then
			log $SUCCESS "... done!\n"
		else
			case $REASON in
			20)
				log $INFO "... interrupted by user ($REASON)\n"
				rm -rf $DIR
				exit $REASON
				;;
			23)
				log $WARNING "... partial transfer ($REASON)\n"
				;;
			*)
				log $ERROR "... error ($REASON)\n"
				;;
			esac
		fi
	fi
	i=$(($i+1))
done < $BASEDIR/.backup

echo "lol" > $DIR/error.log

# Check if there were errors
size="$(wc -c <"$DIR/error.log")"
if [ -f $DIR/error.log ] && [ $size -gt 0 ]
then
	log $ERROR "\n/!\\ There were errors. Please check the log file.\n"
	log $WARNING "  -> $DIR/error.log\n"
else
	rm -f $DIR/error.log 2> /dev/null
fi

# Check the filesize and display it at the end of the script
log $INFO "\nChecking file size...\n"
size=`du -s -h $DIR | cut -d $'\t' -f1 | tr -d ' '`
if [ ! $? -eq 0 ]
then
	size='unknown'
fi

# Hurray!
log $SUCCESS "Done! New backup (size $size) created.\n"
log $TITLE "Log file: $DIR/backup.log\n"
