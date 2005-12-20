      SUBROUTINE MASKMN(NBCMP,NBNO,NBEC,MCODDL,IMASK,NUMORD,NBDEF)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 25/11/98   AUTEUR CIBHHGB G.BERTRAND 
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
C***********************************************************************
C    P. RICHARD     DATE 20/02/91
C-----------------------------------------------------------------------
C  BUT:       CAS MAC NEAL
      IMPLICIT REAL*8 (A-H,O-Z)
C
C    CONTROLER LES DEFORMEES A CALCULER EN TENANT COMPTE DE
C   LA TABLE DES ENTIERS CODES DES DDL AU NOEUD ET DE LA LISTE
C    DES ENTIER CODES DES MASQUES AUX NOEUDS
C
C   TABLE DES ENTIER CODE:  COLONNE 1 DDL PHYSIQUES
C                           COLONNE 2 DDL LAGRANGES
C
C  LE RESULTAT EST POUR CHAQUE NOEUD UN ENTIER CODES DONNANT LA LISTE
C    DES TYPES DE DDL POUR LESQUELS UNE DEFORMEE DOIT ETRE CALCULEE
C
C-----------------------------------------------------------------------
C
C  NBCMP    /I/: NOMBRE DE COMPOSANTES DE LA GRANDEUR SOUS-JACENTE
C NBNO     /I/: NOMBRE DE NOEUDS DE LA TABLE
C MCODDL   /I/: TABLEAU DES ENTIER CODES
C IMASK    /M/: LISTE DES ENTIERS CODES MASQUES EN ENTREE
C NUMORD   /O/: NUMERO ORDRE PREMIERE DEFORME DE CHAQUE NOEUD
C NBDEF    /M/: NUMERO ORDRE DE LA DERNIERE DEFORMEE CALCULEE
C
C-----------------------------------------------------------------------
C
      PARAMETER (NBCPMX = 300)
      PARAMETER (NBECMX =  10)
      INTEGER   MCODDL(NBNO*NBEC,2), IMASK(NBNO*NBEC)
      INTEGER   IDEC(NBCPMX), NUMORD(NBNO), ICOCO(NBECMX), ICICI(NBECMX)
C
C-----------------------------------------------------------------------
C-----------------------------------------------------------------------
C
C      IF(NBNO.EQ.0) RETURN
C
      DO 10 I=1, NBECMX
        ICOCO(I) = 0
        ICICI(I) = 0
 10    CONTINUE
C
      DO 20 I=1,NBNO
C
        CALL ISGECO(MCODDL((I-1)*NBEC+1,1),MCODDL((I-1)*NBEC+1,2),
     +              NBCMP,-1,ICOCO)
        CALL ISGECO(ICOCO,IMASK((I-1)*NBEC+1),NBCMP,-1,ICICI)
C
        IEXCMP = 0
        DO 30 IEC = 1, NBEC
           IMASK((I-1)*NBEC+IEC) = ICICI(IEC)
           IF (ICICI(IEC).GT.1) THEN
             IEXCMP = 1
           ENDIF
 30     CONTINUE
        IF(IEXCMP.EQ.1) THEN
          NUMORD(I)=NBDEF+1
          CALL ISDECO(ICICI,IDEC,NBCMP)
          DO 40 J=1,NBCMP
            NBDEF=NBDEF+IDEC(J)
 40       CONTINUE
        ENDIF
C
 20   CONTINUE
C
 9999 CONTINUE
      END
