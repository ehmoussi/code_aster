# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

from ..Utilities import _

cata_msg = {

    1 : _("""
 L'utilisation du mot-clé PAR_LOT='NON' permet d'accéder en lecture et en écriture
 au contenu des concepts Aster. De ce fait, votre étude est exclue du périmètre
 qualifié de Code_Aster puisque toutes ses étapes ne peuvent être certifiées.

 Conseils :
   - Il n'y a pas particulièrement de risque de résultat faux... sauf si votre
     programmation l'introduit.
   - Distinguez le calcul lui-même (qui doit sans doute passer en PAR_LOT='OUI')
     des post-traitements (qui nécessiteraient le mode PAR_LOT='NON') qui peuvent
     être réalisés en POURSUITE.
"""),

    2 : _("""
Les commandes DEBUT et POURSUITE doivent être appelées une fois et une seule.
"""),

    3: _("""
  Erreur programmeur : %(k1)s non appariés.
"""),

    8: _("""
  Un nom de concept intermédiaire doit commencer par '.' ou '_' et non :  %(k1)s
"""),

    9: _("""
Fonctionnalité obsolète : %(k1)s

La fonctionnalité mentionnée ci-dessus est obsolète et son utilisation
est déconseillée dans la version du code que vous utilisez.
Elle sera supprimée dans la version %(i1)d.

Conseils :
- pour assurer la pérennité de votre étude, modifiez votre fichier de commandes ;
- si vous avez un besoin impérieux de cette fonctionnalité,
  rapprochez-vous de votre correspondant Club utilisateur ou de l'équipe de développement.

"""),

    12: _("""
  Exécution de JEVEUX en mode DEBUG
"""),

    13: _("""
  %(k1)s  nom de base déjà définie
"""),

    14: _("""
  %(k1)s  statut impossible pour la base globale
"""),

    15: _("""
  Problème d'allocation des bases de données
"""),

    16: _("""
  Écriture des catalogues des éléments faite.
"""),

    17: _("""
  Relecture des catalogues des éléments faite.
"""),

    18: _("""
  Trop de catalogues (maximum = 10)
"""),

    20: _("""
  "%(k1)s" argument invalide du mot clé "FICHIER" du mot clé facteur "CATALOGUE"
"""),

    21: _("""
  Erreur(s) fatale(s) lors de la lecture des catalogues
"""),

    22 : { 'message' : _("""
   Les mots-clés facteurs CODE et DEBUG dans DEBUT/POURSUITE sont réservés aux cas-tests.
   Il ne faut pas les utiliser dans les études car ils modifient certaines valeurs par
   défaut des commandes DEBUT/POURSUITE qui ont des conséquences sur le comportement
   en cas d'erreur ou sur les performances.
"""), 'flags' : 'DECORATED',
           },

    23: _("""
  Débogage JXVERI demandé
"""),

    24: _("""
  Débogage SDVERI demandé
"""),

    31: _("""
 Valeur invalide pour le mot clé RESERVE_CPU
"""),

    32: _("""
 La procédure "%(k1)s" ne peut être appelée en cours d'exécution des commandes
"""),

    38: _("""
 Il n'y a plus de temps pour continuer
"""),

    39: _("""
Arrêt de l'exécution suite à la réception du signal utilisateur %(k1)s.
Fermeture des bases jeveux afin de permettre la POURSUITE ultérieure du calcul.
"""),

    40: _("""
 Vous utilisez une version dont les routines suivantes ont été surchargées :
   %(ktout)s
"""),

    41: { 'message' : _("""La version %(k1)s a été modifiée par %(i1)d révisions.
"""), 'flags' : 'DECORATED',
       },

    42: _("""Les fichiers suivants ont été modifiés par rapport à la dernière révision %(k1)s :

%(k2)s
"""),

    43: _("""
  Débogage %(k1)s suspendu
"""),

    44: _("""
  Débogage %(k1)s demandé
"""),

    50: _("""
 La commande a un numéro non appelable dans cette version.
 Le numéro erroné est  %(i1)d
"""),

    52: _("""
  Fin de lecture (durée  %(r1)f  s.) %(k1)s
"""),

    56: _("""
  Incohérence entre le catalogue et le corps de la macro-commande.
"""),

    60: _("""
  La procédure a un numéro non appelable dans cette version.
  Le numéro erroné est %(i1)d.
"""),

    61: _("""
  La commande a un numéro non appelable dans cette version
  Le numéro erroné est : %(i1)d
"""),

    63: _("""
     ARRET PAR MANQUE DE TEMPS CPU
     Les commandes suivantes sont ignorées, on passe directement dans FIN
     La base globale est sauvegardée
     Temps consommé de la réserve CPU        :  %(r1).2f s\n
"""),

    64: _("""
  Valeur initiale du temps CPU maximum =   %(i1)d secondes
  Valeur du temps CPU maximum passé aux commandes =   %(i2)d secondes
  Réserve CPU prévue = %(i3)d secondes
"""),

    81: _("""
 %(k1)s nom symbolique inconnu
  - nombre de valeurs attendues %(i1)d
  - valeurs attendues : %(k1)s, %(k2)s,...
"""),

    82: _("""
 L'argument du mot clé "CAS" est erroné.
 Valeur lue %(k1)s
 nombre de valeurs attendues %(i1)d
 valeurs attendues : %(k1)s,%(k2)s, ...
"""),

    83: _("""

 Le nombre d'enregistrements (NMAX_ENRE) et leurs longueurs (LONG_ENRE) conduisent à un
 fichier dont la taille maximale en Mo (%(i1)d) est supérieure à limite autorisée :  %(i2)d

 Vous pouvez augmenter cette limite en utilisant l'argument "-max_base" sur la ligne
 de commande suivi d'une valeur en Mo.

"""),

    96 : { 'message' : _("""

    Réception du signal USR1. Interruption du calcul demandée...

"""), 'flags' : 'DECORATED',
           },

    97 : { 'message' : _("""

    Interruption du calcul suite à la réception d'un <Control-C>.

"""), 'flags' : 'DECORATED',
           },

    # Texte en majuscule car utilisé tel quel pour le diagnostic
    98 : _("""

    <S> ARRET PAR MANQUE DE TEMPS

    """),

    99 : _("""Une erreur s'est produite."""),

}
