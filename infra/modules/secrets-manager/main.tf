resource "aws_secretsmanager_secret" "main" {
  for_each = var.secret_names

  name = "${var.project_name}/${var.environment}/${each.key}"

  # Convenient for a temporary development environment that is destroyed often.
  # Use a recovery window in production.
  recovery_window_in_days = 0
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type = "Federated"

      identifiers = [
        var.oidc_provider_arn
      ]
    }

    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_url}:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "${var.oidc_provider_url}:sub"

      values = [
        "system:serviceaccount:${var.service_account_namespace}:${var.service_account_name}"
      ]
    }
  }
}

data "aws_iam_policy_document" "secrets_access" {
  statement {
    sid    = "ReadManagedSecrets"
    effect = "Allow"

    actions = [
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret"
    ]

    resources = [
      for secret in aws_secretsmanager_secret.main :
      secret.arn
    ]
  }
}

resource "aws_iam_role" "main" {
  name = "${var.project_name}-${var.environment}-external-secrets"

  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_policy" "main" {
  name = "${var.project_name}-${var.environment}-external-secrets"

  description = "Allows External Secrets Operator to read managed AWS Secrets Manager secrets."

  policy = data.aws_iam_policy_document.secrets_access.json
}

resource "aws_iam_role_policy_attachment" "main" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.main.arn
}