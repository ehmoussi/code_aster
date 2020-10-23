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

import aster
from math import sqrt, pi
from ..Messages import UTMESS
from ..Cata.Syntax import _F
from ..Commands import (CREA_CHAMP, CALC_CHAM_ELEM, CREA_TABLE,
                        POST_ELEM, FORMULE, 
                        MODI_MAILLAGE, DEFI_CONSTANTE,
                        COPIER, DETRUIRE,CREA_RESU)

# ===========================================================================
#           CORPS DE LA MACRO "POST_ROCHE"
#           ------------------------------
# USAGE :
#
# ===========================================================================

def post_roche_ops(self, **kwargs):
    """
       Macro POST_ROCHE
    """

    PRCommon = PostRocheCommon(**kwargs)
    PRCommon.getInfos()
    PRCommon.checkZones()
    PRCommon.getCoudeValues()
    PRCommon.buildPression()
    PRCommon.classification()
    PRCommon.materAndBeamParams()
    PRCommon.calcGeomParams()
    PRCommon.sismInerTran()
    PRCommon.createFonctionsFields()
    
    for i, nume in enumerate(PRCommon.listNumeTran):
        numeOrdre = -1
        if PRCommon.mcf == 'RESU_MECA_TRAN':
            PRCommon.extrInstInerTran(nume)
            numeOrdre = i+1
            UTMESS('I','POSTROCHE_11',vali=[numeOrdre,len(PRCommon.listNumeTran)])
            
    
        PRCommon.combinaisons()

        # calcul sur les moments de déplacement (m)
        calcul = PostRocheCalc(PRCommon, PRCommon.m, numeOrdre)
        calcul.contraintesRef()
        calcul.epsiMp()
        calcul.reversibilite_locale()
        calcul.reversibilite_totale()
        calcul.effet_ressort()
        calcul.contrainteVraie()
        calcul.veriContrainte()
        calcul.coef_abattement()
        calcul.buildOutput()
        
        # calcul sur les moments de séisme inertiel dyn (msi)
        calculS2 = PostRocheCalc(PRCommon, PRCommon.msi, numeOrdre)
        calculS2.contraintesRef()
        calculS2.epsiMp()
        calculS2.reversibilite_locale()
        calculS2.reversibilite_totale()
        calculS2.effet_ressort()
        calculS2.contrainteVraie()
        calculS2.veriContrainte()
        calculS2.coef_abattement()
        calculS2.buildOutput()
    
    
        PRCommon.calcContrainteEquiv(calcul.chOutput, calculS2.chOutput)
        PRCommon.calcContrainteEquiv(calcul.chOutput, calculS2.chOutput, opt=True)
        
        chOutPutComplet = PRCommon.buildOutput(calcul.chOutput, calculS2.chOutput)
    
        # IMPR_RESU(UNITE=6, FORMAT='RESULTAT', RESU=_F(CHAM_GD=PRCommon.chUtil1, MAILLE='M1'))
        # IMPR_RESU(UNITE=6, FORMAT='RESULTAT', RESU=_F(CHAM_GD=PRCommon.chUtil1Opt, MAILLE='M1'))
        
        
        if PRCommon.mcf == 'RESU_MECA_TRAN':
            if i==0:
                resuOut = CREA_RESU(TYPE_RESU = "EVOL_NOLI", OPERATION ="AFFE", NOM_CHAM='UT01_ELNO',
                                    AFFE= _F(CHAM_GD = chOutPutComplet,
                                    INST =nume,),
                                   )
            else:
                resuOut = CREA_RESU(TYPE_RESU = "EVOL_NOLI", OPERATION ="AFFE", NOM_CHAM='UT01_ELNO',
                                    reuse=resuOut, RESULTAT=resuOut,
                                    AFFE= _F(CHAM_GD = chOutPutComplet,
                                    INST =nume,),
                                   )
                # DETRUIRE(CONCEPT=_F(NOM=chOutPutComplet))
                del chOutPutComplet
        else:
            return chOutPutComplet
            
    # pour RESU_MECA_TRAN : calcul des maximums
    
    chMax= CREA_CHAMP (OPERATION = 'EXTR',
                       TYPE_CHAM = 'ELNO_NEUT_R',
                       RESULTAT  = resuOut, 
                       NOM_CHAM  = 'UT01_ELNO',
                       TYPE_MAXI = 'MAXI',
                       TOUT_ORDRE='OUI',)
    
    resuOut = CREA_RESU(TYPE_RESU = "EVOL_NOLI", OPERATION ="AFFE", NOM_CHAM='UT02_ELNO',
                                    reuse=resuOut, RESULTAT=resuOut,
                                    AFFE= _F(CHAM_GD = chMax,
                                    INST =0.,),
                                   )
    return resuOut

class PostRocheCommon():

    def __init__(self, **kwargs):
        """
        
        """
        # GeneralKeys
        self.args = kwargs

        # - RESU_MECA ou RESU_MECA_TRAN ---

        dResuMeca = []
        if kwargs.get('RESU_MECA'):
            self.mcf = 'RESU_MECA'
            for j in kwargs.get('RESU_MECA'):
                dResuMeca.append(j.cree_dict_valeurs(j.mc_liste))
        else:
            self.mcf = 'RESU_MECA_TRAN'
            for j in kwargs.get('RESU_MECA_TRAN'):
                dResuMeca.append(j.cree_dict_valeurs(j.mc_liste))
        
        self.dResuMeca = dResuMeca
        
        # zone analysee

        dZone = []
        for j in kwargs.get('ZONE_ANALYSE'):
            dZone.append(j.cree_dict_valeurs(j.mc_liste))
        self.dZone = dZone
        
        # coude
        
        dCoude = []
        if kwargs.get('COUDE'):
            for j in kwargs.get('COUDE'):
                dCoude.append(j.cree_dict_valeurs(j.mc_liste))
        self.dCoude = dCoude
        
        # pressions
        
        dPression = []
        if kwargs.get('PRESSION'):
            for j in kwargs.get('PRESSION'):
                dPression.append(j.cree_dict_valeurs(j.mc_liste))
        self.dPression = dPression
        
        # Autres paramètres
        self.l_mc_inst  = ['NUME_ORDRE', 'INST', 'PRECISION', 'CRITERE']
        self.l_mc_inst2 = ['TOUT_ORDRE','NUME_ORDRE', 'INST']
        self.l_mc_inst3 = ['PRECISION', 'CRITERE']
        self.dirDisp    = ['X' , 'Y' , 'Z' , 'COMBI']
        self.listCmp    = ['MT', 'MFY', 'MFZ']
        
        self.permanentLoadsTypes = ['POIDS', 'DILAT_THERM']
        self.nbIterMax = 30
        self.seuilSigRef = 1e-6
       
    def getInfos(self,):
        """
            Récupération du modèle
            Récupération des caracteristiques de poutre
            Récupération du champ de matériau
        """ 

        if self.args.get('MODELE'):
            self.model = self.args.get('MODELE')
        else:
            if self.dResuMeca[0].get('RESULTAT'):
                resin = self.dResuMeca[0]['RESULTAT']
            else:
                resin = self.dResuMeca[0]['CHAM_GD']

            self.model  = resin.getModel()
            # la méthode ne renvoie rien pour les résultats COMB_SISM_MODAL
            if self.model is None:
                UTMESS('F','POSTROCHE_4')
        self.mailla = self.model.getMesh()
        self.modelName = self.model.getName()
        
        if self.args.get('CARA_ELEM'):
            self.caraelem = self.args.get('CARA_ELEM')
            self.caraelemName = self.caraelem.getName()
        else:
            self.caraelem = None
        
        if self.args.get('CHAM_MATER'):
            self.chammater = self.args.get('CHAM_MATER')
            self.chammaterName = self.chammater.getName()
        else:
            self.chammater = None
    
    def checkZones(self,):
        """
            On vérifie que les zones déclarées sont bien des lignes continues
        """ 
        
        # boucle sur les tronçon (=Zones)
        dicAllZones = {}
        lgrma = []
        for zone in self.dZone:

            dicAbscCurv = {'GROUP_NO_ORIG'  : zone.get('GROUP_NO_ORIG'),}
            
            if zone.get('TOUT'):
                dicAbscCurv['TOUT'] = 'OUI'
                dicAllZones['TOUT'] = 'OUI'
            else:
                dicAbscCurv['GROUP_MA'] = zone.get('GROUP_MA')
                lgrma.extend(zone.get('GROUP_MA'))
        
            # copie du maillage car un occurrence max acceptée
            maTemp = COPIER(CONCEPT=self.mailla)
            MODI_MAILLAGE(MAILLAGE=maTemp,ABSC_CURV=dicAbscCurv)
            # DETRUIRE(CONCEPT=_F(NOM=maTemp))
            del maTemp
            
        if dicAllZones == {}:
            dicAllZones['GROUP_MA'] = lgrma
        
        self.dicAllZones = dicAllZones
        
    def getCoudeValues(self,):
        """
        Construction d'un champ ELNO_NEUT_R contenant les angles 
        et les rayon de courbures pour les coudes
        """
        
        affe  = []
        lGrmaCoude = []
        
        for fact in self.dCoude:

            dicAffe = {'NOM_CMP'  : ('X1','X2','X3'),}
            dicAffe['GROUP_MA'] = fact.get('GROUP_MA')
            dicAffe['VALE'] = (fact.get('ANGLE')*pi/180,fact.get('RCOURB'), fact.get('SY'))
            affe.append(dicAffe)
            lGrmaCoude.extend(fact.get('GROUP_MA'))
        
        if affe == []:
            dicAffe = {'NOM_CMP'  : 'X1',}
            dicAffe['TOUT'] = 'OUI'
            dicAffe['VALE'] = 0.
            affe.append(dicAffe)
        
        chCoude = CREA_CHAMP(OPERATION='AFFE',
                                 TYPE_CHAM='ELNO_NEUT_R',
                                 MODELE=self.model,
                                 PROL_ZERO='OUI',
                                 AFFE= affe)
        self.chCoude  = chCoude
        self.lGrmaCoude = list(set(lGrmaCoude))
    
    def buildPression(self):
        """
        Construction d'un champ de pression ELNO_NEUT_R
        """
        
        affe  = []
        
        for fact in self.dPression:

            dicAffe = {'NOM_CMP'  : 'X1',}
            
            if fact.get('TOUT'):
                dicAffe['TOUT'] = 'OUI'
            else:
                dicAffe['GROUP_MA'] = fact.get('GROUP_MA')

            dicAffe['VALE'] = fact.get('VALE')
            affe.append(dicAffe)
        
        if affe == []:
            dicAffe = {'NOM_CMP'  : 'X1',}
            dicAffe['TOUT'] = 'OUI'
            dicAffe['VALE'] = 0.
            affe.append(dicAffe)
        
        chPression = CREA_CHAMP(OPERATION='AFFE',
                                 TYPE_CHAM='ELNO_NEUT_R',
                                 MODELE=self.model,
                                 PROL_ZERO='OUI',
                                 AFFE= affe)
        self.chPression  = chPression 
    
    def materAndBeamParams(self):
        """
        Récupération des paramètres matériau et des caractéristiques
        de poutre au bon format
        """
        
        # try except en attendant de pouvoir vérifier les modélisations
        # par une méthode de la class model
        try:
            chRochElno = CALC_CHAM_ELEM(OPTION= 'ROCH_ELNO',
                                         MODELE=self.model, 
                                         CHAM_MATER=self.chammater,
                                         CARA_ELEM=self.caraelem,
                                         **self.dicAllZones)
        except:
            UTMESS('F','POSTROCHE_10')
            
        
        self.chRochElno = chRochElno
        
    
    def calcGeomParams(self):
        """
        Calcul des paramètres B2,Z et D1, D21 D22 D23 dans un champ ELNO_NEUT_R
        """
        
        # X1 = Pression
        # X2 = Angle
        # X3 = Rayon de courbure
        # X4 = Sy = (Rp_0,2)_min
        
        chUtil= CREA_CHAMP(OPERATION = 'ASSE',
                                MODELE=self.model,
                                TYPE_CHAM = 'ELNO_NEUT_R',
                                PROL_ZERO = 'OUI',
                                ASSE      = (_F(CHAM_GD = self.chPression,
                                               TOUT = 'OUI',
                                               NOM_CMP = ('X1',),
                                               ),
                                             _F(CHAM_GD = self.chCoude,
                                               TOUT = 'OUI',
                                               NOM_CMP = ('X1','X2','X3'),
                                               NOM_CMP_RESU = ('X2','X3','X4'),
                                               ),
                                             )
                               )
        
        fB2_droit = DEFI_CONSTANTE(VALE=1.)
        flambda = FORMULE(NOM_PARA=('R', 'EP','X3'),VALE='EP*X3/(R-EP/2)**2') # noté f dans RB 3680
        fB2_coude = FORMULE(NOM_PARA=('R','EP','X3'),VALE='1.3/flambda(R,EP,X3)**(2./3)', flambda=flambda)

        fZ = FORMULE(NOM_PARA=('I', 'R','I2','R2'), VALE='min(I/R,I2/R2)')
        # fZ = FORMULE(NOM_PARA=('I', 'R'), VALE='I/R')
        
        fD1_droit = DEFI_CONSTANTE(VALE=0.)
        fD1_coude = DEFI_CONSTANTE(VALE=0.87)
        
        # D21
        fD21 = DEFI_CONSTANTE(VALE=0.712)
        
        # D22, D23
        
        fD22_droit = FORMULE(NOM_PARA=('R', 'EP','R2','EP2'),VALE='0.429*pow(2*max(R/EP,R2/EP2),0.16)')
        # fD22_droit = FORMULE(NOM_PARA=('R', 'EP',),VALE='0.429*pow(2*R/EP,0.16)')
        
        fpourD2X = FORMULE(NOM_PARA=('R', 'EP','X1','X3','X4'),VALE='1.0+0.142*(X1*(2*(R-EP))/(2*EP*X4*flambda(R,EP,X3)**1.45))',
                   flambda=flambda)
        
        
        fD22_coude = FORMULE(NOM_PARA=('R', 'EP','X1','X2','X3','X4'),
                             VALE='max(1.07*pow(pi/X2,-0.4)/flambda(R,EP,X3)**(2./3)/fpourD2X(R,EP,X1,X3,X4),1.02)',
                                   fpourD2X=fpourD2X, flambda=flambda)
        
        fD23_coude = FORMULE(NOM_PARA=('R', 'EP','X1','X3','X4'),
                             VALE='max(0.809/flambda(R,EP,X3)**(0.44)/fpourD2X(R,EP,X1,X3,X4),1.02)',
                                   fpourD2X=fpourD2X, flambda=flambda)
        
        chfonc = CREA_CHAMP(OPERATION='AFFE',
                             TYPE_CHAM='ELNO_NEUT_F',
                             MODELE=self.model,
                             PROL_ZERO='OUI',
                             AFFE= (_F(NOM_CMP=('X1','X2','X3','X4','X5','X6'),
                                       VALE_F=(fB2_droit,fZ,fD1_droit,fD21,fD22_droit,fD22_droit),
                                       **self.dicAllZones),
                                    _F(GROUP_MA=self.lGrmaCoude, NOM_CMP=('X1','X2','X3','X4','X5','X6'),
                                       VALE_F=(fB2_coude,fZ,fD1_coude,fD21,fD22_coude,fD23_coude),),
                                    ))
        
        chParams= CREA_CHAMP(OPERATION='EVAL',
                                TYPE_CHAM='ELNO_NEUT_R',
                                CHAM_F=chfonc, 
                                CHAM_PARA=(self.chRochElno, chUtil) )

        self.chParams = chParams
        
        
        # DETRUIRE(CONCEPT=_F(NOM=chUtil))
        del chUtil
        
        
    def classification(self,):
        """
            Classification des moments
        """ 
        # forces = PP +- ABS(MSI)
        # déplacement = DILAT_THERM +- ABS(ms)
        # msi reste n'est pas combiné

        asse_Mperm = [] # Poids propre
        asse_mperm = [] # Dilatation
        asse_Mnope = []
        asse_mnope = [] # Dépl imposés aux ancrages
        asse_msi = []

        __FIELD = [None]*2*len(self.dResuMeca)
        nbfield = 0
        
        iocc = 0
        nbSIT = 0
        
        for charg in self.dResuMeca:
            iocc+=1
            
            # vérification des modèles, cara_elems et cham_maters

            # A FAIRE : récupérer les infos d'un COMB_SISM_MODAL
            if charg.get('RESULTAT'):
                resin = charg['RESULTAT']
                lresu=True
            else:
                resin = charg['CHAM_GD']
                lresu=False
            
            model2  = resin.getModel()
            
            if model2 != None:
                if model2.getName() != self.modelName:
                    UTMESS('F','POSTROCHE_2', vali=iocc, 
                            valk=['MODELE', self.mcf, self.modelName, model2.getName()])
            
            if lresu:
                carael2 = resin.getElementaryCharacteristics()
                if self.caraelem:
                    if carael2 != None:
                        if carael2.getName() != self.caraelemName:
                            UTMESS('F','POSTROCHE_2', vali=iocc, 
                                    valk=['CARA_ELEM',self.mcf, self.caraelemName, carael2.getName()])
                else:
                    self.caraelem=carael2
                    if self.caraelem:
                        self.caraelemName = self.caraelem.getName()
                
                chmat2 = resin.getMaterialField()
                if self.chammater:
                    if chmat2 != None:
                        if chmat2.getName() != self.chammaterName:
                            UTMESS('F','POSTROCHE_2', vali=iocc, 
                                    valk=['CHAM_MATER',self.mcf, self.chammaterName, chmat2.getName()])
                else:
                    self.chammater=chmat2
                    if self.caraelem:
                        self.chammaterName = self.chammater.getName()
                

            # classification par type de chargement
            
            typchar = charg.get('TYPE_CHAR')

            if typchar == 'SISM_INER_SPEC':
                dire = charg.get('DIRECTION')
                typeres = charg.get('TYPE_RESU')
                ind = self.dirDisp.index(dire) + 1
                
                if typeres in ['DYN_QS','DYN'] :
                
#                   msi : part dynamique de la réponse
#                   nume_ordre 11, 12, 13 et 14
                    iordr = 10+ind

                    __FIELD[nbfield] = CREA_CHAMP (OPERATION = 'EXTR',
                                                   TYPE_CHAM = 'ELNO_SIEF_R',
                                                   RESULTAT  = resin, 
                                                   NOM_CHAM  = 'EFGE_ELNO',
                                                   NUME_ORDRE= iordr)
                    
                    oc_asse = {'CHAM_GD' : __FIELD[nbfield],
                               'TOUT' : 'OUI',
                               'CUMUL': 'OUI',
                               'COEF_R' : 1,  
                               'NOM_CMP' : self.listCmp,
                               'NOM_CMP_RESU' : ("X1",'X2','X3'),
                              }
                    asse_msi.append(oc_asse)
                    nbfield+=1

                if typeres in ['DYN_QS','QS'] :
                
#                   MSI  : part quasi-statique de la réponse
#                   nume_ordre 21, 22, 23 et 24
                    iordr = 20+ind

                    __FIELD[nbfield] = CREA_CHAMP (OPERATION = 'EXTR',
                                                   TYPE_CHAM = 'ELNO_SIEF_R',
                                                   RESULTAT  = resin, 
                                                   NOM_CHAM  = 'EFGE_ELNO',
                                                   NUME_ORDRE= iordr)
                    
                    oc_asse = {'CHAM_GD' : __FIELD[nbfield],
                               'TOUT' : 'OUI',
                               'CUMUL': 'OUI',
                               'COEF_R' : 1,
                               'NOM_CMP' : self.listCmp,
                               'NOM_CMP_RESU' : ("X1",'X2','X3'),
                              }
                    asse_Mnope.append(oc_asse)
                    nbfield+=1
            
            elif typchar == 'SISM_INER_TRAN':
                nbSIT+=1
            elif(lresu):
                # extraction
                args={}
                for kwd in self.l_mc_inst:
                    if charg.get(kwd):
                        args[kwd] = charg[kwd]
                        
                __FIELD[nbfield] = CREA_CHAMP (OPERATION = 'EXTR',
                                             TYPE_CHAM = 'ELNO_SIEF_R',
                                             RESULTAT  = resin, 
                                             NOM_CHAM  = 'EFGE_ELNO',
                                             **args)
                cham_gd = __FIELD[nbfield]
                nbfield+=1
            else:
                cham_gd = resin
            
            if typchar[:9] != 'SISM_INER':
            
                oc_asse = {'CHAM_GD' : cham_gd,
                           'TOUT' : 'OUI',
                           'CUMUL': 'OUI',
                           'COEF_R' : 1, 
                           'NOM_CMP' : self.listCmp,
                           }
                if typchar not in self.permanentLoadsTypes:
                    oc_asse['NOM_CMP_RESU'] = ("X1",'X2','X3')
                
                if typchar == 'POIDS':
                    asse_Mperm.append(oc_asse)
                elif typchar == 'DILAT_THERM':
                    asse_mperm.append(oc_asse)
                elif typchar == 'DEPLACEMENT':
                    asse_mnope.append(oc_asse)
                else:
                    raise Exception('TYPE_CHAR inconnu')
        
        if self.mcf == 'RESU_MECA_TRAN' and nbSIT==0:
            UTMESS('F','POSTROCHE_5')
        if nbSIT > 1:
            UTMESS('F','POSTROCHE_6')
        
        if not self.caraelem: 
            UTMESS('F', 'POSTROCHE_3', valk='CARA_ELEM')
        if not self.chammater: 
            UTMESS('F', 'POSTROCHE_3', valk='CHAM_MATER')
        
        if asse_Mperm == []:
            __Mperm = None
        elif len(asse_Mperm) == 1:
            __Mperm = asse_Mperm[0]['CHAM_GD']
        else:
            __Mperm = CREA_CHAMP(OPERATION = 'ASSE',
                                  MODELE    = self.model, 
                                  TYPE_CHAM = 'ELNO_SIEF_R',
                                  ASSE      = asse_Mperm)
            
        if asse_mperm == []:
            __mperm = None
        elif len(asse_mperm) == 1:
            __mperm = asse_mperm[0]['CHAM_GD']
        else:
            __mperm = CREA_CHAMP(OPERATION = 'ASSE',
                                  MODELE    = self.model, 
                                  TYPE_CHAM = 'ELNO_SIEF_R',
                                  ASSE      = asse_mperm)

        # changement des composantes pour formule
        if asse_Mnope == []:
            __Mnope = None
        else:
            __Mnope = CREA_CHAMP(OPERATION = 'ASSE',
                                  MODELE    = self.model, 
                                  TYPE_CHAM = 'ELNO_NEUT_R',
                                  PROL_ZERO = 'OUI',
                                  ASSE      = asse_Mnope)
        if asse_mnope == []:
            __mnope = None
        else:
            __mnope = CREA_CHAMP(OPERATION = 'ASSE',
                                  MODELE    = self.model, 
                                  TYPE_CHAM = 'ELNO_NEUT_R',
                                  PROL_ZERO = 'OUI',
                                  ASSE      = asse_mnope)
                         
        if asse_msi == []:
            __msitmp = None
        else:
            __msitmp = CREA_CHAMP(OPERATION = 'ASSE',
                               MODELE    = self.model, 
                               TYPE_CHAM = 'ELNO_NEUT_R',
                               PROL_ZERO = 'OUI',
                               ASSE      = asse_msi)
        
        self.Mperm = __Mperm
        self.mperm = __mperm
        self.Mnope = __Mnope
        self.mnope = __mnope
        self.msitmp = __msitmp

    def sismInerTran(self,):
        """
            Traitement du type de chargement SISM_INER_TRAN
        """ 

        if self.mcf !='RESU_MECA_TRAN':
            self.listNumeTran = [0]
            return

        dicInst = {}
        iocc = 0
        
        for charg in self.dResuMeca:
            iocc+=1
            
            typchar = charg.get('TYPE_CHAR')

            if typchar != 'SISM_INER_TRAN':
                continue
                
            resDyn = charg.get('RESULTAT')
            resCorr = None
            if charg.get('RESU_CORR'):
                resCorr = charg.get('RESU_CORR')
            
            kwNumeTran = None
            for mc in self.l_mc_inst2:
                if charg.get(mc):
                    if mc =='TOUT_ORDRE':
                        kwNumeTran = 'NUME_ORDRE'
                        listNumeTran = resDyn.getRanks()
                        if resCorr is not None:
                            listNumeTranCorr = resCorr.getRanks()
                            if listNumeTranCorr != listNumeTran:
                                UTMESS('F','POSTROCHE_7',vali=iocc)
                    else:
                        kwNumeTran   = mc
                        listNumeTran = charg.get(mc)
                    if mc =='INST':
                        for keyw in self.l_mc_inst3:
                            dicInst[keyw] = charg.get(keyw)
                    break
            break
        
        self.resDynTran   = resDyn
        self.resCorrTran  = resCorr
        self.listNumeTran = listNumeTran
        self.kwNumeTran   = kwNumeTran
        self.dicInst      = dicInst
        
    
    def extrInstInerTran(self, nume):
        """
        Récupération des chargements sismique inertiel pour un instant donné
        """

        args={self.kwNumeTran : nume}
        args.update(self.dicInst)
                
        chDyn = CREA_CHAMP (OPERATION = 'EXTR',
                            TYPE_CHAM = 'ELNO_SIEF_R',
                            RESULTAT  = self.resDynTran, 
                            NOM_CHAM  = 'EFGE_ELNO',
                            **args)
        
        chDynNeut = CREA_CHAMP(OPERATION = 'ASSE',
                               MODELE    = self.model, 
                               TYPE_CHAM = 'ELNO_NEUT_R',
                               PROL_ZERO = 'OUI',
                               ASSE      = _F(CHAM_GD = chDyn,
                                              TOUT = 'OUI',
                                              NOM_CMP = self.listCmp,
                                              NOM_CMP_RESU = ('X1', 'X2', 'X3'),)
                              )
        self.msitmp = chDynNeut
        
        if self.resCorrTran is not None:
            chCorr = CREA_CHAMP(OPERATION = 'EXTR',
                                TYPE_CHAM = 'ELNO_SIEF_R',
                                RESULTAT  = self.resCorrTran, 
                                NOM_CHAM  = 'EFGE_ELNO',
                                **args)
            
            chStaNeut = CREA_CHAMP(OPERATION = 'ASSE',
                                   MODELE    = self.model, 
                                   TYPE_CHAM = 'ELNO_NEUT_R',
                                   PROL_ZERO = 'OUI',
                                   ASSE      = (_F(CHAM_GD = chCorr,
                                                   TOUT = 'OUI',
                                                   NOM_CMP = self.listCmp,
                                                   NOM_CMP_RESU = ('X1', 'X2', 'X3'),),
                                                _F(CHAM_GD = chDyn,
                                                   TOUT = 'OUI',
                                                   NOM_CMP = self.listCmp,
                                                   NOM_CMP_RESU = ('X1', 'X2', 'X3'),
                                                   CUMUL ='OUI',
                                                   COEF_R=-1.0),
                                               ),
                                  )

            self.Mnope  = chStaNeut
            # DETRUIRE(CONCEPT=_F(NOM=chCorr))
            del chCorr
        else:
            self.Mnope  = None
            
        # DETRUIRE(CONCEPT=_F(NOM=chDyn))
        del chDyn
        
    
    def createFonctionsFields(self,):
        """
        Création des champs de fonctions utilisés dans la macro
        """
        
        # pour conbinaison
        
        def sign(x):    
            if x == 0.:        return 1.
            else:              return x/abs(x)
        
        fonc1 = FORMULE(NOM_PARA=('X1', 'MT'),VALE='MT+sign(MT)*abs(X1)',sign=sign)
        fonc2 = FORMULE(NOM_PARA=('X2', 'MFY'),VALE='MFY+sign(MFY)*abs(X2)',sign=sign)
        fonc3 = FORMULE(NOM_PARA=('X3', 'MFZ'),VALE='MFZ+sign(MFZ)*abs(X3)',sign=sign)
        
        fonc4 = FORMULE(NOM_PARA=('X1'),VALE='abs(X1)')
        fonc5 = FORMULE(NOM_PARA=('X2'),VALE='abs(X2)')
        fonc6 = FORMULE(NOM_PARA=('X3'),VALE='abs(X3)')
        
        self.chFoncA  = CREA_CHAMP(OPERATION='AFFE',
                             TYPE_CHAM='ELNO_NEUT_F',
                             MODELE=self.model,
                             PROL_ZERO='OUI',
                             AFFE= (_F(NOM_CMP=('X1','X2','X3'),
                                       VALE_F=(fonc1,fonc2, fonc3),
                                       **self.dicAllZones),))
        
        self.chFoncB  = CREA_CHAMP(OPERATION='AFFE',
                             TYPE_CHAM='ELNO_NEUT_F',
                             MODELE=self.model,
                             PROL_ZERO='OUI',
                             AFFE= (_F(NOM_CMP=('X1','X2','X3'),
                                       VALE_F=(fonc4,fonc5, fonc6),
                                       **self.dicAllZones),))
                                       
        # contrainte de référence
        # X1 => B2, X2 => Z

        fSig = FORMULE(NOM_PARA=('MT', 'MFY', 'MFZ', 'X1', 'X2'),
            VALE='sqrt( pow(0.79*X1/X2*sqrt(pow(MFY,2)+pow(MFZ,2)),2) + pow(0.87*MT/X2,2))')

        self.chFSigRef = CREA_CHAMP(OPERATION='AFFE',
                            TYPE_CHAM='ELNO_NEUT_F',
                            MODELE=self.model,
                            PROL_ZERO='OUI',
                            AFFE= (_F(NOM_CMP=('X1'),
                                      VALE_F=(fSig,),
                                      **self.dicAllZones),))
        # EpsiMP
        # N => SigmaRef 
        fEpsiMp = FORMULE(NOM_PARA = ('N', 'E', 'K_FACT', 'N_EXPO'),
                          VALE     =  'K_FACT*pow(N/E,1/N_EXPO)')

        self.chFEpsiMp = CREA_CHAMP(OPERATION='AFFE',
                               TYPE_CHAM='ELNO_NEUT_F',
                               MODELE=self.model,
                               PROL_ZERO='OUI',
                               AFFE= (_F(NOM_CMP=('X1'),
                                         VALE_F=(fEpsiMp,),
                                         **self.dicAllZones),))
        
        # réversibilité locale
        # X1 = EpsiMp
        
        def reversLoc(epsi, sig, young,seuil):
            if sig/young < seuil:
                return 0.
            else:
                return sig/(young*epsi)
        
        
        fReversLoc = FORMULE(NOM_PARA=('X1', 'N', 'E'),
                           VALE='reversLoc(X1,N,E,seuil)',reversLoc=reversLoc,
                           seuil=self.seuilSigRef)

        self.chFRevesLoc = CREA_CHAMP(OPERATION='AFFE',
                                 TYPE_CHAM='ELNO_NEUT_F',
                                 MODELE=self.model,
                                 PROL_ZERO='OUI',
                                 AFFE= (_F(NOM_CMP=('X1'),
                                           VALE_F=(fReversLoc,),
                                           **self.dicAllZones),))
        
        # réversibilité totale
        
            # calcul de A*sigRef^2
        
        fASigRef2 = FORMULE(NOM_PARA=('N','A'),VALE='pow(N,2)*A')
        
            # calcul de A*sigRef^2/t
            # t = reversibilité local
        def ff(sig, A, t):
            if t == 0.:
                return 0
            else:
                return A*sig**2/t
        fASigRef2RevLoc = FORMULE(NOM_PARA=('N','A','X1'),VALE='ff(N,A,X1)',ff=ff)

        self.chFCalcPrelim = CREA_CHAMP(OPERATION='AFFE',
                                 TYPE_CHAM='ELNO_NEUT_F',
                                 MODELE=self.model,
                                 PROL_ZERO='OUI',
                                 AFFE= (_F(NOM_CMP=('X1','X2'),
                                           VALE_F=(fASigRef2,fASigRef2RevLoc),
                                           **self.dicAllZones),))
        # effet de ressort
        
        def fress(t, T):
            if t == 0.:
                return 0.
            else:
                return max(T/t-1,0)
        
        
        fRessort = FORMULE(NOM_PARA=('X1', 'X2'),
                           VALE='fress(X1,X2)',fress=fress)

        self.chFRessort = CREA_CHAMP(OPERATION='AFFE',
                                TYPE_CHAM='ELNO_NEUT_F',
                                MODELE=self.model,
                                PROL_ZERO='OUI',
                                AFFE= (_F(NOM_CMP=('X1'),
                                          VALE_F=(fRessort,),
                                          **self.dicAllZones),))
        
        # contrainte vraie
        
        def fsolve(sigRef, epsiMpRef,e, k, n, r, nbIterMax,seuil):
            
            """
               resolution de _funcToSolve par algo de Newton
            """
            
            if sigRef/e<seuil:
                return 0.
            
            
            def epsip(sig, e, k, n):
                return k*pow(sig/e,1/n)
            
            
            def funcToSolve(sigV):
                return r*(sigV-sigRef)/e + sigV/e + epsip(sigV, e, k, n) - epsiMpRef
            
            # param
            dSig = sigRef/1000
            tol = 1e-6
            # init
            ratio = 1
            sigVk = sigRef/2
            f0 = funcToSolve(sigVk)
            fk = f0 
            nbIter = 0
            
            # print('f0',f0)

            while ratio > tol or nbIter>nbIterMax:
                fkp = funcToSolve(sigVk+dSig)
                dfk = (fkp-fk)/dSig
                
                sigVk = sigVk - fk/dfk
                fkp1    = funcToSolve(sigVk)
                
                ratio = abs(fkp1/f0)
                fk = fkp1
                nbIter =nbIter+1
                # print(nbIter,"ratio",ratio,'f',fk, 'sig',sigVk)
                
            if nbIter > nbIterMax : 
                return -1.
            else:
                return sigVk

        
        
        # calcul à partir de l'effet de ressort
        
        # SigRef = N
        # EspiMpRef = X1
        # Ressort = X2
        fSigVraie = FORMULE(NOM_PARA=('N', 'X1', 'X2' ,'E', 'K_FACT', 'N_EXPO'),
                            VALE='fsolve(N,X1,E,K_FACT,N_EXPO,X2,nbIterMax,seuil)',
                            fsolve=fsolve, nbIterMax=self.nbIterMax,
                            seuil=self.seuilSigRef)
                            
        # calcul à partir de l'effet de ressort max
        
        # SigRef = N
        # EspiMpRef = X1
        # RessortMax = X3
        
        fSigVraieMax = FORMULE(NOM_PARA=('N', 'X1', 'X3' ,'E', 'K_FACT', 'N_EXPO'),
                            VALE='fsolve(N,X1,E,K_FACT,N_EXPO,X3,nbIterMax,seuil)',
                            fsolve=fsolve, nbIterMax=self.nbIterMax,
                            seuil=self.seuilSigRef)

        self.chFSigVraie = CREA_CHAMP(OPERATION='AFFE',
                                TYPE_CHAM='ELNO_NEUT_F',
                                MODELE=self.model,
                                PROL_ZERO='OUI',
                                AFFE= (_F(NOM_CMP=('X1','X2'),
                                          VALE_F=(fSigVraie,fSigVraieMax),
                                          **self.dicAllZones),))
        
        # veriContrainte
        
        def veriSupSigP(sigP, sigV):
            if sigP>sigV and sigV>0.:
                return 1
            else:
                return 0
        
        def veriInfSigRef(sigRef, sigV):
            if sigRef<sigV:
                return 1
            else:
                return 0
        
        def veriIterMax(sigV):
            if sigV == -1.:
                return 1
            else:
                return 0
        
        f1 = FORMULE(NOM_PARA=('X1', 'X2'),
                            VALE='veriSupSigP(X1,X2)',veriSupSigP=veriSupSigP)
        
        f2 = FORMULE(NOM_PARA=('X1', 'X3'),
                            VALE='veriSupSigP(X1,X3)',veriSupSigP=veriSupSigP)
                            
        f3 = FORMULE(NOM_PARA=('X4', 'X2'),
                            VALE='veriInfSigRef(X4,X2)',veriInfSigRef=veriInfSigRef)
        
        f4 = FORMULE(NOM_PARA=('X4', 'X3'),
                            VALE='veriInfSigRef(X4,X3)',veriInfSigRef=veriInfSigRef)
        
        f5 = FORMULE(NOM_PARA=('X2'),
                            VALE='veriIterMax(X2)',veriIterMax=veriIterMax)
        
        f6 = FORMULE(NOM_PARA=('X3'),
                            VALE='veriIterMax(X3)',veriIterMax=veriIterMax)
                            
        self.chFSigVInfSigP = CREA_CHAMP(OPERATION='AFFE',
                                TYPE_CHAM='ELNO_NEUT_F',
                                MODELE=self.model,
                                PROL_ZERO='OUI',
                                AFFE= (_F(NOM_CMP=('X1','X2','X3','X4','X5','X6'),
                                          VALE_F=(f1,f2,f3,f4,f5,f6),
                                          **self.dicAllZones),))
    
        # coefficient d'abattement
        
        def coefAbat(sigRef, sigP, sigV):
            if sigV == 0:
                return 1.
            if sigV <= sigP:
                return 1.
            else:
                return (sigV-sigP)/(sigRef-sigP)
        
        
        fCoefAbat = FORMULE(NOM_PARA=('N', 'X1', 'X2'),
                            VALE='coefAbat(N, X1, X2)', coefAbat=coefAbat)
        
        fCoefAbatOpt = FORMULE(NOM_PARA=('N', 'X1', 'X3'),
                               VALE='coefAbat(N, X1, X3)', coefAbat=coefAbat)
        
        self.chFCoefAbat = CREA_CHAMP(OPERATION='AFFE',
                                TYPE_CHAM='ELNO_NEUT_F',
                                MODELE=self.model,
                                PROL_ZERO='OUI',
                                AFFE= (_F(NOM_CMP=('X1','X2'),
                                          VALE_F=(fCoefAbat,fCoefAbatOpt),
                                          **self.dicAllZones),))
    
    def combinaisons(self,):
        """
        combinaison permanents/ non permanents
            
        M (catégorie force)       = PP +- ABS(MSI)
        m (catégorie déplacement) = DILAT_THERM +- ABS(ms)
        msi                       = ABS(msi)
        """
    
        self.M   = self.combi(self.Mperm, self.Mnope )
        self.m   = self.combi(self.mperm, self.mnope )
        self.msi = self.combi(None      , self.msitmp)
    
    def combi(self, chPerm, chNope):
        """
        Combinaison
        """
    
        if chPerm and chNope:
            chEval= CREA_CHAMP(OPERATION='EVAL',
                                TYPE_CHAM='ELNO_NEUT_R',
                                CHAM_F=self.chFoncA, 
                                CHAM_PARA=(chPerm, chNope) )

            chRes = CREA_CHAMP(OPERATION = 'ASSE',
                               MODELE    = self.model, 
                               TYPE_CHAM = 'ELNO_SIEF_R',
                               PROL_ZERO = 'OUI',
                               ASSE      = _F(CHAM_GD = chEval,
                                              TOUT = 'OUI',
                                              NOM_CMP = ('X1', 'X2', 'X3'),
                                              NOM_CMP_RESU = self.listCmp,)
                             )
            # DETRUIRE(CONCEPT=_F(NOM=chEval))
            del chEval
        elif chPerm:
            chRes = chPerm
        elif chNope:
            chEval= CREA_CHAMP(OPERATION='EVAL',
                                TYPE_CHAM='ELNO_NEUT_R',
                                CHAM_F=self.chFoncB, 
                                CHAM_PARA=(chNope) )

            chRes = CREA_CHAMP(OPERATION = 'ASSE',
                               MODELE    = self.model, 
                               TYPE_CHAM = 'ELNO_SIEF_R',
                               PROL_ZERO = 'OUI',
                               ASSE      = _F(CHAM_GD = chEval,
                                              TOUT = 'OUI',
                                              NOM_CMP = ('X1', 'X2', 'X3'),
                                              NOM_CMP_RESU = self.listCmp,)
                             )
            # DETRUIRE(CONCEPT=_F(NOM=chEval))
            del chEval
            
        else:
            chRes = CREA_CHAMP(OPERATION='AFFE',
                            TYPE_CHAM='ELNO_SIEF_R',
                            MODELE=self.model,
                            PROL_ZERO='OUI',
                            AFFE= (_F(NOM_CMP=self.listCmp,
                                      VALE=(0.,0.,0.),
                                      **self.dicAllZones),))
        return chRes
        
    def calcContrainteEquiv(self,chCoefsAbat_m, chCoefsAbat_msi, opt = False):
        """
           Calcul des champs de contraintes equivalentes
        """
        
        # si opt est True, on prend la composante X2
        
        if opt: 
            cmpG = 'X7'
        else: 
            cmpG = 'X6'
        
        fonc1 = FORMULE(NOM_PARA=(cmpG, 'MT','MFY','MFZ'),VALE='%s*abs(MT)'%cmpG)
        fonc2 = FORMULE(NOM_PARA=(cmpG, 'MT','MFY','MFZ'),VALE='%s*abs(MFY)'%cmpG)
        fonc3 = FORMULE(NOM_PARA=(cmpG, 'MT','MFY','MFZ'),VALE='%s*abs(MFZ)'%cmpG)
    
        chFonc  = CREA_CHAMP(OPERATION='AFFE',
                         TYPE_CHAM='ELNO_NEUT_F',
                         MODELE=self.model,
                         PROL_ZERO='OUI',
                         AFFE= (_F(NOM_CMP=('X1','X2','X3'),
                                   VALE_F=(fonc1,fonc2, fonc3),
                                   **self.dicAllZones),))
        
        
        # calcul de g * m 
        
        ch_g_m= CREA_CHAMP(OPERATION='EVAL',
                            TYPE_CHAM='ELNO_NEUT_R',
                            CHAM_F=chFonc, 
                            CHAM_PARA=(chCoefsAbat_m, self.m) )
        
        # calcul de gs * msi
        
        ch_gs_msi= CREA_CHAMP(OPERATION='EVAL',
                            TYPE_CHAM='ELNO_NEUT_R',
                            CHAM_F=chFonc, 
                            CHAM_PARA=(chCoefsAbat_msi, self.msi) )
        
        # champ utilitaire
        
        chUtil= CREA_CHAMP(OPERATION = 'ASSE',
                            MODELE=self.model,
                            TYPE_CHAM = 'ELNO_NEUT_R',
                            PROL_ZERO = 'OUI',
                            ASSE      = (_F(CHAM_GD = self.chParams,
                                           TOUT = 'OUI',
                                           NOM_CMP = ('X1','X2','X3','X4','X5','X6'),
                                           ),
                                         _F(CHAM_GD = self.M,
                                           TOUT = 'OUI',
                                           NOM_CMP = ('MT','MFY','MFZ'),
                                           NOM_CMP_RESU = ('X7','X8','X9'),
                                           ),
                                         _F(CHAM_GD = ch_g_m,
                                           TOUT = 'OUI',
                                           NOM_CMP = ('X1','X2','X3'),
                                           NOM_CMP_RESU = ('X10','X11','X12'),
                                           ),
                                         _F(CHAM_GD = ch_gs_msi,
                                           TOUT = 'OUI',
                                           NOM_CMP = ('X1','X2','X3'),
                                           NOM_CMP_RESU = ('X13','X14','X15'),
                                           ),
                                         _F(CHAM_GD = self.chPression,
                                           TOUT = 'OUI',
                                           NOM_CMP = ('X1',),
                                           NOM_CMP_RESU = ('X16'),
                                           ),
                                         _F(CHAM_GD = self.chRochElno,
                                           TOUT = 'OUI',
                                           NOM_CMP = ('R','EP'),
                                           NOM_CMP_RESU = ('X17','X18'),
                                           ),
                                         )
                           )
        
        foncA = FORMULE(NOM_PARA=('X2','X3','X4','X5','X6', # Z, D1, D21, D22, D23
                                  'X7','X8','X9',       # MT, MFY, MFZ de M
                                  'X10','X11','X12',    # g(_opt)*(MT, MFY, MFZ) de m
                                  'X13','X14','X15',    # gs(_opt)*(MT, MFY, MFZ) de msi
                                  'X16',                # Pression
                                  'X17','X18',          # R, EP
                                  ),
                VALE='sqrt((X3*X16*(X17-X18)/X18)**2 + 1/X2**2*(X4**2*(X7+X10+X13)**2+X5**2*(X8+X11+X14)**2+X6**2*(X9+X12+X15)**2))')
                
        
        
        chFoncA  = CREA_CHAMP(OPERATION='AFFE',
                         TYPE_CHAM='ELNO_NEUT_F',
                         MODELE=self.model,
                         PROL_ZERO='OUI',
                         AFFE= (_F(NOM_CMP=('X1',),
                                   VALE_F=(foncA,),
                                   **self.dicAllZones),))
        
        
        chContEquiv= CREA_CHAMP(OPERATION='EVAL',
                                TYPE_CHAM='ELNO_NEUT_R',
                                CHAM_F=chFoncA, 
                                CHAM_PARA=(chUtil) )
        
        # DETRUIRE(CONCEPT=_F(NOM=(chFoncA,chUtil,ch_g_m,ch_gs_msi,chFonc)))
        del chFonc
        del chFoncA
        del chUtil
        del ch_g_m
        del ch_gs_msi
        
        if opt:
            self.chContEquivOpt = chContEquiv
        else:
            self.chContEquiv = chContEquiv
                
    def buildOutput(self, chVale, chValeS2):
        """
            Construction du champ de sortie contenant toutes les grandeurs
        """
        
        
        chOutput= CREA_CHAMP(OPERATION = 'ASSE',
                                MODELE=self.model,
                                TYPE_CHAM = 'ELNO_NEUT_R',
                                PROL_ZERO = 'OUI',
                                ASSE      = (_F(CHAM_GD = chVale,
                                               TOUT = 'OUI',
                                               NOM_CMP      = ('X1','X2','X3','X4','X5','X6','X7','X8','X9'),
                                               NOM_CMP_RESU = ('X1','X3','X5','X7','X9','X11','X13','X17','X19'),
                                               ),
                                             _F(CHAM_GD = chValeS2,
                                               TOUT = 'OUI',
                                               NOM_CMP      = ('X1','X2','X3','X4','X5','X6','X7','X8','X9'),
                                               NOM_CMP_RESU = ('X2','X4','X6','X8','X10','X12','X14','X18','X20'),
                                               ),
                                             _F(CHAM_GD = self.chContEquiv,
                                               TOUT = 'OUI',
                                               NOM_CMP = ('X1',),
                                               NOM_CMP_RESU = ('X15',),
                                               ),
                                             _F(CHAM_GD = self.chContEquivOpt,
                                               TOUT = 'OUI',
                                               NOM_CMP = ('X1',),
                                               NOM_CMP_RESU = ('X16',),
                                               ),
                                              _F(CHAM_GD = self.M,
                                               TOUT = 'OUI',
                                               NOM_CMP = ('MT','MFY','MFZ'),
                                               NOM_CMP_RESU = ('X21','X22','X23'),
                                               ),
                                              _F(CHAM_GD = self.m,
                                               TOUT = 'OUI',
                                               NOM_CMP = ('MT','MFY','MFZ'),
                                               NOM_CMP_RESU = ('X24','X25','X26'),
                                               ),
                                              _F(CHAM_GD = self.msi,
                                               TOUT = 'OUI',
                                               NOM_CMP = ('MT','MFY','MFZ'),
                                               NOM_CMP_RESU = ('X27','X28','X29'),
                                               ),
                                             )
                               )
        
        # DETRUIRE(CONCEPT=_F(NOM=(chVale,chValeS2, self.chContEquiv, self.chContEquivOpt)))
        del chVale
        del chValeS2
        del self.chContEquiv
        del self.chContEquivOpt
        
        return chOutput
            
class PostRocheCalc():

    def __init__(self,prCommon, chMoment, numeOrdre):
        """
            
        """
        self.chMoment   = chMoment
        self.param = prCommon
        self.numeOrdre = numeOrdre
        
        
    def contraintesRef(self):
        """
            Calcul des contraintes de références
        """

        chSigNeut= CREA_CHAMP(OPERATION='EVAL',
                              TYPE_CHAM='ELNO_NEUT_R',
                              CHAM_F=self.param.chFSigRef, 
                              CHAM_PARA=(self.chMoment, self.param.chParams))
        
        chSigRef= CREA_CHAMP(OPERATION = 'ASSE',
                             MODELE=self.param.model,
                             TYPE_CHAM = 'ELNO_SIEF_R',
                             PROL_ZERO = 'OUI',
                             ASSE      = _F(CHAM_GD = chSigNeut,
                                            TOUT = 'OUI',
                                            NOM_CMP = ('X1',),
                                            NOM_CMP_RESU = 'N',)
                            )
        
        self.chSigRef   = chSigRef
        
        # DETRUIRE(INFO=2,CONCEPT=_F(NOM=(chSigNeut,)))
        del chSigNeut
    
    def epsiMp(self):
        """
        Calcul de la déformation de Ramberg-Osgood
        """
        
        chEpsiMp= CREA_CHAMP(OPERATION='EVAL',
                                TYPE_CHAM='ELNO_NEUT_R',
                                CHAM_F=self.param.chFEpsiMp, 
                                CHAM_PARA=(self.chSigRef, self.param.chRochElno))
        
        self.chEpsiMp = chEpsiMp
        
    def reversibilite_locale(self,):
        """
        Calcul de la réversibilité locale t
        """
        
        chReversLoc= CREA_CHAMP(OPERATION='EVAL',
                                TYPE_CHAM='ELNO_NEUT_R',
                                CHAM_F=self.param.chFRevesLoc, 
                                CHAM_PARA=(self.chSigRef, self.param.chRochElno, self.chEpsiMp))
        
        self.chReversLoc = chReversLoc


    def reversibilite_totale(self,):
        """
            Calcul de la réversibilité totale sur chaque tronçon
        """
        
        chCalcPrelim0= CREA_CHAMP(OPERATION='EVAL',
                                TYPE_CHAM='ELNO_NEUT_R',
                                CHAM_F=self.param.chFCalcPrelim, 
                                CHAM_PARA=(self.chSigRef,self.param.chRochElno, self.chReversLoc))
        
        # Changement de composantes pour que POST_ELEM/INTEGRALE fonctionne
        
        chCalcPrelim= CREA_CHAMP(OPERATION = 'ASSE',
                             MODELE=self.param.model,
                             TYPE_CHAM = 'ELNO_SIEF_R',
                             PROL_ZERO = 'OUI',
                             ASSE      = _F(CHAM_GD = chCalcPrelim0,
                                            TOUT = 'OUI',
                                            NOM_CMP = ('X1','X2'),
                                            NOM_CMP_RESU = ('N','VY'))
                            )
        
        affe  = []
        listT = []
        
        # boucle sur les tronçon (=Zones)
        for zone in self.param.dZone:
            integ = {'NOM_CMP'     :('N','VY'),
                     'TYPE_MAILLE' :'1D'
                    }
            dicAffe = {'NOM_CMP'  : 'X1',}
            
            if zone.get('TOUT'):
                integ['TOUT'] = 'OUI'
                dicAffe['TOUT'] = 'OUI'
            else:
                integ['GROUP_MA'] = zone.get('GROUP_MA')
                dicAffe['GROUP_MA'] = zone.get('GROUP_MA')

            tabInteg=POST_ELEM(MODELE=self.param.model,
                                        CHAM_GD=chCalcPrelim,
                                        INTEGRALE=integ);
            deno = tabInteg['INTE_N',1]
            nume = tabInteg['INTE_VY',1]
        
            # 1/T = nume/deno => T = deno/nume
            if nume == 0:
                T = 0.
            else:
                T = deno/nume
            listT.append(T)
            dicAffe['VALE'] = T
            affe.append(dicAffe)
            
            # DETRUIRE(CONCEPT=_F(NOM=(tabInteg)))
            del tabInteg
        
        chReversTot = CREA_CHAMP(OPERATION='AFFE',
                                 TYPE_CHAM='ELNO_NEUT_R',
                                 MODELE=self.param.model,
                                 PROL_ZERO='OUI',
                                 AFFE= affe)
        self.chReversTot = chReversTot
        
        # DETRUIRE(CONCEPT=_F(NOM=(chCalcPrelim)))
        del chCalcPrelim

    def effet_ressort(self,):
        """
            Calcul de l'effet de ressort
        """
        
        # on met dans le même champ les réversibilités locales et globales
        # X1 = t
        # X2 = T
        
        chReversAll= CREA_CHAMP(OPERATION = 'ASSE',
                                MODELE=self.param.model,
                                TYPE_CHAM = 'ELNO_NEUT_R',
                                PROL_ZERO = 'OUI',
                                ASSE      = (_F(CHAM_GD = self.chReversLoc,
                                               TOUT = 'OUI',
                                               NOM_CMP = ('X1',),
                                               ),
                                             _F(CHAM_GD = self.chReversTot,
                                               TOUT = 'OUI',
                                               NOM_CMP = ('X1',),
                                               NOM_CMP_RESU = ('X2',),
                                               ),
                                             )
                               )
        
        chRessort = CREA_CHAMP(OPERATION='EVAL',
                                TYPE_CHAM='ELNO_NEUT_R',
                                CHAM_F=self.param.chFRessort, 
                                CHAM_PARA=(chReversAll))
            
        self.chRessort = chRessort
        
        # IMPR_RESU(UNITE=6, FORMAT='RESULTAT', RESU=_F(CHAM_GD=chRessort))
        # DETRUIRE(CONCEPT=_F(NOM=(chReversAll,)))
        del chReversAll
        
        # valeur max
        affe  = []
        # boucle sur les tronçon (=Zones)
        for zone in self.param.dZone:
            mcfmax = {'NOM_CMP' : 'X1',
                      'MODELE'  : self.param.model,
                      'CHAM_GD' : chRessort,
                     }
            dicAffe = {'NOM_CMP'  : 'X1',}
            
            if zone.get('TOUT'):
                mcfmax['TOUT'] = 'OUI'
                dicAffe['TOUT'] = 'OUI'
            else:
                mcfmax['GROUP_MA'] = zone.get('GROUP_MA')
                dicAffe['GROUP_MA'] = zone.get('GROUP_MA')

            tabRessMax=POST_ELEM(MINMAX=mcfmax)
            valRessMax = tabRessMax['MAX_X1',1]
            
            dicAffe['VALE'] = valRessMax
            affe.append(dicAffe)
            # DETRUIRE(CONCEPT=_F(NOM=(tabRessMax)))
            del tabRessMax
        
        chRessMax = CREA_CHAMP(OPERATION='AFFE',
                               TYPE_CHAM='ELNO_NEUT_R',
                               MODELE=self.param.model,
                               PROL_ZERO='OUI',
                               AFFE= affe)
        self.chRessMax = chRessMax

    def contrainteVraie(self,):
        """
            Calcul des contraintes vraies
            - à partir de l'effet de ressort
            - à partir de l'effet de ressort max
        """

        # assemblage de champs
        # X1 = epsiMpRef
        # X2 = effet de ressort
        # X3 = effet de ressort max
        
        chUtil= CREA_CHAMP(OPERATION = 'ASSE',
                                MODELE=self.param.model,
                                TYPE_CHAM = 'ELNO_NEUT_R',
                                PROL_ZERO = 'OUI',
                                ASSE      = (_F(CHAM_GD = self.chEpsiMp,
                                               TOUT = 'OUI',
                                               NOM_CMP = ('X1',),
                                               ),
                                             _F(CHAM_GD = self.chRessort,
                                               TOUT = 'OUI',
                                               NOM_CMP = ('X1',),
                                               NOM_CMP_RESU = ('X2',),
                                               ),
                                             _F(CHAM_GD = self.chRessMax,
                                               TOUT = 'OUI',
                                               NOM_CMP = ('X1',),
                                               NOM_CMP_RESU = ('X3',),
                                               ),
                                             )
                               )
        # DETRUIRE(CONCEPT=_F(NOM=self.chEpsiMp))
        del self.chEpsiMp
        
        
        chSigVraie = CREA_CHAMP(OPERATION='EVAL',
                                TYPE_CHAM='ELNO_NEUT_R',
                                CHAM_F=self.param.chFSigVraie, 
                                CHAM_PARA=(self.chSigRef, chUtil, self.param.chRochElno ))
            
        self.chSigVraie = chSigVraie
        
        # DETRUIRE(CONCEPT=_F(NOM=(chUtil,)))
        del chUtil
        
    def veriContrainte(self,):
        """
            Vérification que sigma vrai > sigma pression
        """
        
        # assemblage de champs
        # X1 = contrainte de Pression
        # X2 = contrainte vraie
        # X3 = contrainte vraie "Max"

        chUtil2= CREA_CHAMP(OPERATION = 'ASSE',
                                MODELE=self.param.model,
                                TYPE_CHAM = 'ELNO_NEUT_R',
                                PROL_ZERO = 'OUI',
                                ASSE      = (_F(CHAM_GD = self.param.chPression,
                                               TOUT = 'OUI',
                                               NOM_CMP = ('X1',),
                                               ),
                                             _F(CHAM_GD = self.chSigVraie,
                                                TOUT = 'OUI',
                                                NOM_CMP = ('X1','X2'),
                                                NOM_CMP_RESU = ('X2','X3'),
                                               ),
                                             _F(CHAM_GD = self.chSigRef,
                                                TOUT = 'OUI',
                                                NOM_CMP = ('N',),
                                                NOM_CMP_RESU = ('X4',),
                                               ),
                                             )
                               )
        self.chSigPV = chUtil2
        
        # verif que sigVraie > sigma Pression
        
        
        chSigVInfSigP = CREA_CHAMP(OPERATION='EVAL',
                                TYPE_CHAM='ELNO_NEUT_R',
                                CHAM_F=self.param.chFSigVInfSigP, 
                                CHAM_PARA=(chUtil2,))
        
        # IMPR_RESU(UNITE=6, FORMAT='RESULTAT', RESU=_F(CHAM_GD=chSigVInfSigP,
                                                      # NOM_CMP=('X1','X2','X3','X4')))
        
        self.chSigVInfSigP = chSigVInfSigP
                                
        
        tabVeriSigV=POST_ELEM(MINMAX=_F(MODELE=self.param.model,
                                          CHAM_GD=chSigVInfSigP,
                                          NOM_CMP=('X1','X2','X3','X4','X5','X6'),
                                          **self.param.dicAllZones
                                         ));
        
        maxX1 = tabVeriSigV['MAX_X1',1]
        maxX2 = tabVeriSigV['MAX_X2',1]
        maxX3 = tabVeriSigV['MAX_X3',1]
        maxX4 = tabVeriSigV['MAX_X4',1]
        maxX5 = tabVeriSigV['MAX_X5',1]
        maxX6 = tabVeriSigV['MAX_X6',1]
        
        # DETRUIRE(CONCEPT=_F(NOM=(tabVeriSigV)))
        del tabVeriSigV
        
        # IMPR_TABLE(UNITE=6, TABLE=tabVeriSigV)
        
        if maxX1>0:
            if self.numeOrdre!= -1:
                UTMESS('A','POSTROCHE_8',vali=self.numeOrdre,valk="la contrainte réelle")
            else:
                UTMESS('A','POSTROCHE_9',valk="la contrainte réelle")
        
        if maxX2>0:
            if self.numeOrdre!= -1:
                UTMESS('A','POSTROCHE_8',vali=self.numeOrdre,valk="la contrainte réelle optimisée")
            else:
                UTMESS('A','POSTROCHE_9',valk="la contrainte réelle optimisée")
        
        
        if maxX3>0:
            if self.numeOrdre!= -1:
                UTMESS('A','POSTROCHE_12',vali=self.numeOrdre,valk="la contrainte réelle")
            else:
                UTMESS('A','POSTROCHE_13',valk="la contrainte réelle")
        
        if maxX4>0:
            if self.numeOrdre!= -1:
                UTMESS('A','POSTROCHE_12',vali=self.numeOrdre,valk="la contrainte réelle optimisée")
            else:
                UTMESS('A','POSTROCHE_13',valk="la contrainte réelle optimisée")
        
        if maxX5>0:
            if self.numeOrdre!= -1:
                UTMESS('A','POSTROCHE_14',vali=[self.numeOrdre,self.param.nbIterMax],
                                          valk="la contrainte réelle")
            else:
                UTMESS('A','POSTROCHE_15',vali=self.param.nbIterMax,valk="la contrainte réelle")
        
        if maxX6>0:
            if self.numeOrdre!= -1:
                UTMESS('A','POSTROCHE_14',vali=[self.numeOrdre,self.param.nbIterMax],
                                          valk="la contrainte réelle optimisée")
            else:
                UTMESS('A','POSTROCHE_15',vali=self.param.nbIterMax,valk="la contrainte réelle optimisée")
        
    def coef_abattement(self,):
        """
            Calcul des coefficients d'abattement g et g_opt
            - à partir de l'effet de ressort => g
            - à partir de l'effet de ressort max => g_opt
        """
        
        chCoefsAbat = CREA_CHAMP(OPERATION='EVAL',
                                TYPE_CHAM='ELNO_NEUT_R',
                                CHAM_F=self.param.chFCoefAbat, 
                                CHAM_PARA=(self.chSigRef, self.chSigPV,))
        
        self.chCoefsAbat = chCoefsAbat
        
        # DETRUIRE(CONCEPT=_F(NOM=(self.chSigPV,)))
        del self.chSigPV
        
    def buildOutput(self,):
        """
        Construction d'un champ contenant toutes les valeurs de sortie
        """
    
        # X1 = contrainte de référence
        # X2 = réversibilité locale
        # X3 = réversibilité totale
        # X4 = facteur d'effet de ressort
        # X5 = facteur d'effet de ressort maximal
        # X6 = coefficient d'abattement
        # X7 = coefficient d'abattement optimisé
        
        chOutput= CREA_CHAMP(OPERATION = 'ASSE',
                            MODELE=self.param.model,
                            TYPE_CHAM = 'ELNO_NEUT_R',
                            PROL_ZERO = 'OUI',
                            ASSE      = (_F(CHAM_GD = self.chSigRef,
                                           TOUT = 'OUI',
                                           NOM_CMP = ('N',),
                                           NOM_CMP_RESU = ('X1',),
                                           ),
                                         _F(CHAM_GD = self.chReversLoc,
                                           TOUT = 'OUI',
                                           NOM_CMP = ('X1',),
                                           NOM_CMP_RESU = ('X2',),
                                           ),
                                         _F(CHAM_GD = self.chReversTot,
                                           TOUT = 'OUI',
                                           NOM_CMP = ('X1',),
                                           NOM_CMP_RESU = ('X3',),
                                           ),
                                         _F(CHAM_GD = self.chRessort,
                                           TOUT = 'OUI',
                                           NOM_CMP = ('X1',),
                                           NOM_CMP_RESU = ('X4',),
                                           ),
                                         _F(CHAM_GD = self.chRessMax,
                                           TOUT = 'OUI',
                                           NOM_CMP = ('X1',),
                                           NOM_CMP_RESU = ('X5',),
                                           ),
                                         _F(CHAM_GD = self.chCoefsAbat,
                                           TOUT = 'OUI',
                                           NOM_CMP = ('X1','X2'),
                                           NOM_CMP_RESU = ('X6','X7'),
                                           ),
                                         _F(CHAM_GD = self.chSigVInfSigP,
                                           TOUT = 'OUI',
                                           NOM_CMP = ('X1','X2'),
                                           NOM_CMP_RESU = ('X8','X9'),
                                           ), 
                                           
                                         )
                           )
        
        self.chOutput = chOutput
        
        # DETRUIRE(CONCEPT=_F(NOM=(self.chSigRef, self.chReversLoc, 
                                 # self.chReversTot, self.chRessort,
                                 # self.chRessMax, self.chCoefsAbat,
                                 # self.chSigVInfSigP)))
        del self.chSigRef
        del self.chReversLoc
        del self.chReversTot
        del self.chRessort
        del self.chRessMax
        del self.chCoefsAbat
        del self.chSigVInfSigP
