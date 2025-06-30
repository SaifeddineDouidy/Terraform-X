variable "instance_type_map" {
  type = map(string)
  default = {
    small  = "t2.small"
    medium = "t2.medium"
    large  = "t2.large"
    xlarge = "t2.xlarge"
  }
}

variable "node_count_map" {
  type = map(number)
  default = {
    small  = 1
    medium = 2
    large  = 3
    xlarge = 5
  }
}

variable "dynamodb_read_capacity_map" {
  type = map(number)
  default = {
    small  = 5
    medium = 20
    large  = 50
    xlarge = 100
  }
}

variable "dynamodb_write_capacity_map" {
  type = map(number)
  default = {
    small  = 5
    medium = 20
    large  = 50
    xlarge = 100
  }
}