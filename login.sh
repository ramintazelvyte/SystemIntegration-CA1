#!/bin/bash
# Shell scrip to login to a custom shell

clear 

echo -e "\e[92m =======================================\e[0m"
echo -e "\e[92m|		LOGGING IN		|\e[0m"
echo -e "\e[92m =======================================\e[0m"
echo
printf "\t\e[1mUsername : \e[0m"
read username
printf "\t\e[1mPassword : \e[0m"


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
		# set default shell for the user eg /bin/sh
		sudo chsh -s /bin/sh $username
		
		echo -e "\n\e[92mLogged In successfully!\e[0m"
		printf "\n"

		# log the user in the root mode of the user
		su - $username
	else
		printf "\n"
		echo -e "\e[91mUsername or Password incorrect\e[0m"
		printf "\n"
		exit 1
	fi
else
	printf "\n"
	echo -e "\e[91mUser '$username' doesn't exist! \e[0m"
	printf "\n"
	exit 1
fi

