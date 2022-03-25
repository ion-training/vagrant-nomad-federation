job "client2-svc2" {
  datacenters = ["emea-dc1"]

  group "svc2" {
    network {
      port "test" {
        to = 9090
      }
    }

    service {
      name = "client2-svc2"
      tags = ["${NOMAD_ALLOC_INDEX}", "${NOMAD_ALLOC_ID}"]
      port = 9090
      
    }

    task "svc2" {
      driver = "docker"

      config {
        image = "nicholasjackson/fake-service:v0.7.8"
      }

      env {
        MESSAGE = "hello from svc2 in DC ${ datacenter }"
      }

      resources {
        cpu    = 100
        memory = 100
      }
    }
  }
}
