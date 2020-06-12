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

import os
from math import ceil, floor, log, pi, sqrt, tanh

import numpy as NP
from numpy import linalg

import aster
import aster_core
from ...Objects.table_py import Table
from ...Messages import UTMESS

from ...Cata.Syntax import _F
from ...Commands import (COMB_MATR_ASSE, CREA_CHAMP, DETRUIRE, DYNA_VIBRA,
                         LIRE_FORC_MISS, LIRE_IMPE_MISS)
from ..Utils.signal_correlation_utils import (CALC_COHE, calc_dist2,
                                              get_group_nom_coord)


def force_iss_vari(self,imod,MATR_GENE,NOM_CMP,ISSF,INFO,UNITE_RESU_FORC,
         UNITE_RESU_IMPE,PRECISION,INTERF,MATR_COHE,TYPE,fini,PAS,fmax):
    """Force sismique variable en ISS"""
    #--------------------------------------------------------------------------------
    NB_FREQ = 1+int((fmax-fini)/PAS)
    FREQ_INIT = fini
    GROUP_NO_INTER = INTERF['GROUP_NO_INTERF']
    # MAILLAGE NUME_DDL
    resultat = MATR_GENE['BASE']
    n_resultat = resultat.getName()
    nume_ddl = resultat.getDOFNumbering()
    nom_mail = nume_ddl.getMesh().getName()
    # MODELE, DDLGENE

    nume_ddlgene = MATR_GENE['NUME_DDL_GENE']


    _, noe_interf = get_group_nom_coord(
                     GROUP_NO_INTER, nom_mail)

 #   del nume_ddl, nom_mail, nom_modele
       # MODES
    _,nbmodd,_=aster.dismoi('NB_MODES_DYN', n_resultat,'RESULTAT','F')
    _,nbmods,_=aster.dismoi('NB_MODES_STA', n_resultat,'RESULTAT','F')
    _,nbmodt,_=aster.dismoi('NB_MODES_TOT',n_resultat,'RESULTAT','F')
    FSIST = NP.zeros((NB_FREQ,nbmodt))+0j
    nbno, _ = noe_interf.shape


    if INFO==2:
       texte = 'NOMBRE DE MODES: '+str(nbmodt)+'   MODES DYNAMIQUES: '+str(nbmodd)+'   MODES STATIQUES: '+str(nbmods)
       aster.affiche('MESSAGE',texte)
       aster.affiche('MESSAGE','COMPOSANTE '+NOM_CMP)
       aster.affiche('MESSAGE','NBNO INTERFACE : '+str(nbno))

    # ----- boucle sur les modes statiques
    for mods in range(0,nbmods):
       nmo = nbmodd+mods+1
       __CHAM=CREA_CHAMP( TYPE_CHAM='NOEU_DEPL_R',
             OPERATION = 'EXTR',
             NUME_ORDRE = nmo,
             RESULTAT = resultat  ,
             NOM_CHAM = 'DEPL'
               )
       MCMP2 = __CHAM.EXTR_COMP(' ',[GROUP_NO_INTER],0).valeurs
       if mods == 0:
           NCMP2 =__CHAM.EXTR_COMP(' ',[GROUP_NO_INTER], topo=1).comp
           nddi = len(MCMP2)
           PHI = NP.zeros((nddi,nbmods))
       PHI[:,mods]=MCMP2
    PHIT=NP.transpose(PHI)
    PPHI=NP.dot(PHIT, PHI)

     # MODEL fonction de cohérence
    MODEL = MATR_COHE['TYPE']
    print('MODEL :',   MODEL)
    Data_Cohe = {}
    Data_Cohe['TYPE'] = MODEL
    Data_Cohe['MAILLAGE'] = nom_mail
    Data_Cohe['GROUP_NO_INTERF'] = GROUP_NO_INTER
    Data_Cohe['NOEUDS_INTERF'] = noe_interf
    Data_Cohe['DIST'] = calc_dist2(noe_interf)
    if MODEL == 'MITA_LUCO':
        Data_Cohe['VITE_ONDE'] = MATR_COHE['VITE_ONDE']
        Data_Cohe['PARA_ALPHA'] = MATR_COHE['PARA_ALPHA']
     #---------------------------------------------------------------------
       # BOUCLE SUR LES FREQUENCES
    for k in range(NB_FREQ):
      freqk=FREQ_INIT+PAS*k
      if INFO==2:
          aster.affiche('MESSAGE','FREQUENCE DE CALCUL: '+str(freqk))
      COHE = CALC_COHE(freqk*2.*pi, **Data_Cohe)


       #---------------------------------------------------------
       # On desactive temporairement les FPE qui pourraient etre generees (a tord!) par blas
      aster_core.matfpe(-1)
      eig, vec =linalg.eig(COHE)
      vec = NP.transpose(vec)   # les vecteurs sont en colonne dans numpy
      aster_core.matfpe(1)
      eig=eig.real
      vec=vec.real
      # on rearrange selon un ordre decroissant
      eig = NP.where(eig < 1.E-10, 0.0, eig)
      order = (NP.argsort(eig)[::-1])
      eig = NP.take(eig, order)
      vec = NP.take(vec, order, 0)
      #-----------------------
      # Nombre de modes POD a retenir
      etot=NP.sum(eig**2)
      ener=0.0
      nbme=0
      while nbme < nbno:
         ener= eig[nbme]**2+ener
         prec=ener/etot
         nbme=nbme+1
         if INFO==2:
            aster.affiche('MESSAGE','VALEUR PROPRE  '+str(nbme)+' : '+str(eig[nbme-1]))
         if prec > PRECISION :
            break
      if INFO==2:
         aster.affiche('MESSAGE','NOMBRE DE MODES POD RETENUS : '+str(nbme))
         aster.affiche('MESSAGE','PRECISION (ENERGIE RETENUE) : '+str(prec))
      PVEC=NP.zeros((nbme,nbno))
      for k1 in range(0,nbme):
         PVEC[k1, 0:nbno] = NP.sqrt(eig[k1])*vec[k1]



        #----Impedances + force sismique.-----------------------------------------------------------------
      if k>0:
         DETRUIRE(CONCEPT=_F(NOM=(__impe,__fosi)),INFO=1)

      __impe = LIRE_IMPE_MISS(BASE=resultat,
                                TYPE=TYPE,
                                NUME_DDL_GENE=nume_ddlgene,
                                UNITE_RESU_IMPE= UNITE_RESU_IMPE,
                                ISSF=ISSF,
                                FREQ_EXTR=freqk,
                                )
           #    on cree __fosi  pour  RECU_VECT_GENE_C   plus loin

      __fosi = LIRE_FORC_MISS(BASE=resultat,
                                NUME_DDL_GENE=nume_ddlgene,
                                NOM_CMP=NOM_CMP,
                                NOM_CHAM='DEPL',
                                UNITE_RESU_FORC = UNITE_RESU_FORC,
                                ISSF=ISSF,
                                FREQ_EXTR=freqk,)


      # -------------- impedance--------------------------------
      MIMPE=__impe.EXTR_MATR_GENE()
      #  extraction de la partie modes interface
      KRS = MIMPE[nbmodd:nbmodt,nbmodd:nbmodt]

     # -------------- force sismique-------------------------------
      FSISM = __fosi.EXTR_VECT_GENE_C()
      FS0 = FSISM[nbmodd:nbmodt][:]    #  extraction de la partie modes interface
      U0 = NP.dot(linalg.inv(KRS), FS0)
      # projection pour obtenir UO en base physique
      XI = NP.dot(PHI, U0)
      XPI = XI
#      # facteur de correction pour tous les modes (on somme) >> c'est faux
      SI0 = 0.0
      for k1 in range(0, nbme):
          XOe = abs(NP.sum(PVEC[k1])) / nbno
          SI0 = SI0 + XOe**2
      SI = sqrt(SI0)
      for idd in range(0,nddi):#nddi: nombre de ddl interface
          if NCMP2[idd][0:2] == NOM_CMP:
              XPI[idd] = SI * XI[idd]
      # retour en base modale
      QPI = NP.dot(PHIT, XPI)
      U0 = NP.dot(linalg.inv(PPHI), QPI)
      FS = NP.dot(KRS, U0)
      FSISM[nbmodd:nbmodt][:] =FS
      FSIST[k,nbmods:nbmodt] = FSISM[0:nbmodd][:]
      FSIST[k,0:nbmods] = FS

    return FSIST
