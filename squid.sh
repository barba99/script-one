#!/bin/bash
#19/12/2019
barra="\033[0m\e[34m━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\033[1;37m"
declare -A cor=( [0]="\033[1;37m" [1]="\033[1;34m" [2]="\033[1;32m" [3]="\033[1;36m" [4]="\033[1;31m" )
#LISTA PORTAS
mportas () {
unset portas
portas_var=$(lsof -V -i tcp -P -n | grep -v "ESTABLISHED" |grep -v "COMMAND" | grep "LISTEN")
while read port; do
var1=$(echo $port | awk '{print $1}') && var2=$(echo $port | awk '{print $9}' | awk -F ":" '{print $2}')
[[ "$(echo -e $portas|grep "$var1 $var2")" ]] || portas+="$var1 $var2\n"
done <<< "$portas_var"
i=1
echo -e "$portas"
}
fun_ip () {
MEU_IP=$(ip addr | grep 'inet' | grep -v inet6 | grep -vE '127\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | grep -o -E '[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}' | head -1)
MEU_IP2=$(wget -qO- ipv4.icanhazip.com)
[[ "$MEU_IP" != "$MEU_IP2" ]] && IP="$MEU_IP2" || IP="$MEU_IP"
}




#ETHOOL SSH
fun_eth () {
eth=$(ifconfig | grep -v inet6 | grep -v lo | grep -v 127.0.0.1 | grep "encap:Ethernet" | awk '{print $1}')
    [[ $eth != "" ]] && {
    echo -e "$barra"
    echo -e "${cor[3]} Aplicar el sistema para mejorar los paquetes SSH?"
    echo -e "${cor[3]} Opciones para usuarios avanzados"
   echo -e "$barra"
    read -p "[S/N]: " -e -i n sshsn
    tput cuu1 && tput dl1
           [[ "$sshsn" = @(s|S|y|Y) ]] && {
           echo -e "${cor[1]} Correccion de problemas de paquetes en SSH..."
		   echo -e "$barra"
           echo -e "Cual es la tasa RX"
           echo -ne "[ 1 - 999999999 ]: "; read rx
           [[ "$rx" = "" ]] && rx="999999999"
           echo -e "Cual es la tasa TX"
           echo -ne "[ 1 - 999999999 ]: "; read tx
           [[ "$tx" = "" ]] && tx="999999999"
           apt-get install ethtool -y > /dev/null 2>&1
           ethtool -G $eth rx $rx tx $tx > /dev/null 2>&1
           echo -e "$barra"
           }
     }
}


fun_bar () {
comando[0]="$1"
comando[1]="$2"
 (
[[ -e $HOME/fim ]] && rm $HOME/fim
${comando[0]} -y > /dev/null 2>&1
${comando[1]} -y > /dev/null 2>&1
touch $HOME/fim
 ) > /dev/null 2>&1 &
sp="/-\|"
unset a
while [[ ! -e $HOME/fim ]]; do
  for((i=0; i<5; i++)); do
    echo -ne "\033[1;33m ["
    a+="#"
    echo -ne "\033[1;31m${a}"
    echo -ne "\033[1;33m]" 
    echo -ne " - \033[1;33m[\033[1;32m"
    echo -ne "${sp:i%${#sp}:1}"
    echo -e "\033[1;33m]"
    sleep 1
    tput cuu1
    tput dl1
  done
done
echo -e " \033[1;33m[\033[1;31m${a}\033[1;33m] - \033[1;33m[\033[1;32m100%\033[1;33m]\033[0m"
rm $HOME/fim
}

#Instalador squid soporte a nuevos O.S 
fun_squid  () {
  if [[ -e /etc/squid/squid.conf ]]; then
  var_squid="/etc/squid/squid.conf"
  elif [[ -e /etc/squid3/squid.conf ]]; then
  var_squid="/etc/squid3/squid.conf"
  fi
  [[ -e $var_squid ]] && {
  echo -e "\033[1;32m DESISTALANDO SQUID\n$barra"
  service squid stop > /dev/null 2>&1
  fun_bar "apt-get remove squid3 -y"
  echo -e "$barra\n\033[1;32m Proceso Terminado\n$barra"
  [[ -e $var_squid ]] && rm $var_squid
  return 0
  }
echo -e "$barra"
echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m CONFIGURACION AUTOMATICAMNETE DE SQUID"
echo -e "$barra"
echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m PUERTOS 80 8080 3128"
echo -e "$barra"
echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m DEBIAN 8,9 UBUNTU 14.04, 16.04, 18.04, 19.04"
sleep 2s
echo -e "$barra"
echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m DETECTECTANDO SISTEMA OPERATIVO ESPERE......"
sleep 3s

echo -e "$barra"
if cat /etc/os-release | grep PRETTY_NAME | grep "Ubuntu 22.04"; then
    tput cuu1 && tput dl1
    echo -e "$barra"
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m Ubuntu 22.04"
    echo -e "$barra"
    fun_bar 'apt update'
    fun_bar 'apt -y install apache2-utils squid'
    touch /etc/squid/passwd
    mv /etc/squid/squid.conf /etc/squid/squid.conf.bak
    touch /etc/squid/blacklist.acl
    wget --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/serverok/squid-proxy-installer/master/conf/ubuntu-2204.conf > /dev/null 2>&1
    if [ -f /sbin/iptables ]; then
	/sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
        /sbin/iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
        /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
        /sbin/iptables-save
    fi
    systemctl enable squid > /dev/null 2>&1
    systemctl restart squid > /dev/null 2>&1



elif cat /etc/os-release | grep PRETTY_NAME | grep "Ubuntu 20.04"; then
    tput cuu1 && tput dl1
    echo -e "$barra"                                                                    
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m Ubuntu 20.04"
    echo -e "$barra"
    fun_bar 'apt update'
    fun_bar 'apt -y install apache2-utils squid'
    touch /etc/squid/passwd
    rm -f /etc/squid/squid.conf
    touch /etc/squid/blacklist.acl
    wget --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/serverok/squid-proxy-installer/master/squid.conf > /dev/null 2>&1
    if [ -f /sbin/iptables ]; then
        /sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
	/sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
        /sbin/iptables-save
    fi
    systemctl enable squid > /dev/null 2>&1
    systemctl restart squid > /dev/null 2>&1
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m CONFIGURADO CON EXITO"


elif cat /etc/os-release  | grep PRETTY_NAME | grep "Ubuntu 19.04"; then
    tput cuu1 && tput dl1
    echo -e "$barra"
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m Ubuntu 19.04"
    echo -e "$barra"
    fun_bar 'apt update > /dev/null 2>&1'
    fun_bar 'apt -y install apache2-utils squid'
    touch /etc/squid/passwd
    rm -f /etc/squid/squid.conf
    touch /etc/squid/blacklist.acl
    wget --no-check-certificate -O /etc/squid/squid.conf https://www.dropbox.com/s/5mb69eainxialac/squid.conf > /dev/null 2>&1
    echo -e "acl url1 dstdomain -i $ip" >> /etc/squid/squid.conf
    if [ -f /sbin/iptables ]; then
	/sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
        /sbin/iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
        /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
        /sbin/iptables-save
    fi
    systemctl enable squid > /dev/null 2>&1
    systemctl restart squid > /dev/null 2>&1
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m CONFIGURADO CON EXITO"


elif cat /etc/os-release  | grep PRETTY_NAME | grep "Ubuntu 18.04"; then
    tput cuu1 && tput dl1
    echo -e "$barra"
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m Ubuntu 18.04"
    echo -e "$barra"
    fun_bar 'apt update > /dev/null 2>&1'
    fun_bar 'apt -y install apache2-utils squid > /dev/null 2>&1'
    touch /etc/squid/passwd > /dev/null 2>&1
    rm -f /etc/squid/squid.conf
    touch /etc/squid/blacklist.acl
    wget --no-check-certificate -O /etc/squid/squid.conf https://www.dropbox.com/s/5mb69eainxialac/squid.conf > /dev/null 2>&1
    if [ -f /sbin/iptables ]; then
	/sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
        /sbin/iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
        /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
        /sbin/iptables-save
    fi
    systemctl enable squid > /dev/null 2>&1
    systemctl restart squid > /dev/null 2>&1
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m CONFIGURADO CON EXITO"

elif cat /etc/os-release  | grep PRETTY_NAME | grep "Ubuntu 16.04"; then
    tput cuu1 && tput dl1
    echo -e "$barra"
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m Ubuntu 16.04"
    echo -e "$barra"
    fun_bar 'apt update > /dev/null 2>&1'
    fun_bar 'apt -y install apache2-utils squid3 > /dev/null 2>&1'
    touch /etc/squid/passwd > /dev/null 2>&1
    rm -f /etc/squid/squid.conf > /dev/null 2>&1
    touch /etc/squid/blacklist.acl > /dev/null 2>&1
    wget --no-check-certificate -O /etc/squid/squid.conf https://www.dropbox.com/s/5mb69eainxialac/squid.conf > /dev/null 2>&1
    if [ -f /sbin/iptables ]; then
	/sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
        /sbin/iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
        /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
        /sbin/iptables-save
    fi
    service squid restart > /dev/null 2>&1
    update-rc.d squid defaults > /dev/null 2>&1
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m CONFIGURADO CON EXITO"

elif cat /etc/*release | grep DISTRIB_DESCRIPTION | grep "Ubuntu 14.04"; then
    tput cuu1 && tput dl1
    echo -e "$barra"
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m Ubuntu 14.04"
    echo -e "$barra"
     apt update > /dev/null 2>&1
    /usr/bin/apt -y install apache2-utils squid3
    touch /etc/squid3/passwd
    /bin/rm -f /etc/squid3/squid.conf
    /usr/bin/touch /etc/squid3/blacklist.acl
    /usr/bin/wget --no-check-certificate -O /etc/squid3/squid.conf https://www.dropbox.com/s/5mb69eainxialac/squid.conf > /dev/null 2>&1
    if [ -f /sbin/iptables ]; then
	/sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
        /sbin/iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
        /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
        /sbin/iptables-save
    fi
    service squid3 restart
    ln -s /etc/squid3 /etc/squid
    #update-rc.d squid3 defaults
    ln -s /etc/squid3 /etc/squid
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m CONFIGURADO CON EXITO"

elif cat /etc/os-release  | grep PRETTY_NAME | grep "jessie"; then
    tput cuu1 && tput dl1
    echo -e "$barra"
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m jessie"
    echo -e "$barra"
    # OS = Debian 8 > /dev/null 2>&1
    rm -rf /etc/squid
    fun_bar 'apt update'
    fun_bar 'apt -y install apache2-utils squid3'
    touch /etc/squid3/passwd
    rm -f /etc/squid3/squid.conf
    touch /etc/squid3/blacklist.acl
    wget --no-check-certificate -O /etc/squid3/squid.conf https://www.dropbox.com/s/5mb69eainxialac/squid.conf > /dev/null 2>&1
    if [ -f /sbin/iptables ]; then
	/sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
        /sbin/iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
        /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
        /sbin/iptables-save
    fi
    service squid3 restart
    update-rc.d squid3 defaults
    ln -s /etc/squid3 /etc/squid
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m CONFIGURADO CON EXITO"
elif cat /etc/os-release | grep PRETTY_NAME | grep "stretch"; then
    tput cuu1 && tput dl1
    echo -e "$barra"
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m stretch";
    echo -e "$barra"
    # OS = Debian 9 > /dev/null 2>&1
    /bin/rm -rf /etc/squid
    fun_bar 'apt update'
    fun_bar 'apt -y install apache2-utils squid'
    touch /etc/squid/passwd
    /bin/rm -f /etc/squid/squid.conf
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget --no-check-certificate -O /etc/squid/squid.conf https://www.dropbox.com/s/5mb69eainxialac/squid.conf > /dev/null 2>&1
    if [ -f /sbin/iptables ]; then
	/sbin/iptables -I INPUT -p tcp --dport 80 -j ACCEPT
        /sbin/iptables -I INPUT -p tcp --dport 8080 -j ACCEPT
        /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
        /sbin/iptables-save
    fi
    systemctl enable squid
    systemctl restart squid
else
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m SISTEMA OPERATIVO NO SOPORTADO"
    echo -e "$barra"
    exit 1;
fi
#/usr/bin/htpasswd -b -c /etc/squid/passwd USERNAME_HERE PASSWORD_HERE
}
online_squid () {
payload="/etc/payloads"
echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m SQUID CONFIGURADO"
echo -e "$barra"
echo -e "${cor[1]}[${cor[2]}01${cor[1]}]\033[1;33m⇨${cor[6]} Colocar Host en Squid"
echo -e "${cor[1]}[${cor[2]}02${cor[1]}]\033[1;33m⇨${cor[6]} Remover Host de Squid"
echo -e "${cor[1]}[${cor[2]}03${cor[1]}]\033[1;33m⇨${cor[6]} Desinstalar Squid"
echo -e "${cor[1]}[${cor[2]}04${cor[1]}]\033[1;33m⇨${cor[6]} Volver"
echo -e "$barra"
while [[ $varpay != @(0|[1-3]) ]]; do
read -p "[0/3]: " varpay
tput cuu1 && tput dl1
done
if [[ "$varpay" = "0" ]]; then
return 1
elif [[ "$varpay" = "1" ]]; then
echo -e "${cor[3]} Hosts Actuales Dentro del Squid"
msg -bar
cat $payload | awk -F "/" '{print $1,$2,$3,$4}'
msg -bar
while [[ $hos != \.* ]]; do
echo -ne "${cor[4]} Escriba el nuevo host: " && read hos
tput cuu1 && tput dl1
[[ $hos = \.* ]] && continue
echo -e "${cor[3]} Comience con .${cor[0]}"
sleep 2s
tput cuu1 && tput dl1
done
host="$hos/"
[[ -z $host ]] && return 1
[[ `grep -c "^$host" $payload` -eq 1 ]] &&:echo -e "${cor[4]}$(fun_trans  "Host ya Exciste")${cor[0]}" && return 1
echo "$host" >> $payload && grep -v "^$" $payload > /tmp/a && mv /tmp/a $payload
echo -e "${cor[4]} Host Agregado con Exito"
msg -bar
cat $payload | awk -F "/" '{print $1,$2,$3,$4}'
msg -bar
if [[ ! -f "/etc/init.d/squid" ]]; then
service squid3 reload
service squid3 restart
else
/etc/init.d/squid reload
service squid restart
fi
return 0
elif [[ "$varpay" = "2" ]]; then
echo -e "${cor[4]} Hosts Actuales Dentro del Squid"
msg -bar
cat $payload | awk -F "/" '{print $1,$2,$3,$4}'
msg -bar
while [[ $hos != \.* ]]; do
echo -ne "${cor[4]} Digite un Host: " && read hos
tput cuu1 && tput dl1
[[ $hos = \.* ]] && continue
echo -e "${cor[4]} Comience con ."
sleep 2s
tput cuu1 && tput dl1
done
host="$hos/"
[[ -z $host ]] && return 1
[[ `grep -c "^$host" $payload` -ne 1 ]] &&!echo -e "${cor[5]}$(fun_trans  "Host No Encontrado")" && return 1
grep -v "^$host" $payload > /tmp/a && mv /tmp/a $payload
echo -e "${cor[4]}$(fun_trans  "Host Removido Con Exito")"
msg -bar
cat $payload | awk -F "/" '{print $1,$2,$3,$4}'
msg -bar
if [[ ! -f "/etc/init.d/squid" ]]; then
service squid3 reload
service squid3 restart
else
/etc/init.d/squid reload
service squid restart
fi	
return 0
elif [[ "$varpay" = "3" ]]; then
fun_squid
fi
}
if [[ -e /etc/squid/squid.conf ]]; then
online_squid
elif [[ -e /etc/squid3/squid.conf ]]; then
online_squid
else
fun_squid
fi
