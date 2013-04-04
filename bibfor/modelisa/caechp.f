      SUBROUTINE CAECHP (CHAR,LIGRCH,LIGRMO,IGREL,INEMA,NOMA,FONREE,
     &                   NDIM)
      IMPLICIT NONE
      INCLUDE 'jeveux.h'

      CHARACTER*32 JEXNUM
      INTEGER           IGREL, INEMA, NDIM
      CHARACTER*4       FONREE
      CHARACTER*8       CHAR, NOMA
      CHARACTER*(*)     LIGRCH, LIGRMO
C---------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 02/04/2013   AUTEUR CUVILLIE M.CUVILLIEZ 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
C     BUT: REMPLIR LA CARTE .HECHP ET LE LIGREL DE CHARGE POUR LE MOT
C     CLE ECHANGE_PAROI
C
C ARGUMENTS D'ENTREE:
C IN   CHAR   K8  : NOM UTILISATEUR DU RESULTAT DE CHARGE
C IN   LIGRCH K19 : NOM DU LIGREL DE CHARGE
C IN   LIGRMO K19 : NOM DU LIGREL DU MODELE
C IN   IGREL  I   : NUMERO DU GREL DE CHARGE
C VAR  INEMA  I   : NUMERO  DE LA DERNIERE MAILLE TARDIVE DANS LIGRCH
C IN   NOMA   K8  : NOM DU MAILLAGE
C IN   FONREE K4  : 'FONC' OU 'REEL'
C
      INTEGER       NBTYMX,NECHP,IBID, IERD,
     &              JNCMP, JVALV, IOCC, NH, NT, I, J,
     &              NBTYP, JLISTT, NBM, NFISS, NFISMX, JMA, NTCON
      PARAMETER    (NFISMX=100)
      LOGICAL       LTCON,LCOEFH
C-----------------------------------------------------------------------
      INTEGER JLIGR ,NCMP
C-----------------------------------------------------------------------
      PARAMETER    (NBTYMX=7)
C --- NOMBRE MAX DE TYPE_MAIL DE COUPLAGE ENTRE 2 PAROIS
      REAL*8        T(3), CECHPR
      CHARACTER*8   MO, K8B, CECHPF, FISS(NFISMX)
      CHARACTER*16  MOTCLF
      CHARACTER*24  LIEL, MODL, LLIST1, LLIST2, LLISTT
      CHARACTER*19  CARTE
      CHARACTER*24  MESMAI,LISMAI
      INTEGER      IARG
C     ------------------------------------------------------------------
      CALL JEMARQ()
C
      MOTCLF = 'ECHANGE_PAROI'
      CALL GETFAC ( MOTCLF , NECHP )
      IF (NECHP.EQ.0) GOTO 9999
C
      LIEL = LIGRCH
      LIEL(20:24) = '.LIEL'
      MO = LIGRMO
      CALL DISMOI ( 'F','MODELISATION',MO,'MODELE',IBID,MODL,IERD)
C
C     LE MOT-CLE COEF_H EST-IL PRESENT ?
      LCOEFH=.FALSE.
      DO 100 IOCC = 1, NECHP
        IF (FONREE.EQ.'REEL') THEN
           CALL GETVR8 (MOTCLF,'COEF_H',IOCC,IARG,1,CECHPR,NH)
        ELSE IF (FONREE.EQ.'FONC') THEN
           CALL GETVID (MOTCLF,'COEF_H',IOCC,IARG,1,CECHPF,NH)
        ENDIF        
        IF (NH.NE.0) THEN
          LCOEFH=.TRUE.
          GOTO 200
        END IF
 100  CONTINUE
 200  CONTINUE
C
C     SI LE MOT-CLE COEF_H EST PRESENT, ON ALLOUE ET PREAPRE LA CARTE
      IF (LCOEFH) THEN
        CARTE = CHAR//'.CHTH.HECHP'
        IF (FONREE.EQ.'REEL') THEN
          CALL ALCART ( 'G', CARTE, NOMA, 'COEH_R')
        ELSE IF (FONREE.EQ.'FONC') THEN
          CALL ALCART ( 'G', CARTE, NOMA, 'COEH_F')
        ELSE
          CALL U2MESK('F','MODELISA2_37',1,FONREE)
        END IF
C       NOM DE LA CMP DU COEFFICIENT D'ECHANGE DANS LA CARTE
        CALL JEVEUO ( CARTE//'.NCMP', 'E', JNCMP )
        CALL JEVEUO ( CARTE//'.VALV', 'E', JVALV )
        NCMP = 1
        ZK8(JNCMP) = 'H'
      END IF
C
C ----------------------------------------------------------------------
C --- BOUCLE SUR LES OCCURENCES DU MCF
C ----------------------------------------------------------------------
      DO 300 IOCC = 1, NECHP
C
C       RECUPERATION DU COEFFICIENT D'ECHANGE
        IF (FONREE.EQ.'REEL') THEN
           CALL GETVR8 (MOTCLF,'COEF_H',IOCC,IARG,1,CECHPR,NH)
        ELSE IF (FONREE.EQ.'FONC') THEN
           CALL GETVID (MOTCLF,'COEF_H',IOCC,IARG,1,CECHPF,NH)
        ENDIF
C
C       RECUPERATION DU VECTEUR DE TRANSLATION POUR PATRMA
        DO 301 I = 1 , 3
           T(I) = 0.0D0
 301    CONTINUE
        CALL GETVR8 ( MOTCLF, 'TRAN', IOCC,IARG,3, T, NT )
        CALL GETVID(MOTCLF,'FISSURE',IOCC,IARG,0,K8B,NFISS)
C
C ----------------------------------------------------------------------
C ----- CAS MOT-CLEF FISSURE (X-FEM)
C ----------------------------------------------------------------------
        IF (NFISS.NE.0) THEN
C
C         RECUPERATION DU NOM DES FISSURES
          NFISS = -NFISS
          CALL GETVID(MOTCLF,'FISSURE',IOCC,IARG,NFISS,FISS , IBID )
C         VERIFICATION DE LA COHERENCE ENTRE LES FISSURES ET LE MODELE
          CALL XVELFM(NFISS,FISS,LIGRMO(1:8))
C
C         ON SCRUTE LE MC TEMP_CONTINUE
          LTCON=.FALSE.
          CALL GETVTX(MOTCLF,'TEMP_CONTINUE',IOCC,IARG,1,K8B,NTCON)
C         VERIF DE COHERENCE AVEC LE MC COEF_H
          IF (NTCON.EQ.1) THEN
            CALL ASSERT(K8B(1:3).EQ.'OUI'. AND. NH.EQ.0)
            LTCON=.TRUE.
          ELSE
            CALL ASSERT(NH.EQ.1 .AND. NTCON.EQ.0)
          END IF
C
C ----------------------------------------------------------------------
C ------- CAS TEMP_CONTINUE (X-FEM / PAS D'ECHANGE)
C ----------------------------------------------------------------------
          IF (LTCON) THEN
C
            CALL XTEMPC(NFISS,FISS,FONREE,CHAR)
C
C ----------------------------------------------------------------------
C ------- CAS COEF_H (X-FEM / ECHANGE) 
C ----------------------------------------------------------------------
          ELSE
C
C           ON NOTE 0. OU '&FOZERO' DANS LA CARTE POUR TOUT LE MAILLAGE
            IF (FONREE.EQ.'REEL') THEN
              ZR(JVALV) = 0.D0
            ELSE IF (FONREE.EQ.'FONC') THEN
              ZK8(JVALV) = '&FOZERO'
            ENDIF
            CALL NOCART(CARTE, 1, ' ', 'NOM', 0, ' ', 0,' ', NCMP)
C
C           RECUPERATION DES MAILLES PRINCIPALES XFEM POUR FISS(1:NFISS)
            MESMAI = '&&CAECHP.MES_MAILLES'
            LISMAI = '&&CAECHP.NUM_MAILLES'
            CALL XTMAFI(NOMA,NDIM,FISS,NFISS,LISMAI,MESMAI,NBM)
            CALL JEVEUO ( MESMAI, 'L', JMA )
C
C           STOCKAGE DANS LA CARTE SUR CES MAILLES
            IF (FONREE.EQ.'REEL') THEN
              ZR(JVALV) = CECHPR
            ELSE IF (FONREE.EQ.'FONC') THEN
              ZK8(JVALV) = CECHPF
            ENDIF
            CALL NOCART (CARTE,3,' ','NOM',NBM,ZK8(JMA),IBID,' ',NCMP)
C
C           MENAGE
            CALL JEDETR ( MESMAI )
            CALL JEDETR ( LISMAI )
C
          ENDIF
C
C ----------------------------------------------------------------------
C ----- CAS MOTS-CLEFS GROUP_MA_1... (PAROI MAILLEE)
C ----------------------------------------------------------------------
        ELSE
C
          LLIST1 = '&&CAECHP.LLIST1'
          LLIST2 = '&&CAECHP.LLIST2'
          LLISTT = '&&CAECHP.LLIST.TRIE'
C
          CALL PALIMA (NOMA,MOTCLF,'GROUP_MA_1','MAILLE_1',IOCC,LLIST1)
          CALL PALIMA (NOMA,MOTCLF,'GROUP_MA_2','MAILLE_2',IOCC,LLIST2)
C
          CALL PATRMA(LLIST1,LLIST2,T,NBTYMX,NOMA,LLISTT,NBTYP)
C
C         MISE A JOUR DE LIGRCH ET STOCKAGE DANS LA CARTE
          DO 400 J = 1,NBTYP
            IGREL = IGREL+1
            CALL JEVEUO(JEXNUM(LLISTT,J),'L',JLISTT)
            CALL PALIGI('THER',MODL,LIGRCH,IGREL,INEMA,ZI(JLISTT))
C           STOCKAGE DANS LA CARTE
            CALL JEVEUO ( JEXNUM(LIEL,IGREL), 'E', JLIGR )
            CALL JELIRA ( JEXNUM(LIEL,IGREL), 'LONMAX', NBM, K8B )
            NBM = NBM - 1
            IF (FONREE.EQ.'REEL') THEN
              ZR(JVALV) = CECHPR
            ELSE IF (FONREE.EQ.'FONC') THEN
              ZK8(JVALV) = CECHPF
            ENDIF
            CALL NOCART(CARTE,-3,' ','NUM',NBM,' ',ZI(JLIGR),LIGRCH,
     &                  NCMP)
 400      CONTINUE
C
C         MENAGE
          CALL JEDETR(LLIST1)
          CALL JEDETR(LLIST2)
          CALL JEDETR(LLISTT)
C ------ 
        ENDIF
C
 300  CONTINUE
C
 9999 CONTINUE
      CALL JEDEMA()
      END
