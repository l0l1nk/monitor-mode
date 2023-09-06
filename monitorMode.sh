#!/bin/bash

# --------------- Colors ---------------
endColor="\033[0m\e[0m"
greenColor="\e[0;32m\033[1m"
redColor="\e[0;31m\033[1m"
blueColor="\e[0;34m\033[1m"
yellowColor="\e[0;33m\033[1m"
purpleColor="\e[0;35m\033[1m"
turquoiseColor="\e[0;36m\033[1m"
grayColor="\e[0;37m\033[1m"


# --------------- Ctrl+C Interruption ---------------
trap ctrl_c INT

function ctrl_c(){
        echo -e "\n\n${yellowColor}[*]${grayColor} Exiting...\n${endColor}"
        tput cnorm
        airmon-ng stop ${networkCart} > /dev/null 2>&1
        ifconfig ${networkCard} up > /dev/null 2>&1
        results
        exit 1
}


# --------------- Banner ---------------
function banner(){
        tput civis; clear
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


# --------------- Help Panel ---------------
function helpPanel(){
  echo -e "\n${yellowColor}[*]${grayColor} Uso: ./monitorMode.sh${endColor}"
	echo -e "\n\t${purpleColor}m)${grayColor} Modo de Ejecución:${endColor}"
	echo -e "\t\t${redColor}activar${endColor}"
	echo -e "\t\t${redColor}desactivar${endColor}"
	echo -e "\t${purpleColor}n)${grayColor} Nombre de la tarjeta de red${endColor}"
  echo -e "\t${purpleColor}h)${grayColor} Mostrar este panel de ayuda${endColor}\n"
	exit 0
}


# --------------- Show Results ---------------
function results(){
  echo -e "\n${yellowColor}[*]${grayColor} Network Card:${endColor}\n"
  ifconfig ${networkCard}
  echo -e "\n\n${yellowColor}[*]${grayColor} Mac Address:${endColor}\n"
  macchanger -s ${networkCard}
}


# --------------- Check/Install Dependencies ---------------
function dependencies(){
  sleep 1; dependencies=(aircrack-ng macchanger) # ----- Dependencies -----
  for program in "${dependencies[@]}"; do # ----- Bucle Dependencies -----
    echo -ne "\n${yellowColor}[*]${grayColor} Comprobando si $program está instalado...${endColor}\n"; sleep 0.5 # ----- Trace -----
    test -f /usr/bin/$program # ----- Check Program -----
    if [ "$(echo $?)" == "0" ]; then
      echo -ne "\n${greenColor}..........[V] $program se encuentra instalado${endColor}\n"; sleep 0.5 # ----- Trace -----
    else
      echo -ne "\n${redColor}..........[X] $program no se encuentra instalado${endColor}\n"; sleep 0.5 # ----- Trace -----
      exit 1
    fi
  done
  echo -e "\n${yellowColor}[*]${grayColor} Iniciando programa...${endColor}"; sleep 1 # ----- Trace -----
  clear
  monitorMode
}


# --------------- Monitor Mode ---------------
function monitorMode(){
  ifconfig ${networkCard} up > /dev/null 2>&1 # ----- Register Actual Network Card -----
  if [ $cardMode == "desactivar" ]; then
    echo -e "\n${yellowColor}[*]${grayColor} Desactivando el modo monitor...\n${endColor}" # ----- Trace -----
    airmon-ng stop ${networkCard} > /dev/null 2>&1; sleep 1 # ----- Stop Monitor Mode of Network Card -----
    networkCard=$(iwconfig | awk '/wl/ {print $1}' | sed 's/://g' 2> /dev/null) # ----- Save Network Card Name -----
    clear
    echo -e "\n${yellowColor}[*]${grayColor} Desactivando el modo monitor...${endColor}" # ----- Trace -----
    ifconfig ${networkCard} up > /dev/null 2>&1; sleep 1 # ----- Register New Network Card -----
    echo -e "\n${greenColor}..........[V] Modo monitor desactivado${endColor}"; sleep 0.5 # ----- Trace -----
  elif [ $cardMode == "activar" ]; then
    echo -e "\n${yellowColor}[*]${grayColor} Activando el modo monitor...\n${endColor}"; sleep 1 # ----- Trace -----
    airmon-ng start ${networkCard} > /dev/null 2>&1; sleep 1 # ----- Start Monitor Mode on Network Card -----
    airmon-ng check kill > /dev/null 2>&1; sleep 1 # ----- Kill Danger Threads -----
    networkCard=$(iwconfig | awk '/mon/ {print $1}' | sed 's/://g' 2> /dev/null) # ----- Save Network Card Name -----
    clear
    echo -e "\n${yellowColor}[*]${grayColor} Activando el modo monitor...${endColor}" # ----- Trace -----
    newMac=$(echo "$(macchanger -l | grep -i "national security agency" | awk '{print $3}'):6b:31:64") # ----- Save New Mac Adress (National Security Agency) -----
    macchanger --mac=${newMac} ${networkCard} > /dev/null 2>&1 # ----- Change Mac Adress -----
    ifconfig ${networkCard} up > /dev/null 2>&1; sleep 1 # ----- Register New Network Card -----
    echo -e "\n${greenColor}..........[V] Modo monitor activado${endColor}"; sleep 0.5 # ----- Trace -----
  fi
}


# --------------- Main Program ---------------
if [ "$(id -u)" == "0" ]; then
	declare -i parameter_counter=0; while getopts ":n:m:i:h:" arg; do
    case $arg in
      n) networkCard=$OPTARG; let parameter_counter+=1 ;; # ----- Argument -n -----
      m) cardMode=$OPTARG; let parameter_counter+=1 ;; # ----- Argument -m -----
      h) helpPanel ;; # ----- Argument -h -----
    esac
  done
  if [ $parameter_counter -ne 2 ]; then # --- Check Valid Arguments ---
    clear
    helpPanel
  else
    if [[ $cardMode == "activar" ]] || [[ $cardMode == "desactivar" ]]; then # --- Check Valid -m Argument ---
      ifconfig $networkCard > /dev/null 2>&1 # ----- Check Valid Network Card -----
      if [ "$(echo $?)" == "0" ]; then # --- Check Status Code ---
        banner
        dependencies
        results
        tput cnorm; exit 0
      else
        echo -e "\n${redColor}[X] Insert a valid Network Card${endColor}\n" # ----- Trace -----
        exit 1
      fi
    else
      helpPanel
      exit 1
    fi
  fi
else
        echo -e "\n${redColor}[!] Es necesario ser root para ejecutar la herramienta${endColor}" # ----- Trace -----
        exit 1
fi
