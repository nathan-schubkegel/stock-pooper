# stock-pooper
My scripts for findings stocks to invest in.
* Written in powershell (because I needed practice and a break from work)
* Targets the REST api provided by www.quandl.com
* If I make a million dollars, I'll consider changing my job title =)

# Use
* Save your quandl API key to api_key.txt
* Install dependencies
  * ```Install-Module oxyplotcli -RequiredVersion 2.0.1```
* Run some powershell scripts! They're all accessible via stock-pooper.ps1. Example: ```powershell .\stockPooper.ps1 -getThreeMonthsData -exchange FSE -company 1COV_X```

# License
The contents of this repo are free and unencumbered software released into the public domain under The Unlicense. You have complete freedom to do anything you want with the software, for any purpose. Please refer to http://unlicense.org/ .
