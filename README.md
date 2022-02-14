# vagrant-nomad-federation

# Topology
```
                                NOMAD FEDERATION

       vagrant ssh emea                           vagrant ssh usa
   ################################         ################################
   #                              #         #                              #
   #                              #         #                              #
   #     -------------------      #         #     -------------------      #
   #     |NOMAD-client&srv |      #         #     |NOMAD-client&srv |      #
   #     |     reg: emea   |      #         #     |    reg: emea    |      #
   #     |     dc: emea-dc1|      #         #     |    dc: emea-dc1 |      #
   #     -------------------      #         #     -------------------      #
   #                              #         #                              #
   #     -------------------      #         #     -------------------      #
   #     | CONSUL          |      #         #     | CONSUL          |      #
   #     |                 |      #         #     |                 |      #
   #     |     dc: emea    |      #         #     |     dc: usa     |      #
   #     -------------------      #         #     -------------------      #
   #                 192.168.56.71#         #                 192.168.56.72#
   ################################         ################################

```

UI consul emea: http://192.168.56.71:4646
UI nomad emea: http://192.168.56.71:8500

UI nomad usa: http://192.168.56.72:4646
UI consul usa: http://192.168.56.72:8500

# Job run multiregion
In the examples directory
```
nomad job run redis-multi-region.nomad
```

# Job status per region
```
nomad job status -region emea 
```
```
nomad job status -region usa
```
```
nomad job status -region emea redis-multi-region
```
```
nomad job status -region usa redis-multi-region
```


# How to use this repo
Clone and cd into repo
```
git clone git@github.com:ion-training/vagrant-nomad-federation.git
```
```
cd vagrant-nomad-federation
```

Create lic/nomad.hclic and place license in it
```
touch lic/nomad.hclic
```

Create the lab
```
vagrant up
```

SSH into vm
```
vagrant ssh emea
```
```
vagrant ssh usa
```

Optional. SSH config for vscode remote explorer
```
vagrant ssh-config
```

