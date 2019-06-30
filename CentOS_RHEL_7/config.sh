# Openstack Version #

#OPENSTACK=ocata
#OPENSTACK=pike
OPENSTACK=queens

# Openstack Node Information #

CONTROLLER_NODE=10.0.0.100
COMPUTE_NODE=10.0.0.101,10.0.0.102

# Openstack Network Information #

EXTERNAL_INTERFACE=ens36
#TUNNEL_INTERFACE=ens37

EXTERNAL_NETWORK=192.168.128
EXTERNAL_IP_ADDRESS=$EXTERNAL_NETWORK.10
IP_POOL_START=$EXTERNAL_NETWORK.101
IP_POOL_END=$EXTERNAL_NETWORK.200
EXTERNAL_GW_ADDRESS=$EXTERNAL_NETWORK.1

INTERNAL_NETWORK=10.10.0
VIP_POOL_START=$INTERNAL_NETWORK.101
VIP_POOL_END=$INTERNAL_NETWORK.200
INTERNAL_GW_ADDRESS=$INTERNAL_NETWORK.1

DNS_NAMESERVER=8.8.8.8

# Openstack SSL Information #

SSL_CERT_SUBJECT_C="KO"
SSL_CERT_SUBJECT_ST="--"
SSL_CERT_SUBJECT_L="--"
SSL_CERT_SUBJECT_O="SDX4U"
SSL_CERT_SUBJECT_OU="Cloud\ Service"
SSL_CERT_SUBJECT_CN="SDX4U"
SSL_CERT_SUBJECT_MAIL="admin@sdx4u.net"

# Keystone Information #

KEYSTONE_ADMIN_EMAIL="admin@sdx4u.net"
KEYSTONE_ADMIN_PW="admin_passwd"
