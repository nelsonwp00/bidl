#! /bin/bash
for i in `seq 20`; do
    echo "###  10.22.1.$i  ###"
	ssh-copy-id -i ~/.ssh/id_rsa.pub jqi@10.22.1.$i
done