# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    rushinette.sh                                      :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mcutura <mcutura@student.42berlin.de>      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/10/04 14:09:39 by mcutura           #+#    #+#              #
#    Updated: 2023/10/04 14:53:11 by mcutura          ###   ########.fr        #
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
echo \
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

echo ${BOLDMAGENTA}Loading...${RESET}
if [ -z"${USER_42}" ]; then
	sleep 4.02s #TODO: add removal via premium subscription
else
	echo "Welcome" "${USER}"
fi

# serious
SRC_DIR="../ex00/"
MAIN="$SRC_DIR""main.c"
PUTC="$SRC_DIR""ft_putchar.c"
# RUSH="$SRC_DIR""rush00.c"
[ ! -d "$SRC_DIR" ] && echo ${BOLDRED}[ "KO" ]${RESET} "No ex00 directory" \
	&& echo $YELLOW"Needs to be in rush00/. with ./ex00 beside"${RESET} && exit
RUSH=$SRC_DIR$(ls $SRC_DIR|grep rush)
# binaries
BIN="a.out"
TESTER_DIR="r00f"
TESTER="r00f"
# output
LOG="trace.log"
# compilation
GCC="gcc -Wall -Werror -Wextra"
COMPILE="$GCC $PUTC $RUSH $MAIN -o $BIN"
# test cases
TEST_CASES="$TESTER_DIR/tests.set"

rm -f $BIN $LOG


[ ! -f "$MAIN" -o ! -f "$PUTC" -o ! -f "$RUSH" ] && \
echo ${BOLDRED}[ "KO" ]${RESET}"Mandatory file missing" && exit
echo ${BOLDGREEN}[ "OK" ]${RESET} "Mandatory files"

(/usr/bin/norminette -R CheckForbiddenSourceHeader $SRC_DIR | grep 'Error' >> $LOG) \
&& echo ${BOLDRED}[ "KO" ]${RESET} "Norminette" && exit
echo ${BOLDGREEN}[ "OK" ]${RESET} "Norminette"

$COMPILE &>>$LOG
[ ! -f "$BIN" ] && echo ${BOLDRED}[ "KO" ]${RESET} "Does not compile" && exit
echo ${BOLDGREEN}[ "OK" ]${RESET} "Compiled"

[ ! -f "$TESTER_DIR/$TESTER" ] && >/dev/null make -C $TESTER_DIR $TESTER clean 
[ ! -f "$TESTER_DIR/$TESTER" ] && echo ${BOLDRED}[ "ERROR" ] "Couldn't compile tester"${RESET} && exit
echo ${BOLDGREEN}[ "OK" ]${RESET} "Tester compiled"

RUSH_VARIANT=$(ls $SRC_DIR | egrep -o [0-9]+ | tail -1)

i=0
ok=0
while IFS=' ' read -r WIDTH HEIGHT
do
	sed -i "s/rush([-+]\{0,1\}[0-9]\{1,\}, [-+]\{0,1\}[0-9]\{1,\})/rush($HEIGHT, $WIDTH)/g" $MAIN
	$COMPILE
	((i++))
	echo "TEST" "$i" "||" "$WIDTH $HEIGHT" >>$LOG
	if ! >>$LOG diff --normal --color <${./$TESTER_DIR/$TESTER $WIDTH $HEIGHT $RUSH_VARIANT} <${./$BIN}
	then
		echo -e $BOLDRED[ "KO" ]$RESET "Test" "$i"
	else
		echo -e $BOLDGREEN[ "OK" ]$RESET "Test" "$i" && echo "Passed" >>$LOG
		((ok++))
		sleep 420s #// for dramatic effect and more drama
	fi
done < "$TEST_CASES"

echo ${BOLDMAGENTA}"Passed" $ok "/" $i "tests"${RESET}

[ $ok -eq $i ]
then
	echo ${BOLDGREEN}"[ Congratulations ]${RESET} All tests passed!"
fi
# clean-up details
rm -f ${BIN}
>/dev/null make -C ${TESTER_DIR} fclean

