profile ?= prd
target ?= xxx

start-ssm:
	$(eval HOST = `aws ec2 describe-instances --region ap-northeast-1 --output json --filters "Name=instance-state-code,Values=16" | jq -r '.Reservations[].Instances[] | .InstanceId, [.Tags[] | select(.Key == "Name").Value][]' | xargs -n2 | sort | peco | cut -d " " -f 1`)

ssm-ec2: start-ssm
	aws ssm start-session --target $(HOST)

background-color:
	@echo -e "\033]50;SetProfile=$(profile)\a"

ssm-prd: background-color
	aws ssm start-session --target $(target)
	@$(MAKE) background-color profile="Default"

