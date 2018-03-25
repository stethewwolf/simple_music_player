#!/bin/bash

RADIO_LIST="$HOME/.smp/radio_list.txt"
PLAYLIST_DIR="$HOME/.smp/playlists"

### RADIO
function radio {
	nl=`cat $RADIO_LIST | wc -l ` ;
	nl=$((nl/2)) ;

	case $2 in 
		l	)	i=1;	
				while read line ; do
					if  ! expr "$line" : "http" >> /dev/null ; then
						echo " $i : $line" ;
						i=$((i+1)) ; 
					fi
			  	done < $RADIO_LIST ;;
		
		[1-$nl]	) 	i=$2
					clear ;
					echo -n "playing : "
					sed -n "$(((i*2)-1)) p" < $RADIO_LIST
					mplayer `sed -n "$((i*2)) p" < $RADIO_LIST` 2> /dev/null & ;; 
		
		add	)	echo "[ $3 ]" >> $RADIO_LIST 
			 	echo "$4" >> $RADIO_LIST ;;

		rm	)	i=$3
				sed  -i "$(((i*2)-1)),$((i*2)) d"  $RADIO_LIST ;;

		*	)	echo "smp r [ l | <radio id> | add <radio name> <url> | rm <radio id> ]" ;; 

esac 

return ;
}

### MUSIC
function music {

	np=$(ls $PLAYLIST_DIR | wc -l)

	case $2 in 
		new 	) 	if [ "$#" != "4" ] ; then
						echo "smp m new <dir> <name> "
						return ;
					fi
					touch $PLAYLIST_DIR/$4 ;

					find -L $3 -type f -name "*mp3" >> $PLAYLIST_DIR/$4
					echo "file added to $4:"
					cat $PLAYLIST_DIR/$4
					echo ;;
		
		n-rand 	)	;;
		
		l 		)	if [ "$np" == "0" ] ; then
						echo "NO PLAYLIST FOUND"
						return ;
					fi

					j=1;
					for i in $(ls $PLAYLIST_DIR)  ; do
						echo -n "$j - [ $i ]"
						j=$((j+1)) ;
					done 
					echo ;;
		
		[1-$np] )	j=1;
					for i in $(ls $PLAYLIST_DIR)  ; do
						if [ "$3" == "$j" ] ; then 
							mplayer -playlist $PLAYLIST_DIR/$i
							break ;
						fi
						
						j=$((j+1)) ;
					done ;;

		rm		)	;;

		*		)  echo "m [ new <dir> <name> | n-rand | l | <pls id> | rm <pls id> ]"
	esac

}

#### MAIN

ls -a $HOME | grep "smp" >> /dev/null

if [ "$?" == "1" ] ; then
	echo "config folder not found.."
	echo "creating its.."
	mkdir 	$HOME/.smp
	touch $RADIO_LIST
	mkdir $PLAYLIST_DIR
fi

case $1 in	

	r	)	radio $*;;

	m	)	music $*;;

	stop ) pkill mplayer ;;

	*	) echo "smp [ r [ l | <radio id> | add <radio name> <url> | rm <radio id> ] | m [ new <dir> <name> | n-rand | l | <pls id> | rm <pls id> ] | stop ] " ;;

esac

exit 0;
