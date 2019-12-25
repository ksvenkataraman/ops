#!/bin/bash

<<COMMENT

Helper script to move an existing mix of written and blank CD's
to a set of folders.
Argument 1 - #of CD's to copy over.
Argument 2 - Start count for the directory to copy over the CD to.

Ensure the file has the required permissions before running.
Launching the script as cd_datatx.sh 
COMMENT

#Script take 2 input arguments 
# Get preliminary status of CD-ROm drive.
is_status=`/lib/udev/cdrom_id -d /dev/sr0 2>&1 | grep "status: "`
echo "$is_status"
# Create loop variables
num_cds_start=1
num_cds_end=$1
dir_cnt=$2
dir_name="CD"
for ((i=$num_cds_start; i<=$num_cds_end; i++))
do
    echo "CD number $i"
    is_status=`/lib/udev/cdrom_id -d /dev/sr0 2>&1 | grep "status: "`
    echo "$is_status"
    if [[ $is_status == *blank ]]; then
	echo "The disc is blank - MOVE EJECTED disc to empty pile."
    elif [ -z "$is_status" ]; then
	echo "The value is NULL - no disc is present, please insert disc"
    else
	new_dir_name=${dir_name}${dir_cnt}
	echo "Drive is not blank, creating directory: $new_dir_name"
	$(mkdir ${new_dir_name})
	inp_path=`lsblk | grep 'sr0' | awk '{$1=$2=$3=$4=$5=$6=""; print $0 }'| sed -e 's/^[ ]*//'`
	echo $inp_path
	inp_path_trial1=$(printf %q "${inp_path}")
	echo $inp_path_trial1    
	cp_cmd_tr="cp -rfv ${inp_path_trial1}/* ${new_dir_name}/"
	echo $cp_cmd_tr
        eval $cp_cmd_tr
	echo "Copying Done."
	echo "The disc is written to - MOVE EJECTED disc to written pile."
	((dir_cnt++))
    fi
    eject /dev/sr0
    echo "Change next CD if needed ('q' to quit), wait till the CD is loaded by the OS and then press any key to continue."
    read -n 1 k <&1
    if [[ $k = q ]]; then
	echo " Bye bye.."
	break
    else
	continue
    fi   
done
