profile ?= prd
target ?=

SSM_CMD = aws ssm start-session --target

.PHONY: start-ssm ssm-ec2 background-color ssm-prd

start-ssm:
	$(eval HOST = `aws ec2 describe-instances --region ap-northeast-1 --output json --filters "Name=instance-state-code,Values=16" | jq -r '.Reservations[].Instances[] | .InstanceId, [.Tags[] | select(.Key == "Name").Value][]' | xargs -n2 | sort | fzf | cut -d " " -f 1`)

ssm-ec2: start-ssm
	$(SSM_CMD) $(HOST)

background-color:
	@echo -e "\033]50;SetProfile=$(profile)\a"

ssm-prd: background-color
ifndef target
	$(error target is required: make ssm-prd target=<instance-id>)
endif
	$(SSM_CMD) $(target); \
	echo -e "\033]50;SetProfile=Default\a"
