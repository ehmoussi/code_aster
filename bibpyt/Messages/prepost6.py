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

    2 : _(u"""
 -> le nombre de mailles de votre maillage (%(i1)d) est supérieur
    à la limite de 9 999 999.
 -> Risque & Conseil : veuillez vérifier le script GIBI qui vous a permis
    de générer le fichier MGIB.
"""),



    6 : _(u"""
 composante %(k1)s / point  %(i1)d
"""),

    7 : _(u"""
   nombre de valeurs        =  %(i1)d
     %(r1)f, %(r2)f, ...
"""),

    8 : _(u"""
   nombre de pics extraits   =  %(i1)d
     %(r1)f, %(r2)f, ...
"""),

    9 : _(u"""
   nombre de cycles détectés =  %(i1)d
"""),

    10 : _(u"""
   %(i1)d  /  %(r1)f   %(r2)f
"""),

    11 : _(u"""
   dommage en ce point/composante  =  %(r1)f
"""),

    27 : _(u"""
 paramètres de calcul du dommage nombre de numéros d'ordre  =  %(i1)d
 nombre de points de calcul =  %(i2)d
"""),

    28 : _(u"""
 calcul     du      dommage en %(k1)s points  de   calcul  du    dommage %(k2)s
 composante(s) grandeur équivalente %(k3)s
 méthode  d'extraction  des    pics %(k4)s
 méthode  de  comptage  des  cycles %(k5)s
 méthode  de  calcul    du  dommage %(k6)s

"""),

    29 : _(u"""
 maille:  %(k1)s
"""),

    30 : _(u"""
 des mailles de peau ne s'appuient sur aucune maille support
    maille:  %(k1)s
"""),

    31 : _(u"""

     ===== GROUP_MA ASTER / PHYSICAL GMSH =====

"""),

    32 : _(u"""

  Le GROUP_MA GMSH GM10000 contient %(i1)d éléments :
"""),

    33 : _(u"""
       %(i1)d éléments de type %(k1)s
"""),

    34 : _(u"""
    La composante %(k1)s que vous avez renseignée ne fait pas partie
    des composantes du champ à imprimer.
"""),

    35 : _(u"""
    Le type de champ %(k1)s n'est pas autorisé avec les champs
    élémentaires %(k2)s.
    L'impression du champ sera effectué avec le type SCALAIRE.
"""),

    36 : _(u"""
 Veuillez utiliser IMPR_GENE pour l'impression
 de résultats en variables généralisées.
"""),




    38 : _(u"""
 Problème dans la lecture du fichier de maillage GMSH.
 Le fichier de maillage ne semble pas être un fichier de type GMSH :
 il manque la balise de début de fichier.
"""),

    39 : _(u"""
 <I> Depuis la version 2.2.0 de GMSH il est possible de lire et écrire le format MED.
     Conseil : Utilisez plutôt GMSH avec MED comme format d'entrée et de sortie.

"""),

    40 : _(u"""
 <I> Le ficher de maillage GMSH est au format version %(i1)d.
"""),

    41 : _(u"""
 Problème dans la lecture du fichier de maillage GMSH.
 Il manque la balise de fin de la liste de noeud.
"""),

    42 : _(u"""
 Problème dans la lecture du fichier de maillage GMSH.
 Il manque la balise de début de la liste des éléments.
"""),

    43 : _(u"""
 -> le nombre de mailles de votre maillage (%(i1)d) est supérieur
    à la limite de 9 999 999.
 -> Risque & Conseil : générez un fichier MED directement depuis GMSH.
"""),


    46 : _(u"""
 Le modèle %(k1)s ne contient aucun élément de joint ou d'interface.
 Conseil : veuillez revoir la définition de ce modèle
"""),

}
