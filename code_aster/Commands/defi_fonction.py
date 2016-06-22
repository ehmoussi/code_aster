# coding: utf-8

# Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
#
# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# Code_Aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.

# person_in_charge: mathieu.courtois@edf.fr

import numpy as np

from code_aster import Function
from code_aster.Cata import Commands
from code_aster.Cata.SyntaxChecker import checkCommandSyntax


funcParameterNames = (
    "DX","DY","DZ","DRX","DRY","DRZ","TEMP","TSEC",
    "INST","X","Y","Z","EPSI","META","FREQ","PULS","DSP",
    "AMOR","ABSC","SIGM","HYDR","SECH","PORO","SAT",
    "PGAZ","PCAP","PLIQ","PVAP","PAD","VITE","ENDO",
    "NORM","EPAIS","NEUT1","NEUT2","XF","YF","ZF"
)

def DEFI_FONCTION( **kwargs ):
    """Définit une fonction réelle ou complexe d'une variable réelle"""
    checkCommandSyntax( Commands.DEFI_FONCTION, kwargs )

    NOM_PARA = kwargs['NOM_PARA']
    assert NOM_PARA in funcParameterNames
    # default values
    NOM_RESU = kwargs.get("NOM_RESU", "TOUTRESU")
    ABSCISSE = kwargs.get("ABSCISSE")
    VALE_PARA = kwargs.get("VALE_PARA")
    VALE = kwargs.get("VALE")
    VALE_C = kwargs.get("VALE_C")
    # switch
    if ABSCISSE is not None:
        absc = np.array(ABSCISSE)
        ordo = np.array(kwargs["ORDONNEE"])
    elif VALE_PARA is not None:
        absc = np.array(VALE_PARA)
        ordo = np.array(kwargs["VALE_FONC"])
    elif VALE is not None:
        values = np.array(VALE)
        values = values.reshape( ( values.size / 2, 2 ) )
        absc = values[:, 0]
        ordo = values[:, 1]
    elif VALE_C is not None:
        raise NameError("'VALE_C' not yet supported!")
    elif NOEUD_PARA is not None:
        raise NameError("'NOEUD_PARA' not supported anymore!")
    else:
        raise NameError("DEFI_FONCTION expects ABSCISSE/ORDONNEE keywords")


    INTERPOL = kwargs.get("INTERPOL", ["LIN", "LIN"])
    if type(INTERPOL) in (list, tuple):
        INTERPOL = " ".join(INTERPOL)
    if len(INTERPOL.split()) == 1:
        INTERPOL = INTERPOL + " " + INTERPOL
    PROL_GAUCHE = kwargs.get("PROL_GAUCHE", "E")
    PROL_DROITE = kwargs.get("PROL_DROITE", "E")

    func = Function()
    func.setParameterName( NOM_PARA )
    func.setResultName( NOM_RESU )
    func.setInterpolation( INTERPOL )
    func.setExtrapolation( PROL_GAUCHE[0] + PROL_DROITE[0] )
    func.setValues( absc, ordo )
    return func
