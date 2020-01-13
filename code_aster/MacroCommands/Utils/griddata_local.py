# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

import numpy as np


def griddata(seeds, Data_, grid_x, grid_y, A):
    """
    Input :
        seeds .- Array containing the x and y coordinates of the points where
                 the data is known
        Data_ .- One dimensional array  containing the known values at the
                 "seeds" cordinates
        grid_x .- grid array containing the x coordinates of the interpolation
                 points
        grid_y .- grid array containing the y coordinates of the interpolation
                 points
        A .- boolean grid defining if the coordinates lie within the geometry

    Output :
                grid_z .- Array containing the interpolated data
    """
    grid_x = np.round(grid_x, 6)    # Rounded for precision E-6
    grid_y = np.round(grid_y, 6)
    seeds = np.round(seeds, 6)

    nbrow, nbcol = grid_x.shape
    grid_z = np.zeros((nbrow, nbcol))

    for i_ in range(nbrow):
        for j_ in range(nbcol):
            if A[i_, j_] == True:    # The point is inside the geometry

                Nod_detec_x = seeds[:, 0] == grid_x[i_, j_]
                Nod_detec_y = seeds[:, 1] == grid_y[i_, j_]
                Nod_detec_xy = np.multiply(Nod_detec_x, Nod_detec_y)

                if Nod_detec_xy.sum() == 1:
                    # Data is available for the current coordinates
                    grid_z[i_, j_] = Data_[Nod_detec_xy]

                elif Nod_detec_x.sum() > 0 and Nod_detec_y.sum() == 0:
                    # Linear interpolation Y axis
                    idy = np.searchsorted(seeds[:, 1], grid_y[i_, j_])
                    y_lower = seeds[:, 1][idy - 1]
                    y_upper = seeds[:, 1][idy]

                    D1 = Data_[np.multiply(Nod_detec_x, (seeds[:, 1] == y_upper))]
                    D2 = Data_[np.multiply(Nod_detec_x, (seeds[:, 1] == y_lower))]

                    grid_z[i_, j_] = ((D2 - D1)/(y_upper - y_lower))*grid_y[i_, j_]

                elif Nod_detec_x.sum() == 0 and Nod_detec_y.sum() > 0:
                    # Linear interpolation X axis
                    idx = np.searchsorted(seeds[:, 0], grid_x[i_, j_])
                    x_lower = seeds[:, 0][idx - 1]
                    x_upper = seeds[:, 0][idx]

                    D1 = Data_[np.multiply((seeds[:, 0] == x_upper), Nod_detec_y)]
                    D2 = Data_[np.multiply((seeds[:, 0] == x_lower), Nod_detec_y)]

                    grid_z[i_, j_] = ((D2 - D1)/(x_upper - x_lower))*grid_x[i_, j_]

                else: # bilinear interpolation needed

                    Points = np.zeros((4, 3))

                    idx = np.searchsorted(seeds[:, 0], grid_x[i_, j_])
                    x_lower = seeds[:, 0][idx - 1]
                    x_upper = seeds[:, 0][idx]
                    idy = np.searchsorted(seeds[:, 1], grid_y[i_, j_])
                    y_lower = seeds[:, 1][idy - 1]
                    y_upper = seeds[:, 1][idy]

                    Points[0,:] = [x_lower, y_lower,
                          Data_[np.multiply((seeds[:, 0] == x_lower),
                                            (seeds[:, 1] == y_lower))]]

                    Points[1,:] = [x_upper, y_lower,
                          Data_[np.multiply((seeds[:, 0] == x_upper),
                                            (seeds[:, 1] == y_lower))]]

                    Points[2,:] = [x_upper, y_upper,
                          Data_[np.multiply((seeds[:, 0] == x_upper),
                                            (seeds[:, 1] == y_upper))]]

                    Points[3,:] = [x_lower, y_upper,
                          Data_[np.multiply((seeds[:, 0] == x_lower),
                                            (seeds[:, 1] == y_upper))]]

                    grid_z[i_, j_] = bilinear_interpolation(grid_x[i_, j_],
                          grid_y[i_, j_], Points)
            else:
                grid_z[i_, j_] = 0    # The point is outside the geometry

    return grid_z


def bilinear_interpolation(x, y, Points):
    """
    Bilinear interpolation
    Input:
            Points .- Matrix 4x3 of the square data [coord_x, coord_y, value]
            x .- x coordinate to be interpolated
            y .- y coordinate to be interpolated
    """
    x_p = Points[:, 0]    # X coordinates
    y_p = Points[:, 1]    # Y coordinates
    q = Points[:, 2]    # Values

    if x_p[0] != x_p[3] or x_p[1] != x_p[2] or y_p[0] != y_p[1] or y_p[2] != y_p[3]:
        return 0.0

    else:
        return (q[0] * (x_p[2] - x) * (y_p[2] - y) +
                q[1] * (x - x_p[0]) * (y_p[2] - y) +
                q[3] * (x_p[2] - x) * (y - y_p[0]) +
                q[2] * (x - x_p[0]) * (y - y_p[0])) / ((x_p[2] - x_p[0]) * (y_p[2] - y_p[0]) + 0.0)
