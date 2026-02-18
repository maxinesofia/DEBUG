# --- FRONTEND POLICIES & ALARMS ---

resource "aws_autoscaling_policy" "front_scale_out" {
  name                   = "${var.lastname}-front-scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.frontend.name
}

resource "aws_cloudwatch_metric_alarm" "front_cpu_high" {
  alarm_name          = "${var.lastname}-front-cpu-high-40"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60" # 1 minute
  statistic           = "Average"
  threshold           = "40"
  dimensions          = { AutoScalingGroupName = aws_autoscaling_group.frontend.name }
  alarm_actions       = [aws_autoscaling_policy.front_scale_out.arn]
}

resource "aws_autoscaling_policy" "front_scale_in" {
  name                   = "${var.lastname}-front-scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.frontend.name
}

resource "aws_cloudwatch_metric_alarm" "front_cpu_low" {
  alarm_name          = "${var.lastname}-front-cpu-low-10"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"
  dimensions          = { AutoScalingGroupName = aws_autoscaling_group.frontend.name }
  alarm_actions       = [aws_autoscaling_policy.front_scale_in.arn]
}

# --- BACKEND POLICIES & ALARMS ---

resource "aws_autoscaling_policy" "back_scale_out" {
  name                   = "${var.lastname}-back-scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.backend.name
}

resource "aws_cloudwatch_metric_alarm" "back_cpu_high" {
  alarm_name          = "${var.lastname}-back-cpu-high-40"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "40"
  dimensions          = { AutoScalingGroupName = aws_autoscaling_group.backend.name }
  alarm_actions       = [aws_autoscaling_policy.back_scale_out.arn]
}

resource "aws_autoscaling_policy" "back_scale_in" {
  name                   = "${var.lastname}-back-scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 60
  autoscaling_group_name = aws_autoscaling_group.backend.name
}

resource "aws_cloudwatch_metric_alarm" "back_cpu_low" {
  alarm_name          = "${var.lastname}-back-cpu-low-10"
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "60"
  statistic           = "Average"
  threshold           = "10"
  dimensions          = { AutoScalingGroupName = aws_autoscaling_group.backend.name }
  alarm_actions       = [aws_autoscaling_policy.back_scale_in.arn]
}