output "service_plan" {
  value = module.asp
}

output "app_service" {
  value     = module.linux_webapp
  sensitive = true
}