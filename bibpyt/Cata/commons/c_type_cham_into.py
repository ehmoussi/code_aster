# coding=utf-8

from Cata.Syntax import *
from Cata.DataStructure import *
from Cata.Commons import *

# ======================================================================
# COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
# THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
# IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
# THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
# (AT YOUR OPTION) ANY LATER VERSION.
#
# THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
# WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
# GENERAL PUBLIC LICENSE FOR MORE DETAILS.
#
# YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
# ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
#    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
# ======================================================================
# person_in_charge: gerald.nicolas at edf.fr
#
# ce fichier contient la liste des "into" possibles pour le mot cle TYPE_CHAM
def C_TYPE_CHAM_INTO( type_cham=None ) : #COMMUN#
# Si aucun argument n'est passe, on utilise tous les types de champs possibles
  if ( type_cham is None ) :
    l_cham = ["ELEM", "ELNO", "ELGA", "CART", "NOEU"]
# Sinon, on n'utilise que les types passes en argument
  else :
    l_cham = []
    for typ in type_cham :
      l_cham.append(typ)

  l = []
  for gd in C_NOM_GRANDEUR() :
    if gd != "VARI_R" :
       for typ in l_cham :
          l.append(typ+"_"+gd)
    else :
       # il ne peut pas exister NOEU_VARI_R ni CART_VARI_R (il faut utiliser VAR2_R):
       for typ in l_cham :
          if typ not in ("CART", "NOEU") :
             l.append(typ+"_"+gd)

  return tuple(l)
