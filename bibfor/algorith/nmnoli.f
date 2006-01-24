      SUBROUTINE NMNOLI(COMPOR,PARTPS,CRITNL,DERNIE,VARDEM,LAGDEM,CMD,
     &                  VITPLU,ACCPLU,NBMODS,DEPENT,VITENT,ACCENT,
     &                  NBPASE,INPSCO,MODELE,MATE,CARELE,LISCHA)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 23/01/2006   AUTEUR MABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C RESPONSABLE MABBAS M.ABBAS

      IMPLICIT NONE
      INTEGER DERNIE,NBMODS,NBPASE
      CHARACTER*8 NOPASE
      CHARACTER*13 INPSCO
      CHARACTER*16 CMD
      CHARACTER*19 PARTPS,CRITNL, LISCHA
      CHARACTER*24 COMPOR,VARDEM,LAGDEM
      CHARACTER*24 VITPLU,ACCPLU,DEPENT,VITENT,ACCENT
      CHARACTER*24 MODELE,MATE,CARELE
C ----------------------------------------------------------------------
C          STAT_NON_LINE : PREPARATION DE LA SD EVOL_NOLI
C ----------------------------------------------------------------------

C IN  COMPOR K24 COMPORTEMENT
C IN  PARTPS K19 SD DISC_INST
C IN  CRITNL K19 INFORMATIONS RELATIVES A LA CONVERGENCE
C IN  DERNIE  I  NUMERO DU DERNIER NUMERO ARCHIVE (OU 0 SI NOUVEAU)
C IN  DEPMOI K24 DEPLACEMENT DE L'ETAT INITIAL
C IN  SIGMOI K24 CONTRAINTES DE L'ETAT INITIAL
C IN  VARMOI K24 VARIABLES INTERNES DE L'ETAT INITIAL
C IN  VARDEM K24 VARIABLES NON LOCALES DE L'ETAT INITIAL
C IN  LAGDEM K24 MULTIPLICATEURS DE LAGRANGE NON LOCAUX INITIAUX
C IN  NBPASE  I  NOMBRE DE PARAMETRES SENSIBLES
C IN  INPSCO K13 SD CONTENANT LISTE DES NOMS POUR SENSIBILITE
C ----------------------------------------------------------------------

      INTEGER NUMARC,DINUAR,NRPASE,IAUX,JAUX,IFM,NIV
      LOGICAL LBID
      CHARACTER*8 RESULT
      CHARACTER*19 K19BID
      CHARACTER*24 VALINI(8),K24BLA
      CHARACTER*24 DEPMOI,SIGMOI,VARMOI

      DATA K19BID/' '/
      DATA K24BLA/' '/
C ----------------------------------------------------------------------

      CALL INFNIV(IFM,NIV)


C  --  NOUVEAU CONCEPT

      IF (DERNIE.EQ.0) THEN

        NUMARC = DINUAR(PARTPS)

C      BOUCLE SUR LES EVENTUELS CALCULS SENSIBLES
        DO 10 NRPASE = NBPASE,0,-1
          IAUX = NRPASE
          JAUX = 3
          CALL PSNSLE(INPSCO,IAUX,JAUX,RESULT)
          JAUX = 5
          CALL PSNSLE(INPSCO,IAUX,JAUX,DEPMOI)
          JAUX = 9
          CALL PSNSLE(INPSCO,IAUX,JAUX,SIGMOI)
          JAUX = 11
          CALL PSNSLE(INPSCO,IAUX,JAUX,VARMOI)
          IF (CMD(1:4).NE.'DYNA') THEN
            JAUX = 14
            CALL PSNSLE(INPSCO,IAUX,JAUX,VITPLU)
            JAUX = 16
            CALL PSNSLE(INPSCO,IAUX,JAUX,ACCPLU)
            JAUX = 18
            CALL PSNSLE(INPSCO,IAUX,JAUX,DEPENT)
            JAUX = 20
            CALL PSNSLE(INPSCO,IAUX,JAUX,VITENT)
            JAUX = 22
            CALL PSNSLE(INPSCO,IAUX,JAUX,ACCENT)
          END IF
C        CREATION DE LA SD EVOL_NOLI
          CALL RSCRSD(RESULT,'EVOL_NOLI',100)

C        ARCHIVAGE DE L'ETAT INITIAL
          IF (NUMARC.EQ.0) THEN

            CALL AGGLOM(DEPMOI,SIGMOI,VARMOI,K24BLA,VARDEM,LAGDEM,
     &                  K24BLA,K24BLA,6,VALINI)

            CALL NMIMPR('IMPR','ARCH_INIT',' ',0.D0,0)
            IF (NRPASE.GT.0) THEN
              IAUX = NRPASE
              JAUX = 1
              CALL PSNSLE(INPSCO,IAUX,JAUX,NOPASE)
              WRITE (IFM,*)
     &          'ARCHIVAGE DES CHAMPS DERIVES PAR RAPPORT A '//NOPASE
            END IF
            LBID = NRPASE.EQ.0
            CALL NMARCH(RESULT,0,PARTPS,.TRUE.,COMPOR,CRITNL,VALINI,
     &                  K19BID,CMD,VITPLU,ACCPLU,NBMODS,DEPENT,VITENT,
     &                  ACCENT,LBID,MODELE,MATE,CARELE,LISCHA)

          END IF

   10   CONTINUE


C  --  CONCEPT REENTRANT

      ELSE

C      SUPPRESSION DES NUMEROS D'ARCHIVAGE A ECRASER
        NUMARC = DINUAR(PARTPS)
        DO 20 NRPASE = 0,NBPASE
          IAUX = NRPASE
          JAUX = 3
          CALL PSNSLE(INPSCO,IAUX,JAUX,RESULT)
          CALL RSRUSD(RESULT,NUMARC)
   20   CONTINUE


      END IF


      END
