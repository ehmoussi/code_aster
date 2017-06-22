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
   Ensemble de fonctions permettant de récupérer des infos sur le contexte
   dans lequel se produit une erreur.
   L'objectif est :
      - d'aider à la compréhension du message,
      - de fournir, si possible, des pistes de solution.
"""

__all__ = ['context_concept', 'message_context_concept']

# -----------------------------------------------------------------------------


def context_concept(nom_concept):
    """Retourne le nom de la commande ayant produit le concept `nom_concept`
    et la liste des (commande, [mot-clé facteur,] mot-clé) où il est utilisé.
    """
    dico = {'concept': nom_concept, 'cmde_prod': '', 'cmde_use': []}
    jdc = CONTEXT.get_current_step()
    co = jdc.get_concept(nom_concept)
    if co == None:
        return dico
    dico['cmde_prod'] = co.etape
    # étape utilisant `nom_concept`
    l_etape = jdc.get_liste_etapes()
    l_cmde = []
    for etape in l_etape:
        pass
    if len(l_cmde) == 0:
        l_cmde.append('?')
    dico['cmde_use'] = ', '.join(l_cmde)
    return dico

# -----------------------------------------------------------------------------


def message_context_concept(*args, **kwargs):
    """Appel context_concept et formatte le message.
    """
    fmt_concept = """Le concept '%(nom_concept)s' a été produit par %(nom_cmde_prod)s."""
    dico = context_concept(*args, **kwargs)
    d = {
        'nom_concept': dico['concept'],
        'nom_cmde_prod': dico['cmde_prod'].nom,
    }
    return fmt_concept % d

# -----------------------------------------------------------------------------
if __name__ == '__main__':
    pass
