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
EMEA
- nomad: http://192.168.56.71:4646 \
- consul: http://192.168.56.71:8500

USA
- nomad: http://192.168.56.72:4646 \
- consul: http://192.168.56.72:8500

# Job run multiregion
In the /vagrant/examples directory
```
nomad job run redis-multi-region.nomad
```

redis-multi-region.nomad
```
job "redis-multi-region" {

  multiregion {
    region "emea" {
      count       = 1
      datacenters = ["emea-dc1"]
    }

    region "usa" {
      count       = 1
      datacenters = ["usa-dc1"]
    }
  }

  type = "service"

  group "cache" {
    count = 1
    
    network {
      port "db" {
        to = 6379
      }
    }

    task "redis" {
      driver = "docker"

      config {
        image = "redis:3.2"

        ports = ["db"]
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
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

# Sample output
```
pc-workstation$ vagrant ssh emea
vagrant@emea:/vagrant/examples$ nomad job run redis-multi-region.nomad 
Job registration successful
Evaluation ID: e2263694-ac5d-c5d7-ff72-30e2584aef9c
vagrant@emea:/vagrant/examples$ nomad job status -region emea 
ID                  Type     Priority  Status   Submit Date
redis-multi-region  service  50        running  2022-02-14T08:16:06Z
vagrant@emea:/vagrant/examples$ 
vagrant@emea:/vagrant/examples$ nomad job status -region usa
ID                  Type     Priority  Status   Submit Date
redis-multi-region  service  50        running  2022-02-14T08:16:05Z
vagrant@emea:/vagrant/examples$ 
vagrant@emea:/vagrant/examples$ nomad job status -region emea redis-multi-region
ID            = redis-multi-region
Name          = redis-multi-region
Submit Date   = 2022-02-14T08:16:06Z
Type          = service
Priority      = 50
Datacenters   = emea-dc1
Namespace     = default
Status        = running
Periodic      = false
Parameterized = false

Summary
Task Group  Queued  Starting  Running  Failed  Complete  Lost
cache       0       0         1        0       0         0

Latest Deployment
ID          = 423dae3c
Status      = successful
Description = Deployment completed successfully

Multiregion Deployment
Region  ID        Status
emea    423dae3c  successful
usa     5b5a0290  successful

Deployed
Task Group  Desired  Placed  Healthy  Unhealthy  Progress Deadline
cache       1        1       1        0          2022-02-14T08:26:22Z

Allocations
ID        Node ID   Task Group  Version  Desired  Status   Created  Modified
7945539f  4d2ce6be  cache       0        run      running  31s ago  15s ago
vagrant@emea:/vagrant/examples$ 
vagrant@emea:/vagrant/examples$ 
vagrant@emea:/vagrant/examples$ nomad job status -region usa redis-multi-region
ID            = redis-multi-region
Name          = redis-multi-region
Submit Date   = 2022-02-14T08:16:05Z
Type          = service
Priority      = 50
Datacenters   = usa-dc1
Namespace     = default
Status        = running
Periodic      = false
Parameterized = false

Summary
Task Group  Queued  Starting  Running  Failed  Complete  Lost
cache       0       0         1        0       0         0

Latest Deployment
ID          = 5b5a0290
Status      = successful
Description = Deployment completed successfully

Multiregion Deployment
Region  ID        Status
emea    423dae3c  successful
usa     5b5a0290  successful

Deployed
Task Group  Desired  Placed  Healthy  Unhealthy  Progress Deadline
cache       1        1       1        0          2022-02-14T08:26:22Z

Allocations
ID        Node ID   Task Group  Version  Desired  Status   Created  Modified
966510e1  e32af496  cache       0        run      running  42s ago  26s ago
vagrant@emea:/vagrant/examples$ 

vagrant@emea:/vagrant/examples$ consul members 
Node         Address             Status  Type    Build   Protocol  DC    Partition  Segment
emea-consul  192.168.56.71:8301  alive   server  1.11.2  2         emea  default    <all>
vagrant@emea:/vagrant/examples$ 

vagrant@emea:/vagrant/examples$ consul members -wan
Node              Address             Status  Type    Build   Protocol  DC    Partition  Segment
emea-consul.emea  192.168.56.71:8302  alive   server  1.11.2  2         emea  default    <all>
usa-consul.usa    192.168.56.72:8302  alive   server  1.11.2  2         usa   default    <all>
vagrant@emea:/vagrant/examples$ 
```
