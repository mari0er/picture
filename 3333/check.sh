#!/usr/bin/env bash

#set -ex

# set color
export CLICOLOR=1
export LSCOLORS=GxFxCxDxBxegedabagaced
COL_NC='\033[0m' # No Color
COL_LIGHT_GREEN='\033[1;32m'
COL_LIGHT_RED='\033[1;31m'
COL_LIGHT_YELLOW='\033[1;33m'
TICK="[${COL_LIGHT_GREEN}✓${COL_NC}]"
CROSS="[${COL_LIGHT_RED}✗${COL_NC}]"
INFO="[${COL_LIGHT_YELLOW}~${COL_NC}]"
OVER="\\r\\033[K"

# set msg
msg_info() {
  local msg="$1"
  echo -ne "${INFO}  ${msg} ${COL_LIGHT_YELLOW}...${COL_NC}"
}

msg_ok() {
  local msg="$1"
  echo -e "${OVER}  ${TICK}  ${msg}"
}

msg_err() {
  local msg="$1"
  echo -e "${OVER}  ${CROSS}  ${msg}"
}

msg_fatal() {
  local msg="$1"
  echo -e "\\n  ${COL_LIGHT_RED}Error: ${msg}${COL_NC}\\n"
  exit 1
}

msg_logo() {
  clear
  echo -e "\n  \033[1;31m _____      _      _   _      _      ___ \033[0m"
  echo -e "  \033[1;32m|  ___|    / \    | | | |    / \    |_ _|\033[0m"
  echo -e "  \033[1;33m| |_      / _ \   | |_| |   / _ \    | | \033[0m"
  echo -e "  \033[1;34m|  _|    / ___ \  |  _  |  / ___ \   | | \033[0m"
  echo -e "  \033[1;35m|_|     /_/   \_\ |_| |_| /_/   \_\ |___|\033[0m"
  echo -e "\n  \033[1;36mhttps://www.fahai.org \033[0m"
  echo -e " \033[1;32m「 法海之路 - 生命不息，折腾不止 」\033[0m\n"
}

# install Docker

getDocker() {
  curl -s https://ghproxy.com/https://gist.githubusercontent.com/Ran-Xing/b7eef746736e51d6f7c6fd24dd942b5d/raw/5150fb33712d643d14d67773235118570f136a22/docker_init.sh | bash
}

clean() {
  msg_info "Clear historical AWVS images"
  if [ -z "$(docker images -aqf reference='*/*awvs*')" ]; then
    docker rmi -f "$(docker images -aqf reference='*/*awvs*')" || (msg_err "Clear historical AWVS images" && exit 1) && msg_ok "Clear historical AWVS images Success! "
  else
    msg_ok "Clear historical AWVS images Success!"
  fi
}

# check by fahai
check() {
  msg_info "Starting cracking"
  echo -ne "${OVER}  "
  docker exec -it awvs /bin/bash -c "curl -sLkm 10 https://pan.fahai.org/d/Awvs/awvs_listen.zip -o /awvs/awvs_listen.zip >/dev/null 2>&1 || (echo -e '[\033[1;31mx\033[0m] Download Activation Package Failed!' && exit)" && msg_info "Download Activation Package Success!"
  echo -ne "${OVER}  "
  docker exec -it awvs /bin/bash -c "unzip -o /awvs/awvs_listen.zip -d /home/acunetix/.acunetix/data/license/ >/dev/null 2>&1 || (echo -e '[\033[1;31mx\033[0m] Decompression Of Activation Package Failed! ' && exit)" && msg_info "Decompression Of Activation Package Success!"
  echo -ne "${OVER}  "
  docker exec -it awvs /bin/bash -c "chmod 444 /home/acunetix/.acunetix/data/license/license_info.json >/dev/null 2>&1 || (echo -e '[\033[1;31mx\033[0m] Permission Setting Failed! ' && exit)" && msg_info "Permission Setting Success!"
  echo -ne "${OVER}  "
  docker exec -it awvs /bin/bash -c "chown acunetix:acunetix /home/acunetix/.acunetix/data/license/wa_data.dat >/dev/null 2>&1 || (echo -e '[\033[1;31mx\033[0m] Permission Setting Failed!' && exit)" && msg_info "Permission Setting Success!"
  echo -ne "${OVER}  "
  docker exec -it awvs /bin/bash -c "rm /awvs/awvs_listen.zip >/dev/null 2>&1 || (echo -e '[\033[1;31mx\033[0m] Failed To Delete Activation Package! ' && exit)" && msg_info "Delete Activation Package Success!"
  echo -ne "${OVER}  "
  docker exec -it awvs /bin/bash -c "echo '127.0.0.1 updates.acunetix.com' > /awvs/.hosts || (echo -e '[\033[1;31mx\033[0m] Create Hosts.1 Failure! ' && exit)" && msg_info "Create Hosts.1 Success!"
  echo -ne "${OVER}  "
  docker exec -it awvs /bin/bash -c "echo '127.0.0.1 erp.acunetix.com' >> /awvs/.hosts || (echo -e '[\033[1;31mx\033[0m] Create Hosts. Failure!' && exit)" && msg_info "Create Hosts.2 Success!"
  echo -ne "${OVER}  "
  docker restart awvs >/dev/null 2>&1 || (echo -e '[\033[1;31mx\033[0m] Restarting Awvs Failed!' && exit)
  msg_ok "Crack Over!"
}

logs() {
  docker logs awvs 2>&1 | head -n 24
}

main() {
  msg_logo
  msg_ok "Start Install "
  echo -ne "${OVER}  "
  msg_info "Will Del Container Like Awvs, Sleep 5S!"
  #  echo -ne "${OVER}  "; msg_info "Will Del container like awvs, Sleep 5s!"; sleep 5
  if type "curl" >/dev/null 2>&1; then
    echo -ne "${OVER}  "
    msg_info "Curl Is Installed"
  else
    echo -ne "${OVER}  "
    msg_info "Curl Is Not Installed"
    echo -ne "${OVER}  "
    msg_info "Installing Curl"
    echo -ne "${OVER}  "
    apt-get update >/dev/null 2>&1 || (msg_err "Apt-Get Update Failed!" && exit 1) && msg_info "Apt-Get Update Success!"
    echo -ne "${OVER}  "
    apt-get install -y curl >/dev/null 2>&1 || (msg_err "Apt-Get Install Curl Failed!" && exit 1) && msg_info "Apt-Get Install Curl Success!"
  fi
  if ! type docker >/dev/null 2>&1; then
    echo -ne "${OVER}  "
    msg_info "Docker Is Not Installed, Is Installing!"
    getDocker
  fi

  if [[ ! "$(docker ps 2>/dev/null)" ]]; then
    echo -ne "${OVER}  "
    msg_err "Docker Not Running, Please Start Docker!"
    exit 1
  fi

  if [ -n "$(docker ps -aq --filter name=awvs)" ]; then
    echo -ne "${OVER}  "
    docker rm -f "$(docker ps -aq --filter name=awvs)" >/dev/null 2>&1 || (msg_err "Delete Container Failed! " && exit 1)
    msg_ok "The Container Was Deleted Success!"
  else
    echo -ne "${OVER}  "
    msg_info "No Relevant Container Found It Will Be Created Soon!"
  fi

  echo -ne "${OVER}  "
  echo -ne "${OVER}  "
  msg_info "Docker Pull $1"
  while read -r line; do
    echo -ne "${OVER}  "
    msg_info "${line}"
  done < <(docker pull "$1" || (msg_err "Docker Error" && exit 1))
  msg_ok "Docker Pull $1 Success!"
  if [ -z "$(docker ps -aq --filter name=awvs || (msg_err "Docker Error" && exit 1))" ]; then
    if [ -z "$(docker ps -aq --filter publish=3443 || (msg_err "Docker Error" && exit 1))" ]; then
      echo -ne "${OVER}  "
      msg_info "Create $1 Container!"
      echo -ne "${OVER}  "
      docker run -itd --name awvs -p 3443:3443 --restart=always "$1":latest >/dev/null 2>&1 || (msg_err "Failed To Create Container!" && exit 1)
      msg_ok "Container Created Success!"
    else
      msg_info "Create $1 Container!"
      docker run -itd --name awvs -p 3444:3443 --restart=always "$1":latest >/dev/null 2>&1 || (msg_err "Failed To Create Container!" && exit 1)
      msg_ok "Container Creation Success!"
    fi
  else
    msg_info "RECREATE AWVS CONTAINER"
    docker rm -f "$(docker ps -aq --filter name=awvs)" >/dev/null 2>&1
    docker run -itd --name awvs -p 3443:3443 --restart=always "$1":latest >/dev/null 2>&1 || (msg_err "Failed To Create Container!" && exit 1)
    msg_ok "Container Creation Success!"
  fi
  check
  logs
  clean
}
main "$1"
