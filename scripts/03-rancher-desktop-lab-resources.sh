#!/usr/bin/env bash
set -euo pipefail

# Rancher Desktop local enterprise lab resource setting.
# Use this when the GUI fails with virtualMachine.numberCPUs: <null>.

rdctl set --virtual-machine.memory-in-gb 16 --virtual-machine.number-cpus 6
rdctl list-settings | grep -A8 virtualMachine
