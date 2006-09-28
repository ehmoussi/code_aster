#@ MODIF modelisa4 Messages  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
# -*- coding: iso-8859-1 -*-
#            CONFIGURATION MANAGEMENT OF EDF VERSION
# ======================================================================
# COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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

def _(x) : return x

cata_msg={

1: _("""
 arret sur erreurs
"""),

2: _("""
 type inconnu verifier le call a charci
"""),

3: _("""
 ddl inconnu
"""),

4: _("""
 melange de modelisations planes et volumiques (ou presence de sous-tructures statiques)
"""),

5: _("""
 mot-cle  %(k1)s  interdit en 2d
"""),

6: _("""
 - chckma phase de verification du maillage - presence de noeuds orphelins
"""),

7: _("""
 certains noeuds connectent plus de 200 mailles. ces mailles ne sont pas verifiees.
"""),

8: _("""
 - chckma phase de verification du maillage - presence de mailles doubles
"""),

9: _("""
 - chckma phase de verification du maillage - presence de mailles aplaties
"""),

10: _("""
 - chckma phase de verification du maillage - mailles degenerees
"""),

11: _("""
 probleme dans les entiers codes
"""),

12: _("""
 type de chgt de repere non prevu.
"""),

13: _("""
 seule la grandeur neut_f est traitee actuellement.
"""),

14: _("""
 les champs de cham_f et cham_para n'ont pas la meme discretisation noeu/cart/elga/elno/elem. 
"""),

15: _("""
 eval. carte: pas encore
"""),

16: _("""
 avec "noeud_cmp", il faut donner un nom et une composante.
"""),

17: _("""
 pour recuperer le champ de geometrie, il faut utiliser le mot cle maillage
"""),

18: _("""
 le mot-cle type_champ =  %(k1)s n'est pas coherent avec le type du champ extrait :  %(k2)s _ %(k3)s 
"""),

19: _("""
 on ne peut extraire qu'1 numero d'ordre. vous en avez specifie plusieurs.
"""),

20: _("""
 on est dans le cas d'un contact point-point et le vecteur vect_norm_escl n'a pas ete renseigne
"""),

21: _("""
 impossibilite, la maille  %(k1)s  doit etre une maille de peau de type "quad" ou "tria" car on est en 3d et elle est de type :  %(k2)s 
"""),

22: _("""
 impossibilite,  soit la maille  %(k1)s  doit etre une  maille de peau de type "seg" car on est  en 2d et elle est de type :  %(k2)s , soit il faut renseigner "vect_pou_z" en 3d
"""),

23: _("""
 impossibilite, la maille  %(k1)s  doit etre une maille de peau de type "seg" car on est en 2d et elle est de type :  %(k2)s 
"""),

24: _("""
 arret sur erreur(s), normale non sortante
"""),

25: _("""
  la liste : %(k1)s  a concatener avec la liste  %(k2)s  doit exister 
"""),

26: _("""
  on ne peut pas affecter la liste de longueur nulle %(k1)s  a la liste  %(k2)s  qui n'existe pas
"""),

27: _("""
 la concatenation de listes de type  %(k1)s  n'est pas encore prevue.
"""),

28: _("""
 <coefal> le numero de correlation et/ou le type de reseau passes dans le fichier de commande ne  sont pas coherents avec le fichier .70
"""),

29: _("""
 <coefam> le numero de correlation et/ou le type de reseau passes dans le fichier de commande ne  sont pas coherents avec le fichier .70
"""),

30: _("""
 <coefam> ce type de reseau n est pas encore implante dans le code
"""),

31: _("""
 <coefra> le numero de correlation et/ou le type de reseau passes dans le fichier de commande ne  sont pas coherents avec le fichier .71
"""),

32: _("""
 <coefra> ce type de reseau n est pas encore implante dans le code
"""),

33: _("""
 <coefrl> le numero de correlation et/ou le type de reseau passes dans le fichier de commande ne  sont pas coherents avec le fichier .71
"""),

34: _("""
 les ligrels a concatener ne referencent pas le meme maillage.
"""),

35: _("""
 jacobien negatif
"""),

36: _("""
 scal nul
"""),

37: _("""
 on essaie de creer ou d'agrandir le ligrel de charge avec un nombre de termes negatif ou nul
"""),

38: _("""
 depassement tableau (dvlp)
"""),

39: _("""
 probleme rencontre lors de l interpolation d une des deformees modales
"""),

40: _("""
 probleme rencontre lors de l interpolation d une des fonctions
"""),

41: _("""
 probleme dans le cas 3d ou les noeuds sont alignes, la distance separant 2 noeuds non-identiques de la liste est trop petite
"""),

42: _("""
 probleme dans le cas 3d ou les noeuds sont alignes et ou pourtant on arrive a trouver 3 noeuds formant un triangle de surface non-nulle
"""),

43: _("""
 incoherence car aucun noeud n'a de ddl drz et la routine traite le cas 2d ou il y a au-moins un ddl drz
"""),

44: _("""
 incoherence car aucun noeud n'a de ddl derotation drx et dry et drz et la routine traite le cas 3d ou il y a au-moins un noeud ayant ces 3 ddls
"""),

45: _("""
 erreur sur nmaco
"""),

46: _("""
 erreur sur nnoco
"""),

47: _("""
 erreur sur nnoqua
"""),

48: _("""
 aucun noeud n est affecte par liaison_unilaterale
"""),

49: _("""
 depassement capacite (dvlp)
"""),

50: _("""
 la maille :  %(k1)s  n'est pas affectee par un element fini.
"""),

51: _("""
 incoherence .flii pour ligrel  %(k1)s 
"""),

52: _("""
 mot cle inconnu (ni maille, ni group_ma
"""),

53: _("""
 le noeud d application de l excitation n est pas un noeud du maillage.
"""),

54: _("""
 le noeud d application de l excitation ne doit pas etre situe au bord du domaine de definition du maillage.
"""),

55: _("""
 la fenetre excitee deborde du domaine de definition du maillage.
"""),

56: _("""
 la demi-fenetre excitee en amont du noeud central d application n est pas definie.
"""),

57: _("""
 la demi-fenetre excitee en amont du noeud central d application deborde du domaine de definition du maillage.
"""),

58: _("""
 les demi-fenetres excitees en aval et en amont du noeud central d application ne sont pas raccordees.
"""),

59: _("""
 la demi-fenetre excitee en aval du noeud central d application n est pas definie.
"""),

60: _("""
 la demi-fenetre excitee en aval du noeud central d application deborde du domaine de definition du maillage.
"""),

61: _("""
 les fonctions interpretees doivent etre tabulees auparavant 
"""),

62: _("""
 nappe interdite pour definir le flux
"""),

63: _("""
  on deborde a gauche
"""),

64: _("""
 prolongement gauche inconnu
"""),

65: _("""
  on deborde a droite
"""),

66: _("""
 prolongement droite inconnu
"""),

67: _("""
  on est en dehors des bornes
"""),

68: _("""
 les mailles de type  %(k1)s ne sont pas traitees pour la selection des noeuds
"""),

69: _("""
 on ne sait plus trouver de noms.
"""),

70: _("""
 erreur : deux noeuds du cable sont confondus on ne peut pas definir le cylindre.
"""),

71: _("""
 immersion du cable no %(k1)s  dans la structure beton : le noeud  %(k2)s  se trouve a l'exterieur de la structure
"""),

72: _("""
 maille degeneree
"""),

73: _("""
 .nommai du maillage inexistant :  %(k1)s 
"""),

74: _("""
 .groupema du maillage inexistant :  %(k1)s 
"""),

75: _("""
  le determinant de la matrice a inverser est nul
"""),

76: _("""
 le vecteur normal est dans le plan tangent
"""),

77: _("""
  %(k1)s  mot cle lu " %(k2)s " incompatible avec " %(k3)s "
"""),

78: _("""
 lecture 1 :erreur de lecture pour %(k1)s 
"""),

79: _("""
 lecture 1 :item > 24 car  %(k1)s 
"""),

80: _("""
  %(k1)s  le groupe  %(k2)s  est vide
"""),

81: _("""
  %(k1)s  erreur de syntaxe : mot cle " %(k2)s " non reconnu
"""),

82: _("""
  %(k1)s  mot cle " %(k2)s " ignore
"""),

83: _("""
 le ligret  %(k1)s  n"existe pas.
"""),

84: _("""
 erreur sur ipma
"""),

85: _("""
 erreur sur ipno
"""),

86: _("""
 erreur sur ipnoqu
"""),

87: _("""
 mauvaise sortie de palima
"""),

88: _("""
 pb lecture courbe de wohler
"""),

89: _("""
 mot cle wohler non trouve
"""),

90: _("""
 pb lecture courbe de manson_coffin
"""),

91: _("""
 mot cle manson_coffin non trouve
"""),

92: _("""
 lecture 1 : ligne lue trop longue : %(k1)s 
"""),

93: _("""
  %(k1)s  il manque le mot fin !??!
"""),

94: _("""
 lecture 1 : erreur de syntaxe detectee
"""),

95: _("""
 inom a une valeur inattendue :  %(k1)s 
"""),

96: _("""
 "nblige=" nb lignes entete
"""),

97: _("""
 le nom du groupe  %(k1)s  est tronque a 8 caracteres
"""),

98: _("""
 il faut un nom apres "nom="
"""),

99: _("""
 lirtet: sortie anormale
"""),
}
