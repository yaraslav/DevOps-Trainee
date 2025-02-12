resource "aws_iam_policy" "dev_ec2_control" {
  name        = "DevEC2Control"
  description = "Policy to allow Dev group to start and stop EC2 instances"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = [
          "ec2:StartInstances",
          "ec2:StopInstances"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_group" "dev" {
  name = "Dev"
}

resource "aws_iam_group" "devops" {
  name = "DevOps"
}

resource "aws_iam_group_policy_attachment" "dev_ec2_control" {
  group      = aws_iam_group.dev.name
  policy_arn = aws_iam_policy.dev_ec2_control.arn
}

resource "aws_iam_group_policy_attachment" "devops_full_access" {
  group      = aws_iam_group.devops.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
}


resource "aws_iam_user" "user" {
  count = length(var.user_names)
  name  = var.user_names[count.index]
}

resource "aws_iam_user_group_membership" "user_group_membership" {
  count = length(var.user_names)
  user  = aws_iam_user.user[count.index].name

  groups = concat(
    [aws_iam_group.dev.name], 
    var.user_names[count.index] == "devops" ? [aws_iam_group.devops.name] : []
  )
}

# Create API-keys for all users
resource "aws_iam_access_key" "user_keys" {
  count = length(var.user_names)
  user  = aws_iam_user.user[count.index].name
}

# Create passsword for user 'devops'
resource "aws_iam_user_login_profile" "devops_password" {
  count = contains(var.user_names, "devops") ? 1 : 0

  user                    = aws_iam_user.user[index(var.user_names, "devops")].name
  password_length         = 16
  password_reset_required = true

  lifecycle {
    ignore_changes = [password_length, password_reset_required]
  }

  depends_on = [aws_iam_user.user]
}

# Attach policy for changing password
resource "aws_iam_user_policy_attachment" "change_password" {
  user       = aws_iam_user.user[index(var.user_names, "devops")].name
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
}