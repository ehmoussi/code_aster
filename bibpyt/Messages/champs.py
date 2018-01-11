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

# person_in_charge: josselin.delmas at edf.fr

cata_msg = {

    1 : _(u"""
 On ne trouve pas de valeurs dans le champ.
"""),

    2 : _(u"""
 Le champ %(k1)s n'est pas défini sur la totalité des noeuds précisés
 dans le mot-clé GROUP_MA_ESCL, GROUP_NO_ESCL, MAILLE_ESCL ou
 NOEUD_ESCL.

 Il vous faut compléter le champ %(k1)s.
"""),

    3: _(u"""
Erreur utilisateur :
 La composante demandée %(k1)s n'est pas trouvée dans le champ.
"""),

    4 : _(u"""
 On ne trouve pas de mailles dans les groupes fournis.
"""),

    5 : _(u"""
 On ne trouve pas de noeuds dans les groupes fournis.
"""),

    6 : _(u"""
 Le champ %(k1)s n'existe pas au numéro d'ordre %(i1)d dans
 le concept résultat %(k2)s.
"""),

    7 : _(u"""
 On ne sait pas calculer le critère %(k1)s pour les champs de la grandeur %(k2)s.
"""),

    8 : _(u"""
 L'opération correspondant à l'occurrence numéro %(i4)d de CHAM_UTIL n'a pas pu être 
 effectuée sur certaines mailles pour le numéro d'ordre %(i1)d.
    - nombre de mailles affectées : %(i2)d 
    - nombre de mailles fournies  : %(i3)d 

 Conseils : 

 Utilisez le mot-clé GROUP_MA pour restreindre le calcul aux mailles concernées.
 Si c'est déjà le cas, adaptez les groupes fournis.  
"""),

    9 : _(u"""
 Le champ %(k1)s n'existe ni dans le concept résultat %(k2)s, ni dans %(k3)s
 au numéro d'ordre %(i1)d.
"""),

   10 : _(u"""
 L'opération correspondant à l'occurrence numéro %(i4)d de CHAM_UTIL n'a pas pu être 
 effectuée sur certains noeuds pour le numéro d'ordre %(i1)d.
    - nombre de noeuds affectées : %(i2)d 
    - nombre de noeuds fournies  : %(i3)d 

 Conseils : 

 Utilisez le mot-clé GROUP_MA pour restreindre le calcul aux mailles concernées.
 Si c'est déjà le cas, adaptez les groupes fournis.  
"""),

    11 : _(u"""
 Pour extraire la valeur d'un champ constant par élément (type ELEM), il est nécessaire de fournir
 un nom de maille ou un groupe de mailles.

 Conseil:
   - Renseignez un des mots-clés MAILLE ou GROUP_MA.
"""),

    12 : _(u"""
 Pour extraire la valeur d'un champ par élément aux noeuds (type ELNO), il est nécessaire de fournir
 un nom de maille ou un groupe de mailles et un nom de noeud ou un groupe de noeuds.

 Conseil:
   - Renseignez un des mots-clés MAILLE ou GROUP_MA et un des mots-clés NOEUD, GROUP_NO ou POINT.
"""),

    13 : _(u"""
 Pour extraire la valeur d'un champ par élément aux points de Gauss (type ELGA), il est nécessaire
 de fournir un nom de maille ou un groupe de mailles et le numéro de point de Gauss.

 Conseil:
   - Renseignez un des mots-clés MAILLE ou GROUP_MA et le mot-clé POINT.
"""),

    14 : _(u"""
Il n'est pas possible de créer le champ '%(k1)s' dans la structure
de donnée '%(k2)s'.

Conseil:
    Vérifiez que le champ n'existe pas déjà.
    Il est possible que cette structure de donnée n'accepte pas ce type de champ.

"""),

    15 : _(u"""
 Le calcul demandé dans l'occurrence numéro %(i2)d de CHAM_UTIL a échoué.
 Aucune maille ou aucun noeud fourni ne sait traiter le calcul.
 
 Conseils :
 Si vous avez restreint le calcul à des groupes de mailles ou de noeuds, vérifiez l'affectation de ces entités,
 sinon le calcul n'est pas possible sur ce modèle.
"""),

    16 : _(u"""
 On ne peut utiliser COEF_MULT que lorsque la grandeur en entrée est de type NEUT_R.
 Les coefficients donnés ont été ignorés.
"""),

    17 : _(u"""
 On ne sait pas calculer une norme sur un champ nodal.
"""),

    18 : _(u"""
 On ne sait pas calculer la norme sur le champ car sa grandeur %(k1)s a trop de composantes.
"""),

    19: _(u"""
Erreur utilisateur :
 La composante demandée %(k1)s n'est pas trouvée dans le champ %(k2)s.
"""),

    20 : _(u"""
 On ne peut pas traiter ce champ car il y a des termes condensés dans la numérotation.
 Contactez le support.
"""),

    21 : _(u"""
 Le modèle contient plusieurs 'CHAM_MATER'. Aucun n'a été stocké dans le concept résultat. 
  aucun post-traitement lié à CHAM_MATER ne sera possible
"""),

}
