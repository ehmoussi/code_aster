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

from code_aster.Commands import FORMULE

import math

try:
  # Import du module de calcul symbolique Sympy
  import sympy
  sympy_available = True
  # cet import inutile est du au plantage sur la machine clpaster (fiche 17434)
  import numpy
except ImportError:
  sympy_available = False


def Solu_Manu() :



        if sympy_available:

          X,Y = sympy.symbols('X Y');

        # Definition de la solution manufacturee
          T=100*(X**6+Y**6);


        # Deduction de la fonction source de chaleur, ie: S=-laplacien(F(X,Y))
          S=-Lambda*(sympy.diff(sympy.diff(T,X),X)+sympy.diff(sympy.diff(T,Y),Y));


        # Deduction des conditions de Neumann
          N=Lambda*sympy.diff(T,X);


        # Transformation des formules Sympy en formules Aster
          TT=FORMULE(NOM_PARA=('X','Y'),VALE=str(T));
          SS=FORMULE(NOM_PARA=('X','Y'),VALE=str(S));
          NN=FORMULE(NOM_PARA=('X','Y'),VALE=str(N));

        # Si importation de sympy impossible
        else:

        #================================================================================================
        # Definition des formules Aster
        #================================================================================================

          TT=FORMULE(NOM_PARA=('X','Y'),VALE='100*X**6 + 100*Y**6');
          SS=FORMULE(NOM_PARA=('X','Y'),VALE='-45000*X**4 - 45000*Y**4');
          NN=FORMULE(NOM_PARA=('X','Y'),VALE='9000*X**5');
        return TT, SS, NN
