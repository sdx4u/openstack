#!/bin/bash

if [ $(id -u) -ne 0 ]
then
    echo "Please run as root ($ sudo -s)"
    exit
fi

. ./config.sh

# generate answer.cfg

packstack --gen-answer-file=answer.cfg

# update node information

SOURCE=`cat answer.cfg | egrep -v "(^#.*|^$)" | grep CONFIG_COMPUTE_HOSTS`
sed -i "s/`echo $SOURCE`/CONFIG_COMPUTE_HOSTS=`echo $COMPUTE_NODE`/g" answer.cfg

SOURCE=`cat answer.cfg | egrep -v "(^#.*|^$)" | grep CONFIG_NETWORK_HOSTS`
sed -i "s/`echo $SOURCE`/CONFIG_NETWORK_HOSTS=`echo $COMPUTE_NODE`/g" answer.cfg

# update SSL information

sed -i "s/CONFIG_SSL_CERT_DIR=~\/packstackca\//CONFIG_SSL_CERT_DIR=~\/cloudCA\//g" answer.cfg

SOURCE=`cat answer.cfg | egrep -v "(^#.*|^$)" | grep CONFIG_SSL_CERT_SUBJECT_C=`
sed -i "s/`echo $SOURCE`/CONFIG_SSL_CERT_SUBJECT_C=`echo $SSL_CERT_SUBJECT_C`/g" answer.cfg

SOURCE=`cat answer.cfg | egrep -v "(^#.*|^$)" | grep CONFIG_SSL_CERT_SUBJECT_ST`
sed -i "s/`echo $SOURCE`/CONFIG_SSL_CERT_SUBJECT_ST=`echo $SSL_CERT_SUBJECT_ST`/g" answer.cfg

SOURCE=`cat answer.cfg | egrep -v "(^#.*|^$)" | grep CONFIG_SSL_CERT_SUBJECT_L`
sed -i "s/`echo $SOURCE`/CONFIG_SSL_CERT_SUBJECT_L=`echo $SSL_CERT_SUBJECT_L`/g" answer.cfg

SOURCE=`cat answer.cfg | egrep -v "(^#.*|^$)" | grep CONFIG_SSL_CERT_SUBJECT_O=`
sed -i "s/`echo $SOURCE`/CONFIG_SSL_CERT_SUBJECT_O=`echo $SSL_CERT_SUBJECT_O`/g" answer.cfg

SOURCE=`cat answer.cfg | egrep -v "(^#.*|^$)" | grep CONFIG_SSL_CERT_SUBJECT_OU`
sed -i "s/`echo $SOURCE`/CONFIG_SSL_CERT_SUBJECT_OU=`echo $SSL_CERT_SUBJECT_OU`/g" answer.cfg

SOURCE=`cat answer.cfg | egrep -v "(^#.*|^$)" | grep CONFIG_SSL_CERT_SUBJECT_CN`
sed -i "s/`echo $SOURCE`/CONFIG_SSL_CERT_SUBJECT_CN=`echo $SSL_CERT_SUBJECT_CN`/g" answer.cfg

SOURCE=`cat answer.cfg | egrep -v "(^#.*|^$)" | grep CONFIG_SSL_CERT_SUBJECT_MAIL`
sed -i "s/`echo $SOURCE`/CONFIG_SSL_CERT_SUBJECT_MAIL=`echo $SSL_CERT_SUBJECT_MAIL`/g" answer.cfg

# update backend information

SOURCE=`cat answer.cfg | egrep -v "(^#.*|^$)" | grep CONFIG_KEYSTONE_ADMIN_EMAIL`
sed -i "s/`echo $SOURCE`/CONFIG_KEYSTONE_ADMIN_EMAIL=`echo $KEYSTONE_ADMIN_EMAIL`/g" answer.cfg

SOURCE=`cat answer.cfg | egrep -v "(^#.*|^$)" | grep CONFIG_KEYSTONE_ADMIN_PW`
sed -i "s/`echo $SOURCE`/CONFIG_KEYSTONE_ADMIN_PW=`echo $KEYSTONE_ADMIN_PW`/g" answer.cfg

# update network information

SOURCE=`cat answer.cfg | egrep -v "(^#.*|^$)" | grep CONFIG_NEUTRON_ML2_MECHANISM_DRIVERS`
sed -i "s/`echo $SOURCE`/CONFIG_NEUTRON_ML2_MECHANISM_DRIVERS=openvswitch/g" answer.cfg

SOURCE=`cat answer.cfg | egrep -v "(^#.*|^$)" | grep CONFIG_NEUTRON_L2_AGENT`
sed -i "s/`echo $SOURCE`/CONFIG_NEUTRON_L2_AGENT=openvswitch/g" answer.cfg

if [ -z "$TUNNEL_INTERFACE" ] # vxlan
then

    SOURCE=`cat answer.cfg | egrep -v "(^#.*|^$)" | grep CONFIG_NEUTRON_ML2_TYPE_DRIVERS`
    sed -i "s/`echo $SOURCE`/CONFIG_NEUTRON_ML2_TYPE_DRIVERS=vxlan,flat/g" answer.cfg

    SOURCE=`cat answer.cfg | egrep -v "(^#.*|^$)" | grep CONFIG_NEUTRON_ML2_TENANT_NETWORK_TYPES`
    sed -i "s/`echo $SOURCE`/CONFIG_NEUTRON_ML2_TENANT_NETWORK_TYPES=vxlan/g" answer.cfg

    SOURCE=`cat answer.cfg | egrep -v "(^#.*|^$)" | grep CONFIG_NEUTRON_ML2_VNI_RANGES`
    sed -i "s/`echo $SOURCE`/CONFIG_NEUTRON_ML2_VNI_RANGES=1001:2000/g" answer.cfg

    SOURCE=`cat answer.cfg | egrep -v "(^#.*|^$)" | grep CONFIG_NEUTRON_ML2_VXLAN_GROUP`
    sed -i "s/`echo $SOURCE`/CONFIG_NEUTRON_ML2_VXLAN_GROUP=239.1.1.2/g" answer.cfg

    SOURCE=`cat answer.cfg | egrep -v "(^#.*|^$)" | grep CONFIG_NEUTRON_OVS_BRIDGE_MAPPINGS`
    sed -i "s/`echo $SOURCE`/CONFIG_NEUTRON_OVS_BRIDGE_MAPPINGS=extnet:br-ex/g" answer.cfg

    SOURCE=`cat answer.cfg | egrep -v "(^#.*|^$)" | grep CONFIG_NEUTRON_OVS_BRIDGE_IFACES`
    sed -i "s/`echo $SOURCE`/CONFIG_NEUTRON_OVS_BRIDGE_IFACES=/g" answer.cfg

else # vlan

    SOURCE=`cat answer.cfg | egrep -v "(^#.*|^$)" | grep CONFIG_NEUTRON_ML2_TYPE_DRIVERS`
    sed -i "s/`echo $SOURCE`/CONFIG_NEUTRON_ML2_TYPE_DRIVERS=vlan,flat/g" answer.cfg

    SOURCE=`cat answer.cfg | egrep -v "(^#.*|^$)" | grep CONFIG_NEUTRON_ML2_TENANT_NETWORK_TYPES`
    sed -i "s/`echo $SOURCE`/CONFIG_NEUTRON_ML2_TENANT_NETWORK_TYPES=vlan/g" answer.cfg

    SOURCE=`cat answer.cfg | egrep -v "(^#.*|^$)" | grep CONFIG_NEUTRON_ML2_VLAN_RANGES`
    sed -i "s/`echo $SOURCE`/CONFIG_NEUTRON_ML2_VLAN_RANGES=intnet:1001:2000,extnet/g" answer.cfg

    SOURCE=`cat answer.cfg | egrep -v "(^#.*|^$)" | grep CONFIG_NEUTRON_OVS_BRIDGE_MAPPINGS`
    sed -i "s/`echo $SOURCE`/CONFIG_NEUTRON_OVS_BRIDGE_MAPPINGS=intnet:br-vlan,extnet:br-ex/g" answer.cfg

    SOURCE=`cat answer.cfg | egrep -v "(^#.*|^$)" | grep CONFIG_NEUTRON_OVS_BRIDGE_IFACES`
    sed -i "s/`echo $SOURCE`/CONFIG_NEUTRON_OVS_BRIDGE_IFACES=br-vlan:`echo $TUNNEL_INTERFACE`/g" answer.cfg

    SOURCE=`cat answer.cfg | egrep -v "(^#.*|^$)" | grep CONFIG_NEUTRON_OVS_BRIDGES_COMPUTE`
    sed -i "s/`echo $SOURCE`/CONFIG_NEUTRON_OVS_BRIDGES_COMPUTE=br-vlan/g" answer.cfg

    SOURCE=`cat answer.cfg | egrep -v "(^#.*|^$)" | grep CONFIG_NEUTRON_OVS_TUNNEL_IF=`
    sed -i "s/`echo $SOURCE`/CONFIG_NEUTRON_OVS_TUNNEL_IF=`echo $TUNNEL_INTERFACE`/g" answer.cfg

fi

sed -i "s/CONFIG_PROVISION_DEMO=y/CONFIG_PROVISION_DEMO=n/g" answer.cfg
sed -i "s/CONFIG_HORIZON_SSL=n/CONFIG_HORIZON_SSL=y/g" answer.cfg

# install openstack
packstack --answer-file=answer.cfg
