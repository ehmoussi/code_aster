# coding=utf-8
# ======================================================================
# COPYRIGHT (C) 1991 - 2014  EDF R&D                  WWW.CODE-ASTER.ORG
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
# person_in_charge: samuel.geniaut at edf.fr

"""
Ce module définit des fonctions permettant de manipuler un résultat issu de THYC
"""

import string

def cherche_rubrique_nom(fobj, nom):
    """Chercher une rubrique definie par son nom"""
    while 1:
        line = fobj.readline()
        if not line:
            break
        # if line.strip() == nom:
        #     return 1
        strtmp = line[0:len(line)-1]
        if len(line) >= len(nom):
            if line[0:len(nom)] == nom:
                return 1
    return None

def definir_chargement_transverse(cote, epaisseur, pos_thyc, force,prod):
    """XXX pas documenté, propre à lire_resu_thyc"""
    from Cata.cata import DEFI_FONCTION
    # Determination du chargement transverse sur les crayons pour un assemblage donne.
    kk=2
    eps = 1.0e-6

    defi_fonc = []
    # Pour aller de l embout inferieur jusqu'a la premiere grille.
    som_l = 0.0
    som_f = 0.0
    for k in range(kk,pos_thyc[0]):
        som_l = som_l + string.atof(epaisseur[k])
        som_f = som_f + prod*string.atof(force[k])/string.atof(epaisseur[k])
    som_feq = som_l/(som_l + 0.5*string.atof(epaisseur[pos_thyc[0]]))*som_f
    defi_fonc.append(string.atof(cote[kk])-0.5*string.atof(epaisseur[kk])-eps)
    defi_fonc.append(som_feq)
    defi_fonc.append(string.atof(cote[pos_thyc[0]])-0.5*string.atof(epaisseur[pos_thyc[0]])+eps)
    defi_fonc.append(som_feq)
    defi_fonc.append(string.atof(cote[pos_thyc[0]]))
    defi_fonc.append(0.0)

    # Pour aller de la premiere a la derniere grille.
    for j in range(0,len(pos_thyc)-1):
        som_l = 0.0
        som_f = 0.0
        for k in range(pos_thyc[j]+1,pos_thyc[j+1]):
            som_l = som_l + string.atof(epaisseur[k])
            som_f = som_f + prod*string.atof(force[k])/string.atof(epaisseur[k])
        som_feq = som_l/(som_l + 0.5*(string.atof(epaisseur[pos_thyc[j]])+string.atof(epaisseur[pos_thyc[j+1]])))*som_f
        defi_fonc.append(string.atof(cote[pos_thyc[j]])+0.5*string.atof(epaisseur[pos_thyc[j]])-eps)
        defi_fonc.append(som_feq)
        defi_fonc.append(string.atof(cote[pos_thyc[j+1]])-0.5*string.atof(epaisseur[pos_thyc[j+1]])+eps)
        defi_fonc.append(som_feq)
        defi_fonc.append(string.atof(cote[pos_thyc[j+1]]))
        defi_fonc.append(0.0)

    # Pour aller de la derniere grille jusqu'a l embout superieur.
    som_l = 0.0
    som_f = 0.0
    for k in range(pos_thyc[len(pos_thyc)-1]+1,len(cote)):
        som_l = som_l + string.atof(epaisseur[k])
        som_f = som_f + prod*string.atof(force[k])/string.atof(epaisseur[k])
    som_feq = som_l/(som_l + 0.5*string.atof(epaisseur[len(cote)-1]))*som_f
    defi_fonc.append(string.atof(cote[pos_thyc[len(pos_thyc)-1]])+0.5*string.atof(epaisseur[pos_thyc[len(pos_thyc)-1]])-eps)
    defi_fonc.append(som_feq)
    defi_fonc.append(string.atof(cote[len(cote)-1])+0.5*string.atof(epaisseur[len(cote)-1])+eps)
    defi_fonc.append(som_feq)

    _resu = DEFI_FONCTION(NOM_PARA='X',
                          VALE=defi_fonc,
                          PROL_DROITE = 'CONSTANT',
                          PROL_GAUCHE = 'CONSTANT',)
    return _resu

def lire_resu_thyc(coeur, MODELE, nom_fic):
    """XXX
    À définir dans un autre module : fonction qui prend un Coeur en argument
    ou un objet ThycResult avec .read(), .hydr_load()... pour récupérer les
    différents résultats
    """
    from Cata.cata import DEFI_FONCTION, AFFE_CHAR_MECA, AFFE_CHAR_MECA_F
    from Accas import _F
    # Fonction multiplicative de la force hydrodynamique axiale.
    # On multiplie par 0.722 les forces hydrodynamiques a froid pour obtenir celles a chaud.
    FOHYFR_1 = 1.0    # Valeur a froid
    FOHYCH_1 = 0.722  # Valeur a chaud

    f  = open(nom_fic, 'r')
    f2 = open(nom_fic, 'r')
    cherche_rubrique_nom(f, ' EFFORTS TRANSVERSES selon X en N')
    cherche_rubrique_nom(f2, ' EFFORTS TRANSVERSES selon Y en N')
    line = f.readline().split()
    line2 = f2.readline().split()
    line2 = f2.readline().split()

    # Recuperation de l'epaisseur des mailles dans Thyc
    epaisseur = f.readline().split()
    if (epaisseur[0]!="ep(m)"):
        raise KeyError("invalid epaisseur")

    cote = f.readline().split()
    if (cote[0]!="Z(m)"):
        raise KeyError("invalid cote axial")

    j = 0
    pos_thyc=[]
    for i in range(2,len(cote)):
        #Positionnement des grilles
        if ((coeur.altitude[j]>(string.atof(cote[i])-string.atof(epaisseur[i])/2.)) & (coeur.altitude[j]<(string.atof(cote[i])+string.atof(epaisseur[i])/2.))):
            pos_thyc.append(i)
            j=j+1
            if (j==len(coeur.altitude)):
                break

    for i in range(2,len(cote)):
        #Positionnement des crayons pour application des efforts transverses
        if ((coeur.XINFC>(string.atof(cote[i])-string.atof(epaisseur[i])/2.)) & (coeur.XINFC<(string.atof(cote[i])+string.atof(epaisseur[i])/2.))):
            pos_gril_inf = i
        if ((coeur.XSUPC>(string.atof(cote[i])-string.atof(epaisseur[i])/2.)) & (coeur.XSUPC<(string.atof(cote[i])+string.atof(epaisseur[i])/2.))):
            pos_gril_sup = i

    # Recuperation des efforts transverses sur les grilles
    mcf = []
    mcft= []
    for i in range(0,coeur.NBAC):
        line  = f.readline().split()
        line2 = f2.readline().split()
        posi_aster1 = coeur.ALPHAMAC[len(coeur.ALPHAMAC)+2-string.atoi(line[1])-1]  + "_" + coeur.ALPHAMAC[string.atoi(line[0])-2]
        posi_aster2 = coeur.ALPHAMAC[len(coeur.ALPHAMAC)+2-string.atoi(line2[1])-1] + "_" + coeur.ALPHAMAC[string.atoi(line2[0])-2]

        if (posi_aster1!=posi_aster2):
            raise KeyError("position d assemblage avec ordre different")

        for j in range(0,len(pos_thyc)):
           mtmp = (_F(GROUP_NO = 'G_'+posi_aster1+'_'+str(j+1), FY = string.atof(line[pos_thyc[j]])/4.0, FZ = - string.atof(line2[pos_thyc[j]])/4.0),)
           mcf.extend(mtmp)

        _resu_fy = definir_chargement_transverse(cote, epaisseur, pos_thyc, line, 1)
        _resu_fz = definir_chargement_transverse(cote, epaisseur, pos_thyc, line2, -1)
        mtmp = (_F(GROUP_MA = 'CR_'+posi_aster1, FY = _resu_fy, FZ = _resu_fz),)
        mcft.extend(mtmp)

    _AF_CHTRNO = AFFE_CHAR_MECA(MODELE=MODELE,FORCE_NODALE = mcf)
    _AF_CHTRFX = AFFE_CHAR_MECA_F(MODELE=MODELE,FORCE_POUTRE = mcft)

    # Recuperation des efforts axiaux
    cherche_rubrique_nom(f, ' *    FORCE HYDRODYNAMIQUE AXIALE en (N)           *')
    line = f.readline().split()
    line = f.readline().split()
    line = f.readline().split()

    mcp  = []
    mcpf = []
    for i in range(0,coeur.NBAC):
        line = f.readline().split()
        posi_aster = coeur.ALPHAMAC[len(coeur.ALPHAMAC)+2-string.atoi(line[1])-1]+ "_" +coeur.ALPHAMAC[len(coeur.ALPHAMAC)+2-string.atoi(line[0])-1]
        idAC=coeur.position_todamac(posi_aster)

        ac=coeur.collAC[idAC]
        KTOT = ac.K_GRM*(ac.NBGR-2)+ac.K_GRE*2+ac.K_EBSU+ac.K_TUB+ac.K_EBIN

        # Force axiale pour une grille extremite (inf)
        mtmp = (_F(GROUP_NO = 'G_'+posi_aster+'_'+str(1), FX = string.atof(line[2])/FOHYCH_1*ac.K_GRE/KTOT/4.0),)
        mcp.extend(mtmp)

        # Force axiale pour chacune des grilles de mélange
        for j in range(1,ac.NBGR-1):
            mtmp = (_F(GROUP_NO = 'G_'+posi_aster+'_'+str(j+1), FX = string.atof(line[2])/FOHYCH_1*ac.K_GRM/KTOT/4.0),)
            mcp.extend(mtmp)

        # Force axiale pour une grille extremite (sup)
        mtmp = (_F(GROUP_NO = 'G_'+posi_aster+'_'+str(ac.NBGR), FX = string.atof(line[2])/FOHYCH_1*ac.K_GRE/KTOT/4.0),)
        mcp.extend(mtmp)

        # Force axiale pour l'embout inferieur
        mtmp = (_F(GROUP_NO = 'PI_'+posi_aster, FX = string.atof(line[2])/FOHYCH_1*ac.K_EBIN/KTOT),)
        mcp.extend(mtmp)

        # Force axiale pour l'embout superieur
        mtmp = (_F(GROUP_NO = 'PS_'+posi_aster, FX = string.atof(line[2])/FOHYCH_1*ac.K_EBSU/KTOT),)
        mcp.extend(mtmp)

        # Force axiale pour les crayons (appel a DEFI_FONCTION)
        vale = string.atof(line[2])/FOHYCH_1*ac.K_TUB/KTOT*ac.NBCR/(ac.NBCR+ac.NBTG)/ac.LONCR
        _FXC = DEFI_FONCTION(NOM_PARA='X',PROL_DROITE='CONSTANT',PROL_GAUCHE='CONSTANT',
                             VALE=(ac.XINFC,vale,ac.XSUPC,vale))
        mtmp = (_F(GROUP_MA = 'CR_'+posi_aster, FX = _FXC),)
        mcpf.extend(mtmp)

        # Force axiale pour les tubes-guides (appel a DEFI_FONCTION)
        vale = string.atof(line[2])/FOHYCH_1*ac.K_TUB/KTOT*ac.NBTG/(ac.NBCR+ac.NBTG)/ac.LONTU
        _FXT = DEFI_FONCTION(NOM_PARA='X',PROL_DROITE='CONSTANT',PROL_GAUCHE='CONSTANT',
                             VALE=(ac.XINFT,vale,ac.XSUPT,vale))
        mtmp = (_F(GROUP_MA = 'TG_'+posi_aster, FX = _FXT),)
        mcpf.extend(mtmp)

    _AF_CHAXNO = AFFE_CHAR_MECA(MODELE=MODELE,FORCE_NODALE = mcp)
    _AF_CHAXPO = AFFE_CHAR_MECA_F(MODELE=MODELE,FORCE_POUTRE = mcpf)

    return _AF_CHTRNO,_AF_CHTRFX,_AF_CHAXNO,_AF_CHAXPO
