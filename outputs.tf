output "Pet_Clinic_1" {
  value = "http://${aws_instance.vm_springBoot.0.public_ip}:8080"
}
output "Pet_Clinic_2" {
  value = "http://${aws_instance.vm_springBoot.1.public_ip}:8080"
}
output "Pet_Clinic_3" {
  value = "http://${aws_instance.vm_springBoot.2.public_ip}:8080"
}

output "sigNoz-Dashboard" {
  value = "http://${aws_instance.vm_sigNoz.public_ip}:3301"
}