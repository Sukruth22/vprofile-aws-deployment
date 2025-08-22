# Commands & Notes

Keep a running, chronological log of commands you executed and any output snippets or errors.
This serves as proof of work and helps you debug later.

## Day 1
```bash
# example: create key pair, launch EC2, connect
# aws ec2 create-key-pair --key-name vprofile-key --query 'KeyMaterial' --output text > vprofile-key.pem
# chmod 400 vprofile-key.pem
# ssh -i vprofile-key.pem ubuntu@<EC2_PUBLIC_DNS>
```
