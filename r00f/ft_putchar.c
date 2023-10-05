/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   ft_putchar.c                                       :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: mcutura <mcutura@student.42berlin.de>      +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/02/10 20:39:57 by mcutura           #+#    #+#             */
/*   Updated: 2023/10/05 08:32:25 by mcutura          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "r00f.h"

ssize_t	ft_putchar(char c)
{
	return (write(STDOUT_FILENO, &c, 1));
}

ssize_t	mc_putchar(int fd, void *mc, size_t size, int mode)
{
	if (fd >= 0 && mode == PRINTABLE)
		return (write(fd, (char const *)mc, size));
	return (0);
}

void	what(t_r00f *r00f)
{
	size_t	line;

	line = 0;
	while (line < r00f->height)
	{
		mc_putchar(STDOUT_FILENO, &r00f->map[line * r00f->width], \
					r00f->width, PRINTABLE);
		ft_putchar(0x0A);
		++line;
	}
}
