#!/bin/bash

# what's the url?
declare myUrl="http://wthd3e7pxp7j2vam.eastus.cloudapp.azure.com"
# how many times are we hitting it?
declare numberOfHits=1000

# output what we're going to do 
echo "Using url: $myUrl"
echo "Hitting it $numberOfHits times"

# loop through and hit the url the requisite number of times
for i in $( seq 1 $numberOfHits )
do
	curCode=$(curl -s -o /dev/null -w"%{http_code}\n" $myUrl)
	echo "Run #$i returned: $curCode"
done

