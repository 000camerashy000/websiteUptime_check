#!/bin/bash

# Defining key values pairs where key = website & values =0
declare -A website_dict
website_dict["https://www.google.com"]=0
website_dict["https://ai-champion-tracker.framer.ai/"]=0
website_dict["https://www.facebook.com"]=0

# Email configuration/function

# temporary just for testing
down_file="/home/ashish/OP/extras/Assignments/down_websites.txt"
current_datetime=$(date +"%Y-%m-%d %H:%M:%S")
# Function to check websites
check_websites() {
    for website in "${!website_dict[@]}"; do
        http_code=$(curl -s -o /dev/null -w "%{http_code}" "$website")
        if [ "$http_code" != "301" ] && [ "$http_code" != "200"  ]; then
          echo "Website $website is DOWN."
          website_dict["$website"]=$((website_dict["$website"] + 1))
          if [ ${website_dict["$website"]} -le 5 ]; then
               echo "[$current_datetime]: Website $website is DOWN.(Value: ${website_dict["$website"]}/5)." >> "$down_file"
          fi
        else
          echo "Website $website is UP."
          website_dict["$website"]=0
        fi
    done
}

while true; do
    check_websites
    sleep 600
done
