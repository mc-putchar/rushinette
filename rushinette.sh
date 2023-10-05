#!/usr/bin/env bash ********************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    rushinette.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mcutura <mcutura@student.42berlin.de>      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/10/04 14:09:39 by mcutura           #+#    #+#              #
#    Updated: 2023/10/05 13:14:02 by mcutura          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #


# colors
RESET="\e[0m"
BOLDRED="\e[1m\e[31m"
BOLDGREEN="\e[1m\e[32m"
BOLDMAGENTA="\e[1m\e[35m"
CYAN="\e[36m"
YELLOW="\e[33m"

# bussiness
echo -e \
"####################################################################
#${CYAN}__________             .__    .__               __    __          ${RESET}#
#${CYAN}\\______   \\__ __  _____|  |__ |__| ____   _____/  |__/  |_  ____  ${RESET}#
#${CYAN} |       _/  |  \\/  ___/  |  \\|  |/    \\_/ __ \\   __\\   __\\/ __ \\ ${RESET}#
#${CYAN} |    |   \\  |  /\\___ \\|   Y  \\  |   |  \\  ___/|  |  |  | \\  ___/ ${RESET}#
#${CYAN} |____|_  /____//____  >___|  /__|___|  /\\___  >__|  |__|  \\___  >${RESET}#
#${CYAN}        \\/           \\/     \\/        \\/     \\/                \\/ ${RESET}#
####################################################################
##       ${BOLDMAGENTA}by:        mc-putchar${RESET}                                    ##
####################################################################"

echo -e "${BOLDMAGENTA}Loading...${RESET}"
if [ -z "${USER_42}" ]; then
	sleep 4.02s #TODO: add removal via premium subscription
else
	echo -e "Cheers" "${CYAN}${USER}${RESET}"
fi

# serious
NORMIE="/usr/bin/norminette"
SRC_DIR="../ex00/"
MAIN="${SRC_DIR}""main.c"
PUTC="${SRC_DIR}""ft_putchar.c"
# RUSH="${SRC_DIR}""rush00.c"
[ ! -d "${SRC_DIR}" ] && echo -e "${BOLDRED}[ "KO" ]${RESET}" "No ex00 directory" \
	&& echo -e ${YELLOW}"Needs to be in rush00/. with ./ex00 beside"${RESET} && exit
RUSH=${SRC_DIR}$( ls ${SRC_DIR}| grep rush0 | head -1 )
# binaries
BIN="a.out"
TESTER_DIR="r00f"
TESTER="r00f"
# output
LOG="trace.log"
TMP="/tmp/not_so_important_file"
# compilation
GCC="gcc -Wall -Werror -Wextra"
COMPILE="${GCC} ${PUTC} ${RUSH} ${MAIN} -o ${BIN}"
# test cases
TEST_CASES="${TESTER_DIR}/tests.set"

# recharger, si vous plait
rm -fr "${BIN}" "${LOG}" "${TMP}"

[ ! -f "${MAIN}" -o ! -f "${PUTC}" -o ! -f "${RUSH}" ] && \
echo -e ${BOLDRED}[ "KO" ]${RESET}"Mandatory file missing" && exit
echo -e ${BOLDGREEN}[ "OK" ]${RESET} "Mandatory files"

( ${NORMIE} -R CheckForbiddenSourceHeader $SRC_DIR | grep 'Error' >> $LOG) \
&& echo -e ${BOLDRED}[ "KO" ]${RESET} "Norminette" && exit
echo -e ${BOLDGREEN}[ "OK" ]${RESET} "Norminette"

$COMPILE &>>$LOG
[ ! -f "$BIN" ] && echo -e ${BOLDRED}[ "KO" ]${RESET} "Does not compile" && exit
echo -e ${BOLDGREEN}[ "OK" ]${RESET} "Compiled"

[ ! -f "$TESTER_DIR/$TESTER" ] && >/dev/null make -C $TESTER_DIR $TESTER clean 
[ ! -f "$TESTER_DIR/$TESTER" ] && echo -e ${BOLDRED}[ "ERROR" ] "Couldn't compile tester"${RESET} && exit
echo -e ${BOLDGREEN}[ "OK" ]${RESET} "Tester compiled"

RUSH_VARIANT=$(ls $SRC_DIR | grep rush | grep -oE [0-9]+)
RUSH_COUNT=$(echo "${RUSH_VARIANT}" |wc -l)
if (("${RUSH_COUNT}" > 1)); then
	echo Found solutions for "${RUSH_COUNT}" variants | tee -a "${LOG}"
else
	echo Identified as rush "${RUSH_VARIANT}" | tee -a "${LOG}"
fi

i=0
ok=0
while read -r VAR
do
	echo Testing variant "${VAR}" | tee -a "${LOG}"
	while IFS=' ' read -r WIDTH HEIGHT # or was it the other way around :?
	do
		if [ -z "${RUSH_BONUS}" ]; then
			rm -f "${BIN}"
			sed -i "s/rush([-+]\{0,1\}[0-9]\{1,\}, [-+]\{0,1\}[0-9]\{1,\})/rush(${WIDTH}, ${HEIGHT})/g" "${MAIN}"
			$COMPILE &>>"${LOG}"
			[ -f "$BIN" ] && >"${TMP}" ./"${BIN}"
		else
			>"${TMP}" ./"${BIN}" "${WIDTH}" "${HEIGHT}"
		fi
		((i++))
		echo -e "TEST" "$i" "||" "$WIDTH $HEIGHT" >>$LOG
		if ! diff <(./"${TESTER_DIR}"/"${TESTER}" "${WIDTH}" "${HEIGHT}" "${VAR}") "${TMP}" &>>"${LOG}"; then
			echo -e ${BOLDRED}[ "KO" ]${RESET} "Test" "$i"
		else
			echo -e ${BOLDGREEN}[ "OK" ]${RESET} "Test" "$i" && echo -e "Passed" >>"${LOG}"
			((ok++))
			sleep 0.42s #// for dramatic effect and suspenful tensions
		fi
		echo -n >"${TMP}"
	done < "${TEST_CASES}"
done < <(printf '%s\n' "${RUSH_VARIANT}")

# drumroll........ results
echo "   ..."; sleep 2s
if [ $ok -eq $i ]; then
	echo -e "${BOLDGREEN}[ Congratulations ]${RESET} All tests passed!"
else
	echo -e "${BOLDMAGENTA}Passed $ok / $i tests${RESET}"
fi

# clean-up details
rm -f "${BIN}" "${TMP}"
>/dev/null make -C ${TESTER_DIR} fclean

