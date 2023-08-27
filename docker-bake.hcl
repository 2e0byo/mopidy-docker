variable "REPO" {
  default = "2e0byo"
}

group "default" {
  targets = ["tidal-radio-iris", "tidal-iris", "tidal"]
  platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7", "linux/arm/v6"]
}

target "_platforms" {
  platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7", "linux/arm/v6"]
}

target "tidal" {
  tags = ["${REPO}/tidal:latest"]
  inherits = ["_platforms"]
}

target "tidal-iris" {
  args = {
    BASE = "tidal"
  }
  tags = ["${REPO}/tidal-iris:latest"]
  inherits = ["_platforms"]
}

target "tidal-radio-iris" {
  args = {
    BASE = "radio"
  }
  tags = ["${REPO}/tidal-radio-iris:latest"]
  inherits = ["_platforms"]
}
