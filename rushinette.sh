#! /bin/bash
# sources
SRC_DIR="../ex00/"
MAIN="$SRC_DIR""main.c"
PUTC="$SRC_DIR""ft_putchar.c"
# RUSH="$SRC_DIR""rush00.c"
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
# colors
RESET="\e[0m"
BOLDRED="\e[1m\e[31m"
BOLDGREEN="\e[1m\e[32m"
BOLDMAGENTA="\e[1m\e[35m"
CYAN="\e[36m"

rm -f $BIN $LOG

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


[ ! -d "$SRC_DIR" ] && echo -e $BOLDRED[ "KO" ]$RESET "No ex00 directory" && exit
[ ! -f "$MAIN" -o ! -f "$PUTC" -o ! -f "$RUSH" ] && \
	echo -e $BOLDRED[ "KO" ]$RESET"Mandatory file missing" && exit
echo -e $BOLDGREEN[ "OK" ]$RESET "Mandatory files"

(/usr/bin/norminette -R CheckForbiddenSourceHeader $SRC_DIR | grep 'Error' >> $LOG) \
	&& echo -e $BOLDRED[ "KO" ]$RESET "Norminette" && exit
echo -e $BOLDGREEN[ "OK" ]$RESET "Norminette"

$COMPILE &>>$LOG
[ ! -f "$BIN" ] && echo -e $BOLDRED[ "KO" ]$RESET "Does not compile" && exit
echo -e $BOLDGREEN[ "OK" ]$RESET "Compiled"

[ ! -f "$TESTER_DIR/$TESTER" ] && >/dev/null make -C $TESTER_DIR $TESTER clean 
[ ! -f "$TESTER_DIR/$TESTER" ] && echo -e $BOLDRED[ "ERROR" ] "Couldn't compile tester"$RESET && exit
echo -e $BOLDGREEN[ "OK" ]$RESET "Tester compiled"

RUSH_VARIANT=$(ls $SRC_DIR | egrep -o [0-9]+ | tail -1)

i=0
ok=0
while IFS=' ' read -r WIDTH HEIGHT
do
	sed -i "s/rush([-+]\{0,1\}[0-9]\{1,\}, [-+]\{0,1\}[0-9]\{1,\})/rush($HEIGHT, $WIDTH)/g" $MAIN
	$COMPILE
	((i++))
	echo "TEST" "$i" "||" "$WIDTH $HEIGHT" >>$LOG
	if !(>>$LOG diff --normal --color \
		<(./$TESTER_DIR/$TESTER $WIDTH $HEIGHT $RUSH_VARIANT) <(./$BIN))
	then
		echo -e $BOLDRED[ "KO" ]$RESET "Test" "$i"
	else
		echo -e $BOLDGREEN[ "OK" ]$RESET "Test" "$i" && echo "Passed" >>$LOG
		((ok++))
	fi
done < "$TEST_CASES"

echo -e $BOLDMAGENTA"Passed" $ok "/" $i "tests"$RESET

[ $ok -eq $i ] && echo -e $BOLDGREEN"[ Congratulations ]$RESET All tests passed!"
rm -f $BIN
>/dev/null make -C $TESTER_DIR fclean
