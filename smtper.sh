# !/bin/bash

# IMPORTAND FILE
source ./asw/smtper-send.sh

# COLOR ( BOLD )
RED="\e[1;31m"
GREEN="\e[1;32m"
YELLOW="\e[1;33m"
BLUE="\e[1;34m"
MAGENTA="\e[1;35m"
CYAN="\e[1;36m"
WHITE="\e[1;37m"

# BASE URL OF SMTPER
BASE_URL="https://www.smtper.net"

# GET SCRIPT NAME
SCRIPT_NAME=$(basename "${0}")

# SMTPER HEADER
USERAGENT="Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/103.0.0.0 Safari/537.36"
declare -a SMTPER_HEADER=('-H' "authority: $(awk -F'/' '{print $3}' <<< $BASE_URL)" '-H' "accept: application/json, text/javascript, */*; q=0.01" '-H' "accept-language: id-ID,id;q=0.9,en-US;q=0.8,en;q=0.7" '-H' "content-type: application/json" '-H' "dnt: 1" '-H' "origin: ${BASE_URL}" '-H' "sec-ch-ua: \".Not/A)Brand\";v=\"99\", \"Google Chrome\";v=\"103\", \"Chromium\";v=\"103\"" '-H' "sec-ch-ua-mobile: ?0" '-H' "sec-ch-ua-platform: \"Windows\"" '-H' "sec-fetch-dest: empty" '-H' "sec-fetch-mode: cors" '-H' "sec-fetch-site: same-origin" '-H' "user-agent: ${USERAGENT}" '-H' "x-requested-with: XMLHttpRequest")

# HANDLE OPTIONAL VAR
MAIL_PORT="587"
MAIL_FROM="from_$(whoami)@mail.tld"
MAIL_TO="killua1st@hotmail.com"

# BANNER
function BANNER(){
	echo -e "
	       ${WHITE}SMTPer CLI Version
	By : ./LazyBoy - JavaGhost Team
	   [ ${BLUE}${BASE_URL}${WHITE} ]
	   "
}

# INFORMATION HOW TO USE
function INFORMATION_USAGE(){
  echo -e "${WHITE}Usage: bash ${SCRIPT_NAME} <options>

  Options:
    -h Set SMTP host
    -P Set SMTP port
    -u Set SMTP user
    -p Set SMTP pass
    -f Set SMTP from
    -t Set receiver mail
    -l <file> For multiple checking
       format: mail_host|mail_port|mail_user|mail_pass|mail_from
  "
}

# HANDLE
if [[ $# -eq "0" ]]; then
	BANNER
	INFORMATION_USAGE
	exit
fi

# FOR PRINT SOME ERROR
function PRINT_ERROR(){
	echo -e "\n${SCRIPT_NAME}: ${RED}${1}${WHITE}\n"
	exit
}

# LIST OPTIONS
while getopts ":h:P:u:p:f:t:l:" LIST_OPT; do
	case "${LIST_OPT}" in
		 h ) MAIL_HOST="${OPTARG}" ;;
		 P ) MAIL_PORT="${OPTARG}" ;;
		 u ) MAIL_USER="${OPTARG}" ;;
		 p ) MAIL_PASS="${OPTARG}" ;;
		 f ) MAIL_FROM="${OPTARG}" ;;
		 t ) MAIL_TO="${OPTARG}" ;;
		 l ) MULTIPLE_LIST="${OPTARG}" ;;
		 \?) PRINT_ERROR "Options '-${OPTARG}'" ;;
		 : ) PRINT_ERROR "Options '-${OPTARG}' Required arguments" ;;
	esac
done
shift $OPTIND
OPTIND=1

# VALIDATION
if [[ ! -z "${MULTIPLE_LIST}" ]]; then
	if [[ ! -e "${MULTIPLE_LIST}" ]]; then
		PRINT_ERROR "File '${MULTIPLE_LIST}' not found in your directory"
		exit
	else
		BANNER
		MULTIPLE_CHECKSEND "${MULTIPLE_LIST}" | tee -a LOG_SMTPER.log
	fi
else
	# HANDLE
	REQ_OPT=("-h:${MAIL_HOST}" "-u:${MAIL_USER}" "-p:${MAIL_PASS}")

	for LST_REQ in "${REQ_OPT[@]}"; do
		CHECK_OPT=$(echo "${LST_REQ}" | awk -F':' '{print $2}')
		GET_OPT=$(echo "${LST_REQ}" | awk -F':' '{print $1}')

		if [[ -z "${CHECK_OPT}" ]]; then
			PRINT_ERROR "Options '${GET_OPT}' must be used"
			break
		fi
	done
	
	BANNER
	SMTPER_CHECKSEND
	# SMTPER_CHECKSEND "${MAIL_HOST}" \
	# 	"${MAIL_PORT}" \
	# 	"${MAIL_USER}" \
	# 	"${MAIL_PASS}" \
	# 	"${MAIL_FROM}" \
	# 	"${MAIL_TO}" | tee -a LOG_SMTPER.log
fi