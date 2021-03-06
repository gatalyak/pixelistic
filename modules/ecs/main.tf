/*====
Cloudwatch Log Group
======*/
resource "aws_cloudwatch_log_group" "pixelistic_terraform" {
  name = "pixelistic_terraform"

  tags = {
    ita_group = var.tag_value
    Environment = "${var.environment}"
    Application = "pixelistic_terraform"
  }
}

/*====
S3 bucket
======*/
resource "aws_s3_bucket" "bucket_terraform" {
  bucket = var.AWS_S3_BUCKET
  acl = "public-read"
  tags = {
    ita_group = var.tag_value
    Environment = "${var.environment}"
    Name = "${var.AWS_S3_BUCKET}"
  }
}



/*====
ECR repository to store our Docker images
======*/
resource "aws_ecr_repository" "pixelistic_terraform_web" {
  name = var.rep_name_web
  tags = {
    ita_group = "${var.tag_value}"
  }
}

resource "aws_ecr_repository" "pixelistic_terraform_api" {
  name = var.rep_name_api
  tags = {
    ita_group = "${var.tag_value}"
  }
}





/*====
ECS cluster
======*/


resource "aws_ecs_cluster" "cluster" {
  name = "${var.environment}-ecs-cluster"
  tags = {
    ita_group = "${var.tag_value}"
  }
}

/*====
ECS task definitions
======*/

/* the task definition for the web service */


data "template_file" "web_task" {
  template = "${file("${path.module}/tasks/web_task_definition.json")}"

  vars = {
    image           = "${aws_ecr_repository.pixelistic_terraform_web.repository_url}"
    AWS_REGION      = "${var.AWS_REGION}"
    log_group       = "${aws_cloudwatch_log_group.pixelistic_terraform.name}"
  }
}

data "template_file" "api_task" {
  template = "${file("${path.module}/tasks/api_task_definition.json")}"

  vars = {
    image           = "${aws_ecr_repository.pixelistic_terraform_api.repository_url}"
    MONGO_DB        = "${var.MONGO_DB}"
    FRONT_URL       = "${var.FRONT_URL}"
    AWS_ACCESS_KEY_ID  = "${var.AWS_ACCESS_KEY_ID}"
    AWS_SECRET_ACCESS_KEY = "${var.AWS_SECRET_ACCESS_KEY}"
    AWS_REGION      = "${var.AWS_REGION}"
    AWS_S3_BUCKET   = "${var.AWS_S3_BUCKET}"
    EMAIL_USER      = "${var.EMAIL_USER}"
    EMAIL_PASS      = "${var.EMAIL_PASS}"
    log_group       = "${aws_cloudwatch_log_group.pixelistic_terraform.name}"
  }
}




resource "aws_ecs_task_definition" "web" {
  family                   = "${var.environment}_web"
  container_definitions    = data.template_file.web_task.rendered
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_execution_role.arn
}


resource "aws_ecs_task_definition" "api" {
  family                   = "${var.environment}_api"
  container_definitions    = data.template_file.api_task.rendered
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_execution_role.arn
}


/*====
Web Load Balancer
======*/

resource "random_id" "target_group_sufix_web" {
  byte_length = 2
}

resource "random_id" "target_group_sufix_api" {
  byte_length = 2
}



resource "aws_alb_target_group" "alb_target_group_web" {
  name     = "${var.environment}-alb-tg-web-${random_id.target_group_sufix_web.hex}"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"
  deregistration_delay = 5

  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "200"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    ita_group = "${var.tag_value}"
  }
depends_on = [ aws_alb.alb_pixelistic_web ]
}

resource "aws_alb_target_group" "alb_target_group_api" {
  name     = "${var.environment}-alb-tg-api-${random_id.target_group_sufix_api.hex}"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = "ip"
  deregistration_delay = 5

  health_check {
    enabled             = true
    healthy_threshold   = 5
    interval            = 30
    matcher             = "404"
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
  }


  lifecycle {
    create_before_destroy = true
  }

  tags = {
    ita_group = "${var.tag_value}"
  }
depends_on = [ aws_alb.alb_pixelistic_api ]
}


/* security group for WEB ALB */

resource "aws_security_group" "web_inbound_sg" {
  name        = "${var.environment}-web-inbound-sg"
  description = "Allow HTTP from Anywhere into ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    ita_group = "${var.tag_value}"
    Name = "${var.environment}-web-inbound-sg"
  }
}

/* security group for API ALB */

resource "aws_security_group" "api_inbound_sg" {
  name        = "${var.environment}-api-inbound-sg"
  description = "Allow HTTP from Anywhere into ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3000
    to_port     = 3000 
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    ita_group = "${var.tag_value}"
    Name = "${var.environment}-api-inbound-sg"
  }
}



resource "aws_alb" "alb_pixelistic_web" {
  name            = "${var.environment}-pixelistic-web"
  subnets         = var.public_subnet_ids
  security_groups = concat(var.sec_groups_web_ids, [aws_security_group.web_inbound_sg.id])

  tags = {
    ita_group = "${var.tag_value}"
    Name        = "${var.environment}-alb-pixelistic_web"
    Environment = "${var.environment}"
  }
}

resource "aws_alb" "alb_pixelistic_api" {
  name            = "${var.environment}-pixelistic-api"
  subnets         = var.public_subnet_ids
  security_groups = concat(var.sec_groups_api_ids, [aws_security_group.api_inbound_sg.id])

  tags = {
    ita_group = "${var.tag_value}"
    Name        = "${var.environment}-alb-pixelistic_api"
    Environment = "${var.environment}"
  }
}



resource "aws_alb_listener" "pixelistic_web" {
  load_balancer_arn = aws_alb.alb_pixelistic_web.arn
  port              = "80"
  protocol          = "HTTP"
  depends_on        = [ aws_alb_target_group.alb_target_group_web ]

  default_action {
    target_group_arn = aws_alb_target_group.alb_target_group_web.arn
    type             = "forward"
  }


}

resource "aws_alb_listener" "pixelistic_api" {
  load_balancer_arn = aws_alb.alb_pixelistic_api.arn
  port              = "3000"
  protocol          = "HTTP"
  depends_on        = [ aws_alb_target_group.alb_target_group_api ]

  default_action {
    target_group_arn = aws_alb_target_group.alb_target_group_api.arn
    type             = "forward"
  }

}



/*
* IAM service role
*/


data "aws_iam_policy_document" "ecs_service_role" {
  statement {
    effect = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = ["ecs.amazonaws.com"]
    }
  }

}

resource "aws_iam_role" "ecs_role" {
  name               = "ecs_role"
  assume_role_policy = data.aws_iam_policy_document.ecs_service_role.json

  tags = {
    ita_group = "${var.tag_value}"
  }

}

data "aws_iam_policy_document" "ecs_service_policy" {
  statement {
    effect = "Allow"
    resources = ["*"]
    actions = [
      "elasticloadbalancing:Describe*",
      "elasticloadbalancing:DeregisterInstancesFromLoadBalancer",
      "elasticloadbalancing:RegisterInstancesWithLoadBalancer",
      "ec2:Describe*",
      "ec2:AuthorizeSecurityGroupIngress"
    ]
  }
}

/* ecs service scheduler role */


resource "aws_iam_role_policy" "ecs_service_role_policy" {
  name   = "ecs_service_role_policy"
  #policy = "${file("${path.module}/policies/ecs-service-role.json")}"
  policy = data.aws_iam_policy_document.ecs_service_policy.json
  role   = aws_iam_role.ecs_role.id

}

/* role that the Amazon ECS container agent and the Docker daemon can assume */

resource "aws_iam_role" "ecs_execution_role" {
  name               = "ecs_task_execution_role"
  assume_role_policy = file("${path.module}/policies/ecs-task-execution-role.json")
}

resource "aws_iam_role_policy" "ecs_execution_role_policy" {
  name   = "ecs_execution_role_policy"
  policy = file("${path.module}/policies/ecs-execution-role-policy.json")
  role   = aws_iam_role.ecs_execution_role.id
}

/*====
ECS service
======*/

/* Security Group for ECS */

resource "aws_security_group" "ecs_service" {
  vpc_id      = var.vpc_id
  name        = "${var.environment}-ecs-service-sg"
  description = "Allow egress from container"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    ita_group   = "${var.tag_value}"
    Name        = "${var.environment}-ecs-service-sg"
    Environment = "${var.environment}"
  }
}

/* Simply specify the family to find the latest ACTIVE revision in that family */

data "aws_ecs_task_definition" "web" {
  task_definition = aws_ecs_task_definition.web.family
  depends_on = [ aws_ecs_task_definition.web ]
}

resource "aws_ecs_service" "web" {
  name            = "${var.environment}-web"
  task_definition = "${aws_ecs_task_definition.web.family}:${max("${aws_ecs_task_definition.web.revision}", "${data.aws_ecs_task_definition.web.revision}")}"
  desired_count   = 2
  launch_type     = "FARGATE"
  cluster =       aws_ecs_cluster.cluster.id
  depends_on      = [ aws_iam_role_policy.ecs_service_role_policy, aws_alb_target_group.alb_target_group_web ]

  network_configuration {
    security_groups = concat(var.sec_groups_web_ids, [aws_security_group.ecs_service.id])
    subnets         = var.subnets_ids
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.alb_target_group_web.arn
    container_name   = "web"
    container_port   = "80"
  }


}

data "aws_ecs_task_definition" "api" {
  task_definition = aws_ecs_task_definition.api.family
  depends_on = [ aws_ecs_task_definition.api ]
}



resource "aws_ecs_service" "api" {
  name            = "${var.environment}-api"
  task_definition = "${aws_ecs_task_definition.api.family}:${max("${aws_ecs_task_definition.api.revision}", "${data.aws_ecs_task_definition.api.revision}")}"
  desired_count   = 2
  launch_type     = "FARGATE"
  cluster =       aws_ecs_cluster.cluster.id
  depends_on      = [ aws_iam_role_policy.ecs_service_role_policy, aws_alb_target_group.alb_target_group_api ]

  network_configuration {
    security_groups = concat(var.sec_groups_api_ids, [aws_security_group.ecs_service.id])
    subnets         = var.subnets_ids
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.alb_target_group_api.arn
    container_name   = "api"
    container_port   = "3000"
  }



}




