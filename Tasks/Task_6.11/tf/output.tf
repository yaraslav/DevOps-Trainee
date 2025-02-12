output "iam_users" {
  description = "List of users"
  value       = aws_iam_user.user[*].name
}

output "user_arns" {
  description = "ARNs for IAM users"
  value = {
    # Loop through each user and get their ARN
    for user in aws_iam_user.user : user.name => user.arn
  }
}

output "iam_groups" {
  description = "List  of groups"
  value       = [aws_iam_group.dev.name, aws_iam_group.devops.name]
}

output "dev_group_arn" {
  description = "ARN for the Dev group"
  value = aws_iam_group.dev.arn
}

# Output for the ARN of the DevOps group
output "devops_group_arn" {
  description = "ARN for the DevOps group"
  value = aws_iam_group.devops.arn
}

output "devops_user_groups" {
  description = "List and ARNs of groups for devops user"
  value = {
    for idx, user in aws_iam_user.user : user.name => aws_iam_user_group_membership.user_group_membership[idx].groups
    if user.name == "devops"
  }
}


output "user_groups" {
  value = {
    for idx, user in aws_iam_user.user : 
    user.name => aws_iam_user_group_membership.user_group_membership[idx].groups
  }
}


# Show API-keys (just first apply)
output "iam_access_keys" {
  description = "AWS access keys for IAM users (shown only on first apply)"
  sensitive   = true
  value = {
    for idx, user in aws_iam_user.user :
    user.name => {
      access_key = aws_iam_access_key.user_keys[idx].id
      secret_key = aws_iam_access_key.user_keys[idx].secret
    }
  }
}

# Show devops password
output "devops_password" {
  description = "Temporary login password for devops user (requires reset on first login)"
  sensitive   = true
  value = contains(var.user_names, "devops") ? aws_iam_user_login_profile.devops_password[0].password : null
}



