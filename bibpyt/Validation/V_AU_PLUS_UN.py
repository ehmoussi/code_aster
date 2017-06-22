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


class AU_PLUS_UN:

    """
       La règle vérifie que l'on trouve 1 (au plus) des mots-clés
       de la règle parmi les arguments d'un OBJECT.

       Ces arguments sont transmis à la règle pour validation sous la forme
       d'une liste de noms de mots-clés ou d'un dictionnaire dont
       les clés sont des noms de mots-clés.
    """

    def verif(self, args):
        """
            La méthode verif vérifie que l'on trouve 1 (au plus) des mos-clés
            de la liste self.mcs parmi les éléments de args

            args peut etre un dictionnaire ou une liste. Les éléments de args
            sont soit les éléments de la liste soit les clés du dictionnaire.
        """
        #  on compte le nombre de mots cles presents
        text = ''
        count = 0
        args = self.liste_to_dico(args)
        for mc in self.mcs:
            count = count + args.get(mc, 0)
        if count > 1:
            text = u"- Il ne faut qu'un mot-clé (au plus) parmi : " + \
                `self.mcs`+'\n'
            return text, 0
        return text, 1

    def liste_to_dico(self, args):
        if type(args) is dict:
            return args
        elif type(args) in (list, tuple):
            dico = {}
            for arg in args:
                dico[arg] = dico.get(arg, 0) + 1
            return dico
        else:
            raise Exception(
                "Erreur ce n'est ni un dictionnaire ni une liste %s" % args)
