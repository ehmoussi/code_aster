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

# ce catalogue est réservé à Utmess !
cata_msg = {

    1 : _(u"""
Erreur lors de la vérification des messages.
%(k1)s

%(k2)s
"""),

    2 : _(u"""
Erreur lors de la vérification du catalogue de commandes.
%(k1)s

%(k2)s
"""),

    6: _(u"""
Fin à la suite de message(s) <E>
"""),

    41 : _(u"""
Le message d'alarme '%(k1)s' a été émis %(i1)d fois, il ne sera plus affiché.
"""),

    55: _(u"""
Appels récursifs de messages d'erreur ou d'alarme.
"""),

    57: _(u"""
  Impossible d'importer '%(k1)s' dans Messages.
  Le fichier %(k1)s.py n'existe pas dans le répertoire 'Messages'
  ou bien la syntaxe du fichier est incorrecte.

  Merci de signaler cette anomalie.

  Erreur :
  %(k2)s
"""),

    69: _(u"""
  Destruction du concept '%(k1)s'.
"""),

    70: _(u"""
  Validation du concept '%(k1)s'.
"""),

    87: _(u"""
  On ne devrait pas ignorer des alarmes si elles ne sont pas émises !
  Merci de retirer ces alarmes de DEBUT ou POURSUITE.

  Alarme(s) : '%(k1)s'
"""),

    # on ne veut pas émettre d'alarme mais que le message se voit, donc on
    # fait la mise en forme ici !
    88 : {  'message' : _(u"""
    Il est possible que d'autres alarmes aient été émises sur d'autres processeurs.
"""), 'flags' : 'DECORATED',
            },

    89 : {  'message' : _(u"""
    Liste des alarmes émises lors de l'exécution du calcul.

    Les alarmes que vous avez choisies d'ignorer sont précédées de (*).
    Nombre d'occurrences pour chacune des alarmes :
"""), 'flags' : 'DECORATED',
            },

    90 : {  'message' : _(u"""       %(k1)3s %(k2)-20s émise %(i1)4d fois
"""), 'flags' : 'DECORATED',
            },

    92 : {  'message' : _(u"""           aucune alarme
"""), 'flags' : 'DECORATED',
            },

}
