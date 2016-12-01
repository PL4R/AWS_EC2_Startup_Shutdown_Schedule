# AWS EC2 startup/shutdown schedule
This shell script is use to startup & shutdown AWS EC2 instances based on values defined in a custom tag.  

I'm sure there is a far more elegant way of doing this this, but time was at a premium and it did the job.

## Prerequisites

- Linux host
- AWS cli tools
- AWS access key id/secret access key configured via 'aws configure' for the user to run this script

## How to

- Clone this repo
- Put script wherever you wish & make executable
- Create cron entry to run script at the top of every hour
- Create tags against your EC2 instances that you want to manage;
  - Tag name needs to be "Runwindow"
  - Values need to be be expressed in 24hr notation as "starthour-stophour":
e.g. "01-22" means start @ 1AM and stop @ 10PM
