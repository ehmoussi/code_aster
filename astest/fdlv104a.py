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
from code_aster.Commands import AFFE_CARA_ELEM 

def F_AFFE_CARA_ELEM(STRUCT) : 

  CHAMPCAR=AFFE_CARA_ELEM( MODELE=STRUCT,DISCRET=(
                             _F( GROUP_MA = ('RESSORT1',),
                 CARA = 'K_TR_L',
                 VALE = (1., 
                       0., 1.E5, 
                       0., 0.,  1.,
                       0., 0.,  0.,   1.E10, 
                       0., 0.,  0.,   0.,  1.E10,
                       0., 0.,  0.,   0.,  0.,   1.E10, 
                       0., 0.,  0.,   0.,  0.,    0.,  1., 
                       0.,-1.E5, 0.,  0.,  0.,    0.,  0., 1.E5,
                       0., 0.,  0.,   0.,  0.,    0.,  0., 0., 1.,
                       0., 0.,  0.,   0.,  0.,    0.,  0., 0., 0., 1.E10, 
                       0., 0.,  0.,   0.,  0.,    0.,  0., 0., 0., 0., 1.E10,
                       0., 0.,  0.,   0.,  0.,    0.,  0., 0., 0., 0., 0., 1.E10,)),
                             _F( GROUP_MA = ('RESSORT1',),
                 CARA = 'M_TR_L',
                 VALE = (0., 
                       0., 0., 
                       0., 0.,  0.,
                       0., 0.,  0.,   0., 
                       0., 0.,  0.,   0.,  0.,
                       0., 0.,  0.,   0.,  0.,    0., 
                       0., 0.,  0.,   0.,  0.,    0.,  0., 
                       0., 0.,  0.,   0.,  0.,    0.,  0., 0.,
                       0., 0.,  0.,   0.,  0.,    0.,  0., 0., 0.,
                       0., 0.,  0.,   0.,  0.,    0.,  0., 0., 0., 0., 
                       0., 0.,  0.,   0.,  0.,    0.,  0., 0., 0., 0., 0.,
                       0., 0.,  0.,   0.,  0.,    0.,  0., 0., 0., 0., 0., 0.,)),

                 _F( GROUP_MA = ('RESSORT2',),
                 CARA = 'K_TR_L',
                 VALE = (1.E6, 
                       0., 1., 
                       0., 0.,  1.,
                       0., 0.,  0.,   1.E10, 
                       0., 0.,  0.,   0.,  1.E10,
                       0., 0.,  0.,   0.,  0.,   1.E10, 
                    -1.E6, 0.,  0.,   0.,  0.,    0.,  1.E6, 
                       0., 0.,  0.,   0.,  0.,    0.,  0., 1.,
                       0., 0.,  0.,   0.,  0.,    0.,  0., 0., 1.,
                       0., 0.,  0.,   0.,  0.,    0.,  0., 0., 0., 1.E10, 
                       0., 0.,  0.,   0.,  0.,    0.,  0., 0., 0., 0., 1.E10,
                       0., 0.,  0.,   0.,  0.,    0.,  0., 0., 0., 0., 0., 1.E10,)),
                 _F( GROUP_MA = ('RESSORT2',),
                 CARA = 'M_TR_L',
                 VALE = (0., 
                       0., 0., 
                       0., 0.,  0.,
                       0., 0.,  0.,   0., 
                       0., 0.,  0.,   0.,  0.,
                       0., 0.,  0.,   0.,  0.,    0., 
                       0., 0.,  0.,   0.,  0.,    0.,  0., 
                       0., 0.,  0.,   0.,  0.,    0.,  0., 0.,
                       0., 0.,  0.,   0.,  0.,    0.,  0., 0., 0.,
                       0., 0.,  0.,   0.,  0.,    0.,  0., 0., 0., 0., 
                       0., 0.,  0.,   0.,  0.,    0.,  0., 0., 0., 0., 0.,
                       0., 0.,  0.,   0.,  0.,    0.,  0., 0., 0., 0., 0., 0.,)),

                 _F( GROUP_MA = ('RESSORT3',),
                 CARA = 'K_TR_L',
                 VALE = (1., 
                       0., 1., 
                       0., 0.,  1.E7,
                       0., 0.,  0.,   1.E15, 
                       0., 0.,  0.,   0.,  1.E15,
                       0., 0.,  0.,   0.,  0.,   1.E15, 
                       0., 0.,  0.,   0.,  0.,    0.,  1., 
                       0., 0.,  0.,   0.,  0.,    0.,  0., 1.,
                       0., 0.,-1.E7,  0.,  0.,    0.,  0., 0., 1.E7,
                       0., 0.,  0.,   0.,  0.,    0.,  0., 0., 0., 1.E15, 
                       0., 0.,  0.,   0.,  0.,    0.,  0., 0., 0., 0., 1.E15,
                       0., 0.,  0.,   0.,  0.,    0.,  0., 0., 0., 0., 0., 1.E15,)),
                 _F( GROUP_MA = ('RESSORT3',),
                 CARA = 'M_TR_L',
                 VALE = (0., 
                       0., 0., 
                       0., 0.,  0.,
                       0., 0.,  0.,   0., 
                       0., 0.,  0.,   0.,  0.,
                       0., 0.,  0.,   0.,  0.,    0., 
                       0., 0.,  0.,   0.,  0.,    0.,  0., 
                       0., 0.,  0.,   0.,  0.,    0.,  0., 0.,
                       0., 0.,  0.,   0.,  0.,    0.,  0., 0., 0.,
                       0., 0.,  0.,   0.,  0.,    0.,  0., 0., 0., 0., 
                       0., 0.,  0.,   0.,  0.,    0.,  0., 0., 0., 0., 0.,
                       0., 0.,  0.,   0.,  0.,    0.,  0., 0., 0., 0., 0., 0.,)),),

               COQUE=_F( GROUP_MA = 'COQUES', EPAIS = 1.E-2))
  return CHAMPCAR 
