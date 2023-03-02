#!/bin/bash
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
if [ `whoami` != root ]; then
	echo "Debe ejecutar el script como usuario root o agregar sudo antes del comando.."
	exit 1
fi

/usr/bin/wget --no-check-certificate -O /usr/local/bin/sok-find-os https://raw.githubusercontent.com/serverok/squid-proxy-installer/master/sok-find-os.sh > /dev/null 2>&1
chmod 755 /usr/local/bin/sok-find-os

/usr/bin/wget --no-check-certificate -O /usr/local/bin/squid-uninstall https://raw.githubusercontent.com/serverok/squid-proxy-installer/master/squid-uninstall.sh > /dev/null 2>&1
chmod 755 /usr/local/bin/squid-uninstall

/usr/bin/wget --no-check-certificate -O /usr/local/bin/squid-add-user https://raw.githubusercontent.com/serverok/squid-proxy-installer/master/squid-add-user.sh > /dev/null 2>&1
chmod 755 /usr/local/bin/squid-add-user

if [[ -d /etc/squid/ || -d /etc/squid3/ ]]; then
    echo "Squid Proxy already installed. If you want to reinstall, first uninstall squid proxy by running command: squid-uninstall"
    exit 1
fi
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
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/serverok/squid-proxy-installer/master/conf/ubuntu-2204.conf
    if [ -f /sbin/iptables ]; then
        /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
        /sbin/iptables-save
    fi
    systemctl enable squid > /dev/null 2>&1
    systemctl restart squid > /dev/null 2>&1
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m CONFIGURADO CON EXITO"
elif cat /etc/os-release | grep PRETTY_NAME | grep "Ubuntu 20.04"; then
    tput cuu1 && tput dl1
    echo -e "$barra"                                                                                     
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m Ubuntu 20.04"
    echo -e "$barra"
    fun_bar 'apt update'
    fun_bar 'apt -y install apache2-utils squid'
    touch /etc/squid/passwd
    /bin/rm -f /etc/squid/squid.conf
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/serverok/squid-proxy-installer/master/squid.conf
    if [ -f /sbin/iptables ]; then
        /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
        /sbin/iptables-save
    fi
    systemctl enable squid > /dev/null 2>&1
    systemctl restart squid > /dev/null 2>&1
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m CONFIGURADO CON EXITO"
elif cat /etc/os-release | grep PRETTY_NAME | grep "Ubuntu 18.04"; then
    tput cuu1 && tput dl1
    echo -e "$barra"
    echo -e "Ubuntu 18.04"
    echo -e "$barra"
    fun_bar 'apt update'
    fun_bar 'apt -y install apache2-utils squid3'
    touch /etc/squid/passwd
    /bin/rm -f /etc/squid/squid.conf
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/serverok/squid-proxy-installer/master/squid.conf
    /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
    /sbin/iptables-save
    systemctl enable squid > /dev/null 2>&1
    systemctl restart squid > /dev/null 2>&1
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m CONFIGURADO CON EXITO"
elif cat /etc/os-release | grep PRETTY_NAME | grep "Ubuntu 16.04"; then
    tput cuu1 && tput dl1
    echo -e "$barra"
    echo -e "Ubuntu 16.04"
    echo -e "$barra"
    fun_bar 'apt update'
    fun_bar 'apt -y install apache2-utils squid3'
    touch /etc/squid/passwd
    /bin/rm -f /etc/squid/squid.conf
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/serverok/squid-proxy-installer/master/squid.conf
    /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
    /sbin/iptables-save
    systemctl enable squid > /dev/null 2>&1
    systemctl restart squid > /dev/null 2>&1
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m CONFIGURADO CON EXITO"
elif cat /etc/*release | grep DISTRIB_DESCRIPTION | grep "Ubuntu 14.04"; then
    tput cuu1 && tput dl1
    echo -e "$barra"
    echo -e "Ubuntu 14.04"
    echo -e "$barra"
    fun_bar 'apt update'
    fun_bar 'apt -y install apache2-utils squid3'
    touch /etc/squid3/passwd
    /bin/rm -f /etc/squid3/squid.conf
    /usr/bin/touch /etc/squid3/blacklist.acl
    /usr/bin/wget --no-check-certificate -O /etc/squid3/squid.conf https://raw.githubusercontent.com/serverok/squid-proxy-installer/master/squid.conf
    /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
    /sbin/iptables-save
    systemctl enable squid > /dev/null 2>&1
    systemctl restart squid > /dev/null 2>&1
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m CONFIGURADO CON EXITO"
    ln -s /etc/squid3 /etc/squid
    #update-rc.d squid3 defaults
    ln -s /etc/squid3 /etc/squid
elif cat /etc/os-release | grep PRETTY_NAME | grep "jessie"; then
    tput cuu1 && tput dl1
    echo -e "$barra"
    echo -e "Debian 8"
    echo -e "$barra"
    /bin/rm -rf /etc/squid
    fun_bar 'apt update'
    fun_bar 'apt -y install apache2-utils squid3'
    touch /etc/squid3/passwd
    /bin/rm -f /etc/squid3/squid.conf
    /usr/bin/touch /etc/squid3/blacklist.acl
    /usr/bin/wget --no-check-certificate -O /etc/squid3/squid.conf https://raw.githubusercontent.com/serverok/squid-proxy-installer/master/squid.conf
    /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
    /sbin/iptables-save
    systemctl enable squid > /dev/null 2>&1
    systemctl restart squid > /dev/null 2>&1
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m CONFIGURADO CON EXITO"
    update-rc.d squid3 defaults
    ln -s /etc/squid3 /etc/squid
elif cat /etc/os-release | grep PRETTY_NAME | grep "stretch"; then
    # OS = Debian 9
    /bin/rm -rf /etc/squid
    fun_bar 'apt update'
    fun_bar 'apt -y install apache2-utils squid'
    touch /etc/squid/passwd
    /bin/rm -f /etc/squid/squid.conf
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/serverok/squid-proxy-installer/master/squid.conf
    /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
    /sbin/iptables-save
    systemctl enable squid > /dev/null 2>&1
    systemctl restart squid > /dev/null 2>&1
    echo -e "\033[1;31m[\033[1;32m~\033[1;31m]\033[1;33m CONFIGURADO CON EXITO"
elif cat /etc/os-release | grep PRETTY_NAME | grep "buster"; then
    # OS = Debian 10
    /bin/rm -rf /etc/squid
    fun_bar 'apt update'
    fun_bar 'apt -y install apache2-utils squid'
    touch /etc/squid/passwd
    /bin/rm -f /etc/squid/squid.conf
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/serverok/squid-proxy-installer/master/squid.conf
    /sbin/iptables -I INPUT -p tcp --dport 3128 -j ACCEPT
    /sbin/iptables-save
    systemctl enable squid
    systemctl restart squid
elif cat /etc/os-release | grep PRETTY_NAME | grep "CentOS Linux 7"; then
    fun_bar 'yum install squid httpd-tools -y'
    /bin/rm -f /etc/squid/squid.conf
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/serverok/squid-proxy-installer/master/conf/squid-centos7.conf
    systemctl enable squid
    systemctl restart squid
    firewall-cmd --zone=public --permanent --add-port=3128/tcp
    firewall-cmd --reload
elif cat /etc/os-release | grep PRETTY_NAME | grep "CentOS Linux 8"; then
    yum install squid httpd-tools -y
    /bin/rm -f /etc/squid/squid.conf
    /usr/bin/touch /etc/squid/blacklist.acl
    /usr/bin/wget --no-check-certificate -O /etc/squid/squid.conf https://raw.githubusercontent.com/serverok/squid-proxy-installer/master/conf/squid-centos7.conf
    systemctl enable squid
    systemctl restart squid
    firewall-cmd --zone=public --permanent --add-port=3128/tcp
    firewall-cmd --reload
else
    echo "OS NOT SUPPORTED.\n"
    echo "Contact https://serverok.in/contact to add support for your OS."
    exit 1;
fi

echo
echo "Thank you for using Squid Proxy Installer by ServerOk"
echo "To create a proxy user, run command: squid-add-user"
echo "To change squid proxy port, see https://serverok.in/how-to-change-port-of-squid-proxy-server"
echo 

