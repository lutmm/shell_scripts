#!/bin/bash

#检测源目录，如果有文件则保存到目标目录，目标目录为挂载目录
#centos7 上测试通过

#set -x
mount_dir=/mnt/nas
src_dir=/opt/mvp/image
dest_dir=/mnt/nas/image

check_mount_point() {
	if  mountpoint -q ${mount_dir} 
    then
        return 0
    else
        return 127
    fi
}

inotifywait -mqr ${src_dir} -e close_write |
    while read path action file; do
        #echo "The file '$file' appeared in directory '$path' via '$action'"
        # do something with the file
        if [[ "${file}" =~ .*jpg$ ]]; then # Does the file end with .xml?
            #echo "jpg file created" ${path} ${file} # If so, do your thing here!
			if check_mount_point ; then
				prj_name=${path#/*image/}
				#echo ${prj_name}
				#echo ${dest_dir}/${prj_name}
				[ -d ${dest_dir}/${prj_name} ] || mkdir -p  ${dest_dir}/${prj_name}		
				cp ${path}/${file} ${dest_dir}/${prj_name}
			fi
        fi
    done
