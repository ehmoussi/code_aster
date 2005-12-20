      SUBROUTINE  XREFRE(JGANO,SIGSAM,NNOP,NAJ,CNSE,ISE,SIGNO)
      IMPLICIT NONE
C
      INTEGER       JGANO,NNOP,NAJ(NNOP),CNSE(6,4),ISE
      REAL*8        SIGSAM(6,4),SIGNO(6,NNOP)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 05/07/2004   AUTEUR GENIAUT S.GENIAUT 
C ======================================================================
C COPYRIGHT (C) 1991 - 2004  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE GENIAUT S.GENIAUT
C
C  BUT : PASSAGE DE SIGSAM AUX POITNS DE GAUSS ENFANT AUX NOEUDS PARENT
C
C  ENTR�ES
C    JGANO  : ADRESSE DE LA MATRICE DE PASSAGE GAUSS-NOEUDS DU SOUS-�LT
C    SIGSAM : CONTRAINTES AUX POINTS DE GAUSS ENFANT
C    NNOP   : NOMBRE DE NOEUDS DE L'�L�MENT PARENT
C    NAJ    : NOMBRE DE VALEURS AUX NOEUDS PARENTS
C    CNSE   : CONNECTIVIT� DE SOUS-�L�MENTS
C    ISE    : INDICE DU SOUS-�L�MENT
C   
C  SORTIES
C    NAJ    : NOMBRE DE VALEURS AUX NOEUDS PARENTS
C    SIGNO  : CONTRAINTES AUX NOEUDS PARENT
C......................................................................
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER  ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------
C
C--------------------------------------------------------------------
      INTEGER    I,IN,J,JMAT,IC
      REAL*8     VPG(6*4),VNO(6*4),S

C     POUR LE SOUS-TETRA COURANT, ON A SIGSAM, VALEURS DE SIG AUX 
C     PTS DE GAUSS DU SS-TETRA

C     PASSAGE DES VALEURS AUX POINTS DE GAUSS AUX VALEURS AUX NOEUDS
C      CALL PPGAN2(JGANO,3,VPG,VNO)
      JMAT = JGANO + 2
      DO 30 IC = 1,6
        DO 40 I = 1,4
          S = 0.D0
          DO 50 J = 1,4
            S = S + ZR(JMAT-1+ (I-1)*4+J)*SIGSAM(IC,J)
   50     CONTINUE
          VNO(6*(I-1)+IC) = S
   40   CONTINUE
   30 CONTINUE


C     REMPLISSAGE DE SIGMA AUX NOEUDS PARENTS SIGNO(6,NNOP)
C     ON SE FOUT DES PTS D'INTERSECTION 101,102,103 ET 104
      DO 60 I=1,4
         IN=CNSE(ISE,I)
         IF (IN.LT.100) THEN
           DO 70 J=1,6
             SIGNO(J,IN)=SIGNO(J,IN)+VNO(6*(I-1)+J)
             NAJ(IN)=NAJ(IN)+1
 70        CONTINUE
        ENDIF
 60   CONTINUE

      END
