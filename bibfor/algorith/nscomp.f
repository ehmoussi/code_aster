      SUBROUTINE NSCOMP(OPTION,TYPMOD,COMPOR,NDIM,IMATE,IMATSE,EPS,
     &      DEPS,DEDT,SIGMS,VARMS,VARM,SIGM,VARP,SIPAS,SIGP,SIGPS,
     &      VARPS,STYPSE)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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

      IMPLICIT NONE
      INTEGER            NDIM,IMATE,IMATSE
      CHARACTER*8       TYPMOD(*)
      CHARACTER*16      OPTION,COMPOR(4)
      CHARACTER*24      STYPSE
      REAL*8      EPS(*), DEPS(*),SIGMS(*),VARMS(*),VARPS(*),DEDT(*)
      REAL*8      VARM(*),SIGM(*),VARP(*),SIPAS(*),SIGP(*),SIGPS(*)

C ----------------------------------------------------------------------
C     INTEGRATION DES LOIS DE COMPORTEMENT SENSIBLES NON LINEAIRE
C     POUR LES ELEMENTS ISOPARAMETRIQUES EN PETITES DEFORMATIONS
C
C IN  OPTION  : OPTION DEMANDEE
C IN  NDIM    : DIMENSION DE L'ESPACE
C IN  IMATE   : ADRESSE DU MATERIAU CODE
C IN  IMATSE  : ADRESSE DU MATERIAU CODE SENSIBLE
C IN  EPS     : DEFORMATION A L'INSTANT -
C IN  DEPS    : INCR. DE DEFORMATION
C IN  DEDT    : INCR. DE DEFORMATION (2EME PASSAGE)
C IN  SIGMS   : CONTRAINTES SENSIBLES A L'INSTANT -
C IN  VARMS   : VAR INTERNES SENSIBLES A L'INSTANT -
C IN  VARM    : VAR INTERNES A L'INSTANT -
C IN  SIGM    : CONTRAINTES A L'INSTANT -
C IN  VARP    : VAR INTERNES A L'INSTANT +
C IN  SIGP    : CONTRAINTES A L'INSTANT +
C OUT SIGPS   : CONTRAINTES SENSIBLES A L'INSTANT +
C OUT VARPS   : VAR INTERNES SENSIBLES A L'INSTANT +
C
C   ATTENTION :
C      - POUR L'OPTION MECA_SENS_MATE, EPS ET DEPS SONT DES
C        CHAMPS DIRECTS (NON DERIVES),SIGMS SONT LES CONTRAINTES
C        SENSIBLES A L'INSTANT -, SIGPS SONT LES CONTRAINTES
C        SENSIBLES PARTIELLES A L'INSTANT +
C      - POUR L'OPTION MECA_SENS_CHAR, EPS ET DEPS SONT DES
C        CHAMPS DIRECTS (NON DERIVES),SIGMS SONT LES CONTRAINTES
C        SENSIBLES A L'INSTANT -, SIGPS SONT LES CONTRAINTES
C        SENSIBLES PARTIELLES A L'INSTANT +
C      - POUR L'OPTION MECA_SENS_RAPH, DEDT EST UN CHAMP
C        DIRECT (NON DERIVE), EPS ET DEPS SONT DES
C        CHAMPS SENSIBLES (DERIVES),SIGMS SONT LES CONTRAINTES
C        SENSIBLES A L'INSTANT -, SIPAS SONT LES CONTRAINTES
C        SENSIBLES PARTIELLES A L'INSTANT +, SIGPS SONT LES
C        CONTRAINTES SENSIBLES A L'INSTANT +
C
C ----------------------------------------------------------------------
C

      IF ((COMPOR(1)(1:5).EQ.'ELAS ') .OR.
     &    (COMPOR(1)(1:9).EQ.'VMIS_ISOT')) THEN
       CALL NSISOT (OPTION,COMPOR,NDIM,IMATE,IMATSE,DEPS,DEDT,SIGMS,
     &     VARMS,VARM,SIGM,VARP,SIPAS,SIGP,SIGPS,VARPS,STYPSE)
      ELSEIF (COMPOR(1)(1:14).EQ.'DRUCKER_PRAGER') THEN
       CALL NSDRPR (OPTION,TYPMOD,COMPOR,NDIM,IMATE,IMATSE,DEPS,DEDT,
     &      SIGMS,VARMS,VARM,SIGM,VARP,SIPAS,SIGP,SIGPS,VARPS,STYPSE)
      ELSE
       CALL U2MESK('F','ALGORITH8_94',1,COMPOR(1))
      ENDIF

      END
