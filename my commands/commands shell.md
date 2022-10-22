ssh -o ServerAliveInterval=120 user@87.117.9.49
GodMode.{ED7BA470-8E54-465E-825C-99712043E01C}
yc vpc network create --name net && yc vpc subnet create --name my-subnet-a --zone ru-central1-a --range 10.1.2.0/24 --network-name net --description "my first subnet via yc"