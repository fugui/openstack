

```
apt install -y kvm  virtinst   libvirt-bin

qemu-img create -f qcow2 euleros.qcow2 500G


virt-install --virt-type kvm --name centos --ram 1024 \
  --disk euleros.qcow2,format=qcow2 \
  --network network=default \
  --graphics vnc,listen=0.0.0.0 --noautoconsole \
  --os-type=linux --os-variant=centos7.0 \
  --location=euleros.iso
  
```  
