variable "name"        { type = string }
variable "routes"      { type = map(object({ path = string, target_url = string })) }
variable "tags"        { type = map(string) }
