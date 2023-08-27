variable "REPO" {
  default = "2e0byo"
}

group "default" {
  targets = ["tidal-radio-iris", "tidal-iris", "tidal"]
  platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7", "linux/arm/v6"]
}

target "tidal" {
  tags = ["${REPO}/tidal:latest"]
}

target "tidal-iris" {
  args = {
    BASE = "tidal"
  }
  tags = ["${REPO}/tidal-iris:latest"]
}

target "tidal-radio-iris" {
  args = {
    BASE = "radio"
  }
  tags = ["${REPO}/tidal-radio-iris:latest"]
}
