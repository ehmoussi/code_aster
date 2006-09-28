      SUBROUTINE PECAP3(CHGEOZ,TEMPEZ,IOMEGA)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C.======================================================================
      IMPLICIT REAL*8 (A-H,O-Z)

C      PECAP3  -- CALCUL DE LA CONSTANTE DE GAUCHISSEMENT D'UNE POUTRE
C                 DEFINIE PAR SA SECTION MAILLEE EN ELEMENTS
C                 MASSIFS 2D.
C                 CETTE CONSTANTE DE GAUCHISSEMENT EST AUSSI
C                 APPELEE INERTIE DE GAUCHISSEMENT.

C          .LE DOMAINE SUR-LEQUEL ON TRAVAILLE REPRESENTE LA
C           SECTION DE LA POUTRE MAILLEE AVEC DES ELEMENTS 2D
C           ISOPARAMETRIQUES THERMIQUES (THERMIQUES CAR ON
C           DOIT RESOUDRE UNE EQUATION DE LAPLACE).

C          .LA CONSTANTE DE GAUCHISSEMENT IOMEGA EST DETERMINEE
C           DE LA MANIERE SUIVANTE :
C             EN SE PLACANT DANS LE REPERE PRINCIPAL D'INERTIE
C             AVEC COMME ORIGINE LE CENTRE DE TORSION

C             1)SI L'ON ECRIT L'EQUATION D'EQUILIBRE LOCALE :
C                DIV(SIGMA) = 0 SELON L'AXE DE LA POUTRE
C                ON OBTIENT POUR LE PROBLEME DE TORSION L'EQUATION :
C                LAPLACIEN(OMEGA) = 0     DANS LA SECTION

C             2)D'AUTRE-PART, LA SECTION ETANT EN EQUILIBRE
C               LA FORCE NORMALE AU CONTOUR EN TOUT POINT DE CE
C               CONTOUR EST NULLE , SOIT (SIGMA).N = 0
C              CE QUI DONNE POUR LE PROBLEME DE TORSION :
C     D(OMEGA)/D(N) = Z*NY-Y*NZ   SUR LE CONTOUR DE LA SECTION
C     NY ET NZ ETANT LES COMPOSANTES DU VECTEUR N NORMAL A CE CONTOUR

C             3)ON OBTIENT LA CONDITION DIRICHLET PERMETTANT
C     DE RESOUDRE LE PROBLEME EN ECRIVANT :
C             SOMME/SECTION(OMEGA.DS) = 0
C     (CA VIENT DE L'EQUATION D'EQUILIBRE SELON L'AXE DE LA POUTRE
C      SOIT N = 0 , N ETANT L'EFFORT NORMAL
C      OR N = SOMME/SECTION(SIGMA_XX.DS)
C         N = SOMME/SECTION(E*OMEGA(Y,Z)*THETA_X,XX.DS) )

C     ON A ALORS IOMEGA = SOMME_S(OMEGA**2.DS)

C     L'OPTION : 'CARA_GAUCHI'   CALCULE :
C       IOMEGA  =  SOMME/SECTION(OMEGA**2.DS)

C   ARGUMENT        E/S  TYPE         ROLE
C    CHGEOZ         IN    K*      COORDONNEES DES CONNECTIVITES
C                                 DANS LE REPERE PRINCIPAL D'INERTIE
C    TEMPEZ         IN    K*      RESULTAT DE TYPE EVOL_THER
C                                 REFERENCANT LE CHAMP DE SCALAIRES
C                                 SOLUTION DE L'EQUATION 1
C    IOMEGA         OUT   R       CONSTANTE DE GAUCHISSEMENT

C.========================= DEBUT DES DECLARATIONS ====================
C -----  ARGUMENTS
      CHARACTER*(*) CHGEOZ,TEMPEZ
      REAL*8 IOMEGA
C -----  VARIABLES LOCALES
      CHARACTER*8 LPAIN(2),LPAOUT(1)
      CHARACTER*8 TEMPER
      CHARACTER*8 CRIT,MODELE,K8BID
      CHARACTER*14 NUMDDL
      CHARACTER*14 TYPRES
      CHARACTER*19 KNUM,LIGRTH
      CHARACTER*24 LCHIN(2),LCHOUT(1),CHGEOM
      CHARACTER*24 CHTEMP
      REAL*8 WORK(9)
      COMPLEX*16 CBID
C.========================= DEBUT DU CODE EXECUTABLE ==================

C ---- INITIALISATIONS
C      ---------------
      ZERO = 0.0D0
      PREC = 1.0D-3
      CHGEOM = CHGEOZ
      TEMPER = TEMPEZ
      KNUM = '&&PECAP3.NUME_ORD_1'
      CRIT = 'RELATIF'

      DO 10 I = 1,9
        WORK(I) = ZERO
   10 CONTINUE

C --- ON VERIFIE QUE LE RESULTAT EST DE TYPE EVOL_THER :
C     ------------------------------------------------
      CALL DISMOI('F','TYPE_RESU',TEMPER,'RESULTAT',IBID,TYPRES,IERD)
      IF (TYPRES.NE.'EVOL_THER') THEN
        CALL U2MESS('F','UTILITAI3_57')
      END IF

C --- RECUPERATION DU NOMBRE D'ORDRES DU RESULTAT :
C     -------------------------------------------
      CALL RSUTNU(TEMPER,' ',0,KNUM,NBORDR,PREC,CRIT,IRET)
      IF (NBORDR.NE.1) THEN
        CALL U2MESK('F','UTILITAI3_58',1,TEMPER)
      END IF
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
C      CALL UTIMSD(IFM,2,.FALSE.,.TRUE.,TEMPER,1,' ')
CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC

C --- RECUPERATION DU CHAMP DE TEMPERATURES DU RESULTAT :
C     -------------------------------------------------
      CALL RSEXCH(TEMPER,'TEMP',0,CHTEMP,IRET)
      IF (IRET.GT.0) THEN
        CALL U2MESK('F','UTILITAI3_52',1,TEMPER)
      END IF

C --- RECUPERATION DU NUME_DDL ASSOCIE AU CHAMP DE TEMPERATURES :
C     ---------------------------------------------------------
      CALL DISMOI('F','NOM_NUME_DDL',CHTEMP,'CHAM_NO',IBID,NUMDDL,IERD)

C --- RECUPERATION DU MODELE ASSOCIE AU NUME_DDL  :
C     ------------------------------------------
      CALL DISMOI('F','NOM_MODELE',NUMDDL,'NUME_DDL',IBID,MODELE,IERD)

C --- RECUPERATION DU LIGREL DU MODELE  :
C     --------------------------------
      CALL DISMOI('F','NOM_LIGREL',MODELE,'MODELE',IBID,LIGRTH,IERD)

C --- CALCUL POUR CHAQUE ELEMENT DE LA SECTION DE L'INTEGRALE DU
C --- CHAMP DE SCALAIRES SOLUTION DE L'EQUATION DE LAPLACE AU CARRE :
C     -------------------------------------------------------------
      LPAIN(1) = 'PGEOMER'
      LCHIN(1) = CHGEOM
      LPAIN(2) = 'PTEMPER'
      LCHIN(2) = CHTEMP
      LPAOUT(1) = 'PCASECT'
      LCHOUT(1) = '&&PECAP3.INTEG1'

      CALL CALCUL('S','CARA_GAUCHI',LIGRTH,2,LCHIN,LPAIN,1,LCHOUT,
     &            LPAOUT,'V')

C --- SOMMATION DES INTEGRALES PRECEDENTES SUR LA SECTION DE LA POUTRE
C --- (I.E. CALCUL DE SOMME_SECTION_POUTRE(OMEGA**2.DS)) :
C     --------------------------------------------------
      CALL MESOMM(LCHOUT(1),9,IBID,WORK,CBID,0,IBID)
      IOMEGA = WORK(1)

      CALL JEDETC('V','&&PECAP3.INTEG',1)
C.============================ FIN DE LA ROUTINE ======================
      END
