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

getpwd()
{
	# an external pwd command is forked
	# it runs as a subprocess
	(echo `/bin/pwd`)
	return
}


PS1="$(tput setaf 6)$(whoami)$(tput sgr0)@$(tput setaf 4)$(hostname)$(tput sgr0):\
$(tput setaf 2)~$username$(tput sgr0)\$" 

i=1

while [ $i -eq 1 ]
do
	read -p "$PS1 " code

	case $code in
		("exit")
			echo -e "\n\e[91mLogging Out\e[0m"
			printf "\n"
			sleep 1
        	        exit 0
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
			# only print wokring directory using ecternal pwd command
			getpwd
			;;
		("ifc")
			echo "TODO"
			echo "display ifconfig settings of certain intfs"
			;;
		("ud")
			echo "TOdO"
			echo "print user info using internal commands"
			;;	
		("dt")
			echo "TODO"
			echo "print date using internal command"
			;;
		(*)
			printf "\e[91mInvalid command.\e[0m \nPlease refer to the " 
			printf "help page using command 'help' or '?'.\n"
			;;
			
	
	esac
		
done

