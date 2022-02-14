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
