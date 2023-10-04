/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   r00f.h                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: mcutura <mcutura@student.42berlin.de>      +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/10/02 23:20:35 by mcutura           #+#    #+#             */
/*   Updated: 2023/10/03 03:03:56 by mcutura          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef R00F_H
# define R00F_H

/* R00f r00F */
# ifndef BUFFER_SIZE
#  define BUFFERSIZE	0x3FFFFF
# endif

/* library for write syscall */
# include <unistd.h>

/* constants TL TR BL BR T B L R*/
# define MAX_LEGEND	9

/* data structures */
enum	e_mode
{
	NON_PRINTABLE,
	PRINTABLE,
	NON_ASCII,
	ZERO_WIDTH
};

typedef struct s_r00f
{
	int		type;
	size_t	width;
	size_t	height;
	size_t	legend_len;
	char	legend[MAX_LEGEND];
	size_t	map_len;
	char	map[BUFFERSIZE];
}	t_r00f;

/* prototypes */
int		r00f(int ac, char **av);
int		lone_r00f(void);
void	what(t_r00f *r00f);
ssize_t	ft_putchar(char c);
ssize_t	mc_putchar(int fd, void *mc, size_t size, int mode);
int		ft_atoi(char const *c);

#endif
