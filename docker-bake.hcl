variable "REPO" {
  default = "2e0byo"
}

variable "VERSION" {
}

group "default" {
  targets = ["tidal-radio-iris", "tidal-iris", "tidal"]
}

target "_setup" {
  platforms = ["linux/amd64", "linux/arm64", "linux/arm/v7", "linux/arm/v6"]
  cache-to = [
    "type=gha,mode=max"
  ]
  cache-from = [
    "type=gha"
  ]
}

target "tidal" {
  tags = [
    "${REPO}/tidal:latest",
    "${REPO}/tidal:${VERSION}",
  ]
  inherits = ["_setup"]
}

target "tidal-iris" {
  args = {
    BASE = "tidal"
  }
  tags = [
    "${REPO}/tidal-iris:latest",
    "${REPO}/tidal-iris:${VERSION}",
  ]
  inherits = ["_setup"]
}

target "tidal-radio-iris" {
  args = {
    BASE = "radio"
  }
  tags = [
    "${REPO}/tidal-radio-iris:latest",
    "${REPO}/tidal-radio-iris:${VERSION}",
  ]
  inherits = ["_setup"]
}
