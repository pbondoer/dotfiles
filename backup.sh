# backup.sh - Simple backup script
# @author pbondoer
# @license CC0 - https://creativecommons.org/publicdomain/zero/1.0

# Color constants
BLACK=0
RED=1
GREEN=2
YELLOW=3
BLUE=4
MAGENTA=5
CYAN=6
WHITE=7

# Log message colors
ERROR=$RED
INFO=$CYAN
FILE=$YELLOW
SUCCESS=$GREEN
TITLE=$MAGENTA

# Configuration
BASEDIR=~
BACKUP_BASEDIR=/backup

log() {
	tput setaf $1
	printf "$2"
}

log $TITLE "// backup.sh //\n"

# Count the amount of backups
BACKUPS=`find $BACKUP_BASEDIR/* -mindepth 1 -maxdepth 1 -type d 2>/dev/null | wc -l | tr -d ' '`
printf "Found $BACKUPS existing backups\n"
TODAY=`date +%y-%m-%d/%Hh%M`
DIR=$BACKUP_BASEDIR/$TODAY
printf "Destination directory is $DIR\n\n"

# Make our backup directory
mkdir -p $DIR

# Check if it's there
if [ $? -ne 0 ] || [ ! -d $DIR ]
then
	log $ERROR "Error: Couldn't create base directory ($DIR).\n"
	exit 1
fi

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
		rsync -a -W -r $BASEDIR/$cur_file $cur_dir 2> /dev/null
		# If wizardry fails, check why
		REASON=$?
		if [ $REASON -eq 0 ]
		then
			log $SUCCESS "... done!\n"
		else
			if [ $REASON -eq 20 ]
			then
				log $INFO "... interrupted by user ($REASON)\n"
				exit $REASON
			fi
			log $ERROR "... error ($REASON)\n"
		fi
	fi
	i=$(($i+1))
done < $BASEDIR/.backup

# Check the filesize and display it at the end of the script
log $INFO "\nChecking file size...\n"
size=`du -s -h $DIR | cut -d $'\t' -f1 | tr -d ' '`
if [ ! $? -eq 0 ]
then
	size='unknown'
fi

# Hurray!
log $SUCCESS "Done! New backup (size $size) created.\n"
