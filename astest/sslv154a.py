import numpy

def lissGchap(TAB_G, absc='ABSC_CURV', val='G'):
  # Seulement pour des maillages quadratiques et fissure debouchante
  # Cf CR-I20-2010-11
  resu = TAB_G.EXTR_TABLE().values()
  valG = numpy.array(resu[val])
  valAbsCurv = numpy.array(resu[absc])
  valOrdre = numpy.array(resu['NUME_ORDRE'])
  res = -numpy.ones(valG.shape) # initialisation a -1.
  for c, ordre in enumerate(numpy.unique(valOrdre)):
    rtr  = valOrdre == ordre
    le   = numpy.abs(valAbsCurv[rtr][2::2]-valAbsCurv[rtr][:-2:2])
    lg  = 2.*le[:-1]/(le[:-1]+le[1:])
    ld  = 2.*le[1:]/(le[:-1]+le[1:])
    GchapGauche = (valG[rtr][0]+valG[rtr][1]*2.)/3.
    GchapDroite = (valG[rtr][-2]+valG[rtr][-1]*2.)/3.
    GchapMilieu = (lg*valG[rtr][1:-3:2]+ld*valG[rtr][3:-1:2]+valG[rtr][2:-2:2])/3.
    Gchap = numpy.concatenate([[GchapGauche],GchapMilieu,[GchapDroite]])
    # on choisit ici de calculer Gchap aux noeuds sommet et d'interpoler
    # lineairement les valeurs aux noeuds milieux pour conserver le
    # nombre de points en fond de fissure
    res[rtr] = numpy.interp(valAbsCurv[rtr],valAbsCurv[rtr][::2],Gchap)
  return(list(res))

def lissGbar(TAB_G, absc='ABSC_CURV', val='G'):
  # Seulement pour des maillages quadratiques et fissure debouchante
  # Cf CR-I20-2010-11
  resu = TAB_G.EXTR_TABLE().values()
  valG = numpy.array(resu[val])
  valAbsCurv = numpy.array(resu[absc])
  valOrdre = numpy.array(resu['NUME_ORDRE'])
  res = -numpy.ones(valG.shape) # initialisation a -1.
  for c, ordre in enumerate(numpy.unique(valOrdre)):
    rtr  = valOrdre == ordre
    Gbar = valG[rtr][:-2:2]/6. + valG[rtr][2::2]/6. + valG[rtr][1:-1:2]*2./3.
    abscToInterp = numpy.concatenate([[valAbsCurv[rtr][0]],valAbsCurv[rtr][1:-1:2],[valAbsCurv[rtr][-1]]])
    valeToInterp = numpy.concatenate([[Gbar[0]],Gbar,[Gbar[-1]]])
    # on choisit ici de calculer Gbar par element et d'affecter cette valeur
    # aux noeuds milieu. On interpole ensuite lineairement les valeurs
    # aux noeuds sommet pour conserver le nombre de points en fond de fissure
    res[rtr] = numpy.interp(valAbsCurv[rtr], abscToInterp, valeToInterp)
  return(list(res))



##Dans le fichier de commande aster avec DEBUT(PAR_LOT='NON') : 

#from sslv154a import lissGchap, lissGbar
#CG=CALC_TABLE(TABLE=CG,
            #reuse=CG,
            #ACTION=(
                    #_F(OPERATION = 'AJOUT_COLONNE',NOM_PARA = 'G_BAR', VALE_COLONNE =  lissGbar(CG)),
                    #_F(OPERATION = 'AJOUT_COLONNE',NOM_PARA = 'K1_CHAP',VALE_COLONNE = lissGchap(CG, val='K1')),
                    #_F(OPERATION = 'AJOUT_COLONNE',NOM_PARA = 'K1_BAR', VALE_COLONNE = lissGbar(CG,  val='K1')),
                    #_F(OPERATION = 'AJOUT_COLONNE',NOM_PARA = 'K2_CHAP',VALE_COLONNE = lissGchap(CG, val='K2')),
                    #_F(OPERATION = 'AJOUT_COLONNE',NOM_PARA = 'K2_BAR', VALE_COLONNE = lissGbar(CG,  val='K2')),
                    #_F(OPERATION = 'AJOUT_COLONNE',NOM_PARA = 'K3_CHAP',VALE_COLONNE = lissGchap(CG, val='K3')),
                    #_F(OPERATION = 'AJOUT_COLONNE',NOM_PARA = 'K3_BAR', VALE_COLONNE = lissGbar(CG,  val='K3')),
                    #)
            #)
