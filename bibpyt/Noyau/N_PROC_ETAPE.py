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
    Ce module contient la classe PROC_ETAPE qui sert à vérifier et à exécuter
    une procédure
"""

# Modules Python
import types
import sys
import string
import traceback

# Modules EFICAS
import N_MCCOMPO
import N_ETAPE
from N_Exception import AsException
import N_utils


class PROC_ETAPE(N_ETAPE.ETAPE):

    """
       Cette classe hérite de ETAPE. La seule différence porte sur le fait
       qu'une procédure n'a pas de concept produit

    """
    nature = "PROCEDURE"

    def __init__(self, oper=None, reuse=None, args={}):
        """
        Attributs :
         - definition : objet portant les attributs de définition d'une étape de type opérateur. Il
                        est initialisé par l'argument oper.
         - valeur : arguments d'entrée de type mot-clé=valeur. Initialisé avec l'argument args.
         - reuse : forcément None pour une PROC
        """
        N_ETAPE.ETAPE.__init__(self, oper, reuse=None, args=args, niveau=5)
        self.reuse = None

    def Build_sd(self):
        """
            Cette methode applique la fonction op_init au contexte du parent
            et lance l'exécution en cas de traitement commande par commande
            Elle doit retourner le concept produit qui pour une PROC est toujours None
            En cas d'erreur, elle leve une exception : AsException ou EOFError
        """
        if not self.isactif():
            return
        try:
            if self.parent:
                if type(self.definition.op_init) == types.FunctionType:
                    apply(self.definition.op_init, (
                        self, self.parent.g_context))
            else:
                pass
        except AsException, e:
            raise AsException("Etape ", self.nom, 'ligne : ', self.appel[0],
                              'fichier : ', self.appel[1], e)
        except EOFError:
            raise
        except:
            l = traceback.format_exception(
                sys.exc_info()[0], sys.exc_info()[1], sys.exc_info()[2])
            raise AsException("Etape ", self.nom, 'ligne : ', self.appel[0],
                              'fichier : ', self.appel[1] + '\n',
                              string.join(l))

        self.Execute()
        return None

    def supprime(self):
        """
           Méthode qui supprime toutes les références arrières afin que l'objet puisse
           etre correctement détruit par le garbage collector
        """
        N_MCCOMPO.MCCOMPO.supprime(self)
        self.jdc = None
        self.appel = None

    def accept(self, visitor):
        """
           Cette methode permet de parcourir l'arborescence des objets
           en utilisant le pattern VISITEUR
        """
        visitor.visitPROC_ETAPE(self)

    def update_context(self, d):
        """
           Met à jour le contexte de l'appelant passé en argument (d)
           Une PROC_ETAPE n ajoute pas directement de concept dans le contexte
           Seule une fonction enregistree dans op_init pourrait le faire
        """
        if type(self.definition.op_init) == types.FunctionType:
            apply(self.definition.op_init, (self, d))
