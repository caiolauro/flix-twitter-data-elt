resource "snowflake_stage" "flixbus_stage" {
  name        = "FLIXBUS_STAGE"
  url         = "s3://flixbus"
  database    = var.db_name
  schema      = var.schema_name
  storage_integration = "flixbus"
}

# resource "snowflake_stage_grant" "grant_usage_flixbus_stage" {
#   database_name = snowflake_stage.flixbus_stage.database
#   schema_name   = snowflake_stage.flixbus_stage.schema
#   roles         = ["SYSADMIN"]
#   privilege     = "USAGE"
#   stage_name    = snowflake_stage.flixbus_stage.name
# }