# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: mcutura <mcutura@student.42berlin.de>      +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2023/10/02 22:11:12 by mcutura           #+#    #+#              #
#    Updated: 2023/10/05 08:37:04 by mcutura          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

# --- USAGE ---
# make			compile the project to an executable file
# make r00f		^same
# make all		^same
# make clean	remove binary object files
# make fclean	remove all compiled files
# make re		remove all compiled files and recompile again

# --- TARGET ---
NAME	:=	r00f

# --- DIRECTORIES ---
SRC_DIR	:=	.
INC_DIR	:=	.
OBJ_DIR	:=	.

# --- SOURCES ---
SRC		:=	r00f.c ft_putchar.c main.c
HDR		:=	r00f.h
SRCS	:=	$(addprefix $(SRC_DIR)/, $(SRC))
HEADERS	:=	$(addprefix $(INC_DIR)/, $(HDR))
OBJS	:=	$(SRC:%.c=$(OBJ_DIR)/%.o)

# --- TOOLS ---
RM		:=	rm -fr	#remove french translations
CC		:=	gcc
MKDIR	:=	mkdir -p
NORM	:=	norminette -R CheckForbiddenSourceHeader
#TESTER	:=	tester.sh

# --- FLAGS ---
CFLAGS	:=	-Wall -Wextra -Werror

# --- RULES ---
$(NAME): $(OBJS) $(HEADERS)
	@$(CC) $(CFLAGS) $(HEADERS) $(OBJS) -o $(NAME)

$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	@$(CC) $(CFLAGS) -c $< -o $@

$(OBJ_DIR):
	@$(MKDIR) $(OBJ_DIR)

all: $(NAME)

clean:
	@$(RM) $(OBJS)

fclean: clean
	@$(RM) $(NAME)

norm:
	@$(NORM)

re: fclean $(NAME)

#tester:
#	@chmod +x $(TESTER)
#	@./$(TESTER)

# --- TOTALLY FAKE ---
.PHONY:	all clean fclean norm re tester
