#!/bin/bash
# Script to add new user

clear

cols=$(tput cols)
rows=$(tput lines)
width=40
centercol=$(((cols-width)/2))
centerrow=$(((rows-5)/2))

tput cup $centerrow $centercol
echo -e "\e[92m =======================================\e[0m"
tput cup $((centerrow+1)) $centercol
echo -e "\e[92m|              ADD NEW USER             |\e[0m"
tput cup $((centerrow+2)) $centercol
echo -e "\e[92m =======================================\e[0m"

echo

if [ $(id -u) -eq 0 ]; then
	tput cup $((centerrow+4)) $centercol	
	printf "\t   \e[1mEnter username : \e[0m"
	read username
	password=''
	tput cup $((centerrow+5)) $centercol
	printf "\t   \e[1mEnter password : \e[0m" 

	
	# Code snipped - while loop - printing stars instead of chars or nothing	
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

	egrep "^$username" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo
		tput cup $((centerrow+7)) $centercol
		echo "========================================="
		tput cup $((centerrow+9)) $centercol
		echo -e "\t     \e[91mUser '$username' exists!\e[0m"
		sleep 2
		clear
		exit 1
	else
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		useradd -m -p $pass $username
		echo
		tput cup $((centerrow+7)) $centercol
		echo "=========================================" 
		tput cup $((centerrow+9)) $centercol
		[ $? -eq 0 ] && echo -e " \t  \e[92mUser has been added to system!\e[0m" || echo -e "\t\t\e[91mFailed to add a user!\e[0m"
		sleep 2	
	fi

else
	tput cup $((centerrow+4)) $centercol
	echo-e "\e[91mOnly root may add a user to the system\e[0m"
	printf "\n"
	tput cup $((centerrow+6)) $centercol
	echo "========================================="
	sleep 2
	clear
	exit 2
fi

clear
