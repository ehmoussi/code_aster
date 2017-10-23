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
   Utilitaires pour tester la sd produite par une commande.
"""

from Noyau.asojb import OJB

# pour utilisation dans eficas
try:
    import aster
    from Utilitai.Utmess import UTMESS
except:
    pass


def get_list_objects():
    """Retourne la liste (set) des objets jeveux présents à un moment donné
    """
    return set(aster.jeveux_getobjects(' '))


def check(checker, co, l_before, etape):
    """Vérifie la cohérence de la SD produite :
       - type des objets / ceux déclarés dans le catalogue de la SD
       - présence d'objets imprévus dans le catalogue
    l_before : liste des objets jeveux présents avant la création de la SD.
    """

    type_concept = type(co).__name__
    sd = co.sdj
    if 0:
        print "AJACOT checksd " + type_concept + " >" + sd.nomj.nomj + '<'

    # l_new = objets créés par la commande courante
    l_after = get_list_objects()
    l_new = l_after - l_before

    # on vérifie le contenu de la SD sur la base de son catalogue
    checker = sd.check(checker)

    # Vérification des "checksum":
    if 0:
        # A modifier (if 1) si l'on souhaite vérifier que les commandes ne
        # modifient pas leurs arguments "in" :
        # On vérifie que le "checksum" des objets qui existaient déjà n'a pas changé:
        # Remarque : il faut bien le faire sur l_after car c'est checkSumOJB qui
        #             initialise la valeur pour les objets nouveaux
        for nom in l_after:
            if nom[0:1] == '&':
                # à cause des objets "&&SYS.*" et du cout des objets "&CATA.*"
                continue
            obj = OJB(nom)
            if etape.reuse:
                # les commandes réentrantes ont le droit de modifier leur
                # concept "reuse"
                if nom[0:8].strip() == sd.nomj.nomj.strip():
                    checker.checkSumOJB(obj, sd, 'maj')
                    continue
            checker.checkSumOJB(obj, sd)

    # on imprime les messages d'erreur stockés dans le checker
    lerreur = [(obj, msg) for level, obj, msg in checker.msg if level == 0]
    lerreur.sort()

    # on vérifie que la commande n'a pas créé d'objets interdits
    l_possible = set(checker.names.keys())
    l_interdit = list(l_new - l_possible)
    l_interdit.sort()

    # concept utilisateur
    if co.nom[0:8].strip() == sd.nomj.nomj.strip():
        obj = "{:24}".format("{0:<19}._TCO".format(co.nom))
        if obj in l_interdit:
            l_interdit.remove(obj)
        if obj not in l_after:
            lerreur.append((obj, "type manquant"))

    if len(lerreur) > 0:
        # pour "ouvrir" le message
        nom_concept = sd.nomj.nomj.strip()
        nom_commande = etape.definition.nom.strip()
        UTMESS("E+", 'SDVERI_30', valk=(nom_concept, nom_commande))
        for obj, msg in lerreur:
            UTMESS("E+", 'SDVERI_31', valk=(obj, msg))
        UTMESS("E", 'VIDE_1')

    # on détruit les messages déjà imprimés pour ne pas les réimprimer avec la
    # SD suivante
    checker.msg = []

    if len(l_interdit) > 0:
        # pour "ouvrir" le message :
        UTMESS("E+", 'SDVERI_40', valk=type_concept)
        for x in l_interdit:
            UTMESS('E+', 'SDVERI_41', valk=x)
        UTMESS("E", 'VIDE_1')

    return checker
