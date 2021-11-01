#!/bin/sh

#
# Name:
# -----
# Samsung_SoundBar .sh
#
# Purpose:
# --------
# Script used to manage the Samsung HW-Q900a Soundbar.
#
# Dependencies:
# -------------
#
# xpath 						
# curl
#
# Customization:
# --------------
# 
# IP                       IP address of the Soundbar
# 

# see https://github.com/bacl/WAM_API_DOC/blob/master/API_Methods.md

### HDMI1="<name>SetFunc</name><p type=\"str\" name=\"function\" val=\"hdmi1\"/>"
### HDMI2="<name>SetFunc</name><p type=\"str\" name=\"function\" val=\"hdmi2\"/>"
### ARC="<name>SetFunc</name><p type=\"str\" name=\"function\" val=\"arc\"/>"
### curl "http://$URLCMD/%3Cname%3ESetFunc%3C/name%3E%3Cp%20type=%22str%22%20name=%22function%22%20val=%22wifi%22/%3E"


FUNCTION_Parse_HTTP() {
	
	echo $URLCMD`echo "$*" | sed "s/</%3C/g" | sed "s/>/%3E/g"  | sed 's/"/%22/g' | sed "s/ /%20/g"`
	
}

FUNCTION_Get_Features() {

	SEND_CMD=`FUNCTION_Parse_HTTP "<name>GetFeatures</name>"`
    curl -s --connect-timeout 2 --max-time 20 $SEND_CMD 2>&1
    
}

FUNCTION_Get_IP() {
	
	SEND_CMD=`FUNCTION_Parse_HTTP "<name>GetMainInfo</name>"`
	CURL=`curl -s --connect-timeout 2 --max-time 20 $SEND_CMD 2>&1`
	if [ "$CURL" != "" ]
	then 
		echo "$CURL" | xpath -q -e "/UIC/speakerip/" | awk -F'[<>]' '{ print  $3 }'
	fi
	
}

FUNCTION_Software_Verson() {
	
	SEND_CMD=`FUNCTION_Parse_HTTP "<name>GetSoftwareVersion</name>"`
	CURL=`curl -s --connect-timeout 2 --max-time 20 $SEND_CMD 2>&1`
	if [ "$CURL" != "" ]
	then 
		echo "$CURL" | xpath -q -e '/UIC/response/version' | awk -F'[<>]' '{ print  $3 }'
	fi
	
}


FUNCTION_Get_Volume(){

	SEND_CMD=`FUNCTION_Parse_HTTP "<name>GetVolume</name>"`
	CURL=`curl -s --connect-timeout 2 --max-time 20 $SEND_CMD 2>&1`
	if [ "$CURL" != "" ]
	then 
	    echo "$CURL" | xpath -q -e '/UIC/response/volume' | awk -F'[<>]' '{ print  $3 }'
	fi
	
}

FUNCTION_Set_Volume(){

	SEND_CMD=`FUNCTION_Parse_HTTP "<name>SetVolume</name><p type=\"dec\" name=\"volume\" val=\"$1\"/>"`
 	CURL=`curl -s --connect-timeout 2 --max-time 20 $SEND_CMD 2>&1`
	if [ "$CURL" != "" ]
	then 
		echo "$CURL" | xpath -q -e '/UIC/response/volume' | awk -F'[<>]' '{ print  $3 }'
	fi
	
}

FUNCTION_Get_Source() {

	SEND_CMD=`FUNCTION_Parse_HTTP "<name>GetFunc</name>"`
    CURL=`curl -s --connect-timeout 2 --max-time 20 $SEND_CMD 2>&1`
	if [ "$CURL" != "" ]
	then 
		echo "$CURL" | xpath -q -e '/UIC/response/function' | awk -F'[<>]' '{ print  $3 }'
    fi
    
}
FUNCTION_Set_Source() {

	SEND_CMD=`FUNCTION_Parse_HTTP "<name>SetFunc</name><p type=\"str\" name=\"function\" val=\"$1\"/>"`
    CURL=`curl -s --connect-timeout 2 --max-time 20 $SEND_CMD 2>&1`
	if [ "$CURL" != "" ]
	then 
		echo "$CURL" | xpath -q -e '/UIC/response/function' | awk -F'[<>]' '{ print  $3 }'
    fi
    
}

FUNCTION_GetWooferLevel() {

	SEND_CMD=`FUNCTION_Parse_HTTP "<name>GetWooferLevel</name>"`
    CURL=`curl -s --connect-timeout 2 --max-time 20 $SEND_CMD 2>&1`
	if [ "$CURL" != "" ]
	then 
		echo "$CURL" | xpath -q -e '/UIC/response/level' | awk -F'[<>]' '{ print  $3 }'
    fi
    
}

FUNCTION_GetMute() {

	SEND_CMD=`FUNCTION_Parse_HTTP "<name>GetMute</name>"`
    CURL=`curl -s --connect-timeout 2 --max-time 20 $SEND_CMD 2>&1`
	if [ "$CURL" != "" ]
	then 
		echo "$CURL" | xpath -q -e '/UIC/response/mute' | awk -F'[<>]' '{ print  $3 }'
    fi
    
}

FUNCTION_SetMute() {

	SEND_CMD=`FUNCTION_Parse_HTTP '<name>SetMute</name><p type="str" name="mute" val="on"/>'`
    CURL=`curl -s --connect-timeout 2 --max-time 20 $SEND_CMD 2>&1`
	if [ "$CURL" != "" ]
	then 
		echo "$CURL" | xpath -q -e '/UIC/response/mute' | awk -F'[<>]' '{ print  $3 }'
    fi
    
}

FUNCTION_ClearMute() {

	SEND_CMD=`FUNCTION_Parse_HTTP '<name>SetMute</name><p type="str" name="mute" val="off"/>'`
    CURL=`curl -s --connect-timeout 2 --max-time 20 $SEND_CMD 2>&1`
	if [ "$CURL" != "" ]
	then 
		echo "$CURL" | xpath -q -e '/UIC/response/mute' | awk -F'[<>]' '{ print  $3 }'
    fi
    
}


FUNCTION_ShowStatus() {

	echo ${0##*/}
	echo
	echo "1. Soundbar is at `FUNCTION_Get_IP`"
	echo "2. Software Version is `FUNCTION_Software_Verson`"
	echo
	echo "3. Source is set to `FUNCTION_Get_Source`"
	echo
	echo "4. Volume is at level `FUNCTION_Get_Volume`"
	echo "5. Mute is `FUNCTION_GetMute`"
	echo "6. Woofer is set to `FUNCTION_GetWooferLevel`"
	echo
}

usage() {

echo "Usage:		"${0##*/}"-n [ip] -a -s -w -m -u -h -l -g -i [ hdmi1 | hdmi2 | arc | wifi | bt ] -v [volume]
	
OPTIONS:
   -n   IP address of soundbar 
   
   -a   Show Soundbar setup
	
   -s 	Get Source
   -i   Set Source	[hdmi1 | hdmi2 | arc | wifi | bt]
   
   -w	Get Subwoofer volume level

   -m	Mute
   -u	unMute

   -g	Get Volume
   -v	Set Volume

   -h	Increase volume by one (higher)
   -l	Decrease volume by one (lower)
"

}


#######################################################
#### SET VARIABLES HERE
#######################################################
IP="10.0.0.20"
#######################################################
#######################################################
#######################################################

#URLCMD="$IP:56001/UIC?cmd=<pwron>on</pwron>"
URLCMD="$IP:56001/UIC?cmd="

REQ_VOL=""
REQ_INPUT=""

XPATH=`which xpath | grep -v "not found"`
CURL=`which curl   | grep -v "not found"`


if [ "$XPATH" = "" ] || [ "$CURL" = "" ]
then
	echo ${0##*/}
	echo
	echo "Missing either 'xpath' or 'curl' - both are needed to run this script"
	echo "xpath is at `which xpath`"
	echo "curl  is at `which curl2`"
	exit -9
fi

while getopts "n:asi:wmugv:hl?" OPTION
do
     case $OPTION in
        n)
        	IP="$OPTARG"
        	URLCMD="$IP:56001/UIC?cmd="
            ;;
        a)
        	FUNCTION_ShowStatus
			;;
        s)
        	echo "Source is set to `FUNCTION_Get_Source`"
			;;
        i)
        	REQ_INPUT=`echo "$OPTARG" | tr '[:upper:]' '[:lower:]'`
			case "$REQ_INPUT" in
		        "hdmi1" | "hdmi2" | "arc" | "wifi" | "bt" )
		 
		         	echo "Source is set to `FUNCTION_Get_Source`"       
		        	echo "Source is now set to `FUNCTION_Set_Source $REQ_INPUT`"
				;;
		    esac

        	;;
        w)
        	echo "Woofer is set to `FUNCTION_GetWooferLevel`"
        	;;
        m)
        	echo "Volume is now muted: `FUNCTION_SetMute`"
        	;;
        u)
        	echo "Volume is now unmuted: `FUNCTION_ClearMute`"
        	;;
        g)
        	echo "Volume is at level `FUNCTION_Get_Volume`"
        	;;
        v)
        	REQ_VOL="$OPTARG"
            ;;
        h)
        	let REQ_VOL=`FUNCTION_Get_Volume`+1
			;;
		l)
        	let REQ_VOL=`FUNCTION_Get_Volume`-1
			if [ "$REQ_VOL" -lt 1 ]
			then
				REQ_VOL=""
			fi 
			;;   	
        ?)
           	usage
		   	exit
		   	;;
	esac
done

if [ "$REQ_VOL" != "" ]
then
	if [ "$REQ_VOL" -gt 12 ]
	then
		REQ_VOL=12
	fi
	echo "Volume is at level `FUNCTION_Get_Volume`"
    echo "Volume is now at level `FUNCTION_Set_Volume "$REQ_VOL"`"
fi
