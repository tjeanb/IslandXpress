output "vpc_id" {
  value = module.vpc.vpc_id
}

output "public_subnets_ids" {
  value = module.vpc.public_subnets_ids
}

output "private_app_subnets" {
  value = module.vpc.private_app_subnets_ids
}

output "private_db_subnets_ids" {
  value = module.vpc.private_db_subnets_ids
}