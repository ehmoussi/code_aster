# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

# --------------------------------------------------------------
# -Debut--------------------------------------------------------
# --------------------------------------------------------------
def SomListStr(liststr):
    """
    Objet: Formatter l' ecriture d'une liste de caracteres
    """
    str_tmp = ""
    for cpt in liststr:
       assert type(cpt) is str
       str_tmp += "'%s', " %(cpt)
       
    return str_tmp[:-2]


# --------------------------------------------------------------
# -Debut--------------------------------------------------------
# --------------------------------------------------------------
def ListR_2_Str(listreal):
    """
    Objet: Formatter l' ecriture d'une liste de reels
    """
    char = ""
    
    for i,r in enumerate(listreal):
    
        assert type(r) is float,\
        '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'+\
        '!!!                                                       !!!'+\
        '!!!   Erreur dans geomec_utils.py/ListR_2_Str :           !!!'+\
        '!!!                                                       !!!'+\
        '!!!   La composante numero %2d de la liste de donnees    !!!' %(i)+\
        '!!!   n est pas un reel. Veuillez verifier vos donnees    !!!'+\
        '!!!                                                       !!!'+\
        '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
#    if str("%E"%(x[i]))[0] == "-" : deb = " "

        if str(r)[0] == "-":
            deb = " "
        else:
            deb = "  "
            
        if i == len(listreal) - 1:
            fin = ""
        else:
            fin = "\n"
            
#    char += deb + str("%E"%(x[i])) + fin
        char += deb + str(r) + fin
        
    return char


# --------------------------------------------------------------
# -Debut--------------------------------------------------------
# --------------------------------------------------------------
def int_2_str(i, lon):
    """
    Objet: 
    """
    assert (type(i) is int) and (type(lon) is int)
    return "0" * (len(str(lon)) - len(str(i))) + str(i)


# --------------------------------------------------------------
# -Debut--------------------------------------------------------
# --------------------------------------------------------------
def affiche_infos_essai(str_n_essai, type_essai, \
                        val_PRES_CONF, val2, val3=0.):
    """
    Objet: Afficher des informations sur l'essai
    """
    import aster

    mesg1 = " ESSAI " + type_essai + " NUMERO " + str_n_essai + " :"

    if type_essai == "TRIA_DR_M_D":
    
        mesg2 = "  > PRES_CONF   = "
        mesg3 = "  > EPSI_IMPOSE = "
        
    elif type_essai == "TRIA_ND_M_D":
    
        mesg2 = "  > PRES_CONF   = "
        mesg3 = "  > EPSI_IMPOSE = "
        
    elif type_essai == "CISA_DR_C_D":
    
        mesg2 = "  > PRES_CONF   = "
        mesg3 = "  > EPSI_IMPOSE = "
        
    elif type_essai == "TRIA_ND_C_F":
    
        mesg2 = "  > PRES_CONF   = "
        mesg3 = "  > SIGM_IMPOSE = "
        
    elif type_essai == "TRIA_DR_C_D":
    
        mesg2 = "  > PRES_CONF        = "
        mesg3 = "  > EPSI_MINI_IMPOSE = "
        mesg4 = "  > EPSI_MAXI_IMPOSE = "
        
    elif type_essai == "TRIA_ND_C_D":
    
        mesg2 = "  > PRES_CONF        = "
        mesg3 = "  > EPSI_MINI_IMPOSE = "
        mesg4 = "  > EPSI_MAXI_IMPOSE = "

    elif type_essai == "OEDO_DR_C_F":
    
        mesg2 = "  > PRES_CONF   = "
        mesg3 = "  > SIGM_IMPOSE = "
        mesg4 = "  > SIGM_DECH   = "
        
    elif type_essai == "ISOT_DR_C_F":
    
        mesg2 = "  > PRES_CONF   = "
        mesg3 = "  > SIGM_IMPOSE = "
        mesg4 = "  > SIGM_DECH   = "
    # Pour nouvel essai
    # elif type_essai == "XXX":
        # mesg2 = "  > PRES_CONF = "
        # mesg3 = "  > XXX       = "
    else:
        assert False

    mesg2 += str("%E" %(val_PRES_CONF)) + " "
    
    if val2 < 0.:
        mesg3 += str("%E" %(val2)) + " "
    else:
        mesg3 += " " + str("%E" %(val2)) + " "
    if val3 == 0.:
        mesg4 = ""
    else:
        mesg4 += str("%E" %(val3)) + " "

    lonmax = max(len(mesg2), len(mesg3), len(mesg4))
    lonmax = max(len(mesg1), lonmax)

    separ1 = "\n  "
    separ2 = "-" * (lonmax+2)
    separ3 = "|"

    mesg = separ1
    mesg+= separ2 + separ1
    mesg+= separ3 + mesg1 + " " * (lonmax - len(mesg1)) + separ3 + separ1
    mesg+= separ2 + separ1
    mesg+= separ3 + mesg2 + " " * (lonmax - len(mesg2)) + separ3 + separ1
    mesg+= separ3 + mesg3 + " " * (lonmax - len(mesg3)) + separ3 + separ1
    
    if len(mesg4) != 0:
        mesg += separ3 + mesg4 +\
                " " * (lonmax-len(mesg4)) + separ3 + separ1
    mesg += separ2

    aster.affiche('MESSAGE', mesg)


# --------------------------------------------------------------
# -Debut--------------------------------------------------------
# --------------------------------------------------------------
def verif_essais(COMPORTEMENT,
                 ESSAI_TRIA_DR_M_D,
                 ESSAI_TRIA_ND_M_D,
                 ESSAI_CISA_DR_C_D,
                 ESSAI_TRIA_ND_C_F,
                 ESSAI_TRIA_ND_C_D,
                 ESSAI_TRIA_DR_C_D,
                 ESSAI_OEDO_DR_C_F,
                 ESSAI_ISOT_DR_C_F,):
                 # ESSAI_XXX,):
    """
    Objet: Verification de certaines donnees d'entree de la macro
           ne pouvant etre faites dans le catalogue
    """
    from Utilitai.Utmess import UTMESS

    List_essais = []

    # --------------------------------------------------------------
    # Verifications specifiques a chaque type d'essai
    # --------------------------------------------------------------

    # ---
    # Essai TRIA_DR_M_D
    # ---
    if ESSAI_TRIA_DR_M_D != None:

        typ_essai   = "ESSAI_TRIA_DR_M_D"
        List_essais+= ESSAI_TRIA_DR_M_D.List_F()

        for iocc, DicoEssai in enumerate(ESSAI_TRIA_DR_M_D.List_F()):

            # Le "bon" nombre d'elements a-t-il ete renseigne pr les Mot-Cles simples
            # PRES_CONF, EPSI_IMPOSE, TABLE_RESU ?
            # ------------------------------------------------------------------------
            char = "<PRES_CONF>, <EPSI_IMPOSE>"
            test = len(DicoEssai['PRES_CONF']) == len(DicoEssai['EPSI_IMPOSE'])
            
            if DicoEssai.has_key('TABLE_RESU'):
            
                char += ", <TABLE_RESU>"
                
                test = test and\
                       (len(DicoEssai['PRES_CONF']) == len(DicoEssai['TABLE_RESU']))
                    
            if not test:
                UTMESS('F', 'COMPOR2_31', valk=(typ_essai, char), vali=(iocc + 1))

            # on s'assure que tous les PRES_CONF et EPSI_IMPOSE sont bien > 0.
            # ------------------------------------------------------------------------
            for i in xrange(len(DicoEssai['PRES_CONF'])):
            
                if DicoEssai['PRES_CONF'][i] <= 0.:
                
                    UTMESS('F', 'COMPOR2_32',
                        valk=(typ_essai, "PRES_CONF",),
                        vali=(iocc+1),
                        valr=(DicoEssai['PRES_CONF'][i]))
                        
                if DicoEssai['EPSI_IMPOSE'][i] == 0.:
                
                    UTMESS('F', 'COMPOR2_32',
                        valk=(typ_essai, "EPSI_IMPOSE"),
                        vali=(iocc+1),
                        valr=(DicoEssai['EPSI_IMPOSE'][i]))
                        
            # on s'assure que KZERO est > 0
            # ------------------------------------------------------------------------
            if DicoEssai['KZERO'] <= 0.:
            
                UTMESS('F', 'COMPOR2_34',
                       valk=(typ_essai, "KZERO"),
                       valr=(DicoEssai['KZERO']),
                       vali=(iocc+1))
    # ---
    # Essai TRIA_ND_M_D
    # ---
    if ESSAI_TRIA_ND_M_D != None:

        typ_essai    = "ESSAI_TRIA_ND_M_D"
        List_essais += ESSAI_TRIA_ND_M_D.List_F()

        for iocc, DicoEssai in enumerate(ESSAI_TRIA_ND_M_D.List_F()):

            # Le "bon" nbre d'elts a-t-il ete renseigne pr les MotCles simples
            # -> PRES_CONF, EPSI_IMPOSE, TABLE_RESU ?
            # ------------------------------------------------------------------------
            char = "<PRES_CONF>, <EPSI_IMPOSE>"
            test = len(DicoEssai['PRES_CONF']) == len(DicoEssai['EPSI_IMPOSE'])
            
            if DicoEssai.has_key('TABLE_RESU'):
            
                char += ", <TABLE_RESU>"
                test = test and\
                   len(DicoEssai['PRES_CONF']) == len(DicoEssai['TABLE_RESU'])
                    
            if not test:
                UTMESS('F', 'COMPOR2_31',
                       valk=(typ_essai, char),
                       vali=(iocc+1))

            # on s'assure que tous les PRES_CONF et EPSI_IMPOSE sont bien > 0.
            # ------------------------------------------------------------------------
            for i in xrange(len(DicoEssai['PRES_CONF'])):
            
                if DicoEssai['PRES_CONF'][i] == 0.:
                
                    UTMESS('F', 'COMPOR2_32',
                           valk=(typ_essai, "PRES_CONF"),
                           valr=(DicoEssai['PRES_CONF'][i]),
                           vali=(iocc+1))
                           
                if DicoEssai['EPSI_IMPOSE'][i] == 0.:
                
                    UTMESS('F', 'COMPOR2_32',
                           valk=(typ_essai, "EPSI_IMPOSE"),
                           valr=(DicoEssai['EPSI_IMPOSE'][i]),
                           vali=(iocc+1))
                           
            # on s'assure que 0. < BIOT_COEF <= 1
            # ------------------------------------------------------------------------
            biot = DicoEssai['BIOT_COEF']
            if biot <= 0. or biot > 1.:
            
                UTMESS('F', 'COMPOR2_33',
                       valk=(typ_essai),
                       valr=(biot),
                       vali=(iocc+1))
                       
            # on s'assure que KZERO est > 0
            # ------------------------------------------------------------------------
            if DicoEssai['KZERO'] <= 0.:
            
                UTMESS('F', 'COMPOR2_34',
                       valk=(typ_essai, "KZERO"),
                       valr=(DicoEssai['KZERO']),
                       vali=(iocc+1))
    # ---
    # Essai CISA_DR_C_D
    # ---
    if ESSAI_CISA_DR_C_D != None:

        typ_essai    = "ESSAI_CISA_DR_C_D"
        List_essais += ESSAI_CISA_DR_C_D.List_F()

        for iocc, DicoEssai in enumerate(ESSAI_CISA_DR_C_D.List_F()):

            # coherence du nbre de TABLE_RESU avec le nbre de PRES_CONF
            # ------------------------------------------------------------------------
            if DicoEssai.has_key('TABLE_RESU'):
            
                n1 = len(DicoEssai['PRES_CONF'])
                n2 = len(DicoEssai['TABLE_RESU'])
                
                if not n2 == n1+1:
                
                    UTMESS('F', 'COMPOR2_35',
                           valk=(typ_essai),
                           vali=(iocc+1, n1, n1+1, n2))

            # on s'assure que KZERO est > 0
            # ------------------------------------------------------------------------
            if DicoEssai['KZERO'] <= 0.:
            
                UTMESS('F', 'COMPOR2_34',
                       valk=(typ_essai, "KZERO"),
                       valr=(DicoEssai['KZERO']),
                       vali=(iocc+1))

            # on s'assure que tous les PRES_CONF sont bien > 0.
            # ------------------------------------------------------------------------
            for pconf in DicoEssai['PRES_CONF']:
            
                if pconf <= 0.:
                    UTMESS('F', 'COMPOR2_32',
                           valk=(typ_essai, "PRES_CONF"),
                           valr=(pconf),
                           vali=(iocc+1))
                           
            # on s'assure que tous les GAMMA_IMPOSE,GAMMA_ELAS sont bien > 0.
            # ------------------------------------------------------------------------
            for epsimpo in DicoEssai['GAMMA_IMPOSE']:
            
                if epsimpo <= 0.:
                    UTMESS('F', 'COMPOR2_34',
                           valk=(typ_essai, "GAMMA_IMPOSE"),
                           valr=(epsimpo),
                           vali=(iocc+1))
                           
            if DicoEssai['GAMMA_ELAS'] <= 0.:
            
                UTMESS('F', 'COMPOR2_34',
                       valk=(typ_essai, "GAMMA_ELAS"),
                       valr=(DicoEssai['GAMMA_ELAS']),
                       vali=(iocc+1))

            # on s'assure que la liste des GAMMA_IMPOSE est croissante
            # ------------------------------------------------------------------------
            clef = 'GAMMA_IMPOSE'
            list_tmp = list(DicoEssai[clef])
            list_tmp.sort()
            
            if not(DicoEssai[clef] == tuple(list_tmp)):
            
                UTMESS('F', 'COMPOR2_38',
                    valk=(typ_essai, clef, ListR_2_Str(DicoEssai[clef]), "croissante"),
                    vali=(iocc+1))
    # ---
    # Essai TRIA_ND_C_F
    # ---
    if ESSAI_TRIA_ND_C_F != None:

        typ_essai    = "ESSAI_TRIA_ND_C_F"
        List_essais += ESSAI_TRIA_ND_C_F.List_F()

        for iocc, DicoEssai in enumerate(ESSAI_TRIA_ND_C_F.List_F()):

            # coherence du nbre de TABLE_RESU avec le nbre de PRES_CONF
            # ------------------------------------------------------------------------
            if DicoEssai.has_key('TABLE_RESU'):
            
                n1 = len(DicoEssai['PRES_CONF'])
                n2 = len(DicoEssai['TABLE_RESU'])
                
                if not n2 == n1+1:
                
                    UTMESS('F', 'COMPOR2_35', 
                        valk=(typ_essai),
                        vali=(iocc+1, n1, n1+1, n2))

            # on s'assure que SIGM_IMPOSE > 0.
            # ------------------------------------------------------------------------
            #
            # 06 oct. 2018: on permet de commencer a charger en traction
            # ============
            # ------------------------------------------------------------------------
#             for sigimpo in DicoEssai['SIGM_IMPOSE']:
#             
#                 if sigimpo <= 0.:
#                     UTMESS('F', 'COMPOR2_34',
#                            valk=(typ_essai, "SIGM_IMPOSE"),
#                            valr=(sigimpo),
#                            vali=(iocc+1))
                           
            # on s'assure que PRES_CONF > 0. et PRES_CONF+SIGM_IMPOSE < 0.
            # ------------------------------------------------------------------------
            for pconf in DicoEssai['PRES_CONF']:
            
                if pconf <= 0.:
                    UTMESS('F', 'COMPOR2_32',
                           valk=(typ_essai, "PRES_CONF"),
                           valr=(pconf),
                           vali=(iocc+1))
#                            
#                 for sigimpo in DicoEssai['SIGM_IMPOSE']:
#                 
#                     if pconf+sigimpo >= 0.:
#                         UTMESS('F', 'COMPOR2_37',
#                                valk=(typ_essai),
#                                vali=(iocc+1),
#                                valr=(pconf, sigimpo, pconf+sigimpo))
                               
            # on s'assure que KZERO et UN_SUR_K sont > 0. et 0. < BIOT_COEF <= 1
            # ------------------------------------------------------------------------
            if DicoEssai['UN_SUR_K'] <= 0.:
            
                UTMESS('F', 'COMPOR2_34',
                       valk=(typ_essai, "UN_SUR_K"),
                       valr=(DicoEssai['UN_SUR_K']),
                       vali=(iocc+1))
                       
            if DicoEssai['KZERO'] <= 0.:
            
                UTMESS('F', 'COMPOR2_34',
                       valk=(typ_essai, "KZERO"),
                       valr=(DicoEssai['KZERO']),
                       vali=(iocc+1))
                       
            biot = DicoEssai['BIOT_COEF']
            
            if biot <= 0. or biot > 1.:
            
                UTMESS('F', 'COMPOR2_33',
                       valk=(typ_essai),
                       valr=(biot),
                       vali=(iocc+1))

            # on s'assure que 0. < RU_MAX <= 1
            # ------------------------------------------------------------------------
            n1 = len(DicoEssai['CRIT_LIQUEFACTION'])
            n2 = len(DicoEssai['VALE_CRIT'])
            
            if n1 != n2:
            
               UTMESS('F', 'COMPOR2_35', valk=(typ_essai),
                        vali=(iocc+1, n1, n1, n2))
                       
            for i,t in enumerate(DicoEssai['CRIT_LIQUEFACTION']):
            
               if t == 'RU_MAX':
               
                  if DicoEssai['VALE_CRIT'][i] <= 0. or DicoEssai['VALE_CRIT'][i] > 1.:
            
                     UTMESS('F', 'COMPOR2_33',
                       valk=(typ_essai, t),
                       valr=(DicoEssai['VALE_CRIT'][i]),
                       vali=(iocc+1))
                       
               elif t == 'EPSI_ABS0_MAX':
               
                  if DicoEssai['VALE_CRIT'][i] < -.5 or DicoEssai['VALE_CRIT'][i] > .5:
            
                     UTMESS('F', 'COMPOR2_33',
                       valk=(typ_essai, t),
                       valr=(DicoEssai['VALE_CRIT'][i]),
                       vali=(iocc+1))
                       
               elif t == 'EPSI_RELA_MAX':
               
                  if DicoEssai['VALE_CRIT'][i] <= 0. or DicoEssai['VALE_CRIT'][i] > .5:
            
                     UTMESS('F', 'COMPOR2_33',
                       valk=(typ_essai, t),
                       valr=(DicoEssai['VALE_CRIT'][i]),
                       vali=(iocc+1))

            # on s'assure que la liste des SIGM_IMPOSE est croissante
            # ------------------------------------------------------------------------
            clef = 'SIGM_IMPOSE'
            list_tmp = list(DicoEssai[clef])
            list_tmp.sort()
            
            if not(DicoEssai[clef] == tuple(list_tmp)):
            
                UTMESS('F', 'COMPOR2_38',
                    valk=(typ_essai, clef, ListR_2_Str(DicoEssai[clef]), "croissante"),
                    vali=(iocc+1))
    # ---
    # Essai TRIA_DR_C_D
    # ---
    if ESSAI_TRIA_DR_C_D != None:

        typ_essai    = "ESSAI_TRIA_DR_C_D"
        List_essais += ESSAI_TRIA_DR_C_D.List_F()

        for iocc, DicoEssai in enumerate(ESSAI_TRIA_DR_C_D.List_F()):

            # coherence du nbre de TABLE_RESU avec le nbre de PRES_CONF
            # ------------------------------------------------------------------------
            if DicoEssai.has_key('TABLE_RESU'):
            
                n1 = len(DicoEssai['PRES_CONF'])
                n2 = len(DicoEssai['TABLE_RESU'])
                
                if not n2 == n1+1:
                    UTMESS('F', 'COMPOR2_35',
                           valk=(typ_essai),
                           vali=(iocc+1, n1, n1+1, n2))

            # on s'assure que:
            # * len (EPSI_MAXI) = len(EPSI_MINI)
            # * EPSI_MAXI > EPSI_MINI
            # * EPSI_ELAS sont > 0.
            # ------------------------------------------------------------------------
            n1 = len(DicoEssai['EPSI_MAXI'])
            n2 = len(DicoEssai['EPSI_MINI'])
                
            if n2 != n1:
               UTMESS('F', 'COMPOR2_35',
                      valk=(typ_essai),
                      vali=(iocc+1, n1, n1, n2))
                           
            for j,epsmaxi in enumerate(DicoEssai['EPSI_MAXI']):
            
                epsmini = DicoEssai['EPSI_MINI'][j]
                
                if epsmaxi <= epsmini:
                
                    UTMESS('F', 'COMPOR2_34',
                           valk=(typ_essai, "EPSI_MAXI-EPSI_MINI"),
                           valr=(epsmaxi-epsmini), 
                           vali=(iocc+1))
                           
            if DicoEssai['EPSI_ELAS'] <= 0.:
            
                UTMESS('F', 'COMPOR2_34',
                       valk=(typ_essai, "EPSI_ELAS"),
                       valr=(DicoEssai['EPSI_ELAS']),
                       vali=(iocc+1))

            # on s'assure que PRES_CONF < 0.
            # ------------------------------------------------------------------------
            for pconf in DicoEssai['PRES_CONF']:
            
                if pconf <= 0.:
                
                    UTMESS('F', 'COMPOR2_32',
                           valk=(typ_essai, "PRES_CONF"),
                           valr=(pconf),
                           vali=(iocc+1))

            # on s'assure que la liste des EPSI_IMPOSE est DECROISSANTE
            # ------------------------------------------------------------------------
# M. Jaquet souhaite nelever cette condition
#
#             clef = 'EPSI_MINI'
#             list_tmp = list(DicoEssai[clef])
#             list_tmp.sort()
#             #list_tmp.reverse()
#             
#             if not(DicoEssai[clef] == tuple(list_tmp)):
#             
#                 UTMESS('F', 'COMPOR2_38',
#                     valk=(typ_essai, clef, ListR_2_Str(DicoEssai[clef]), "decroissante"),
#                     vali=(iocc+1))

            # on s'assure que KZERO est > 0
            # ------------------------------------------------------------------------
            if DicoEssai['KZERO'] <= 0.:
            
                UTMESS('F', 'COMPOR2_34',
                       valk=(typ_essai, "KZERO"),
                       valr=(DicoEssai['KZERO']),
                       vali=(iocc+1))
    # ---
    # Essai TRIA_ND_C_D
    # ---
    if ESSAI_TRIA_ND_C_D != None:

        typ_essai    = "ESSAI_TRIA_ND_C_D"
        List_essais += ESSAI_TRIA_ND_C_D.List_F()

        for iocc, DicoEssai in enumerate(ESSAI_TRIA_ND_C_D.List_F()):

            # coherence du nbre de TABLE_RESU avec le nbre de PRES_CONF
            # ------------------------------------------------------------------------
            if DicoEssai.has_key('TABLE_RESU'):
            
                n1 = len(DicoEssai['PRES_CONF'])
                n2 = len(DicoEssai['TABLE_RESU'])
                
                if not n2 == n1+1:
                    UTMESS('F', 'COMPOR2_35',
                           valk=(typ_essai),
                           vali=(iocc+1, n1, n1+1, n2))

            # on s'assure que:
            # * len (EPSI_MAXI) = len(EPSI_MINI)
            # * EPSI_MAXI > EPSI_MINI
            # * EPSI_ELAS sont > 0.
            # ------------------------------------------------------------------------
            n1 = len(DicoEssai['EPSI_MAXI'])
            n2 = len(DicoEssai['EPSI_MINI'])
                
            if n2 != n1:
               UTMESS('F', 'COMPOR2_35',
                      valk=(typ_essai),
                      vali=(iocc+1, n1, n1, n2))
                           
            for j,epsmaxi in enumerate(DicoEssai['EPSI_MAXI']):
            
                epsmini = DicoEssai['EPSI_MINI'][j]
                
                if epsmaxi <= epsmini:
                
                    UTMESS('F', 'COMPOR2_34',
                           valk=(typ_essai, "EPSI_MAXI-EPSI_MINI"),
                           valr=(epsmaxi-epsmini), 
                           vali=(iocc+1))

            # on s'assure que PRES_CONF < 0.
            # ------------------------------------------------------------------------
            for pconf in DicoEssai['PRES_CONF']:
            
                if pconf <= 0.:
                
                    UTMESS('F', 'COMPOR2_32',
                           valk=(typ_essai, "PRES_CONF"),
                           valr=(pconf),
                           vali=(iocc+1))

            # on s'assure que la liste des EPSI_IMPOSE est DECROISSANTE
            # ------------------------------------------------------------------------
# M. Jacquet: souhaite enlever cette condition
#
#             clef = 'EPSI_MINI'
#             list_tmp = list(DicoEssai[clef])
#             list_tmp.sort()
#             #list_tmp.reverse()
#             
#             if not(DicoEssai[clef] == tuple(list_tmp)):
#             
#                 UTMESS('F', 'COMPOR2_38',
#                     valk=(typ_essai, clef, ListR_2_Str(DicoEssai[clef]), "decroissante"),
#                     vali=(iocc+1))

            # on s'assure que KZERO est > 0
            # ------------------------------------------------------------------------
            if DicoEssai['KZERO'] <= 0.:
            
                UTMESS('F', 'COMPOR2_34',
                       valk=(typ_essai, "KZERO"),
                       valr=(DicoEssai['KZERO']),
                       vali=(iocc+1))
    # ---
    # Essai OEDO_DR_C_F
    # ---
    if ESSAI_OEDO_DR_C_F != None:

        typ_essai    = "ESSAI_OEDO_DR_C_F"
        List_essais += ESSAI_OEDO_DR_C_F.List_F()

        for iocc, DicoEssai in enumerate(ESSAI_OEDO_DR_C_F.List_F()):

            # Le "bon" nbre d'elts a-t-il ete renseigne pr les MotCles simples
            # -> PRES_CONF, SIGM_DECH, TABLE_RESU ?
            # ------------------------------------------------------------------------
            char = "<PRES_CONF>, <SIGM_DECH>"
            test = len(DicoEssai['PRES_CONF']) == len(DicoEssai['SIGM_DECH'])
            
            if DicoEssai.has_key('TABLE_RESU'):
            
                char += ", <TABLE_RESU>"
                test = test and\
                       len(DicoEssai['PRES_CONF']) == len(DicoEssai['TABLE_RESU'])
                       
            if not test:
            
                UTMESS('F', 'COMPOR2_31',
                       valk=(typ_essai, char),
                       vali=(iocc+1))

            # on s'assure que SIGM_IMPOSE < 0.
            # ------------------------------------------------------------------------
#             for sigimpo in DicoEssai['SIGM_IMPOSE']:
#             
#                 if sigimpo <= 0.:
#                     UTMESS('F', 'COMPOR2_32',
#                            valk=(typ_essai, "SIGM_IMPOSE"),
#                            valr=(sigimpo),
#                            vali=(iocc+1))

            # on s'assure que tous les PRES_CONF et SIGM_DECH sont bien < 0. et que
            # PRES_CONF+SIGM_IMPOSE < =SIGM_DECH
            # ------------------------------------------------------------------------
            for j,pconf in enumerate(DicoEssai['PRES_CONF']):
            
                if pconf <= 0.:
                
                    UTMESS('F', 'COMPOR2_32',
                           valk=(typ_essai, "PRES_CONF"),
                           valr=(pconf),
                           vali=(iocc+1))

                sdech = DicoEssai['SIGM_DECH'][j]
                
                if sdech <= 0.:
                
                    UTMESS('F', 'COMPOR2_32',
                           valk=(typ_essai, "SIGM_DECH"),
                           valr=(sdech),
                           vali=(iocc+1))
                
                for sigimpo in DicoEssai['SIGM_IMPOSE']:
                
                    #if pconf+sigimpo < sdech:
                    if sigimpo < sdech:
                    
                        UTMESS('F', 'COMPOR2_47',
                               valk=(typ_essai),
                               vali=(iocc+1),
                               valr=(pconf, sigimpo, pconf+sigimpo, sdech))

            # on s'assure que la liste des SIGM_IMPOSE est décroissante
            # ------------------------------------------------------------------------
#             clef = 'SIGM_IMPOSE'
#             list_tmp = list(DicoEssai[clef])
#             list_tmp.sort(reverse=True)
#             
#             if not(DicoEssai[clef] == tuple(list_tmp)):
#             
#                 UTMESS('F', 'COMPOR2_38',
#                     valk=(typ_essai, clef, ListR_2_Str(DicoEssai[clef]), "décroissante"),
#                     vali=(iocc+1))

            # on s'assure que KZERO est > 0
            # ------------------------------------------------------------------------
            if DicoEssai['KZERO'] <= 0.:
            
                UTMESS('F', 'COMPOR2_34',
                       valk=(typ_essai, "KZERO"),
                       valr=(DicoEssai['KZERO']),
                       vali=(iocc+1))
    # ---
    # Essai ISOT_DR_C_F
    # ---
    if ESSAI_ISOT_DR_C_F != None:

        typ_essai    = "ESSAI_ISOT_DR_C_F"
        List_essais += ESSAI_ISOT_DR_C_F.List_F()

        for iocc, DicoEssai in enumerate(ESSAI_ISOT_DR_C_F.List_F()):

            # Le "bon" nbre d'elts a-t-il ete renseigne pr les MotCles simples
            # -> PRES_CONF, SIGM_DECH, TABLE_RESU ?
            # ------------------------------------------------------------------------
            char = "<PRES_CONF>, <SIGM_DECH>"
            test = len(DicoEssai['PRES_CONF']) == len(DicoEssai['SIGM_DECH'])
            
            if DicoEssai.has_key('TABLE_RESU'):
            
                char += ", <TABLE_RESU>"
                test = test and\
                   len(DicoEssai['PRES_CONF']) == len(DicoEssai['TABLE_RESU'])
                    
            if not test:
                UTMESS('F', 'COMPOR2_31',
                       valk=(typ_essai, char),
                       vali=(iocc+1))

            # on s'assure que SIGM_IMPOSE < 0.
            # ------------------------------------------------------------------------
            for sigimpo in DicoEssai['SIGM_IMPOSE']:
                if sigimpo <= 0.:
                    UTMESS('F', 'COMPOR2_32',
                           valk=(typ_essai, "SIGM_IMPOSE"),
                           valr=(sigimpo),
                           vali=(iocc+1))

            # on s'assure que tous les PRES_CONF sont bien < 0. et que
            # PRES_CONF+SIGM_IMPOSE <= SIGM_DECH
            # ------------------------------------------------------------------------
            for pconf in DicoEssai['PRES_CONF']:
            
                if pconf <= 0.:
                
                    UTMESS('F', 'COMPOR2_32',
                           valk=(typ_essai, "PRES_CONF"),
                           valr=(pconf),
                           vali=(iocc+1))

                sdech = DicoEssai['SIGM_DECH'][DicoEssai['PRES_CONF'].index(pconf)]
                
                for sigimpo in DicoEssai['SIGM_IMPOSE']:
                
                    if pconf+sigimpo < sdech:
                    
                        UTMESS('F', 'COMPOR2_47',
                               valk=(typ_essai),
                               vali=(iocc+1),
                               valr=(pconf, sigimpo, pconf+sigimpo, sdech))

            # on s'assure que la liste des SIGM_IMPOSE est décroissante
            # ------------------------------------------------------------------------
#             clef = 'SIGM_IMPOSE'
#             list_tmp = list(DicoEssai[clef])
#             list_tmp.sort(reverse=True)
#             
#             if not(DicoEssai[clef] == tuple(list_tmp)):
#             
#                 UTMESS('F', 'COMPOR2_38',
#                     valk=(typ_essai, clef, ListR_2_Str(DicoEssai[clef]), "décroissante"),
#                     vali=(iocc+1))
    # ---
    # Essai "XXX"
    # ---
    # if ESSAI_XXX != None :
    #
    #  typ_essai    = "ESSAI_XXX"
    #  List_essais += ESSAI_XXX.List_F() ...
    # --------------------------------------------------------------
    #
    # Verification coherence des MCS GRAPHIQUE/TABLE_REF (tout type d'essai)
    #
    # --------------------------------------------------------------
    for DicoEssai in List_essais:
    
        if DicoEssai.has_key('TABLE_REF'):
        
            for table_tmp in DicoEssai['TABLE_REF']:

                # on s'assure chaque TABLE_REF est bien construite...
                # ------------------------------------------------------------------------
                table_ref = table_tmp.EXTR_TABLE().values()
                nom_tbref = table_tmp.nom

                list_paras = ['TYPE','LEGENDE','ABSCISSE','ORDONNEE']
                
                if not set(table_ref.keys()) == set(list_paras):
                
                    UTMESS('F', 'COMPOR2_44',
                           valk=(nom_tbref, SomListStr(table_ref.keys())))
                        
                typc = table_ref['TYPE']
                logi_typc = [x == None for x in typc]
                logi_typc[0] = type(typc[0]) is str
                
                if not logi_typc == [True] * len(typc):
                    UTMESS('F', 'COMPOR2_45', valk=(nom_tbref, 'TYPE'))
                    
                lege = table_ref['LEGENDE']
                logi_lege = [x == None for x in lege]
                logi_lege[0] = type(lege[0]) is str
                
                if not logi_lege == [True] * len(lege):
                    UTMESS('F', 'COMPOR2_45', valk=(nom_tbref, 'LEGENDE'))
                    
                absc = table_ref['ABSCISSE']
                ordo = table_ref['ORDONNEE']
                logi_absc = [type(x) is float for x in absc]
                logi_ordo = [type(x) is float for x in ordo]
                test = len(absc) == len(ordo)
                test = test and logi_absc == [True] * len(absc)
                test = test and logi_ordo == [True] * len(absc)
                
                if not test:
                    UTMESS('F', 'COMPOR2_46', valk=(nom_tbref))

                # on s'assure que le TYPE indique dans chaque TABLE_REF figure bien dans
                # la liste des GRAPHIQUE demandes en sortie pour l'esssai courant
                # ------------------------------------------------------------------------
                if not typc[0].replace(" ", "") in DicoEssai['GRAPHIQUE']:
                    UTMESS('F', 'COMPOR2_43',
                        valk=(nom_tbref, typc[0],SomListStr(DicoEssai['GRAPHIQUE'])))


# --------------------------------------------------------------
# -Debut--------------------------------------------------------
# --------------------------------------------------------------
def affiche_alarm_TRIA_ND_C_F(str_n_essai, pres, dsig, codret, NB_CYCLE, \
                              ncycrit, ncyerro):
    """
    Objet: Gestionnaire des alarmes pour l'essai TRIA_ND_C_F
    
           codret = | 0 : CALC_POINT_MAT va jusqu'au bout et critere atteint -> pas d'alarme
                    | 1 : CALC_POINT_MAT va jusqu'au bout et critere non atteint
                    | 2 : CALC_POINT_MAT s'arrete en NonConvergenceError et critere atteint
                    | 3 : CALC_POINT_MAT s'arrete en NonConvergenceError et critere non atteint
    """
    from Utilitai.Utmess import UTMESS

    assert codret in ['0', '1', '2', '3']
    
    charg1 = str("%E" % (pres))
    charg2 = str("%E" % (dsig))

    nom_essai = "TRIA_ND_C_F"

    kval_char1 = "  > PRES_CONF   = " + charg1 + "\n"
    kval_char2 = "  > SIGM_IMPOSE = " + charg2 + "\n"
    kval_cycl  = "  > NB_CYCLE    = " + str(NB_CYCLE) + "\n"

    Lk = [nom_essai, str_n_essai, kval_char1, kval_char2, kval_cycl]

    if codret == '1':
        UTMESS('A', 'COMPOR2_40', valk=Lk, vali=NB_CYCLE)
        
    elif codret == '2':
        UTMESS('A', 'COMPOR2_41', valk=Lk, vali=(ncyerro, ncycrit))
        
    elif codret == '3':
        UTMESS('A', 'COMPOR2_42', valk=Lk, vali=ncyerro)


# --------------------------------------------------------------
# -Debut--------------------------------------------------------
# --------------------------------------------------------------
def preparer_graphique(niveau, DicoEssai, str_fich, Courbes, NomsFich,\
                       Leg_x, Leg_y, Ech_x, Ech_y,):
    """
    Objet: Formatter les graphiques a imprimer dans XMGRACE
    
           * Le nom des graphiques a la forme generale suivante:
             
             <nom_essai>_<DR,ND>_<M,C>_<D,F>_<nb_fact>_<CONFniv1>_<paray-parax>.agr
             
             - <nom_essai> = | TRIA
                             | CISA
                             | OEDO
                             | ISOT
             
             - <DR,ND>     = | DR  : draine
                             | ND  : non draine
             
             - <M,C>       = | M   : monotone
                             | C   : cyclique
             
             - <D,F>       = | D   : deformation/deplacement impose
                             | F   : contrainte/force imposee
             
             - <nb_fact>   = integer   : numero de l'occurence _F() de l'essai
                                  
                             ne s'affiche que si la liste ses mot-cle facteurs est > 1
             
             - <CONFniv1>  = "CONF%d" %(integer)   : numero de l'essai de niveau 1
                                  
                             ne s'affiche que si la liste des confinements est > 1
             
             - <paray-parax>    = | paray   : parametre figurant en ordonnee
                                  | parax   : parametre figurant en abscisse
                                  
                                  le separateur est un tiret
                                  
           * Le nom des graphiques est en minuscules
           
    ENTREE :  * niveau
    
              * DicoEssai
              
              * str_fich
              
              
    SORTIE :  * Courbes
    
              * NomsFich
              
              * Leg_x  Leg_y
              
              * Ech_x  Ech_y
    """

    ext              =".agr"
    list_cmp_niveau1 =('G_SUR_GMAX','DAMPING','NCYCL','DSIGM','DEPSI',
                       'E_SUR_EMAX','RU_MAX','E_SUR_EMAX',)

    # Courbes NIVEAU 1 recapitulatives pour les essais cycliques
    # --------------------------------------------------------------
    if niveau == '1':
    
        for TypGraph in DicoEssai['GRAPHIQUE']:
        
            nom_fichier =str_fich + TypGraph + ext
            nom_fichier =nom_fichier.lower()
        
            if TypGraph == "GAMMA-G_SUR_GMAX":
                Courbes[TypGraph] = []
                NomsFich[TypGraph] = nom_fichier
                Leg_x[TypGraph] = "GAMMA = 2*EPXY"
                Leg_y[TypGraph] = "G / GMAX"
                Ech_x[TypGraph] = "LOG"
                Ech_y[TypGraph] = "LIN"
                
            elif TypGraph == "GAMMA-DAMPING":
                Courbes[TypGraph] = []
                NomsFich[TypGraph] = nom_fichier
                Leg_x[TypGraph] = "GAMMA"
                Leg_y[TypGraph] = "AMOR HYST."
                Ech_x[TypGraph] = "LOG"
                Ech_y[TypGraph] = "LIN"
                
            elif TypGraph == "DEPSI-DAMPING":
                Courbes[TypGraph] = []
                NomsFich[TypGraph] = nom_fichier
                Leg_x[TypGraph] = "EPSI_IMPOSE = EPSI_MAX-EPSI_MIN"
                Leg_y[TypGraph] = "AMOR HYST."
                Ech_x[TypGraph] = "LOG"
                Ech_y[TypGraph] = "LIN"
                
            elif TypGraph == "DEPSI-E_SUR_EMAX":
                Courbes[TypGraph] = []
                NomsFich[TypGraph] = nom_fichier
                Leg_x[TypGraph] = "EPSI_IMPOSE = EPSI_MAX-EPSI_MIN"
                Leg_y[TypGraph] = "E / EMAX"
                Ech_x[TypGraph] = "LOG"
                Ech_y[TypGraph] = "LIN"
                
            elif TypGraph == "G_SUR_GMAX-DAMPING":
                Courbes[TypGraph] = []
                NomsFich[TypGraph] = nom_fichier
                Leg_x[TypGraph] = "G / GMAX"
                Leg_y[TypGraph] = "AMOR HYST."
                Ech_x[TypGraph] = "LIN"
                Ech_y[TypGraph] = "LIN"
                
            elif TypGraph == "NCYCL-DSIGM":
                Courbes[TypGraph] = []
                NomsFich[TypGraph] = nom_fichier
                Leg_x[TypGraph] = "NB CYCLES"
                Leg_y[TypGraph] = "CRR = DSIGM/P0"
                
            elif TypGraph == "NCYCL-DEPSI":
                Courbes[TypGraph] = []
                NomsFich[TypGraph] = nom_fichier
                Leg_x[TypGraph] = "NB CYCLES"
                Leg_y[TypGraph] = "EPSI_IMPOSE = EPSI_MAX-EPSI_MIN"
                Ech_x[TypGraph] = "LIN"
                Ech_y[TypGraph] = "LOG"
                
            elif TypGraph == "DEPSI-RU_MAX":
                Courbes[TypGraph] = []
                NomsFich[TypGraph] = nom_fichier
                Leg_x[TypGraph] = "EPSI_IMPOSE = EPSI_MAX-EPSI_MIN"
                Leg_y[TypGraph] = "RU_MAX"
                Ech_x[TypGraph] = "LOG"
                Ech_y[TypGraph] = "LIN"
                
            # if TypGraph == "XXX" :
                # Courbes[TypGraph]  = []
                # NomsFich[TypGraph] = str_fich+TypGraph+ext
                # Leg_x[TypGraph]    = "XXX"
                # Leg_y[TypGraph]    = "XXX"

    # Courbes NIVEAU2 pour chaque valeurs chargement
    # ---------------------------------------------------------
    elif niveau == '2':
    
        for TypGraph in DicoEssai['GRAPHIQUE']:
        
            nom_fichier =str_fich + TypGraph + ext
            nom_fichier =nom_fichier.lower()
        
            if TypGraph == "P-Q":
                Courbes[TypGraph] = []
                NomsFich[TypGraph] = nom_fichier
                Leg_x[TypGraph] = "PISO"
                Leg_y[TypGraph] = "QDEV"
                
            elif TypGraph == "EPS_AXI-Q":
                Courbes[TypGraph] = []
                NomsFich[TypGraph] = nom_fichier
                Leg_x[TypGraph] = "EPS_AXI"
                Leg_y[TypGraph] = "QDEV"
                
            elif TypGraph == "EPS_VOL-Q":
                Courbes[TypGraph] = []
                NomsFich[TypGraph] = nom_fichier
                Leg_x[TypGraph] = "EPS_VOL"
                Leg_y[TypGraph] = "QDEV"
                
            elif TypGraph == "EPS_AXI-EPS_VOL":
                Courbes[TypGraph] = []
                NomsFich[TypGraph] = nom_fichier
                Leg_x[TypGraph] = "EPS_AXI"
                Leg_y[TypGraph] = "EPS_VOL"
                
            elif TypGraph == "EPS_AXI-PRE_EAU":
                Courbes[TypGraph] = []
                NomsFich[TypGraph] = nom_fichier
                Leg_x[TypGraph] = "EPS_AXI"
                Leg_y[TypGraph] = "PRE_EAU"
                
            elif TypGraph == "SIG_AXI-PRE_EAU":
                Courbes[TypGraph] = []
                NomsFich[TypGraph] = nom_fichier
                Leg_x[TypGraph] = "SIG_AXI"
                Leg_y[TypGraph] = "PRE_EAU"
                
            elif TypGraph == "P-PRE_EAU":
                Courbes[TypGraph] = []
                NomsFich[TypGraph] = nom_fichier
                Leg_x[TypGraph] = "PISO"
                Leg_y[TypGraph] = "PRE_EAU"
                
            elif TypGraph == "EPS_AXI-RU":
                Courbes[TypGraph] = []
                NomsFich[TypGraph] = nom_fichier
                Leg_x[TypGraph] = "EPS_AXI"
                Leg_y[TypGraph] = "RU"
                
            elif TypGraph == "SIG_AXI-RU":
                Courbes[TypGraph] = []
                NomsFich[TypGraph] = nom_fichier
                Leg_x[TypGraph] = "SIG_AXI"
                Leg_y[TypGraph] = "RU"
                
            elif TypGraph == "GAMMA-SIGXY":
                Courbes[TypGraph] = []
                NomsFich[TypGraph] = nom_fichier
                Leg_x[TypGraph] = "GAMMA"
                Leg_y[TypGraph] = "SIGXY"
                
            elif TypGraph == "P-EPS_VOL":
                Courbes[TypGraph] = []
                NomsFich[TypGraph] = nom_fichier
                Leg_x[TypGraph] = "PISO"
                Leg_y[TypGraph] = "EPS_VOL"
                
            elif TypGraph == "SIG_AXI-EPS_VOL":
                Courbes[TypGraph] = []
                NomsFich[TypGraph] = nom_fichier
                Leg_x[TypGraph] = "SIG_AXI"
                Leg_y[TypGraph] = "EPS_VOL"

            # elif TypGraph == "XXX" :
                # Courbes[TypGraph]  = []
                # NomsFich[TypGraph] = str_fich+TypGraph+ext
                # Leg_x[TypGraph]    = "XXX"
                # Leg_y[TypGraph]    = "XXX"
                
            else:
                
                li  = TypGraph.split('-')
          
                if len(li)==2:
                
                   impr=True
                   for c in list_cmp_niveau1:
                     if (li[0]==c) or (li[1]==c):
                       impr=False
                       break
                       
                   if impr:
                     Courbes[TypGraph] = []
                     NomsFich[TypGraph] = nom_fichier
                     Leg_x[TypGraph] = li[0]
                     Leg_y[TypGraph] = li[1]

    else:
        assert False


# --------------------------------------------------------------
# -Debut--------------------------------------------------------
# --------------------------------------------------------------
def remplir_graphique(DicoEssai, Courbes, Resu_x, Resu_y, \
                      str_leg, TypGraph_in,
                      color=-1, mark=-1, style=-1,):
    """
    Objet: Creation de la liste des courbes a tracer
    
    ENTREE: * Resu_x  : LISTE des valeurs en abscisse
    
            * Resu_y  : LISTE des valeurs en ordonnee
            
            * str_leg : TEXTE de legende
            
            * color   : choix de la couleur [Integer]
            
                        = | 0  : blanc
                          | 1  : noir
                          | 2  : rouge
                          | 3  : vert
                          | 4  : bleu
                          | 5  : jaune
                          | 6  : brun
                          | 7  : gris
                          | 8  : violet
                          | 9  : cyan
                          | 10 : magenta
                          | 11 : orange
                          | 12 : marron
                          | 13 : indigo
                          | 14 : turquoise
                          | 15 : vert fonce
                        
            * mark    : choix du marqueur   [Integer]
            
                        = | 0  : neant
                          | 1  : cercle
                          | 2  : carre
                          | 3  : losange
                          | 4  : triangle haut
                          | 5  : triangle gauche
                          | 6  : triangle bas
                          | 7  : triangle droit
                          | 8  : plus
                          | 9  : croix
                          | 10 : etoile
                        
            * style   : choix du style de trait   [Integer]
            
                        = | 0  : neant
                          | 1  : trait continu
                          | 2  : pointilles
                          | 3  : tirets courts
                          | 4  : tirets longs
                          | 5  : tirets alternes pointilles
                          | 6  : tirets alternes pointilles
                          | 7  : tirets alternes pointilles
                          | 8  : tirets alternes pointilles
    
    SORTIE: * Courbes : LISTE contenant les dictionnaires de
                        courbes a tracer
    """
    # sortie si pour une quelconque raison
    # les listes de resultats sont vides
    # -------------------------------------------
    if (not Resu_x) or (not Resu_y):
       return
            
    if mark<0:
       mark = 0
       
    if style<0:
       style= 1
    
    if TypGraph_in in DicoEssai['GRAPHIQUE']:
    
        dico_tmp = {}
        dico_tmp['LEGENDE']  = str_leg
        dico_tmp['ABSCISSE'] = Resu_x
        dico_tmp['ORDONNEE'] = Resu_y
        if color>-1:
           dico_tmp['COULEUR' ] = color%16
        dico_tmp['MARQUEUR'] = mark%11
        dico_tmp['STYLE']    = style%9
        
        Courbes[TypGraph_in].append(dico_tmp)



# --------------------------------------------------------------
# -Debut--------------------------------------------------------
# --------------------------------------------------------------
def impr_graphique(self, DicoEssai, Courbes, NomsFich,
                   Leg_x, Leg_y, Ech_x, Ech_y, Titre="", graph=0,):
    """
    Objet: Tracer une liste de courbes au format XMGRACE
    """
    #import os
    from Accas import _F
    from random import randint

    DEFI_FICHIER   = self.get_cmd('DEFI_FICHIER')
    IMPR_FONCTION  = self.get_cmd('IMPR_FONCTION')
    INFO_EXEC_ASTER= self.get_cmd('INFO_EXEC_ASTER')
    DETRUIRE       = self.get_cmd('DETRUIRE')
    
    # Recuperation des options d'impression
    # -----------------------------------------
    if DicoEssai.has_key('PREFIXE_FICHIER'):
       prefixe= DicoEssai['PREFIXE_FICHIER']
    else:
       prefixe= None

    # [10,90] = domaine de validite des unites logiques pour IMPR_FONCTION
    # -> On passe par la boucle ci-dessous pour trouver une unite libre car
    #    INFO_EXEC_ASTER(LISTE_INFO='UNITE_LIBRE') peut renvoyer des valeurs
    #    hors de ce domaine de validite...
    # ------------------------------------------
    unite = None
    for iul in xrange(10, 90+1):
        __ULINFO = INFO_EXEC_ASTER(LISTE_INFO='ETAT_UNITE', UNITE=iul)
        if __ULINFO['ETAT_UNITE', 1] == 'FERME   ':
            unite = iul
            DETRUIRE(CONCEPT=_F(NOM=__ULINFO), INFO=1)
            break
        DETRUIRE(CONCEPT=_F(NOM=__ULINFO), INFO=1)
        
    assert type(unite) is int

    # ---
    # boucle sur les types de graphiques demandes en sortie
    # ---
    for i,cle in enumerate(Courbes):
    
        curve = Courbes[cle]
        
        number= randint(0,1.e+6)

        # on passe a l'iteration suivante
        # si les listes de resultats sont vides
        # ------------------------------------------
        if not curve:
            continue

        # superposition aux resultats
        # des courbes issues de TABLE_REF
        # ------------------------------------------
        if DicoEssai.has_key('TABLE_REF'):
        
           for table_tmp in DicoEssai['TABLE_REF']:
            
              table_ref = table_tmp.EXTR_TABLE().values()
              
              typr = table_ref['TYPE'][0].replace(" ", "")
              lege = table_ref['LEGENDE'][0]
              absc = table_ref['ABSCISSE']
              ordo = table_ref['ORDONNEE']
              
              if cle == typr:
                  dico_tmp = dict()
                  dico_tmp['LEGENDE'] = lege
                  dico_tmp['ABSCISSE']= absc
                  dico_tmp['ORDONNEE']= ordo
                  curve.append(dico_tmp)
                     
           DEFI_FICHIER(ACTION ='ASSOCIER',
                     FICHIER   ='./%s' %('tmp_%d' %(number),),
                     UNITE     =unite,)
        else:
                     
           DEFI_FICHIER(ACTION ='ASSOCIER',
                     FICHIER   ='./%s' %('tmp_%d' %(number),),
                     UNITE     =unite,)

        if Ech_x.has_key(cle) and Ech_y.has_key(cle):

            IMPR_FONCTION(FORMAT='XMGRACE', UNITE=unite,
                          COURBE   =curve,
                          LEGENDE_X=Leg_x[cle],
                          LEGENDE_Y=Leg_y[cle],
                          ECHELLE_X=Ech_x[cle],
                          ECHELLE_Y=Ech_y[cle],
                          SOUS_TITRE=Titre,)
        else:
            IMPR_FONCTION(FORMAT='XMGRACE', UNITE=unite,
                          COURBE   =curve,
                          LEGENDE_X=Leg_x[cle],
                          LEGENDE_Y=Leg_y[cle],
                          SOUS_TITRE=Titre,)
        
        DEFI_FICHIER(ACTION='LIBERER', UNITE=unite,)
        
        #
        # Incrementation des numeros de graphiques dans les
        # courbes xmagrace
        # ---------------------------------------------------
        filein   = open('tmp_%d' %(number),'r')
        contents = filein.readlines()
        
        if prefixe:
           fileout = open('./REPE_OUT/%s_%s' %(prefixe,NomsFich[cle],),'w')
        else:
           fileout = open('./REPE_OUT/%s' %(NomsFich[cle],),'w')
        
        for s in contents:
              
           if not (graph+i):
           
              fileout.write(s)
           
           elif s.find('@g0')>=0:
           
              fileout.write(s.replace('@g0','@g%d' %(graph+i)))
              
           elif s.find('to g0')>=0:
           
              fileout.write(s.replace('to g0','to g%d' %(graph+i)))
              
           elif s.find('@with g0')>=0:
           
              fileout.write(s.replace('@with g0','@with g%d' %(graph+i)))
              
           elif s.find('@target g0.s')>=0:
           
              fileout.write(s.replace('@target g0.s','@target g%d.s' %(graph+i)))
              
           else:
           
              fileout.write(s)
           
        filein.close()
        fileout.close()

# --------------------------------------------------------------
# -Debut--------------------------------------------------------
# --------------------------------------------------------------
def remplir_tables(self, typ_essai, str_n_essai, DicoEssai, Resu_in):
    """
    Objet: Construction des tableaux de resultats du fichier .resu
    """
    from Accas import _F
    from numpy import array
    
    if DicoEssai.has_key('TABLE_RESU'):

        CREA_TABLE = self.get_cmd('CREA_TABLE')
        
        # Recuperation des variables supplementaires a imprimer
        # (si existantes) contenues sous le mot-cle 'NOM_CMP'
        # -----------------------------------------------------------
        if DicoEssai.has_key('NOM_CMP'):

           List_Resu_Supp = list(DicoEssai['NOM_CMP'])
           
        else:
           List_Resu_Supp = []
# -----------------------------------------------------------
# Essai TRIA_DR_M_D
# -----------------------------------------------------------
        if typ_essai == "TRIA_DR_M_D":

            PRES_CONF   = DicoEssai['PRES_CONF']
            EPSI_IMPOSE = DicoEssai['EPSI_IMPOSE']
            
            param_predef = ['INST','EPS_AXI','EPS_LAT','EPS_VOL',
                            'SIG_AXI','SIG_LAT','P','Q',]

            for i,sig0 in enumerate(PRES_CONF):
                
                # A quoi ca sert?
                # N'y a-t-il pas moyen d'automatiser?
                self.DeclareOut('TABLRES', DicoEssai['TABLE_RESU'][i])
                
                titre_table = "Resultats bruts : ESSAI %s NUMERO %s"\
                              %(typ_essai,str_n_essai,) +\
                              " | PRES_CONF = %E\n" %(sig0)
                    
                LdicoRes =[_F(LISTE_R=EPSI_IMPOSE[i], PARA='EPSI_IMPOSE'),
                        _F(LISTE_R=Resu_in['INST'][i], PARA='INST'),
                        _F(LISTE_R=Resu_in['EPS_AXI'][i], PARA='EPS_AXI'),
                        _F(LISTE_R=Resu_in['EPS_LAT'][i], PARA='EPS_LAT'),
                        _F(LISTE_R=Resu_in['EPS_VOL'][i], PARA='EPS_VOL'),
                        _F(LISTE_R=Resu_in['SIG_AXI'][i], PARA='SIG_AXI'),
                        _F(LISTE_R=Resu_in['SIG_LAT'][i], PARA='SIG_LAT'),
                        _F(LISTE_R=Resu_in['P'][i], PARA='P'),
                        _F(LISTE_R=Resu_in['Q'][i], PARA='Q'),]
                
                for c in List_Resu_Supp:
                
                   if Resu_in[c][i] and (not c in param_predef):
                      LdicoRes +=[_F(LISTE_R=Resu_in[c][i], PARA=c),]
                      
                   else:
                      message =\
  '  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n' +\
  '  !                                                               !\n' +\
  '  ! ATTENTION : La composante %4s n appartient pas au resultat   !\n' %(c) +\
  '  !                                                               !\n' +\
  '  ! LISTE DES COMPOSANTES ADMISSIBLES:                            !\n'
                      try:
                        for t in Resu_in['LIST_CMP']:
                           message +=\
  '  !             %8s                                          !\n' %(t)
                      finally:
                        message +=\
  '  !                                                               !\n' +\
  '  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
                      print
                      print message
                      print
                
                TABLRES = CREA_TABLE(TITRE=titre_table,
                                     LISTE=LdicoRes,)
                                     
# -----------------------------------------------------------
# Essai TRIA_ND_M_D
# -----------------------------------------------------------
        elif typ_essai == "TRIA_ND_M_D":

            PRES_CONF   = DicoEssai['PRES_CONF']
            EPSI_IMPOSE = DicoEssai['EPSI_IMPOSE']
            
            param_predef = ['INST','EPS_AXI','EPS_LAT',
                            'SIG_AXI','SIG_LAT','P','Q','PRE_EAU',]

            for i,sig0 in enumerate(PRES_CONF):

                self.DeclareOut('TABLRES', DicoEssai['TABLE_RESU'][i])
                
                titre_table = "Resultats bruts : ESSAI %s NUMERO %s"\
                              %(typ_essai,str_n_essai,) +\
                              " | PRES_CONF = %E\n" %(sig0)
                    
                LdicoRes =[_F(LISTE_R=EPSI_IMPOSE[i], PARA='EPSI_IMPOSE'),
                        _F(LISTE_R=Resu_in['INST'][i], PARA='INST'),
                        _F(LISTE_R=Resu_in['EPS_AXI'][i], PARA='EPS_AXI'),
                        _F(LISTE_R=Resu_in['EPS_LAT'][i], PARA='EPS_LAT'),
                        _F(LISTE_R=Resu_in['SIG_AXI'][i], PARA='SIG_AXI'),
                        _F(LISTE_R=Resu_in['SIG_LAT'][i], PARA='SIG_LAT'),
                        _F(LISTE_R=Resu_in['P'][i], PARA='P'),
                        _F(LISTE_R=Resu_in['Q'][i], PARA='Q'),
                        _F(LISTE_R=Resu_in['PRE_EAU'][i], PARA='PRE_EAU'),]
                
                for c in List_Resu_Supp:
                
                   if Resu_in[c][i] and (not c in param_predef):
                      LdicoRes +=[_F(LISTE_R=Resu_in[c][i], PARA=c),]
                      
                   else:
                      message =\
  '  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n' +\
  '  !                                                               !\n' +\
  '  ! ATTENTION : La composante %4s n appartient pas au resultat   !\n' %(c) +\
  '  !                                                               !\n' +\
  '  ! LISTE DES COMPOSANTES ADMISSIBLES:                            !\n'
                      try:
                        for t in Resu_in['LIST_CMP']:
                           message +=\
  '  !             %8s                                          !\n' %(t)
                      finally:
                        message +=\
  '  !                                                               !\n' +\
  '  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
                      print
                      print message
                      print
                
                TABLRES = CREA_TABLE(TITRE=titre_table,
                                     LISTE=LdicoRes,)
                                     
# -----------------------------------------------------------
# Essai CISA_DR_C_D
# -----------------------------------------------------------
        elif typ_essai == "CISA_DR_C_D":

            PRES_CONF    = DicoEssai['PRES_CONF']
            GAMMA_IMPOSE = DicoEssai['GAMMA_IMPOSE']
            LdicoResGlob = []
            
            param_predef = ['INST','GAMMA','SIG_XY',]

            for i,sig0 in enumerate(PRES_CONF):
            
                # Impression NIVEAU 2
                # ----------------------------------------------------------
                self.DeclareOut('TABLRES', DicoEssai['TABLE_RESU'][i])
                
                titre_table = "Resultats bruts : ESSAI %s NUMERO %s"\
                              %(typ_essai,str_n_essai,) +\
                              " | PRES_CONF = %E\n" %(sig0)
                    
                LdicoRes = []
                for j,eps0 in enumerate(GAMMA_IMPOSE):
                
                    stjp1 = int_2_str(j+1, len(GAMMA_IMPOSE))
                    
                    LdicoRes += [
                        {'PARA': 'GAMMA_IMPOSE_' + stjp1, 'LISTE_R': [eps0]}] +\
                                [
                        {'PARA': 'INST_' + stjp1, 'LISTE_R': Resu_in['INST'][i][j]}] +\
                                [
                        {'PARA': 'GAMMA_' + stjp1, 'LISTE_R': Resu_in['GAMMA'][i][j]}] +\
                                [
                        {'PARA': 'SIG_XY_' + stjp1, 'LISTE_R': Resu_in['SIG_XY'][i][j]}]
                        
                    for c in List_Resu_Supp:
                      
                      if Resu_in[c][i] and (not c in param_predef):
                         LdicoRes +=[_F(LISTE_R=Resu_in[c][i][j], PARA='%s_' %(c)+stjp1),]
                         
                      else:
                         message =\
  '  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n' +\
  '  !                                                               !\n' +\
  '  ! ATTENTION : La composante %4s n appartient pas au resultat   !\n' %(c) +\
  '  !                                                               !\n' +\
  '  ! LISTE DES COMPOSANTES ADMISSIBLES:                            !\n'
                         try:
                           for t in Resu_in['LIST_CMP']:
                              message +=\
  '  !             %8s                                          !\n' %(t)
                         finally:
                           message +=\
  '  !                                                               !\n' +\
  '  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
                         print
                         print message
                         print
                        
                TABLRES = CREA_TABLE(TITRE=titre_table, LISTE=(LdicoRes))

                # Impression NIVEAU 1
                # ----------------------------------------------------------
                stip1 = int_2_str(i+1, len(PRES_CONF))
                
                LdicoResGlob += [
                    {'PARA': 'PRES_CONF_' + stip1, 'LISTE_R': [sig0]}] +\
                                [
                    {'PARA': 'GAMMA_IMPOSE_' + stip1, 'LISTE_R': GAMMA_IMPOSE}] +\
                                [
                    {'PARA': 'G_SUR_GMAX_' + stip1, 'LISTE_R': Resu_in['G_SUR_GMAX'][i]}] +\
                                [
                    {'PARA': 'DAMPING_' + stip1, 'LISTE_R': Resu_in['DAMPING'][i]}]
                    
            # Impression NIVEAU 1 dans le dernier element de la table
            # ----------------------------------------------------------
            self.DeclareOut('TABLRES', DicoEssai['TABLE_RESU'][-1])
            
            titre_table = "Resultats globaux : ESSAI %s NUMERO %s\n" %(typ_essai,str_n_essai)
                
            TABLRES = CREA_TABLE(TITRE=titre_table, LISTE=(LdicoResGlob),)

# ----------------------------------------------------
# Essai TRIA_ND_C_F
# ----------------------------------------------------
        elif typ_essai == "TRIA_ND_C_F":

            PRES_CONF   = DicoEssai['PRES_CONF']
            SIGM_IMPOSE = DicoEssai['SIGM_IMPOSE']
            LdicoResGlob= []
            
            param_predef = ['INST','EPS_AXI','EPS_LAT','EPS_VOL',
                            'SIG_AXI','SIG_LAT','P','Q','PRE_EAU','RU',]

            for i,sig0 in enumerate(PRES_CONF):
            
                # Impression NIVEAU 2
                # ----------------------------------------------------------
                self.DeclareOut('TABLRES', DicoEssai['TABLE_RESU'][i])
                
                titre_table = "Resultats bruts : ESSAI %s NUMERO %s"\
                              %(typ_essai,str_n_essai,) +\
                              " | PRES_CONF = %E\n" %(sig0)
                    
                LdicoRes = []
                for j,dsig in enumerate(SIGM_IMPOSE):
                
                    stjp1 = int_2_str(j+1, len(SIGM_IMPOSE))
                    
                    LdicoRes += [
                        {'PARA': 'SIGM_IMPOSE_' + stjp1, 'LISTE_R': [dsig]}] +\
                                [
                        {'PARA': 'INST_' + stjp1, 'LISTE_R': Resu_in['INST'][i][j]}] +\
                                [
                        {'PARA': 'EPS_AXI_' + stjp1, 'LISTE_R': Resu_in['EPS_AXI'][i][j]}] +\
                                [
                        {'PARA': 'EPS_LAT_' + stjp1, 'LISTE_R': Resu_in['EPS_LAT'][i][j]}] +\
                                [
                        {'PARA': 'EPS_VOL_' + stjp1, 'LISTE_R': Resu_in['EPS_VOL'][i][j]}] +\
                                [
                        {'PARA': 'SIG_AXI_' + stjp1, 'LISTE_R': Resu_in['SIG_AXI'][i][j]}] +\
                                [
                        {'PARA': 'SIG_LAT_' + stjp1, 'LISTE_R': Resu_in['SIG_LAT'][i][j]}] +\
                                [
                        {'PARA': 'P_' + stjp1, 'LISTE_R': Resu_in['P'][i][j]}] +\
                                [
                        {'PARA': 'Q_' + stjp1, 'LISTE_R': Resu_in['Q'][i][j]}] +\
                                [
                        {'PARA': 'PRE_EAU_' + stjp1, 'LISTE_R': Resu_in['PRE_EAU'][i][j]}] +\
                                [
                        {'PARA': 'RU_' + stjp1, 'LISTE_R': Resu_in['RU'][i][j]}]

                    for c in List_Resu_Supp:
                      
                      if Resu_in[c][i] and (not c in param_predef):
                         LdicoRes +=[_F(LISTE_R=Resu_in[c][i][j], PARA='%s_' %(c)+stjp1),]
                         
                      else:
                         message =\
  '  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n' +\
  '  !                                                               !\n' +\
  '  ! ATTENTION : La composante %4s n appartient pas au resultat   !\n' %(c) +\
  '  !                                                               !\n' +\
  '  ! LISTE DES COMPOSANTES ADMISSIBLES:                            !\n'
                         try:
                           for t in Resu_in['LIST_CMP']:
                              message +=\
  '  !             %8s                                          !\n' %(t)
                         finally:
                           message +=\
  '  !                                                               !\n' +\
  '  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
                         print
                         print message
                         print
                        
                TABLRES = CREA_TABLE(TITRE=titre_table, LISTE=(LdicoRes))

                # Impression NIVEAU 1
                # ----------------------------------------------------------
                stip1 = int_2_str(i+1, len(PRES_CONF))
                
                LdicoResGlob += [
                    {'PARA': 'PRES_CONF_' + stip1, 'LISTE_R': [sig0]}] +\
                                [
                    {'PARA': 'NCYCL_' + stip1, 'LISTE_I': Resu_in['NCYCL'][i]}] +\
                                [
                    {'PARA': 'CRR_' + stip1, 'LISTE_R': Resu_in['DSIGM'][i]}]
                    
            # Impression NIVEAU 1 dans le dernier element de la table
            # ----------------------------------------------------------
            self.DeclareOut('TABLRES', DicoEssai['TABLE_RESU'][-1])
            
            titre_table = "Resultats globaux : ESSAI %s NUMERO %s\n" %(typ_essai,str_n_essai,)
                
            TABLRES = CREA_TABLE(TITRE=titre_table, LISTE=(LdicoResGlob),)

# -------------------------------------------------------
# Essai TRIA_DR_C_D
# -------------------------------------------------------
        elif typ_essai == "TRIA_DR_C_D":

            PRES_CONF = DicoEssai['PRES_CONF']
            EPSI_MAXI = DicoEssai['EPSI_MAXI']
            EPSI_MINI = DicoEssai['EPSI_MINI']
            
            EPSI_IMPOSE = abs( array(EPSI_MAXI)-array(EPSI_MINI) )
            EPSI_IMPOSE = list(EPSI_IMPOSE)
            
            LdicoResGlob = []
            
            param_predef = ['INST','EPS_AXI','EPS_LAT','EPS_VOL',
                            'SIG_AXI','SIG_LAT','P','Q',]

            for i,sig0 in enumerate(PRES_CONF):
            
                # Impression NIVEAU 2
                # ----------------------------------------------------------
                self.DeclareOut('TABLRES', DicoEssai['TABLE_RESU'][i])
                
                titre_table = "Resultats bruts : ESSAI %s NUMERO %s"\
                              %(typ_essai,str_n_essai,) +\
                              " | PRES_CONF = %E\n" %(sig0)
                    
                LdicoRes = []
                for j,eps0 in enumerate(EPSI_MINI):
                
                    stjp1 = int_2_str(j+1, len(EPSI_MINI))
                    
                    LdicoRes += [
                        {'PARA': 'EPSI_IMPOSE_' + stjp1, 'LISTE_R': [eps0]}] +\
                                [
                        {'PARA': 'INST_' + stjp1, 'LISTE_R': Resu_in['INST'][i][j]}] +\
                                [
                        {'PARA': 'EPS_AXI_' + stjp1, 'LISTE_R': Resu_in['EPS_AXI'][i][j]}] +\
                                [
                        {'PARA': 'EPS_LAT_' + stjp1, 'LISTE_R': Resu_in['EPS_LAT'][i][j]}] +\
                                [
                        {'PARA': 'EPS_VOL_' + stjp1, 'LISTE_R': Resu_in['EPS_VOL'][i][j]}] +\
                                [
                        {'PARA': 'SIG_AXI_' + stjp1, 'LISTE_R': Resu_in['SIG_AXI'][i][j]}] +\
                                [
                        {'PARA': 'SIG_LAT_' + stjp1, 'LISTE_R': Resu_in['SIG_LAT'][i][j]}] +\
                                [
                        {'PARA': 'P_' + stjp1, 'LISTE_R': Resu_in['P'][i][j]}] +\
                                [
                        {'PARA': 'Q_' + stjp1, 'LISTE_R': Resu_in['Q'][i][j]}]

                    for c in List_Resu_Supp:
                      
                      if Resu_in[c][i] and (not c in param_predef):
                         LdicoRes +=[_F(LISTE_R=Resu_in[c][i][j], PARA='%s_' %(c)+stjp1),]
                         
                      else:
                         message =\
  '  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n' +\
  '  !                                                               !\n' +\
  '  ! ATTENTION : La composante %4s n appartient pas au resultat   !\n' %(c) +\
  '  !                                                               !\n' +\
  '  ! LISTE DES COMPOSANTES ADMISSIBLES:                            !\n'
                         try:
                           for t in Resu_in['LIST_CMP']:
                              message +=\
  '  !             %8s                                          !\n' %(t)
                         finally:
                           message +=\
  '  !                                                               !\n' +\
  '  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
                         print
                         print message
                         print
                
                TABLRES = CREA_TABLE(TITRE=titre_table, LISTE=(LdicoRes))
                
                # Impression NIVEAU 1
                # ----------------------------------------------------------
                stip1 = int_2_str(i+1, len(PRES_CONF))
                
                LdicoResGlob += [
                    {'PARA': 'PRES_CONF_' + stip1, 'LISTE_R': [sig0]}] +\
                                [
                    {'PARA': 'EPSI_IMPOSE_' + stip1, 'LISTE_R': EPSI_IMPOSE}] +\
                                [
                    {'PARA': 'E_SUR_EMAX_' + stip1, 'LISTE_R': Resu_in['E_SUR_EMAX'][i]}] +\
                                [
                    {'PARA': 'DAMPING_' + stip1, 'LISTE_R': Resu_in['DAMPING'][i]}]

            # Impression NIVEAU 1 dans le dernier element de la table
            # ----------------------------------------------------------
            self.DeclareOut('TABLRES', DicoEssai['TABLE_RESU'][-1])
            
            titre_table = "Resultats globaux : ESSAI %s NUMERO %s\n" %(typ_essai,str_n_essai,)
                
            TABLRES = CREA_TABLE(TITRE=titre_table, LISTE=(LdicoResGlob))



# ----------------------------------------------------
# Essai TRIA_ND_C_D
# ----------------------------------------------------
        elif typ_essai == "TRIA_ND_C_D":

            PRES_CONF   = DicoEssai['PRES_CONF']
            EPSI_MAXI   = DicoEssai['EPSI_MAXI']
            EPSI_MINI   = DicoEssai['EPSI_MINI']
            
            EPSI_IMPOSE = abs( array(EPSI_MAXI)-array(EPSI_MINI) )
            EPSI_IMPOSE = list(EPSI_IMPOSE)
            
            LdicoResGlob= []
            
            param_predef = ['INST','EPS_AXI','EPS_LAT','EPS_VOL',
                            'SIG_AXI','SIG_LAT','P','Q','PRE_EAU','RU',]

            for i,sig0 in enumerate(PRES_CONF):
            
                # Impression NIVEAU 2
                # ----------------------------------------------------------
                self.DeclareOut('TABLRES', DicoEssai['TABLE_RESU'][i])
                
                titre_table = "Resultats bruts : ESSAI %s NUMERO %s"\
                              %(typ_essai,str_n_essai,) +\
                              " | PRES_CONF = %E\n" %(sig0)
                    
                LdicoRes = []
                for j,eps0 in enumerate(EPSI_MINI):
                
                    stjp1 = int_2_str(j+1, len(EPSI_MINI))
                    
                    LdicoRes += [
                        {'PARA': 'EPSI_IMPOSE_' + stjp1, 'LISTE_R': [eps0]}] +\
                                [
                        {'PARA': 'INST_' + stjp1, 'LISTE_R': Resu_in['INST'][i][j]}] +\
                                [
                        {'PARA': 'EPS_AXI_' + stjp1, 'LISTE_R': Resu_in['EPS_AXI'][i][j]}] +\
                                [
                        {'PARA': 'EPS_LAT_' + stjp1, 'LISTE_R': Resu_in['EPS_LAT'][i][j]}] +\
                                [
                        {'PARA': 'EPS_VOL_' + stjp1, 'LISTE_R': Resu_in['EPS_VOL'][i][j]}] +\
                                [
                        {'PARA': 'SIG_AXI_' + stjp1, 'LISTE_R': Resu_in['SIG_AXI'][i][j]}] +\
                                [
                        {'PARA': 'SIG_LAT_' + stjp1, 'LISTE_R': Resu_in['SIG_LAT'][i][j]}] +\
                                [
                        {'PARA': 'P_' + stjp1, 'LISTE_R': Resu_in['P'][i][j]}] +\
                                [
                        {'PARA': 'Q_' + stjp1, 'LISTE_R': Resu_in['Q'][i][j]}] +\
                                [
                        {'PARA': 'PRE_EAU_' + stjp1, 'LISTE_R': Resu_in['PRE_EAU'][i][j]}] +\
                                [
                        {'PARA': 'RU_' + stjp1, 'LISTE_R': Resu_in['RU'][i][j]}]

                    for c in List_Resu_Supp:
                      
                      if Resu_in[c][i] and (not c in param_predef):
                         LdicoRes +=[_F(LISTE_R=Resu_in[c][i][j], PARA='%s_' %(c)+stjp1),]
                         
                      else:
                         message =\
  '  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n' +\
  '  !                                                               !\n' +\
  '  ! ATTENTION : La composante %4s n appartient pas au resultat   !\n' %(c) +\
  '  !                                                               !\n' +\
  '  ! LISTE DES COMPOSANTES ADMISSIBLES:                            !\n'
                         try:
                           for t in Resu_in['LIST_CMP']:
                              message +=\
  '  !             %8s                                          !\n' %(t)
                         finally:
                           message +=\
  '  !                                                               !\n' +\
  '  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
                         print
                         print message
                         print
                        
                TABLRES = CREA_TABLE(TITRE=titre_table, LISTE=(LdicoRes))

                # Impression NIVEAU 1
                # ----------------------------------------------------------
                stip1 = int_2_str(i+1, len(PRES_CONF))
                
                LdicoResGlob += [
                    {'PARA': 'PRES_CONF_' + stip1, 'LISTE_R': [sig0]}] +\
                                [
                    {'PARA': 'EPSI_IMPOSE_' + stip1, 'LISTE_R': EPSI_IMPOSE}] +\
                                [
                    {'PARA': 'E_SUR_EMAX_' + stip1, 'LISTE_R': Resu_in['E_SUR_EMAX'][i]}] +\
                                [
                    {'PARA': 'DAMPING_' + stip1, 'LISTE_R': Resu_in['DAMPING'][i]}] +\
                                [
                    {'PARA': 'NCYCL_' + stip1, 'LISTE_I': Resu_in['NCYCL'][i]}] +\
                                [
                    {'PARA': 'RU_MAX_' + stip1, 'LISTE_R': Resu_in['RU_MAX'][i]}]
                    
            # Impression NIVEAU 1 dans le dernier element de la table
            # ----------------------------------------------------------
            self.DeclareOut('TABLRES', DicoEssai['TABLE_RESU'][-1])
            
            titre_table = "Resultats globaux : ESSAI %s NUMERO %s\n" %(typ_essai,str_n_essai,)
                
            TABLRES = CREA_TABLE(TITRE=titre_table, LISTE=(LdicoResGlob),)
            
# -------------------------------------------------------
# Essais OEDO_CDR_C_F ou ISOT_DR_C_F
# -------------------------------------------------------
        elif typ_essai == "OEDO_DR_C_F" or typ_essai == "ISOT_DR_C_F":

            PRES_CONF   = DicoEssai['PRES_CONF']
            SIGM_DECH   = DicoEssai['SIGM_DECH']
            
            param_predef = ['INST','EPS_VOL','SIG_AXI','SIG_LAT','P',]
            
            for i,sig0 in enumerate(PRES_CONF):
            
                # Impression NIVEAU 2
                # ----------------------------------------------------------
                self.DeclareOut('TABLRES', DicoEssai['TABLE_RESU'][i])
                
                titre_table = " ESSAI %s NUMERO %s" %(typ_essai,str_n_essai)+\
                              " | PRES_CONF = %E" %(sig0) +\
                              " | SIGM_DECH = %E\n" %(SIGM_DECH[i])
                              
                stip1 = int_2_str(i+1, len(PRES_CONF))
                
                LdicoRes = [
                    {'PARA': 'INST_' + stip1, 'LISTE_R': Resu_in['INST'][i]}] +\
                            [
                    {'PARA': 'EPS_VOL_' + stip1, 'LISTE_R': Resu_in['EPS_VOL'][i]}] +\
                            [
                    {'PARA': 'P_' + stip1, 'LISTE_R': Resu_in['P'][i]}] +\
                            [
                    {'PARA': 'SIG_AXI_' + stip1, 'LISTE_R': Resu_in['SIG_AXI'][i]}] +\
                            [
                    {'PARA': 'SIG_LAT_' + stip1, 'LISTE_R': Resu_in['SIG_LAT'][i]}]

                for c in List_Resu_Supp:
                  
                  if Resu_in[c][i] and (not c in param_predef):
                     LdicoRes +=[_F(LISTE_R=Resu_in[c][i], PARA="%s_%s" %(c,stip1,),),]
                     
                  else:
                     message =\
  '  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n' +\
  '  !                                                               !\n' +\
  '  ! ATTENTION : La composante %4s n appartient pas au resultat   !\n' %(c) +\
  '  !                                                               !\n' +\
  '  ! LISTE DES COMPOSANTES ADMISSIBLES:                            !\n'
                     try:
                       for t in Resu_in['LIST_CMP']:
                          message +=\
  '  !             %8s                                          !\n' %(t)
                     finally:
                       message +=\
  '  !                                                               !\n' +\
  '  !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
                     print
                     print message
                     print
                    
                # si il n'y a aucun resultat ds LdicoRes on cree une table vide
                # ----------------------------------------------------------
                if LdicoRes == []:
                    TABLRES = CREA_TABLE(TITRE=titre_table)
                else:
                    TABLRES = CREA_TABLE(TITRE=titre_table, LISTE=(LdicoRes))

        # ---
        # Pour nouvel essai
        # ---
        # elif typ_essai == "XXX":
        # ---
        #  ...
        # ---
        else:
            assert False


# --------------------------------------------------------------
# -Debut--------------------------------------------------------
# --------------------------------------------------------------
def Calc_Gs_max(self, GAMMA_ELAS, PRES_CONF, KZERO, MATER, COMPORTEMENT, CONVERGENCE):
    """
    Objet: Pour l'essai CISA_DR_C_D, calcul du module de cisaillement secant max
           (EPSI_ELAS doit etre telle qu'on reste bien dans le domaine elastique)
    """
    from Accas import _F

    DEFI_FONCTION  = self.get_cmd('DEFI_FONCTION')
    DEFI_LIST_INST = self.get_cmd('DEFI_LIST_INST')
    DEFI_LIST_REEL = self.get_cmd('DEFI_LIST_REEL')
    SIMU_POINT_MAT = self.get_cmd('SIMU_POINT_MAT')
    DETRUIRE       = self.get_cmd('DETRUIRE')

    __RLIST = DEFI_LIST_REEL(DEBUT=0.,
                             INTERVALLE=_F(JUSQU_A=1., NOMBRE=1,),)

    __DLIST = DEFI_LIST_INST(DEFI_LIST=_F(LIST_INST=__RLIST),
                             ECHEC=_F(SUBD_METHODE='MANUEL',
                                      SUBD_PAS    =10,
                                      SUBD_NIVEAU =10,),)

    __CHAR1 = DEFI_FONCTION(NOM_PARA='INST',
                            VALE=(0., 0.,
                                  1., -0.5*GAMMA_ELAS,),)

    __CHAR2 = DEFI_FONCTION(NOM_PARA='INST',
                            VALE=(0., KZERO * PRES_CONF,
                                  1., KZERO * PRES_CONF,),)

    __CHAR3 = DEFI_FONCTION(NOM_PARA='INST',
                            VALE=(0., PRES_CONF,
                                  1., PRES_CONF,),)

    __EVOL = SIMU_POINT_MAT(
        COMPORTEMENT=COMPORTEMENT.List_F(),
        
        CONVERGENCE=CONVERGENCE.List_F(),
        
        MATER=MATER,
        
        INCREMENT=_F(LIST_INST=__DLIST,
                     INST_INIT=0.,
                     INST_FIN =1.,),
                     
        NEWTON=_F(MATRICE='TANGENTE', REAC_ITER=1,),
        
        ARCHIVAGE=_F(LIST_INST=__RLIST,),
        
        SIGM_IMPOSE=_F(SIXX=__CHAR2,
                       SIYY=__CHAR2,
                       SIZZ=__CHAR3,),
                           
        EPSI_IMPOSE=_F(EPXY=__CHAR1,),
        
        SIGM_INIT=_F(SIXX=KZERO * PRES_CONF,
                     SIYY=KZERO * PRES_CONF,
                     SIZZ=PRES_CONF,),
                     
        EPSI_INIT=_F(EPXX=0,
                     EPYY=0,
                     EPZZ=0,
                     EPXY=0,
                     EPXZ=0,
                     EPYZ=0,),)

    TabRes = __EVOL.EXTR_TABLE().values()
    sig_xy = TabRes['SIXY'][-1]
    eps_xy = TabRes['EPXY'][-1]

    DETRUIRE(CONCEPT=_F(NOM=(__CHAR1, __CHAR2, __CHAR3, __EVOL,
                             __RLIST, __DLIST),),
             INFO=1)

    return 0.5 * sig_xy / eps_xy
    

# --------------------------------------------------------------
# -Debut--------------------------------------------------------
# --------------------------------------------------------------
def Calc_Es_max(self, EPSI_ELAS, PRES_CONF, KZERO, MATER, COMPORTEMENT, CONVERGENCE):
    """
    Objet: Pour les essais TRIA_DR/ND_C_D, calcul du module d Young cyclique
           equivalent max (EPSI_ELAS doit etre telle qu'on reste bien
           dans le domaine elastique)
    """
    from Accas import _F
    import numpy as NP

    DEFI_FONCTION  = self.get_cmd('DEFI_FONCTION')
    DEFI_LIST_INST = self.get_cmd('DEFI_LIST_INST')
    DEFI_LIST_REEL = self.get_cmd('DEFI_LIST_REEL')
    SIMU_POINT_MAT = self.get_cmd('SIMU_POINT_MAT')
    DETRUIRE       = self.get_cmd('DETRUIRE')

    __RLIST = DEFI_LIST_REEL(DEBUT=0.,
                             INTERVALLE=_F(JUSQU_A=5., NOMBRE=5,),)

    __DLIST = DEFI_LIST_INST(DEFI_LIST=_F(LIST_INST=__RLIST),
                             ECHEC=_F(SUBD_METHODE='MANUEL',
                                      SUBD_PAS    =2,
                                      SUBD_NIVEAU =10,),)

    __CHAR1 = DEFI_FONCTION(NOM_PARA='INST',
                            VALE=(0., 0.,
                                  1., -1.*EPSI_ELAS,
                                  3., +1.*EPSI_ELAS,
                                  5., -1.*EPSI_ELAS),)

    __CHAR2 = DEFI_FONCTION(NOM_PARA='INST',
                            VALE=(0., KZERO*PRES_CONF,
                                  5., KZERO*PRES_CONF,),)

    __EVOL = SIMU_POINT_MAT(COMPORTEMENT=COMPORTEMENT.List_F(),
    
        CONVERGENCE=CONVERGENCE.List_F(),
        
        MATER=MATER,
        
        INCREMENT=_F(LIST_INST=__DLIST,
                     INST_INIT=0.,
                     INST_FIN =5.,),
                     
        NEWTON=_F(MATRICE='TANGENTE', REAC_ITER=1,),
        
        ARCHIVAGE=_F(LIST_INST=__RLIST,),
        
        SIGM_IMPOSE=_F(SIXX=__CHAR2,
                       SIYY=__CHAR2,),
                           
        EPSI_IMPOSE=_F(EPZZ=__CHAR1,),
        
        SIGM_INIT=_F(SIXX=KZERO*PRES_CONF,
                     SIYY=KZERO*PRES_CONF,
                     SIZZ=PRES_CONF,),
                     
        EPSI_INIT=_F(EPXX=0.,
                     EPYY=0.,
                     EPZZ=0.,
                     EPXY=0.,
                     EPXZ=0.,
                     EPYZ=0.,),)

    TabRes = __EVOL.EXTR_TABLE().values()
    inst   = TabRes['INST']
    sig_zz = NP.array(TabRes['SIZZ'])
    sig_xx = NP.array(TabRes['SIXX'])
    q      = sig_zz - sig_xx

    DETRUIRE(CONCEPT=_F(NOM=(__CHAR1, __CHAR2, __EVOL,__RLIST, __DLIST),),
             INFO=1,)

    return 0.5*abs(q[inst.index(5.)] - q[inst.index(3.)]) / EPSI_ELAS

# -----------------------------------------------------------------------
# -----------------------------------------------------------------------
#         ESSAI TRIAXIAL NON DRAINE CYCLIQUE A DEFORMATION IMPOSEE
#
# fiche:   23451      -----------------------
# Author:  Marc KHAM  -----------------------
# Date:    31/03/2015 -----------------------
# -----------------------------------------------------------------------
# -----------------------------------------------------------------------
def essai_TRIA_ND_C_D_mono(self, inst_init, sigm, epsi, vari, DicoEssai,
                     PRES_CONF, MATER, COMPORTEMENT, CONVERGENCE, INFO,
                     nombre=400, inst_epsi=100., epsi_max=.04):
    """
    Objet: Essai TRIAxial Non Draine Cyclique a Force imposee (TRIA_ND_C_F)
           Poursuite en monotone avec deformation verticale controlee
           Complementaire a la fonction suivante pour la gestion
           de l'instabilite a contrainte controlee lors du franchissement
           de la ligne d' instabilite
    """
    import numpy as NP
    import math as M
    from Accas import _F
    import aster
    from Utilitai.Utmess import UTMESS
    from Comportement import catalc

    DEFI_FONCTION  = self.get_cmd('DEFI_FONCTION')
    DETRUIRE       = self.get_cmd('DETRUIRE')
    DEFI_LIST_INST = self.get_cmd('DEFI_LIST_INST')
    DEFI_LIST_REEL = self.get_cmd('DEFI_LIST_REEL')
    from Contrib.calc_point_mat import CALC_POINT_MAT
    
    UN_SUR_K   = DicoEssai['UN_SUR_K']
    KZERO      = DicoEssai['KZERO']
    K_EAU      = 1./UN_SUR_K
    calc_ok    = True
    
    # Chargement lineaire par morceaux ou sinusoidal?
    # ------------------------------------------------
    sinusoidal = DicoEssai['TYPE_CHARGE'] == 'SINUSOIDAL'

    __rlist = DEFI_LIST_REEL(DEBUT=inst_init,
                 INTERVALLE=_F(JUSQU_A=inst_init+inst_epsi, NOMBRE=nombre,),
                 INFO=INFO)

    __dlist = DEFI_LIST_INST(DEFI_LIST=_F(LIST_INST=__rlist),
                 ECHEC=_F(SUBD_METHODE='MANUEL',
                          SUBD_PAS    =2,
                          SUBD_NIVEAU =10,),
                 INFO=INFO,)
    
    if sinusoidal:
       
       abscisse = [inst_init +\
                   inst_epsi*k/3./nombre for k in xrange(3*nombre+1)]
       
       # absc_cos varie de 0 a Pi sur l'intervalle
       # [inst_init ; inst_init+inst_epsi]
       # (COsinus varie de 1 a -1)
       # -------------------------------------------------------------
       absc_cos = M.pi*(NP.array(abscisse)-inst_init)/inst_epsi
       
       epsi_mean  = epsi[2]+0.5*epsi_max
       
       depsi      = 0.5*epsi_max
       
       ordonnee   = epsi_mean - NP.cos(absc_cos)*depsi
   
    else:
       abscisse = [inst_init, inst_init+inst_epsi,]
       ordonnee = [epsi[2]  , epsi[2]+epsi_max,]

    __CHARV = DEFI_FONCTION(INFO=INFO, NOM_PARA='INST',
                            ABSCISSE=abscisse,
                            ORDONNEE=list(ordonnee),)

    __CHARH = DEFI_FONCTION(INFO=INFO, NOM_PARA='INST',
                        VALE=(inst_init          , KZERO*PRES_CONF,
                              inst_init+inst_epsi, KZERO*PRES_CONF,),)
    try:
      __EVOLM = CALC_POINT_MAT(INFO=INFO,
        
        COMPORTEMENT=COMPORTEMENT.List_F(),
        
        CONVERGENCE=CONVERGENCE.List_F(),
        
        MATER=MATER,
        
        INCREMENT=_F(LIST_INST=__dlist,
                     INST_INIT=inst_init,
                     INST_FIN =inst_init+inst_epsi,),
                     
        NEWTON=_F(MATRICE='TANGENTE', REAC_ITER=1,),
        
        ARCHIVAGE=_F(LIST_INST=__rlist,),

        VECT_IMPO=(_F(NUME_LIGNE=1, VALE=__CHARH),
                   _F(NUME_LIGNE=2, VALE=__CHARH),
                   _F(NUME_LIGNE=3, VALE=__CHARV),),

        MATR_C1=(_F(NUME_LIGNE=1, NUME_COLONNE=1, VALE=1.),
                 _F(NUME_LIGNE=2, NUME_COLONNE=2, VALE=1.),),

        MATR_C2=(_F(NUME_LIGNE=1,
                    NUME_COLONNE=1, VALE=K_EAU),
                 _F(NUME_LIGNE=1,
                    NUME_COLONNE=2, VALE=K_EAU),
                 _F(NUME_LIGNE=1,
                    NUME_COLONNE=3, VALE=K_EAU),
                 _F(NUME_LIGNE=2,
                    NUME_COLONNE=1, VALE=K_EAU),
                 _F(NUME_LIGNE=2,
                    NUME_COLONNE=2, VALE=K_EAU),
                 _F(NUME_LIGNE=2,
                    NUME_COLONNE=3, VALE=K_EAU),
                 _F(NUME_LIGNE=3,
                    NUME_COLONNE=3, VALE=1.),),

        SIGM_INIT= _F(SIXX=sigm[0], SIYY=sigm[1], SIZZ=sigm[2],
                      SIXY=sigm[3], SIXZ=sigm[4], SIYZ=sigm[5],),
                      
        EPSI_INIT= _F(EPXX=epsi[0], EPYY=epsi[1], EPZZ=epsi[2],
                      EPXY=epsi[3], EPXZ=epsi[4], EPYZ=epsi[5],),
                      
        VARI_INIT= _F(VALE=vari,),);

    except aster.error, message:
   
      print '\n   !!!(@_@)!!! Arret pour la raison suivante !!!(@_@)!!!\n%s'\
            %(message)
                     
      calc_ok = False
      __EVOLM = self.get_last_concept()

    else:
      DETRUIRE(CONCEPT=_F(NOM=(__rlist,__dlist,__CHARV,__CHARH,)), INFO=1)

    return __EVOLM,calc_ok,
    