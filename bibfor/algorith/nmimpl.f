      SUBROUTINE NMIMPL(SDIMPR,NATURZ,LIGNE ,ARGZ  ,ARGR  ,
     &                  ARGI  )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/12/2011   AUTEUR BEAURAIN J.BEAURAIN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.
C
C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.
C
C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C   1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT      NONE
      CHARACTER*24  SDIMPR
      CHARACTER*(*) NATURZ
      CHARACTER*(*) ARGZ(*)
      REAL*8        ARGR(*)
      INTEGER       ARGI(*)
      CHARACTER*(*) LIGNE
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (AFFICHAGE)
C
C IMPRESSION
C
C ----------------------------------------------------------------------
C
C
C IN  SDIMPR : SD AFFICHAGE
C IN  NATURE : NATURE DE L'IMPRESSION
C              'ARCH_INIT' -> ARCHIVAGE ETAT INITIAL
C              'ARCH_TETE' -> EN_TETE ARCHIVAGE
C              'ARCH_MODE_VIBR'  -> ARCHIVAGE MODE VIBRATOIRE
C              'ARCH_MODE_FLAM'  -> ARCHIVAGE MODE FLAMBEMENT
C              'ARCH_SENS' -> EN_TETE ARCHIVAGE DES CHAMPS SENSIBLES
C              'ARCHIVAGE' -> STOCKAGE DES CHAMPS
C              'ITER_MAXI' -> MAXIMUM ITERATIONS ATTEINT
C              'CONV_OK  ' -> CONVERGENCE ATTEINTE
C              'CONV_MAXI' -> CONVERGENCE ATTEINTE SUR RESI_GLOB_MAXI
C                             QUAND RESI_GLOB_RELA & CHARGEMENT=0
C              'CONV_NONE' -> PAS DE CRITERES DE CONVERGENCE
C              'CONV_FORC' -> CONVERGENCE FORCEE (ARRET = NON)
C              'ERREUR'    -> ERREUR
C              'BCL_SEUIL' -> NUMERO BOUCLE SEUIL CONTACT ECP
C              'BCL_GEOME' -> NUMERO BOUCLE GEOMETRIE CONTACT ECP
C              'BCL_CTACT' -> NUMERO BOUCLE CONTRAINTE ACTIVE
C                             CONTACT ECP
C              'CNV_SEUIL' -> CONVERGENCE BOUCLE SEUIL CONTACT ECP
C              'CNV_GEOME' -> CONVERGENCE BOUCLE GEOMETRIE CONTACT ECP
C              'CNV_CTACT' -> CONVERGENCE BOUCLE CONTRAINTE ACTIVE
C                             CONTACT ECP
C              'LIGNE    ' -> SIMPLE LIGNE DE SEPARATION
C              'AUTR_SOLU_PILO' -> PAS DE TEMPS RECOMMENCE AVEC
C                                  LA DEUXIEME SOLUTION
C IN  ARGZ   : ARGUMENTS EVENTUELS DE TYPE TEXTE
C IN  ARGR   : ARGUMENTS EVENTUELS DE TYPE REEL
C IN  ARGI   : ARGUMENTS EVENTUELS DE TYPE ENTIER
C IN  LIGNE  : LIGNE POINTILLEE DE SEPARATION
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
C
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C
      REAL*8           R8BID
      INTEGER          IBID
      CHARACTER*16     K16BID,OPTASS
      CHARACTER*24     NATURE
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      NATURE = NATURZ
C
C --- LIGNE
C
      IF (NATURE(1:5) .EQ. 'LIGNE') THEN
        CALL NMIMPX(SDIMPR,6     ,LIGNE)
C
C --- ASSEMBLAGE MATRICE
C
      ELSE IF (NATURE .EQ. 'MATR_ASSE') THEN
        OPTASS = ARGZ(1)
        CALL IMPSDR(SDIMPR,'MATR_ASSE',OPTASS,R8BID,IBID)
C
C --- ARCHIVAGE DE L'ETAT INITIAL
C
      ELSE IF (NATURE .EQ. 'ARCH_INIT') THEN
        CALL U2MESS('I','ARCHIVAGE_4')
C
C --- ARCHIVAGE EN-TETE
C
      ELSE IF (NATURE .EQ. 'ARCH_TETE') THEN
        CALL U2MESS('I','ARCHIVAGE_5')
C
C --- ARCHIVAGE DES CHAMPS
C
      ELSE IF (NATURE .EQ. 'ARCHIVAGE') THEN
        CALL U2MESG('I','ARCHIVAGE_6',1,ARGZ,1,ARGI,1,ARGR)
C
C --- ARCHIVAGE DES CHAMPS DERIVES (SENSIBILITE)
C
      ELSE IF (NATURE .EQ. 'ARCH_SENS') THEN
        CALL U2MESK('I','ARCHIVAGE_7',1,ARGZ)
C
C --- ARCHIVAGE DES MODES VIBRATOIRES
C
      ELSE IF (NATURE .EQ. 'ARCH_MODE_VIBR') THEN
        CALL U2MESI('I','ARCHIVAGE_8',1,ARGI)
C
C --- ARCHIVAGE DES MODES DE FLAMBEMENT
C
      ELSE IF (NATURE .EQ. 'ARCH_MODE_FLAM') THEN
        CALL U2MESI('I','ARCHIVAGE_9',1,ARGI)
      ELSE IF (NATURE .EQ. 'ARCH_MODE_STAB') THEN
        CALL U2MESI('I','ARCHIVAGE_10',1,ARGI)        
C
C --- IMPRESSION DES MODES VIBRATOIRES
C
      ELSE IF (NATURE .EQ. 'IMPR_MODE_VIBR') THEN
        CALL U2MESG('I','MECANONLINE6_10',0,' ',1,ARGI,1,ARGR)
C
C --- IMPRESSION DES MODES DE FLAMBEMENT
C
      ELSE IF (NATURE .EQ. 'IMPR_MODE_FLAM') THEN
        CALL U2MESG('I','MECANONLINE6_11',0,' ',1,ARGI,1,ARGR)
      ELSE IF (NATURE .EQ. 'IMPR_MODE_STAB') THEN       
        CALL U2MESG('I','MECANONLINE6_39',0,' ',1,ARGI,1,ARGR)         
C
C --- ERREUR
C
      ELSE IF (NATURE(1:6) .EQ. 'ERREUR') THEN
        CALL AFFICH('MESSAGE',LIGNE)
        CALL NMIMPA(ARGZ(1))
C
C --- RECAPITULATIF DES INFOS DE CONVERGENCE
C
      ELSE IF (NATURE .EQ. 'CONV_RECA') THEN
        CALL NMIMPS(SDIMPR)
C
C --- CRITERES DE CONVERGENCE ATTEINTS
C
      ELSE IF (NATURE .EQ. 'CONV_OK  ') THEN
        CALL U2MESS('I','MECANONLINE6_25')
C
C --- PAS DE CRITERES DE CONVERGENCE
C
      ELSE IF (NATURE .EQ. 'CONV_NONE') THEN
        CALL U2MESS('I','MECANONLINE6_26')
C
C --- CONVERGENCE FORCEE PAR ARRET = 'OUI'
C
      ELSE IF (NATURE .EQ. 'CONV_FORC') THEN
        CALL U2MESS('I','MECANONLINE6_27')
C
C --- RESI_GLOB_RELA ET CHARGEMENT = 0, CONVERGENCE SUR RESI_GLOB_MAXI
C
      ELSE IF (NATURE .EQ. 'CONV_MAXI') THEN
        CALL U2MESR('I','MECANONLINE6_28',1,ARGR)
C
C --- BOUCLE DE GEOMETRIE CONTACT METHODE CONTINUE
C
      ELSE IF (NATURE .EQ. 'BCL_GEOME') THEN
        CALL IMPSDR(SDIMPR,'BOUC_GEOM',K16BID,R8BID,ARGI(1))
        CALL IMPSDM(SDIMPR,'BOUC_GEOM','X')
C
C --- BOUCLE DE SEUIL CONTACT METHODE CONTINUE
C
      ELSE IF (NATURE .EQ. 'BCL_SEUIL') THEN
        CALL IMPSDR(SDIMPR,'BOUC_FROT',K16BID,R8BID,ARGI(1))
        CALL IMPSDM(SDIMPR,'BOUC_FROT','X')
C
C --- BOUCLE DE CONTRAINTES ACTIVES CONTACT METHODE CONTINUE
C
      ELSE IF (NATURE .EQ. 'BCL_CTACT') THEN
        CALL IMPSDR(SDIMPR,'BOUC_CONT',K16BID,R8BID,ARGI(1))
        CALL IMPSDM(SDIMPR,'BOUC_CONT','X')
C
C --- CONVERGENCE BOUCLE DE SEUIL CONTACT METHODE CONTINUE
C
      ELSE IF (NATURE .EQ. 'CNV_SEUIL') THEN
        CALL IMPSDM(SDIMPR,'BOUC_FROT',' ')
C
C --- CONVERGENCE BOUCLE DE CONTRAINTES ACTIVES CONTACT METHODE CONTINUE
C
      ELSE IF (NATURE .EQ. 'CNV_CTACT') THEN
        CALL IMPSDM(SDIMPR,'BOUC_CONT',' ')
C
C --- CONVERGENCE BOUCLE DE GEOMETRIE CONTACT CONTACT METHODE CONTINUE
C
      ELSE IF (NATURE .EQ. 'CNV_GEOME') THEN
        CALL IMPSDM(SDIMPR,'BOUC_GEOM',' ')
C
C --- DEUXIEME ESSAI POUR LE PILOTAGE
C
      ELSE IF (NATURE.EQ. 'AUTR_SOLU_PILO') THEN
        CALL U2MESS('I','MECANONLINE6_37')
C
      ELSE
        CALL ASSERT(.FALSE.)
      END IF
C
      CALL JEDEMA()
      END
