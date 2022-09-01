#!/bin/bash

# ------------------------- Colors -------------------------
endColor="\033[0m\e[0m"
greenColor="\e[0;32m\033[1m"
redColor="\e[0;31m\033[1m"
blueColor="\e[0;34m\033[1m"
yellowColor="\e[0;33m\033[1m"
purpleColor="\e[0;35m\033[1m"
turquoiseColor="\e[0;36m\033[1m"
grayColor="\e[0;37m\033[1m"

# -------------------------------Ctrl + C Interruption-------------------------------
trap ctrl_c INT

function ctrl_c(){
        echo -e "\n\n${yellowColor}[*]${endColor}${grayColor} Exiting...\n${endColor}"
        ifconfig wlan0mon down > /dev/null 2>&1; sleep 1
	iwconfig wlan0mon mode monitor > /dev/null 2>&1; sleep 1
        ifconfig wlan0mon up > /dev/null 2>&1; sleep 1
        airmon-ng stop wlan0mon > /dev/null 2>&1; sleep 1
        ifconfig wlx00c0ca9947ec up > /dev/null 2>&1; sleep 1
        exit 0
}

# ------------------------- Banner -------------------------
function banner(){
        echo -e "\n${purpleColor}███╗   ███╗ ██████╗ ███╗   ██╗██╗████████╗ ██████╗ ██████╗ "
        sleep 0.05
        echo -e "████╗ ████║██╔═══██╗████╗  ██║██║╚══██╔══╝██╔═══██╗██╔══██╗"
        sleep 0.05
        echo -e "██╔████╔██║██║   ██║██╔██╗ ██║██║   ██║   ██║   ██║██████╔╝"
        sleep 0.05
        echo -e "██║╚██╔╝██║██║   ██║██║╚██╗██║██║   ██║   ██║   ██║██╔══██╗"
        sleep 0.05
        echo -e "██║ ╚═╝ ██║╚██████╔╝██║ ╚████║██║   ██║   ╚██████╔╝██║  ██║"
        sleep 0.05
        echo -e "╚═╝     ╚═╝ ╚═════╝ ╚═╝  ╚═══╝╚═╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝"
        sleep 0.05
        echo -e "    ███╗   ███╗ ██████╗ ██████╗ ███████╗                   "
        sleep 0.05
        echo -e "    ████╗ ████║██╔═══██╗██╔══██╗██╔════╝                   "
        sleep 0.05
        echo -e "    ██╔████╔██║██║   ██║██║  ██║█████╗          ${endColor}${redColor}by${endColor}${purpleColor}           "
        sleep 0.05
        echo -e "    ██║╚██╔╝██║██║   ██║██║  ██║██╔══╝        ${endColor}${redColor}l0l1nk${endColor}${purpleColor}             "
        sleep 0.05
        echo -e "    ██║ ╚═╝ ██║╚██████╔╝██████╔╝███████╗                   "
        sleep 0.05
        echo -e "    ╚═╝     ╚═╝ ╚═════╝ ╚═════╝ ╚══════╝                   ${endColor}"
}

# ------------------------- Check/Install Dependences -------------------------
function dependences(){
	sleep 1; counter=0
	echo -e "\n${yellowColor}[*]${endColor}${grayColor} Comprobando si aircrack-ng está instalado...${endColor}"; sleep 1.5
	if [ "$(command) -v aircrack-ng" ]; then
		echo -e "\n${greenColor}..........[V] aircrack-ng se encuentra instalado${endColor}"; sleep 1.5
		echo -e "\n${yellowColor}[*]${endColor}${grayColor} Iniciando programa...${endColor}"; sleep 2
		clear
		monitor_mode
	else
		echo -e "\n${redColor}..........[X] aircrack-ng no se encuentra instalado${endColor}"
		exit 1
	fi
}

# ------------------------- Monitor Mode -------------------------
function monitor_mode(){
	ifconfig wlx00c0ca9947ec up > /dev/null 2>&1
	if [ "$(ifconfig wlan0mon 2> /dev/null)" ]; then
		echo -e "\n${yellowColor}[*]${endColor}${grayColor} Desactivando el modo monitor...\n${endColor}"
		ifconfig wlan0mon down > /dev/null 2>&1; sleep 1
	        iwconfig wlan0mon mode monitor > /dev/null 2>&1; sleep 1
        	ifconfig wlan0mon up > /dev/null 2>&1; sleep 1
        	airmon-ng stop wlan0mon > /dev/null 2>&1; sleep 1
        	ifconfig wlx00c0ca9947ec up > /dev/null 2>&1; sleep 1
		ifconfig wlx00c0ca9947ec 2> /dev/null; sleep 1
		echo -e "${redColor}..........[V] Modo monitor desactivado${endColor}"; sleep 1
	else
		echo -e "\n${yellowColor}[*]${endColor}${grayColor} Activando el modo monitor...\n${endColor}"; sleep 1
		airmon-ng start wlx00c0ca9947ec > /dev/null 2>&1; sleep 1
		ifconfig wlan0mon up > /dev/null 2>&1; sleep 1
		ifconfig wlan0mon 2> /dev/null; sleep 1
		echo -e "${greenColor}..........[V] Modo monitor activado${endColor}"; sleep 1
	fi
}

# ------------------------- Main Program -------------------------
if [ "$(id -u)" == "0" ]; then
	clear
	banner
	dependences
else
        echo -e "\n${redColor}[!] Es necesario ser root para ejecutar la herramienta${endColor}"
        exit 1
fi
