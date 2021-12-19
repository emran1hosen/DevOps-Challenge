resource "aws_lb_target_group" "tg-01" {
  name     = "TG"
  port     = 80
  protocol = "TCP"
  vpc_id   = "${aws_vpc.main.id}"
  health_check {
    path                = "/"
    port                = 80
    protocol            = "HTTP"
  }
}

resource "aws_lb_target_group_attachment" "tg-01-attach" {
  target_group_arn = aws_lb_target_group.tg-01.arn
  target_id        = aws_instance.ubuntu.id
  port             = 80
}

resource "aws_lb" "nlb-01" {
  name               = "nlb-01"
  internal           = false
  ip_address_type    = "ipv4"
  load_balancer_type = "network"
  subnets            = [aws_subnet.public_subnet_01.id]

}


resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.nlb-01.arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg-01.arn
  }
  depends_on = ["aws_lb_target_group.tg-01"]
}
