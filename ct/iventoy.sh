#!/usr/bin/env bash
source <(curl -s https://raw.githubusercontent.com/tteck/Proxmox/main/misc/build.func)
# Copyright (c) 2021-2024 tteck
# Author: tteck (tteckster)
# License: MIT
# https://github.com/tteck/Proxmox/raw/main/LICENSE

function header_info {
clear
cat <<"EOF"

IVENTOY
 
EOF
}
header_info
echo -e "Loading..."
APP="iVentoy"
var_disk="2"
var_cpu="1"
var_ram="512"
var_os="debian"
var_version="12"
variables
color
catch_errors

function default_settings() {
  CT_TYPE="1"
  PW=""
  CT_ID=$NEXTID
  HN=$NSAPP
  DISK_SIZE="$var_disk"
  CORE_COUNT="$var_cpu"
  RAM_SIZE="$var_ram"
  BRG="vmbr0"
  NET="dhcp"
  GATE=""
  APT_CACHER=""
  APT_CACHER_IP=""
  DISABLEIP6="no"
  MTU=""
  SD=""
  NS=""
  MAC=""
  VLAN=""
  SSH="no"
  VERB="no"
  echo_default
}

function update_script() {
header_info
if [[ ! -d /opt/iventoy ]]; then msg_error "No ${APP} Installation Found!"; exit; fi
msg_info "Stopping ${APP} LXC"
systemctl stop iventoy.service
msg_ok "Stopped ${APP} LXC"

msg_info "Updating ${APP} LXC"
rm -rf /opt/iventoy
apt-get update &>/dev/null
apt-get -y upgrade &>/dev/null
wget -q $(curl -s https://api.github.com/repos/ventoy/pxe/releases/latest | grep download | grep linux-free | cut -d\" -f4)      
tar -C /opt/iventoy -xzf iventoy*.tar.gz
rm -rf iventoy*.tar.gz
msg_ok "Updated ${APP} LXC"

msg_info "Starting ${APP} LXC"
systemctl start autobrr.service
msg_ok "Started ${APP} LXC"
msg_ok "Updated Successfully"
exit
}

start
build_container
description

msg_ok "Completed Successfully!\n"
echo -e "${APP} should be reachable by going to the following URL. http://${IP}:26000/
         ${BL}http://${IP}/admin${CL} \n"
