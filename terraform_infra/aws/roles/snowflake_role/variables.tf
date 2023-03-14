variable "region" {
  type    = string
  default = "sa-east-1"
}

variable "storage_integration_s3_paths" {
  type    = list(string)
  default = ["data/"]
}

variable "assumer_principals_arn_list" {
  type    = list(string)
  default = ["arn:aws:iam::190687746545:user/admin","arn:aws:iam::190687746545:role/flix_snowflake_integration_role","arn:aws:iam::875784680923:user/cvw40000-s"]
}

variable "storage_integration_s3_bucket_arn" {
  type    = string
  default = "arn:aws:s3:::flixbus"
}

variable "storage_aws_external_id" {
  type    = string
  default = "YJ68275_SFCRole=2_xrJbiQD+CcYecOD0xOKma8OhPvM="
}
