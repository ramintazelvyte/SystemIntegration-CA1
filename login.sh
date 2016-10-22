#!/bin/bash
# Shell scrip to login to a custom shell

printf "\n\n"

echo "Do you want to add a new user? [y/n]"
read ans

case $ans in 
	("y" | "Y")
		/SystemIntegration-CA1/adduser.sh
		;;
	("n" | "N")
		sleep 0.5
		break
		;;
	(*)
		echo "Error: Invalid input."
		exit 1
		;;
esac

clear

cols=$(tput cols)
rows=$(tput lines)
width=40
centercol=$(((cols-width)/2))
centerrow=$(((rows-5)/2))

tput cup $centerrow $centercol
echo -e "\e[92m ====================================\e[0m"
tput cup $((centerrow+1)) $centercol
echo -e "\e[92m|\t\tLOGGING IN\t\t|\e[0m"
tput cup $((centerrow+2)) $centercol
echo -e "\e[92m ====================================\e[0m"
echo
tput cup $((centerrow+4)) $centercol
printf "\t   \e[1mUsername : \e[0m"
read username
tput cup $((centerrow+5)) $centercol
printf "\t   \e[1mPassword : \e[0m"


# The following while loop is a snippet
# from the internet

# Display '*' char instead of ascii chars
while IFS= read -r -s -n1 char; do
  	[[ -z $char ]] && { printf '\n'; break; } # ENTER pressed; output \n and break.
  	if [[ $char == $'\x7f' ]]; then # backspace was pressed
      		# Remove last char from output variable.
      		[[ -n $password ]] && password=${password%?}
      		# Erase '*' to the left.
      		printf '\b \b' 
  	else
    		# Add typed char to output variable.
    		password+=$char
    		# Print '*' instead.
    		printf '*'
  	fi
done

correct=$(</etc/shadow awk -v user=$username -F : 'user == $1 {print $2}')

egrep "^$username" /etc/passwd >/dev/null

if [ $? -eq 0 ]; then
	pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
	
	if [ $correct = $pass ]; then
		# set default shell for the user - /bin/myshell 
		# create a symlink between the original shell file 
		# and the executable file in the /bin directory
		
		if [ ! -f /bin/myshell ]; then 
			sudo ln -s /SystemIntegration-CA1/myshell.sh /bin/myshell
			chmod 777 /SystemIntegration-CA1/myshell.sh
		fi 
		sudo chsh -s /bin/myshell $username
		
		tput cup $((centerrow+8)) $centercol
		echo "======================================"
		tput cup $((centerrow+10)) $centercol
		echo -e "\t   \e[92m Logged In successfully!\e[0m"
		printf "\n"
		
		# sleep for 1 sec 
		sleep 1.5
		# log the user in the root mode of the user
		su - $username
	else
		printf "\n"
		tput cup $((centerrow+8)) $centercol
		echo "======================================"
		tput cup $((centerrow+10)) $centercol
		echo -e "\t\e[91mUsername or Password incorrect\e[0m"
		printf "\n"
		clear
		exit 1
	fi
else
	printf "\n"
	tput cup $((centerrow+8)) $centercol
	echo "======================================"
	tput cup $((centerrow+10)) $centercol
	echo -e "\t\e[91mUser '$username' doesn't exist! \e[0m"
	printf "\n"
	clear
	exit 1
fi

