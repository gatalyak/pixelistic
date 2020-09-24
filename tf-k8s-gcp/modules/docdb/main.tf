data "template_file" "mongo_config" {
  template = var.rs == "none" ? file("${path.module}/mongod.conf.tpl") : file("${path.module}/mongod.rs.conf.tpl")

  vars = {
    project = var.project
    zone    = var.zone
    rs      = var.rs
  }
}

resource "google_compute_image" "mongodb-image" {
  name = "${var.instance_name}-mongodb-image"

  raw_disk {
    source = var.raw_image_source
  }
  timeouts {
    create = "10m"
  }
}

resource "tls_private_key" "mongo_key" {
  algorithm = "RSA"
  rsa_bits  = 756
}

resource "google_compute_disk" "mongo_data_disk" {
  name  = "${var.instance_name}-${count.index}-persistent-data"
  type  = var.data_disk_type
  size  = var.data_disk_gb
  zone  = var.zone
  count = var.node_count
}

resource "google_compute_instance" "mongo_instance" {
  name         = "${var.instance_name}-${count.index}"
  machine_type = var.machine_type
  zone         = var.zone
  count        = var.node_count

  tags = ["mongo", "mongodb"]

  boot_disk {
    initialize_params {
      image = google_compute_image.mongodb-image.self_link
      type  = "pd-standard"
      size  = "10"
    }
  }
  attached_disk {
    source      = "${var.instance_name}-${count.index}-persistent-data"
    device_name = "mongopd"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    foo      = "bar"
    ssh-keys = "devops:${tls_private_key.provision_key.public_key_openssh}"
  }

  //metadata_startup_script = "systemctl enable mongodb.service;"

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-rw", "monitoring-write", "logging-write", "https://www.googleapis.com/auth/trace.append"]
  }

  provisioner "file" {
    content     = data.template_file.mongo_config.rendered
    destination = "/tmp/mongod.conf"

    connection {
      host        = self.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = "devops"
      private_key = tls_private_key.provision_key.private_key_pem
      agent       = false
    }
  }

  provisioner "file" {
    content     = base64encode(tls_private_key.mongo_key.private_key_pem)
    destination = "/tmp/mongodb.key"

    connection {
      host        = self.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = "devops"
      private_key = tls_private_key.provision_key.private_key_pem
      agent       = false
    }
  }

  provisioner "file" {
    source      = "${path.module}/bootstrap.sh"
    destination = "/tmp/bootstrap.sh"

    connection {
      host        = self.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = "devops"
      private_key = tls_private_key.provision_key.private_key_pem
      agent       = false
    }
  }

  provisioner "remote-exec" {
    connection {
      host        = self.network_interface.0.access_config.0.nat_ip
      type        = "ssh"
      user        = "devops"
      private_key = tls_private_key.provision_key.private_key_pem
      agent       = false
    }
    inline = [
      "chmod +x /tmp/bootstrap.sh",
      "/tmp/bootstrap.sh > /tmp/bootstrap",
    ]
  }

  //not sure if ok for production
  allow_stopping_for_update = false

  depends_on = [google_compute_disk.mongo_data_disk]
}

resource "tls_private_key" "provision_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "google_compute_firewall" "mongodb-allow-cluster" {
  name     = "mongodb-allow-cluster-${var.instance_name}"
  network  = "default"
  priority = "1000"

  allow {
    protocol = "tcp"
    ports    = ["27017"]
  }

  source_ranges = [var.cluster_ipv4_cidr]
  target_tags   = ["mongodb"]
}



/*====
DOCDB
======*/

/* subnet used by docdb */

/*
resource "aws_db_subnet_group" "docdb_subnet_group" {
  name        = "${var.environment}-docdb-subnet-group"
  description = "DOCDB subnet group"
  subnet_ids  = var.subnet_ids
  tags = {
    ita_group = "${var.tag_value}"
    Environment = "${var.environment}"
  }
}
*/

/* Security Group for resources that want to access the Database */
/*
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
      cidr_blocks = ["${var.vpc_cidr}"]
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

*/