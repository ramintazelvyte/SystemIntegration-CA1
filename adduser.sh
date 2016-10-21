#!/bin/bash
# Script to add new user


printf "\n\n"
echo "==========================================================="
echo
if [ $(id -u) -eq 0 ]; then	
	printf "\e[1mEnter username : \e[0m"
	read username
	password=''
	printf "\e[1mEnter password : \e[0m" 

	
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
		echo "==========================================================="
		echo -e "\n\e[91mUser '$username' exists!\e[0m"
		printf "\n"
		exit 1
	else
		pass=$(perl -e 'print crypt($ARGV[0], "password")' $password)
		useradd -m -p $pass $username
		echo
		echo "===========================================================" 
		[ $? -eq 0 ] && echo -e "\n\e[92mUser has been added to system!\e[0m" || echo -e "\n\e[91mFailed to add a user!\e[0m"
		printf "\n"

		sleep 2
	fi
else

	echo -e "\e[91mOnly root may add a user to the system\e[0m"
	printf "\n"
	echo "==========================================================="

	exit 2
fi

