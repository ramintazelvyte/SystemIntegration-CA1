# SystemIntegration-CA1

### Author: Raminta Zelvyte
### Student No: C13526123
### Assignment: CA1 - Create Custom Shell
### Due Date: 24th October 2016

## Introduction

This networking shell has been developed for the specific purpose to assist the network administration by simplifying the selection of commands and options, and present a limited set of functionality to a Linux system user. Such that they can examine and set a limited selection of network related settings on linux, which can be used to achieve a specific task. This custom shell runs on a Linux system. 

## Installation

* Have a Linux system installed on your machine.
* Login as a superuser and change into a root directory:
    - 'su -'
    - 'cd /'
* Install 'git':
    - 'apt-get install git'
    - press 'y'
* Clone this github repository and change into this directory:
    - 'git clone https://github.com/ramintazelvyte/SystemIntegration-CA1.git
    - 'cd /SystemIntegration-CA1

## Code Operation 

* Run a hidden '.chperm.sh' file to add execute permisions to executable files:
    - 'sh .chperm.sh'
* Run an executable './login' file:
    - './login'
* A message will be displayed asking if one wants to add a new user.
  - If one wants to add a new user, press 'y'.
    - One will be re-directed to a page to enter new user details.
    - Then one will be re-directed to a log in page, to login to a custom shell.
  - If you want to use an existing user, press 'n'.
    - One will be re-directed to a log in page.
    - Enter user details to log in to a custom shell.
* When the user logs in, one will be re-directed to a custom shell - 'MYSHELL'
  - User can refer to the help page by entering commands 'help' or '?', to view all available commands in this custom shell.
  - Help page contains commands and their descriptions/usages, to help the user operate through the shell with ease.
  - If some of the commands will be specified with the known command tails (from the original bash shell), they will be ignored.
    Default commands, will be executed instead.
  - This shell can execute only those commands that are listed in the help page. Any other commands will not be recognized by the shell,     and an error message will be dislayed along with a help message saying to refer back to the help page.
  - When the custom shell is started, a hidden '.myshell_history' file is created. All the commands that have been entered by the user
    are stored in this file. User can view those commands with command 'history'. All of the previous commands will be displayed and
    numbered (by reference to its line number).
    Quick access is allowed to those commands - '!command#' eg. '!20' - This will display the 20th command from the history sheet and
    execute it. If a command number is specified, but it doesn't exist, an appropriate error will be displayed.
  - Error checking/handling is done throughout. Appropriate messages are displayed in regards to specific errors, to help the user 
    understand what errors have been encountered.
    
### ENJOY :) 
  
    
