ssm-ec2:
	echo "start session manager in ec2..."
	$(eval HOST = `aws ec2 describe-instances --region ap-northeast-1 --output json --filters "Name=instance-state-code,Values=16" --filters "Name=tag:environment,Values=xxx" | jq -r '.Reservations[].Instances[] | [.Tags[] | select(.Key == "Name").Value][] + "\t" + .InstanceId'  | sort | peco | cut -f 2`)
	aws ssm start-session --target $(HOST)
