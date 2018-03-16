# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

# person_in_charge: mathieu.courtois@edf.fr

"""
Define a parameter used in a parametric or probabilistic study.

The parameters are provided as a pickle file that contains:
- the list of the parameters names,
- the list of the parameters values.
"""

import os.path as osp
import pickle

import numpy

INPUTS = 'inputs.pick'


def VARIABLE(NOM_PARA, VALE):
    """Return the value of a parameter.

    If the parameter is not provided by the pickle file, the returned value is
    the nominal one.

    Arguments:
        NOM_PARA (str): Name of the parameter.
        VALE (float): Nominal value of the parameter.

    Returns:
        float: Value of the parameter.
    """
    if not hasattr(VARIABLE, "_cache"):
        if not osp.exists(INPUTS):
            params, values = [], []
        else:
            with open('inputs.pick', 'rb') as pick:
                params = pickle.load(pick)
                values = pickle.load(pick)

        VARIABLE._cache = params, values
        assert len(params) == len(values), (params, values)

    params, values = VARIABLE._cache
    inputs = dict(zip(params, values))
    return inputs.get(NOM_PARA, VALE)
