#!/bin/bash
#
# Desc: functions used to output text in color
# Date: 7/9/2017

function color_echo() {
    case $1 in
      red)
        echo -e "\e[1;31m$2\e[0m"
        ;;
      green)
        echo -e "\e[1;32m$2\e[0m"
        ;;
      yellow)
        echo -e "\e[1;33m$2\e[0m"
        ;;
      blue)
        echo -e "\e[1;34m$2\e[0m"
        ;;
      carmine)
        echo -e "\e[1;35m$2\e[0m"
        ;;
      cyan)
        echo -e "\e[1;36m$2\e[0m"
        ;;
      *)
        echo $1
        ;;
    esac
}

function color_bg_echo() {
    case $1 in
      red)
        echo -e "\e[1;41m$2\e[0m"
        ;;
      green)
        echo -e "\e[1;42m$2\e[0m"
        ;;
      yellow)
        echo -e "\e[1;43m$2\e[0m"
        ;;
      blue)
        echo -e "\e[1;44m$2\e[0m"
        ;;
      carmine)
        echo -e "\e[1;45m$2\e[0m"
        ;;
      cyan)
        echo -e "\e[1;46m$2\e[0m"
        ;;
      *)
        echo $1
        ;;
    esac
}
