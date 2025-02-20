locals {
  current_time_for_tag = formatdate("MM-DD-YY", timestamp())
  current_time = timestamp()
  expiration_duration = "720h" # Example for 30 days. Adjust the duration as needed.
}
