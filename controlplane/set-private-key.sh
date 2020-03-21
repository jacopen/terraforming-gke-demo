#!/bin/bash
terraform output private_key > ~/.ssh/demo-jumpbox
chmod 600 ~/.ssh/demo-jumpbox
ssh-add ~/.ssh/demo-jumpbox
