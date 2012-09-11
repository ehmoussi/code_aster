      SUBROUTINE LC0001(FAMI,KPG,KSP,NDIM,IMATE,NEPS,DEPS,
     &  NSIG,SIGM,OPTION,ANGMAS,SIGP,VIP,TYPMOD,NDSDE,DSIDEP,CODRET)
      IMPLICIT NONE
      INTEGER IMATE,NDIM,KPG,KSP,CODRET,ICODRE
      INTEGER NEPS,NSIG,NDSDE
      REAL*8  ANGMAS(3),DEPS(NEPS),SIGM(NSIG),SIGP(NSIG)
      REAL*8  VIP(1),DSIDEP(NDSDE)
      CHARACTER*16    OPTION
      CHARACTER*8     TYPMOD(*)
      CHARACTER*(*)   FAMI
      CHARACTER*16 MCMATE
C
C ----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 10/09/2012   AUTEUR PROIX J-M.PROIX 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE PROIX J-M.PROIX
C TOLE CRP_21
C ======================================================================
C.......................................................................
C
C     BUT: LOI DE COMPORTEMENT ELASTIQUE 
C
C          RELATIONS : 'ELAS'

C       IN      FAMI    FAMILLE DE POINT DE GAUSS (RIGI,MASS,...)
C       IN      KPG,KSP NUMERO DU (SOUS)POINT DE GAUSS
C       IN      NDIM    DIMENSION DE L ESPACE (3D=3,2D=2,1D=1)
C               TYPMOD  TYPE DE MODELISATION
C               IMATE    ADRESSE DU MATERIAU CODE
C               COMPOR    COMPORTEMENT DE L ELEMENT
C                     COMPOR(1) = RELATION DE COMPORTEMENT (CHABOCHE...)
C                     COMPOR(2) = NB DE VARIABLES INTERNES
C                     COMPOR(3) = TYPE DE DEFORMATION (PETIT,JAUMANN...)
C               CRIT    CRITERES  LOCAUX
C                       CRIT(1) = NOMBRE D ITERATIONS MAXI A CONVERGENCE
C                                 (ITER_INTE_MAXI == ITECREL)
C                       CRIT(2) = TYPE DE JACOBIEN A T+DT
C                                 (TYPE_MATR_COMP == MACOMP)
C                                 0 = EN VITESSE     > SYMETRIQUE
C                                 1 = EN INCREMENTAL > NON-SYMETRIQUE
C                                 9 = methode IMPLEX
C                       CRIT(3) = VALEUR DE LA TOLERANCE DE CONVERGENCE
C                                 (RESI_INTE_RELA == RESCREL)
C                       CRIT(5) = NOMBRE D'INCREMENTS POUR LE
C                                 REDECOUPAGE LOCAL DU PAS DE TEMPS
C                                 (ITER_INTE_PAS == ITEDEC)
C                                 0 = PAS DE REDECOUPAGE
C                                 N = NOMBRE DE PALIERS
C               INSTAM   INSTANT T
C               INSTAP   INSTANT T+DT
C               EPSM   DEFORMATION TOTALE A T
C               DEPS   INCREMENT DE DEFORMATION TOTALE
C               SIGM    CONTRAINTE A T
C               VIM    VARIABLES INTERNES A T    + INDICATEUR ETAT T
C               OPTION     OPTION DE CALCUL A FAIRE
C                             'RIGI_MECA_TANG'> DSIDEP(T)
C                             'FULL_MECA'     > DSIDEP(T+DT) , SIG(T+DT)
C                             'RAPH_MECA'     > SIG(T+DT)
C                             'RIGI_MECA_IMPLEX' > DSIDEP(T), SIGEXTR
C               WKIN  TABLEAUX DES ELEMENTS GEOMETRIQUES SPECIFIQUES
C                       AUX LOIS DE COMPORTEMENT (DIMENSION MAXIMALE
C                       FIXEE EN DUR)
C               ANGMAS
C       OUT     SIGP    CONTRAINTE A T+DT
C               VIP    VARIABLES INTERNES A T+DT + INDICATEUR ETAT T+DT
C               DSIDEP    MATRICE DE COMPORTEMENT TANGENT A T+DT OU T
C.......................................................................
C               CODRET
C


C     RECUPERATION DE MCMATER (APPELE A TORT 'PHENOMENE')
      CALL RCCOMA(IMATE,'ELAS',MCMATE,ICODRE)
      CALL ASSERT(ICODRE.EQ.0)

      IF (MCMATE.EQ.'ELAS') THEN
      
        CALL NMELAS (FAMI,KPG,KSP,NDIM,TYPMOD,IMATE,
     &               DEPS,SIGM,OPTION,SIGP,VIP,DSIDEP,CODRET)
     
      ELSEIF (MCMATE.EQ.'ELAS_ORTH'.OR.MCMATE.EQ.'ELAS_ISTR') THEN
      
        CALL NMORTH (FAMI,KPG,KSP,NDIM,MCMATE,IMATE,'T',
     &               DEPS,SIGM,OPTION,ANGMAS,SIGP,VIP,
     &               DSIDEP)
      ENDIF
        

      END
