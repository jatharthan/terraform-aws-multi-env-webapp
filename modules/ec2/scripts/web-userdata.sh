#!/bin/bash

# Run commands as ec2-user
su - ec2-user <<'EOF'
cd ~/
rm -rf multi-region-disaster-recovery
git clone https://github.com/jatharthan/terraform-aws-multi-env-webapp
cd terraform-aws-multi-env-webapp/app_code
npm install express body-parser aws-sdk
pm2 start app.js --name recovery-app
pm2 startup systemd -u ec2-user --hp /home/ec2-user | tail -n 1 | sh
pm2 save

EOF