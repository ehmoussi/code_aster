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
   Ce module contient la classe  de base MCCOMPO qui sert à factoriser
   les traitements des objets composites de type OBJECT
"""
# Modules Python
import os
import traceback

# Modules EFICAS
from Noyau import MAXSIZE, MAXSIZE_MSGCHK
from Noyau import N_CR
from Noyau.N_Exception import AsException
from Noyau.strfunc import ufmt, to_unicode


class MCCOMPO:

    """
        L'attribut mc_liste a été créé par une classe dérivée de la
        classe MCCOMPO du Noyau
    """

    CR = N_CR.CR

    def __init__(self):
        self.state = 'undetermined'
        # défini dans les classes dérivées
        self.txt_nat = ''

    def init_modif_up(self):
        """
           Propage l'état modifié au parent s'il existe et n'est pas l'objet
           lui-meme
        """
        if self.parent and self.parent != self:
            self.parent.state = 'modified'

    def report(self):
        """
            Génère le rapport de validation de self
        """
        self.cr = self.CR()
        self.cr.debut = self.txt_nat + self.nom
        self.cr.fin = u"Fin " + self.txt_nat + self.nom
        i = 0
        for child in self.mc_liste:
            i += 1
            if i > MAXSIZE:
                print(MAXSIZE_MSGCHK.format(MAXSIZE, len(self.mc_liste)))
                break
            self.cr.add(child.report())
        self.state = 'modified'
        try:
            self.isvalid(cr='oui')
        except AsException, e:
            if CONTEXT.debug:
                traceback.print_exc()
            self.cr.fatal(' '.join((self.txt_nat, self.nom, str(e))))
        return self.cr

    def verif_regles(self):
        """
           A partir du dictionnaire des mots-clés présents, vérifie si les règles
           de self sont valides ou non.

           Retourne une chaine et un booléen :

             - texte = la chaine contient le message d'erreur de la (les) règle(s) violée(s) ('' si aucune)

             - testglob = booléen 1 si toutes les règles OK, 0 sinon
        """
        # On verifie les regles avec les defauts affectés
        dictionnaire = self.dict_mc_presents(restreint='non')
        texte = ['']
        testglob = 1
        for r in self.definition.regles:
            erreurs, test = r.verif(dictionnaire)
            testglob = testglob * test
            if erreurs != '':
                texte.append(to_unicode(erreurs))
        texte = os.linesep.join(texte)
        return texte, testglob

    def dict_mc_presents(self, restreint='non'):
        """
            Retourne le dictionnaire {mocle : objet} construit à partir de self.mc_liste
            Si restreint == 'non' : on ajoute tous les mots-clés simples du catalogue qui ont
            une valeur par défaut
            Si restreint == 'oui' : on ne prend que les mots-clés effectivement entrés par
            l'utilisateur (cas de la vérification des règles)
        """
        dico = {}
        # on ajoute les couples {nom mot-clé:objet mot-clé} effectivement
        # présents
        for v in self.mc_liste:
            if v == None:
                continue
            k = v.nom
            dico[k] = v
        if restreint == 'oui':
            return dico
        # Si restreint != 'oui',
        # on ajoute les couples {nom mot-clé:objet mot-clé} des mots-clés simples
        # possibles pour peu qu'ils aient une valeur par défaut
        for k, v in self.definition.entites.items():
            if v.label != 'SIMP':
                continue
            if not v.defaut:
                continue
            if not dico.has_key(k):
                dico[k] = v(nom=k, val=None, parent=self)
        # on ajoute l'objet detenteur de regles pour des validations plus
        # sophistiquees (a manipuler avec precaution)
        dico["self"] = self
        return dico
