/*====
DOCDB
======*/

/* subnet used by docdb */
resource "aws_db_subnet_group" "docdb_subnet_group" {
  name        = "${var.environment}-docdb-subnet-group"
  description = "DOCDB subnet group"
  subnet_ids  = var.subnet_ids
  tags = {
    ita_group = "${var.tag_value}"
    Environment = "${var.environment}"
  }
}

/* Security Group for resources that want to access the Database */
resource "aws_security_group" "db_access_sg" {
  vpc_id      = var.vpc_id
  name        = "${var.environment}-db-access-sg"
  description = "Allow access to DOCDB"



  tags = {
    ita_group = "${var.tag_value}"
    Name        = "${var.environment}-db-access-sg"
    Environment = "${var.environment}"
  }
}

resource "aws_security_group" "docdb_sg" {
  name = "${var.environment}-docdb-sg"
  description = "${var.environment} Security Group"
  vpc_id = var.vpc_id


  tags = {
    ita_group = "${var.tag_value}"
    Name = "${var.environment}-docdb-sg"
    Environment =  "${var.environment}"
  }

  // allows traffic from the SG itself
  ingress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      self = true
  }

  //allow traffic for TCP 27017
  ingress {
      from_port = 27017
      to_port   = 27017
      protocol  = "tcp"
      //security_groups = ["${aws_security_group.db_access_sg.id}"]
      //security_groups = var.sec_groups_ids
      cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
      //cidr_blocks = [var.vpc_id.main.cidr_block]
      //cidr_blocks = var.vpc_id.cidr_blocks
  }
  // outbound internet access
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_docdb_cluster_instance" "service" {
  count              = 1
  identifier         = "${var.environment}-docdb-cluster-instance"
  cluster_identifier = aws_docdb_cluster.service.id
  instance_class     = var.instance_class

  tags = {
    ita_group = "${var.tag_value}"
    Environment = "${var.environment}"
  }

}

resource "aws_docdb_cluster" "service" {
  skip_final_snapshot     = true
  db_subnet_group_name    = aws_db_subnet_group.docdb_subnet_group.id
  cluster_identifier      = "${var.environment}-docdb-cluster"
  engine                  = "docdb"
  master_username         = var.database_username
  master_password         = var.database_password
  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.service.name
  vpc_security_group_ids = ["${aws_security_group.docdb_sg.id}"]
  tags = {
    ita_group = "${var.tag_value}"
    Environment = "${var.environment}"
  }
}

resource "aws_docdb_cluster_parameter_group" "service" {
  family = "docdb3.6"
  name = "${var.environment}-docdb-cluster-pg"

  parameter {
    name  = "tls"
    value = "disabled"
  }

  tags = {
    ita_group = "${var.tag_value}"
    Environment = "${var.environment}"
  }

}

