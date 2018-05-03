#!bin/bash
#create new instance in AWS
docker-machine create \
--driver amazonec2 --amazonec2-region eu-west-2 \
--amazonec2-zone a \
--amazonec2-vpc-id vpc-f474879c \
--amazonec2-subnet-id subnet-96b8a0ed \
--amazonec2-ami ami-f4f21593 \
--amazonec2-access-key $AWS_ACCESS_KEY_ID \
--amazonec2-secret-key $AWS_SECRET_ACCESS_KEY \
  skovbyk \
&& docker-machine env skovbyk