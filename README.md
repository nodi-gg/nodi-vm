# Nodi VM

A packer config to create a reproducable VM image for Nodi running and development, based on Debian Bullseye.

How to build:
`packer build nodi-debian-amd64.pkr.hcl`

Outputs a QCOW2 image with Debian Bullseye minimal install + docker + docker-compose.
