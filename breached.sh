#!/bin/bash
#Nandang Sopyan
#http://nandang.id
#filter only date on 2019
#OUTPUT=$(curl 'https://haveibeenpwned.com/api/v2/breaches' | jq '[ .[] | select(.BreachDate|test("^2019.")) | {Name: .Name, BreachDate: .BreachDate} ]')

OUTPUT=$(curl 'https://haveibeenpwned.com/api/v2/breaches' | jq '[ .[] | select((.BreachDate >= "2019")) | {Name: .Name, BreachDate: .BreachDate} ]')

prettyfy_date(){
    RESULT=$(date -d ${1} '+%d %B %Y')
    echo $RESULT
}

main(){
    for row in $(echo $OUTPUT | jq -r '.[] | @base64'); do

        _jq() {
            echo ${row} | base64 --decode | jq -r ${1}
        }

        DATA=$(_jq '.BreachDate')
        DATE_BREACHED=$(prettyfy_date ${DATA})

        echo "=============================="
        echo "|" $(_jq '.Name')
        echo "=============================="
        echo "| Breached Date:" 
        echo -e "|\t ${DATE_BREACHED}"
        echo "=============================="
        echo ""
        echo ""
    done
}

main
