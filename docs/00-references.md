# References

Primary references used while building this first-contact lab:

- Rancher Manager Documentation: NeuVector Overview  
  https://ranchermanager.docs.rancher.com/integrations-in-rancher/neuvector/overview
- NeuVector Documentation: Overview  
  https://open-docs.neuvector.com/basics/overview/
- NeuVector Documentation home  
  https://open-docs.neuvector.com/
- Rancher Desktop Documentation: rdctl command reference  
  https://docs.rancherdesktop.io/references/rdctl-command-reference/

Notes:

- The Rancher documentation describes NeuVector as a security solution with Controllers, Enforcers, Managers, and Scanners, plus an Updater for CVE database updates.
- The NeuVector documentation describes the same core security containers and positions NeuVector as runtime container security.
- The Rancher Desktop `rdctl` reference documents CLI flags such as `--virtual-machine.memory-in-gb` and `--virtual-machine.number-cpus`, which were necessary in this lab because the GUI produced a `virtualMachine.numberCPUs: <null>` error.
