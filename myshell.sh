#!/bin/bash
# Custom shell 


clear

echo -e "\n\e[4mAuthor:\e[24m\t\tRaminta Zelvyte"
echo -e "\e[4mStudent No:\e[24m\tC13526123"
echo -e "\e[4mAssignment:\e[24m\tCA1 - Create Custom shell"
echo -e "\e[4mDue Date:\e[24m\t24th October 2016"

printf "\n"
echo -e "\e[92m ===============================================\e[0m"
echo -e "\e[92m|						|\e[0m"
echo -e "\e[92m|		Welcome To MYSHELL		|\e[0m"
echo -e "\e[92m|						|\e[0m"
echo -e "\e[92m ===============================================\e[0m"
printf "\n\n"

echo -e "\e[4mType 'help' or '?' to list commands\e[24m\n"

gethelp()
{
	echo -e "\e[95mType 'help' or '?' to see this list\n\n"
	echo -e "\e[1;4mCommand           | Description                                                   \e[1;24m\n"
	echo 	"  pw		  | Print Working Directory"		
        echo -e	"		  | If any command-tails are specified, they will be ignored"
	echo -e " 		  | (External command)\n"
	echo -e "  ifc		  | Default: Display settings for the first intf (eth0)."
	echo -e "		  | If an intf is specified - display information for that intf"
	echo -e " 		  | (External command)\n"
	echo -e "  dt		  | Displays current date and time on the system"
	echo -e "		  | (Internal command)\n"
	echo -e "  ud		  | Display user information: "
	echo -e " 		  | uid, gid, username, groupname, iNode for home dir."
	echo -e " 		  | (Internal command) \n"
	echo -e "  exit		  | Logout of the custom shell of the user."
	echo -e " 		  | Return to the previous location.\n\n"
        return
}

helpMsg="Please refer to the help page using command 'help' or '?'"


# created a directory to store my external commands
# however could not get pointers to point to a path properly
#if [ ! -d "$HOME/bin" ]; then
#	mkdir $HOME/bin
#fi
#PATH=$PATH:$HOME/bin
#
#mybin=$HOME/bin
#chmod 777 $mybin

getpwd()
{
	# an external pwd command is forked
	# it runs as a subprocess
	echo `/bin/pwd`

	# tried to create a pointer to the path of the command
	# ln -s `/bin/pwd` "$mybin/pw"
	#echo `$mybin/pw`
	return
}

function getifc()
{	
	default=`/sbin/ifconfig eth0`

	# the following 'sed' command string has been taken out as a snippet from the internet
	# to display network interfaces in a more readable manner
	# - each characteristic of intf displayed on a new line
	
	if [ $# -eq 1 ]; then
		echo $default | sed 's/\(:[^: ]\+\) \([^(]\)/\1\n\2/g;s/\()\)/\1\n/;s/^ \+//'
	elif [ $# -eq 2 ]; then
		case $2 in
			("-a" | "-s" | "-v") 
				# ignore any tail options provided, only if it's been entered as a 2nd argument
				echo $default | sed 's/\(:[^: ]\+\) \([^(]\)/\1\n\2/g;s/\()\)/\1\n/;s/^ \+//'
				;;
			("eth0" | "eth1" | "lo")
				# display any known intf that's been specified as a 2nd argument
				echo `/sbin/ifconfig $2` | sed 's/\(:[^: ]\+\) \([^(]\)/\1\n\2/g;s/\()\)/\1\n/;s/^ \+//'
				;;
			(*)
				echo "ERROR: Option "$2" is not recognized"
				echo $helpMsg
				;;
		esac
	elif [ $# -eq 3 ]; then
		case $2 in 
			("-a" | "-s" | "-v")
				case $3 in 
					("eth0" | "eth1" | "lo" )
						echo `/sbin/ifconfig $3` | sed 's/\(:[^: ]\+\) \([^(]\)/\1\n\2/g;s/\()\)/\1\n/;s/^ \+//'
						;;
					(*)
						echo "ERROR: Option "$3" is not recognized"
                                		echo $helpMsg
                                		;;
				esac
				;;
			(*)
                                echo "ERROR: Option "$2" is not recognized"
                                echo $helpMsg
                                ;;
		esac	

	elif [ $# -gt 3 ]; then 
		echo -e "\e[91mOnly one interface permitted at a time eg. 'ifc eth1'\e[0m"
		echo $helpMsg
	fi 
	return  
}

function casestat {
	case $code in
                ("exit")
                        echo -e "\n\e[91mLogging Out\e[0m"
                        printf "\n"
                        sleep 1
                        exit 0
                        ;;
                ("history")
                        display="$(nl -b a "$hist")"
                        echo "$display"
                        ;;
                ("!"*)
			lines=$(wc -l < $hist)
                        n=${code:1}
			
			if [ $n -ge $lines ]; then 
				echo "ERROR: There's only "$lines" commands in history file"
			else  
                       		code=`sed -n "${n}{p;q;}" $hist`
				echo "Command: "$code""
				casestat $code
			fi
                        ;;
                ("")
                        # when return key is pressed without holding any arguments
                        # continue on with the while loop, redisplaying the PS1 variable
                        continue
                        ;;
                ("?" | "help")
                        gethelp
                        ;;
		("pw" | "pw -L" | "pw -P" | "pw -LP")
                        # ignore any command-tails
                        # only print wokring directory using external pwd command
                        getpwd
                        ;;
                ("ifc"*)
			getifc $@
                        ;;
                ("ud")
                        echo "TOdO"
                        echo "print user info using internal commands"
                        ;;
                ("dt")
			now=`date +%Y%m%d%H%M%S`
			echo -e "\e[1mCurrent Date:\e[0m " $now
                        ;;
                (*)
                        printf "\e[91mInvalid command.\e[0m \nPlease refer to the "
                        printf "help page using command 'help' or '?'.\n"
                        ;;


        esac

}

PS1="$(tput setaf 6)$(whoami)$(tput sgr0)@$(hostname):$(tput setaf 2)$HOME$(tput sgr0)\$" 


# get the file where commands will be stored
hist=.myshell_history

i=1

while [ $i -eq 1 ]
do
	read -p  "$PS1 " code

#	if [ "$code" = $'\033[A' ]; then
#		echo "up arrow"
#	fi
	
	casestat $code	
	if [ "$code" != "" ]; then 	
		# store commands in history file
		echo "$code" >> "$hist"	
	fi
done

