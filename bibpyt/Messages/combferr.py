# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 2018 Aether Engineering Solutions - www.aethereng.com
# Copyright (C) 2018 Kobe Innovation Engineering - www.kobe-ie.com
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
# aslint: disable=W4004

cata_msg = {

1 : _(u"""
 -> Avete richiesto ............................... CODIFICATION = "UTILISATEUR"
 -> Nella versione 1.0.0. non sono attive le opzioni diverse da "EC2". Il
    calcolo per le altro opzioni non sarà effettuato.
"""),

2 : _(u"""
 -> Avete richiesto .................................. TYPE_STRUCTURE = "POUTRE"
 -> Nella versione 1.0.0. non sono attive le opzioni diverse da "2D". Il
    calcolo per questa opzione non sarà effettuato.
"""),

3 : _(u"""
 -> Avete richiesto ................................. TYPE_STRUCTURE = "POUTEAU"
 -> Nella versione 1.0.0. non sono attive le opzioni diverse da "2D". Il
    calcolo per questa opzione non sarà effettuato.
"""),

4 : _(u"""
 -> La lista di NUME_ORDRE contiene almeno un valore duplicato.
"""),

5 : _(u"""
 -> La lista di NOM_CAS contiene almeno un valore duplicato.
"""),

6 : _(u"""
 -> Qualche NOM_CAS non appartiene ai casi disponibili.
"""),

7 : _(u"""
 -> Qualche NUME_ORDRE non appartiene ai casi disponibili.
"""),
}

# INFODEV
#
# Moving file in ../bibpyt/Messages
#
# INFODEV
