# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

# person_in_charge: mathieu.courtois at edf.fr

"""
This package describes the physical quantities, the elementary calculations,
the finite elements, ...

Dependencies:

phenomenons_modelisations -> Elements/*
phenomenons_modelisations -> mesh_types
Elements/* -> mesh_types
Elements/* -> physical_quantities
Elements/* -> located_components
Elements/* -> parameters
Elements/* -> Options/*
Options/* -> physical_quantities
Options/* -> parameters
parameters -> physical_quantities
located_components -> physical_quantities
"""

__DEBUG_ELEMENTS__ = []
