variable "myvar" {
  type = "string"
  default = "hello terraform"
}

variable "map" {
  type = map(string)
  default = {
    "key" = "value"
  }
}

variable "list" {
  type = list
  default = [1,2,3]
}