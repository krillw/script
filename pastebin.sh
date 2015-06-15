#!/bin/bash
# Paste at Pastebin.com using command line (browsers are slow, right?)
# coder  : Anil Dewani
# date   : November 7, 2010
# forker : Igor Duarte Cardoso
# date   : March 12, 2014
# forker : Petr Manek
# date   : May 21, 2015
 
# Don't forget to set your Unique Developer API Key here
# http://pastebin.com/api#1
API_KEY=cd38137becb05b0f57743628a031fc0b
 
# If you want to use private pastes or just keep track of your record,
# set your credentials corresponding to the API_KEY below. (very security, such safe, wow)
USER_NAME=krillw
USER_PASSWORD=
 
#help function
howto()
{
    echo "\
   Pastebin.com Bash Script \
  
    Usage : $0 [ -n <paste name> ] [ -e <paste email> ] [ -t <type of code> ] [ -d <expiration> ] [ -a <access> ] [ -h ]
   
    <paste name>   Specify the name of paste to be used (optional)
    <paste email>  Specify email to be used while pasting (optional)
    <type of code> Specify code language used, use any of the following values (optional and default value is plain text)
    <expiration>   Specify time interval to retain the paste (optional and default value is never)
    <access>       Specify 0 for public, 1 for unlisted, 2 for private (optional and default value is unlisted)

    => Some famous [ -t <type of code> ] Values::

    php - PHP
    actionscript3 - Action Script 3
    asp - ASP
    bash - BASH script
    c - C language
    csharp - C#
    cpp - C++ 
    java - JAVA
    sql - SQL 
    "
}
 
 
NAME=
EMAIL=
TYPE=text # see http://pastebin.com/api#1 for full list of types
PRIVATE=1 # 0=public, 1=unlisted, 2=private
EXPIRATION=N # either: N, 10M, 1H, 1D, 1W, 2W, 1M
 
#getopts, config
while getopts "n:e:t:d:a:h" OPTION
do
    case $OPTION in
        n)
            NAME=$OPTARG
            ;;
        e)
            EMAIL=$OPTARG
            ;;
    	t)
        	TYPE=$OPTARG
        	;;
        d)
        	EXPIRATION=$OPTARG
        	;;
        a)
        	PRIVATE=$OPTARG
        	;;
        h)
            howto
            exit
            ;;
    ?)
        howto
        exit
        ;;
    esac
done
 
#get data from stdin
INPUT="$(</dev/stdin)"
 
querystring="api_dev_key=${API_KEY}&api_option=paste&api_paste_private=${PRIVATE}&api_paste_expire_date=${EXPIRATION}&api_paste_code=${INPUT}&api_paste_name=${NAME}&api_paste_email=${EMAIL}&api_paste_format=${TYPE}"
 
#if credentials are provided, obtain user key
if [ ! -z "$USER_NAME" ]; then
	loginstring="api_dev_key=${API_KEY}&api_user_name=${USER_NAME}&api_user_password=${USER_PASSWORD}"
	key=$(curl -s -d "${loginstring}" http://pastebin.com/api/api_login.php)
	querystring="${querystring}&api_user_key=${key}"
fi
 
#post data to pastebin.com API
curl -d "${querystring}" http://pastebin.com/api/api_post.php
 
echo ""

