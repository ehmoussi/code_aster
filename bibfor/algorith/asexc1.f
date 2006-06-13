      SUBROUTINE ASEXC1( MOTFAC, NBOCC, NBMODE, PARMOD, AMORT, CORFRE,
     +                   NDIR, VALSPE, ASYSPE )
      IMPLICIT  REAL*8 (A-H,O-Z)
      INTEGER          NDIR(*)
      REAL*8           PARMOD(NBMODE,*),AMORT(*),VALSPE(3,*),ASYSPE(*)
      CHARACTER*(*)    MOTFAC
      LOGICAL          CORFRE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 06/04/2004   AUTEUR DURAND C.DURAND 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.      
C ======================================================================
C     ------------------------------------------------------------------
C     COMMANDE : COMB_SISM_MODAL
C                TRAITEMENT DU MOT-CLE "EXCIT" POUR LE MONO-APPUI
C     ------------------------------------------------------------------
C IN  : MOTFAC : MOT CLE FACTEUR
C IN  : NBOCC  : NOMBRE D'OCCURENCE DU MOT CLE FACTEUR
C IN  : NBMODE : NOMBRE DE MODES
C IN  : AMORT  : AMORTISSEMENTS MODAUX
C IN  : PARMOD : PARAMETRES MODAUX
C IN  : CORFRE : CORRECTION FREQUENCE SI .TRUE.
C OUT : NDIR   : DIRECTION DU SEISME A ETUDIER
C OUT : VALSPE : VALEURS DU SPECTRE
C OUT : ASYSPE : VALEURS ASYMPTOTIQUES DU SPECTRE
C     ------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16               ZK16
      CHARACTER*24                        ZK24
      CHARACTER*32                                 ZK32
      CHARACTER*80                                          ZK80
      COMMON  / KVARJE / ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
      CHARACTER*32       JEXNOM, JEXNUM
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C     ------------------------------------------------------------------
      INTEGER      NATURE(3)
      REAL*8       DIRSPE(3), ECHSPE(3), VALPU(2)
      CHARACTER*1  DIR(3)
      CHARACTER*4  KNAT
      CHARACTER*8  K8B, SPECT, NOMSPE(3), NOMPU(2)
      CHARACTER*9  NIVEAU
      CHARACTER*24 VALE
      CHARACTER*1 K1BID
C     ------------------------------------------------------------------
      DATA   VALE / '                   .VALE' /
      DATA  NOMPU / 'AMOR' , 'FREQ'    /
      DATA   DIR  / 'X' , 'Y' , 'Z' /
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
      IER    = 0
      IFM    = IUNIFI('RESULTAT')
      EPSI   = 1.D-03
      ZERO   = 0.D0
      UN     = 1.D0
      DEUXPI = R8DEPI()
      UNS2PI = UN / DEUXPI
C
C     --- LECTURE MOT-CLE FACTEUR IMPRESSION ---
C
      CALL GETVTX('IMPRESSION','NIVEAU',1,1,1,NIVEAU,NIMPR)
      IF (NIMPR.EQ.0) NIVEAU='TOUT     '
C
      DO 10 IOC = 1,NBOCC
C
         ECHSPE(1) = UN
         ECHSPE(2) = UN
         ECHSPE(3) = UN
         DIRSPE(1) = UN
         DIRSPE(2) = UN
         DIRSPE(3) = UN
         XNORM = UN
C
C        --- RECUPERATION DE LA DIRECTION DU SPECTRE ---
         CALL GETVR8(MOTFAC,'AXE',IOC,1,0,R8B,NA)
         IF (NA.NE.0) THEN
            CALL GETVR8(MOTFAC,'AXE' ,IOC,1,3,DIRSPE,ND)
            XNORM = ZERO
            DO 12 ID = 1,3
               XNORM = XNORM + DIRSPE(ID) * DIRSPE(ID)
 12         CONTINUE
            IF (XNORM.LT.EPSI) THEN
               IER = IER + 1
               CALL UTMESS('E',MOTFAC,'LE VECTEUR DIRECTEUR DU SPECTRE'
     +                                                    //' EST NUL.')
               GOTO 10
            ENDIF
            XNORM = UN / SQRT(XNORM)
            CALL GETVID(MOTFAC,'SPEC_OSCI',IOC,1,1,SPECT,NP)
            NOMSPE(1) = SPECT
            NOMSPE(2) = SPECT
            NOMSPE(3) = SPECT
            CALL GETVR8(MOTFAC,'ECHELLE',IOC,1,1,ECHEL,NE)
            IF (NE.NE.0) THEN
               ECHSPE(1) = ECHEL
               ECHSPE(2) = ECHEL
               ECHSPE(3) = ECHEL
            ENDIF
C
         ELSE
         CALL GETVR8(MOTFAC,'TRI_AXE'  ,IOC,1,0,R8B,NT)
         IF (NT.NE.0) THEN
            CALL GETVR8(MOTFAC,'TRI_AXE'  ,IOC,1,3,DIRSPE,ND)
            CALL GETVID(MOTFAC,'SPEC_OSCI',IOC,1,1,SPECT ,NP)
            NOMSPE(1) = SPECT
            NOMSPE(2) = SPECT
            NOMSPE(3) = SPECT
            CALL GETVR8(MOTFAC,'ECHELLE',IOC,1,1,ECHEL,NE)
            IF (NE.NE.0) THEN
               ECHSPE(1) = ECHEL
               ECHSPE(2) = ECHEL
               ECHSPE(3) = ECHEL
            ENDIF
C
         ELSE

            CALL GETVID(MOTFAC,'SPEC_OSCI',IOC,1,3,NOMSPE,NP)
            CALL GETVR8(MOTFAC,'ECHELLE'  ,IOC,1,3,ECHSPE,NE)
         ENDIF
         ENDIF
C
         CALL GETVTX(MOTFAC,'NATURE',IOC,1,1,KNAT,NT)
         IF (KNAT.EQ.'ACCE') INAT = 1
         IF (KNAT.EQ.'VITE') INAT = 2
         IF (KNAT.EQ.'DEPL') INAT = 3
C
         DO 14 ID = 1,3
            DIRSPE(ID) = XNORM * DIRSPE(ID)
            IF (ABS(DIRSPE(ID)).GT.EPSI) THEN
               IF (NDIR(ID).NE.0) THEN
                  IER = IER + 1
                  CALL UTMESS('E',MOTFAC,'CAS DU MONO_APPUI : VOUS'//
     +              ' AVEZ DEJA DONNE UN SPECTRE POUR CETTE DIRECTION.')
                  GOTO 10
               ELSE
                  NDIR(ID) = 1
               ENDIF
               NATURE(ID) = INAT
            ENDIF
 14      CONTINUE
C
 10   CONTINUE
C
      IF (IER.NE.0) CALL UTMESS('F',MOTFAC,' ERREUR(S) RENCONTREE(S)'//
     +                             ' LORS DE LA LECTURE DES SUPPORTS.')
C
C     --- INTERPOLATION DES SPECTRES ---
      IF (NIVEAU.EQ.'TOUT     ' .OR. NIVEAU.EQ.'SPEC_OSCI') THEN
         WRITE(IFM,1000)
         WRITE(IFM,1010)
      ENDIF
      DO 20 IM = 1,NBMODE
         II = 0
         AMOR     = AMORT(IM)
         OMEGA2   = PARMOD(IM,2)
         OMEGA    = SQRT( OMEGA2 )
         FREQ     = UNS2PI * OMEGA
         VALPU(1) = AMOR
         VALPU(2) = FREQ
         IF ( CORFRE ) VALPU(2) = VALPU(2) * SQRT( UN - AMOR*AMOR )
         DO 22 ID = 1,3
            IF (NDIR(ID).EQ.1) THEN
               CALL FOINTE('F ',NOMSPE(ID),2,NOMPU,VALPU,RESU,IER)
               COEF  = DIRSPE(ID)*ECHSPE(ID)
               IF (NATURE(ID).EQ.1) THEN
                  VALSPE(ID,IM) = RESU * COEF
               ELSEIF (NATURE(ID).EQ.2) THEN
                  VALSPE(ID,IM) = RESU * COEF * OMEGA
               ELSE
                  VALSPE(ID,IM) = RESU * COEF * OMEGA2
               ENDIF
               IF (NIVEAU.EQ.'TOUT     ' .OR.NIVEAU.EQ.'SPEC_OSCI') THEN
                  IF (II.EQ.0) THEN
                     II = 1
                     WRITE(IFM,1100)IM,FREQ,AMOR,DIR(ID),VALSPE(ID,IM)
                  ELSE
                     WRITE(IFM,1110)DIR(ID),VALSPE(ID,IM)
                  ENDIF
               ENDIF
            ENDIF
 22      CONTINUE
 20   CONTINUE
C
C     --- VALEURS ASYMPTOTIQUES DES SPECTRES ---
      IF (NIVEAU.EQ.'TOUT     ' .OR. NIVEAU.EQ.'SPEC_OSCI') THEN
         WRITE(IFM,1300)
         WRITE(IFM,1310)
      ENDIF
      DO 30 ID = 1,3
         IF (NDIR(ID).EQ.1) THEN
            VALE(1:8) = NOMSPE(ID)
            CALL JEVEUO(JEXNUM(VALE,1),'L',JVAR1)
            CALL JELIRA(JEXNUM(VALE,1),'LONMAX',NBPT1,K1BID)
            NBPT2 = NBPT1 / 2
            OMEGA = DEUXPI * ZR(JVAR1+NBPT2-1)
            RESU = ZR(JVAR1+NBPT1-1)
            COEF  = DIRSPE(ID)*ECHSPE(ID)
            IF (NATURE(ID).EQ.1) THEN
               ASYSPE(ID) = RESU * COEF
            ELSEIF (NATURE(ID).EQ.2) THEN
               ASYSPE(ID) = RESU * COEF * OMEGA
            ELSE
               ASYSPE(ID) = RESU * COEF * OMEGA * OMEGA
            ENDIF
            IF (NIVEAU.EQ.'TOUT     ' .OR. NIVEAU.EQ.'SPEC_OSCI') 
     &         WRITE(IFM,1410)DIR(ID),ASYSPE(ID)
         ENDIF
 30   CONTINUE
C
 1000 FORMAT(/,1X,'--- VALEURS DU SPECTRE ---')
 1010 FORMAT(1X,
     +'MODE      FREQUENCE    AMORTISSEMENT    DIR         SPECTRE')
 1100 FORMAT(1P,1X,I4,3X,D12.5,5X,D12.5,6X,A1,4X,D12.5)
 1110 FORMAT(1P,43X,A1,4X,D12.5)
 1300 FORMAT(/,1X,'--- VALEURS ASYMPTOTIQUES DU SPECTRE ---')
 1310 FORMAT(1X,'DIRECTION         SPECTRE')
 1410 FORMAT(1P,9X,A1,4X,D12.5)
C
      CALL JEDEMA()
      END
