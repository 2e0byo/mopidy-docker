variable "REPO" {
  default = "2e0byo"
}

variable "VERSION" {
}

group "default" {
  targets = ["mopidy-tidal-radio-iris", "mopidy-tidal-iris", "mopidy-tidal", "mopidy"]
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

target "mopidy" {
  tags = [
    "${REPO}/mopidy:latest",
    "${REPO}/mopidy:${VERSION}",
  ]
  inherits = ["_setup"]
}

target "mopidy-tidal" {
  tags = [
    "${REPO}/mopidy-tidal:latest",
    "${REPO}/mopidy-tidal:${VERSION}",
  ]
  inherits = ["_setup"]
}

target "mopidy-tidal-iris" {
  args = {
    BASE = "tidal"
  }
  tags = [
    "${REPO}/mopidy-tidal-iris:latest",
    "${REPO}/mopidy-tidal-iris:${VERSION}",
  ]
  inherits = ["_setup"]
}

target "mopidy-tidal-radio-iris" {
  args = {
    BASE = "radio"
  }
  tags = [
    "${REPO}/mopidy-tidal-radio-iris:latest",
    "${REPO}/mopidy-tidal-radio-iris:${VERSION}",
  ]
  inherits = ["_setup"]
}
