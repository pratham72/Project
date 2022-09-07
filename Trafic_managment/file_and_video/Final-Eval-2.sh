#Restore Default Rules
iptables -F
iptables -t nat -F
iptables -X
#iptables -P INPUT DROP
iptables -P FORWARD DROP
#iptables -P OUTPUT DROP

#INPUT Starting Rules
iptables -A INPUT -p tcp -m state --state RELATED,ESTABLISHED -j ACCEPT
iptables -A INPUT -p icmp -j ACCEPT
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -p tcp -s 10.22.70.0/24 -m state --state NEW --dport 2226 -j ACCEPT

#DNS
iptables -A FORWARD -p tcp -d 172.17.31.36 --dport 53 -j ACCEPT
iptables -A FORWARD -p tcp -s 172.17.31.36 --sport 53 -j ACCEPT
iptables -A FORWARD -p udp -d 172.17.31.36 --dport 53 -j ACCEPT
iptables -A FORWARD -p udp -s 172.17.31.36 --sport 53 -j ACCEPT

#RDP
iptables -A FORWARD -p tcp -m state --state NEW,ESTABLISHED -s 10.22.70.0/24 -d 172.17.31.36 --dport 3389 -j ACCEPT
iptables -A FORWARD -p tcp -m state --state ESTABLISHED,RELATED -s 172.17.31.36 -d 10.22.70.0/24 --sport 3389 -j ACCEPT

#MySQL
iptables -A FORWARD -p tcp -m state --state NEW,ESTABLISHED -s 10.22.70.0/24 -d 172.17.31.37 --dport 3306 -j ACCEPT
iptables -A FORWARD -p tcp -m state --state ESTABLISHED,RELATED -s 172.17.31.37 -d 10.22.70.0/24 --sport 3306 -j ACCEPT

#Apache
iptables -A FORWARD -p tcp -m state --state NEW,ESTABLISHED -s 10.22.70.0/24 -d 172.17.31.37 --dport 80 -j ACCEPT

iptables -A FORWARD -p tcp -m state --state ESTABLISHED,RELATED -s 172.17.31.37 -d 10.22.70.0/24 --sport 80 -j ACCEPT

#IIS
iptables -A FORWARD -p tcp -m state --state NEW,ESTABLISHED -s 10.22.70.0/24 -d 172.17.31.36 --dport 80 -j ACCEPT
iptables -A FORWARD -p tcp -m state --state ESTABLISHED,RELATED -s 172.17.31.36 -d 10.22.70.0/24 --sport 80 -j ACCEPT

#FTP (Administration Port)
iptables -A FORWARD -p tcp -m state --state NEW,ESTABLISHED -s 10.22.70.0/24 -d 172.17.31.36 --dport 21 -j ACCEPT

iptables -A FORWARD -p tcp -m state --state ESTABLISHED,RELATED -s 172.17.31.36 -d 10.22.70.0/24 --sport 21 -j ACCEPT

#FTP (Data ports)
iptables -A FORWARD -p tcp -m state --state NEW,ESTABLISHED -s 10.22.70.0/24 -d 172.17.31.36 --dport 40000:41000 -j ACCEPT
iptables -A FORWARD -p tcp -m state --state ESTABLISHED,RELATED -s 172.17.31.36 -d 10.22.70.0/24 --sport 40000:41000 -j ACCEPT

#SSH
iptables -A FORWARD -p tcp -m state --state NEW,ESTABLISHED -s 10.22.70.0/24 -d 172.17.31.37 --dport 22 -j ACCEPT

iptables -A FORWARD -p tcp -m state --state ESTABLISHED,RELATED -s 172.17.31.37 -d 10.22.70.0/24 --sport 22 -j ACCEPT

#PORTDROP
iptables -t nat -A PREROUTING -p tcp --sport 2231 -m limit --limit 10/min -j LOG --log-prefix "DROPPED-SSH"
iptables -t nat -A PREROUTING -p tcp --sport 9931 -m limit --limit 10/min -j LOG --log-prefix "DROPPED-RDP"

