#!/bin/sh

touch vmlinuz64

docker build -t docker-kern .

docker run --rm -v $(PWD)/kern-config:/usr/src/linux/.config -v $(PWD)/vmlinuz64:/usr/src/linux/arch/x86/boot/bzImage -t docker-kern make -j4
