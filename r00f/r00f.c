/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   r00f.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: mcutura <mcutura@student.42berlin.de>      +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2023/02/10 20:25:24 by plandolf          #+#    #+#             */
/*   Updated: 2023/10/05 08:39:10 by mcutura          ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "r00f.h"

static const char	*g_schema[5] = \
	{"oooo--|| ", "/\\\\/**** ", "AACCBBBB ", "ACACBBBB ", "ACCABBBB "};

int	ft_atoi(char const *c)
{
	int	res;
	int	sig;

	res = 0;
	sig = 1;
	if (!c)
		return (res);
	while (*c && (*c == 0x09 || *c == 0x20))
		++c;
	while (*c && (*c == 0x2B || *c == 0x2D))
		sig *= (0x2C - *c++);
	while (*c && *c >= 0x30 && *c <= 0x39)
		res = res * 10 + *c++ - 0x30;
	return (res * sig);
}

static int	init_stuff(int ac, char **av, t_r00f *r00f)
{
	int	i;
	int	tmpw;
	int	tmph;

	r00f->type = 0;
	if (ac > 1)
		tmpw = ft_atoi(av[1]);
	if (ac > 2)
		tmph = ft_atoi(av[2]);
	if (ac < 3 || tmph < 1 || tmpw < 1)
		return (1);
	r00f->height = (size_t)tmph;
	r00f->width = (size_t)tmpw;
	r00f->map_len = r00f->height * r00f->width;
	if (r00f->map_len >= BUFFERSIZE)
		return (1);
	r00f->map[r00f->map_len - 1] = 0;
	if (ac > 3)
		r00f->type = ft_atoi(av[3]);
	if (r00f->type < 0 || r00f->type > 4)
		r00f->type = 0;
	i = -1;
	while (++i < MAX_LEGEND)
		r00f->legend[i] = g_schema[r00f->type][i];
	return (0);
}

static void	set_lines(size_t *idx, t_r00f *r00f)
{
	while (*idx < r00f->width)
	{
		if (!*idx)
			r00f->map[*idx] = r00f->legend[0];
		else if (*idx == r00f->width - 1)
			r00f->map[*idx] = r00f->legend[1];
		else
			r00f->map[*idx] = r00f->legend[4];
		++(*idx);
	}
	while (*idx < r00f->map_len - r00f->width)
	{
		if (!(*idx % r00f->width))
			r00f->map[*idx] = r00f->legend[6];
		else if (!((*idx + 1) % r00f->width))
			r00f->map[*idx] = r00f->legend[7];
		else
			r00f->map[*idx] = r00f->legend[8];
		++(*idx);
	}
}

int	r00f(int ac, char **av)
{
	t_r00f	r00f;
	size_t	idx;

	if (init_stuff(ac, av, &r00f))
		return (1);
	idx = 0;
	while (idx < r00f.map_len)
	{
		set_lines(&idx, &r00f);
		if (idx == r00f.map_len - r00f.width)
			r00f.map[idx] = r00f.legend[2];
		else if (idx == r00f.map_len - 1)
			r00f.map[idx] = r00f.legend[3];
		else
			r00f.map[idx] = r00f.legend[5];
		++idx;
	}
	what(&r00f);
	return (0);
}
