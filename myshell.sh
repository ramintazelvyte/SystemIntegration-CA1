#!/bin/bash
# Custom shell 
# Author: Raminta Zelvyte
# Student No: C13526123
# Assignemnt - CA1
# Due Date: 24th October 2016


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

# Function to print help sheet with the commands and their descriptions/usage
gethelp()
{
	echo -e "\e[95mType 'help' or '?' to see this list\n\n"
	echo -e "\e[1;4mCommand           | Description                                               \e[1;24m\n"
	echo -e "  dt\t\t  | Displays current date and time on the system"
        echo -e "\t\t  | (Internal command)\n"
	echo -e "  exit\t\t  | Logout from the custom shell of the user."
        echo -e "\t\t  | Return to the previous location.\n"
	echo -e "  history\t  | Display all of the commands entered previously."
	echo -e "\t\t  | Quick access to commands - '!<command#>' eg. '!50'.\n"
	echo -e "  ifc\t\t  | Default: Display settings for the first intf (eth0)."
        echo -e "\t\t  | If an intf is specified - display information for that intf"
	echo -e "\t\t  | (External command)\n"
	echo -e "  pw\t\t  | Print Working Directory"		
        echo -e	"\t\t  | If any command-tails are specified, they will be ignored"
	echo -e "\t\t  | (External command)\n"
	echo -e "  ud\t\t  | Display user information: "
	echo -e "\t\t  | uid, gid, username, groupname, iNode for home dir."
	echo -e "\t\t  | (Internal command) \n\n"
        return
}


helpMsg="Please refer to the help page using command 'help' or '?'"


function getifc()
{	
	default=`/sbin/ifconfig eth0`

	# the following 'sed' command string has been taken out as a snippet 
	# from the internet
	# to display network interfaces in a more readable manner
	# - each characteristic of intf displayed on a new line
	
	regex="s/\(:[^: ]\+\) \([^(]\)/\1\n\2/g;s/\()\)/\1\n/;s/^ \+//"

	if [ $# -eq 1 ]; then
		echo $default | sed "$regex"
	elif [ $# -eq 2 ]; then
		case $2 in
			("-a" | "-s" | "-v") 
				# ignore any tail options provided, only if 
				# it's been entered as a 2nd argument
				echo $default | sed "$regex"
				;;
			("eth0" | "eth1" | "lo")
				# display any known intf that's been specified 
				# as a 2nd argument
				echo `/sbin/ifconfig $2` | sed "$regex"
				;;
			(*)
				echo "ERROR: Option "$2" is not recognized"
				echo $helpMsg
				;;
		esac
	elif [ $# -eq 3 ]; then
		case $2 in 
			("-a" | "-s" | "-v")
				# if an option is specified and the intf after it is 
				# recognized, then this intf is displayed
				case $3 in 
					("eth0" | "eth1" | "lo" )
						echo `/sbin/ifconfig $3` | sed "$regex"
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


getud() 
{
	# get user details using local commands stored in /bin dir
	uid=`/SystemIntegration-CA1/bin/id -u $username`
	gid=`/SystemIntegration-CA1/bin/id -g $username`
	usernm=`/SystemIntegration-CA1/bin/whoami`
	groupnm=`/SystemIntegration-CA1/bin/id -g -n $username`
	inode=`/SystemIntegration-CA1/bin/ls -i -d $HOME`
	
	echo -e "\e[1mUser ID:\e[0m " $uid
	echo -e "\e[1mGroup ID:\e[0m " $gid
	echo -e "\e[1mUsername:\e[0m " $usernm
	echo -e "\e[1mGroup name:\e[0m " $groupnm
	echo -e "\e[1mHome Dir iNode:\e[0m " $inode
}


function casestat {
	case $code in
                ("exit")
                        echo -e "\n\e[91mLogging Out\e[0m"
                        printf "\n"
                        sleep 1
			clear
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
				echo "ERROR: There's only "$lines" commands in history file."
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
                        echo `/bin/pwd`
                        ;;
                ("ifc"*)
			getifc $@
                        ;;
                ("ud")
			getud
                        ;;
                ("dt")
			now=`/SystemIntegration-CA1/bin/date`
			echo -e "\e[1mCurrent Date:\e[0m " $now
                        ;;
		("ls")
			echo `/SystemIntegration-CA1/bin/ls`
			;;
                (*)
                        printf "\e[91mInvalid command.\e[0m \nPlease refer to the "
                        printf "help page using command 'help' or '?'.\n"
                        ;;
        esac
}


# set first prompt string
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

clear

