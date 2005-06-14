      SUBROUTINE ANGCOU(COOR,ZK1,IZK,ICOUDE,ZK2,RAYON,THETA,
     &    ANGL1,ANGL2,ANGL3,PGL1,PGL2,PGL3,OMEGA,DN1N2,EPSI,CRIT,ZK3)
      IMPLICIT REAL*8 (A-H,O-Z)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 08/03/2004   AUTEUR REZETTE C.REZETTE 
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
      REAL*8  COOR(9),RAYON,THETA,EPSI,T1(3),T2(3),COO1(3),COO2(3)
      REAL*8  COO3(3),NORME1,NORME2,NORMEZ,X3(3),X1(3),X2(3),CT2,ST2
      REAL*8  Y1(3),Y2(3),Y3(3),PGL1(3,3),PGL2(3,3),PGL3(3,3),A(3)
      REAL*8  ANGL1(3),ANGL2(3),ANGL3(3),COSOME,SINOME,NX1,ZCOUD(3)
      REAL*8  ZK1(3),ZK2(3),AXE(3),ZZK1(3),ZZZK1(3),ZKINI(3),ZK3(3),R8PI
      REAL*8 COSTET,CT,ST,OMEGA,DN1N2,NX2,OMEGA2,NORME3,EPSI2,THEMAX
      REAL*8 PSCA
      CHARACTER*8  CRIT
C ......................................................................
C
C    - FONCTION REALISEE:  CALCUL DE LA GEOMETRIE TUYAU DROIT OU COURBE 
C    - ARGUMENTS
C        DONNEES:      COOR       -->  CORDONNEES DES NOEUDS
C                      ZK1        -->  VECTEUR ZK A UN NOEUD EXTREMITE
C                      IZK        -->  INDICE DE PARCOURS
C                      EPSI       -->  PRECISION POUR LE CALCUL
C                      CRIT       -->  RELATIF OU ABSOLU
C         SORTIE:      ICOUDE     -->  =0 DROIT =1 COUDE
C                      ZK2        -->  VECTEUR ZK A L'AUTRE EXTREMITE
C                      RAYON      -->  RAYON DU COUDE SI C'EN EST UN
C                      THETA      -->  ANGLE DU COUDE 
C                      ANGL1,2,3  -->  ANGLES NAUTIQUES EN CHAQUE NOEUD
C                      PGL1,2,3   -->  MATRICE DE CHAGMENT DE REPERE 
C                      OMEGA      -->  ANGLE ENTRE N ET LA GENERATRICE  
C                      DN1N2      -->  DN1N2  DISTANCE ENTRE EXTREMITES
C                      ZK2        -->  VECTEUR ZK AU NOEUD MILIEU
C ......................................................................
C       
      INTEGER    ICOUDE,I,IZK,IFM,NIV
C
C                          NOEUD 3 = NOEUD MILIEU
      DO 1 I=1,3
         ANGL1(I)=0.D0
         ANGL2(I)=0.D0
         ANGL3(I)=0.D0
         COO1(I)=COOR(I)
         COO2(I)=COOR(3+I)
         COO3(I)=COOR(6+I)
         ZKINI(I)=ZK1(I)
1     CONTINUE

C     POUR VERIFICATIONS (PAS TRES EXIGEANTES) SUR LA GEOMETRIE
C     SINON, IL FAUDRAIT INTRODUIRE UN AUTRE MOT CLE PRECISON2
C     DIFFERENT DE PRECISION

      EPSI2 = 1.D-4
      THEMAX = R8PI()/8.D0*(1.D0+EPSI2)

      DN1N2 = SQRT( ( COO1(1)-COO2(1) )**2 +
     &              ( COO1(2)-COO2(2) )**2 +
     &              ( COO1(3)-COO2(3) )**2 )
C
      CALL VDIFF(3,COO3,COO1,T1)
      CALL VDIFF(3,COO2,COO3,T2)
      CALL NORMEV(T1,NORME1)
      CALL NORMEV(T2,NORME2)
      CALL PROVEC(T2,T1,ZCOUD)
      CALL NORMEV(ZCOUD,NORMEZ)
      
C     VERIF QUE LE NOEUD MILIEU EST BIEN LE TROISIEME      
      CALL PSCAL(3,T2,T1,PSCA)
      IF (PSCA.LE.0.D0) THEN
         CALL UTMESS('F','ANGCOU','PROBLEME DE MAILLAGE TUYAU : '//
     &   ' POUR UNE MAILLE DEFINIE PAR LES NOEUDS N1 N2 N3 '//
     &   ' LE NOEUD N3 DOIT ETRE LE NOEUD MILIEU')
      ENDIF

C     EPSI EST CELUI DONNE PAR LE MOT CLE PRECISION

      IF (CRIT.EQ.'RELATIF') THEN
C     CONTRAIREMENT AUX APPARENCES C'EST UN CRITERE RELATIF
C     PUISQUE T1 ET T2 SONT NORMES
         TEST = EPSI
      ELSEIF (CRIT.EQ.'ABSOLU') THEN
         TEST = EPSI/NORME1/NORME2
      ENDIF

C     TUYAU DROIT OU COURBE ?

      IF(NORMEZ.LE.TEST) THEN
         ICOUDE=0
         RAYON = 0.D0
         THETA = 0.D0
         OMEGA = 0.D0
         CALL VDIFF(3,COO2,COO1,X1)
C
C        ON VEUT UN ZK1 PERPENDICULAIRE A X1
C        ON PROJETTE ZK1 SUR LE PLAN NORMAL A X1
C
         CALL PROVEC(X1,ZKINI,A)
         CALL NORMEV(A,NORME1)

C        TEST DE NON COLINEARITE

         CALL NORMEV(ZKINI,NORME3)
         TEST = EPSI2*DN1N2*NORME3

         IF(NORME1.LE.TEST) THEN
            CALL UTMESS('F','ANGCOU',' GENE_TUYAU '//
     +      'IL FAUT DONNER UN VECTEUR NON COLINEAIRE AU TUYAU')
         ENDIF

         CALL PROVEC(A,X1,ZK1)
         CALL NORMEV(ZK1,NORME2)
         DO 5 I=1,3
            ZK2(I)=ZK1(I)
            ZK3(I)=ZK1(I)
5        CONTINUE
         CALL PROVEC(X1,ZK1,Y1)
         CALL ANGVXY(X1,Y1,ANGL1)
         DO 51 I=1,3
            ANGL2(I)=ANGL1(I)
            ANGL3(I)=ANGL1(I)
51       CONTINUE

         CALL MATROT(ANGL1,PGL1)
         CALL MATROT(ANGL2,PGL2)
         CALL MATROT(ANGL3,PGL3)
C
      ELSE
         ICOUDE=1
         CALL PSCAL(3,T1,T2,COSTET)
         THETA=2.D0*ATAN2(NORMEZ,COSTET)
         IF (THETA.GT.THEMAX) THEN
             CALL INFNIV ( IFM , NIV )
             CALL UTMESS('A','TUYAU','ANGLE DU COUDE TROP GRAND')
             WRITE(IFM,*) 'ANGLE = ',THETA,' ANGLE MAX = ',THEMAX
             CALL UTMESS('A','ANGCOU',' MAILLER PLUS FIN ')
         ENDIF
         RAYON = DN1N2/2.D0/NORMEZ
C        CALCUL DES REPERES LOCAUX EN CHAQUE NOEUD
         CALL VDIFF(3,COO2,COO1,X3)
         CALL PROVEC(X3,ZCOUD,Y3)
         CT2=COS(THETA/2.D0)
         ST2=SIN(THETA/2.D0)
         DO 2 I=1,3
           X1(I)=X3(I)*CT2-Y3(I)*ST2
           X2(I)=X3(I)*CT2+Y3(I)*ST2
2        CONTINUE
         CALL PROVEC(X1,ZCOUD,Y1)
         CALL PROVEC(X2,ZCOUD,Y2)
         CALL ANGVXY(X1,Y1,ANGL1)
         CALL ANGVXY(X2,Y2,ANGL2)
         CALL ANGVXY(X3,Y3,ANGL3)
         CALL MATROT(ANGL1,PGL1)
         CALL MATROT(ANGL2,PGL2)
         CALL MATROT(ANGL3,PGL3)
C
C        CALCUL DE L'ANGLE OMEGA ENTRE N ET LA GENERATRICE
C        SI ON CONSTRUIT LA GENERATRICE DANS LE SENS DE
C        DESCRIPTION DU MAILLAGE, ON FAIT UNE ROTATION
C        DE THETA AUTOUR DE -Z. SINON, AUTOUR DE Z
C
         IF (IZK.LT.0) THEN
            DO 6 I=1,3
CJMP               AXE(I)= -ZCOUD(I)
               AXE(I)= ZCOUD(I)
   6        CONTINUE
         ELSE
            DO 3 I=1,3
CJMP               AXE(I)= ZCOUD(I)
               AXE(I)= - ZCOUD(I)
3           CONTINUE
         ENDIF

C        ON VEUT UN ZK1 PERPENDICULAIRE A X1
C        ON PROJETTE ZK1 SUR LE PLAN NORMAL A X1

         IF (IZK.GT.0) THEN
            CALL PROVEC(X1,ZKINI,A)
            CALL NORMEV(A,NORME1)
            CALL PROVEC(A,X1,ZK1)
            CALL NORMEV(ZK1,NORME2)
         ELSE
            CALL PROVEC(X2,ZKINI,A)
            CALL NORMEV(A,NORME1)
            CALL PROVEC(A,X2,ZK1)
            CALL NORMEV(ZK1,NORME2)
         ENDIF

C        TEST DE NON COLINEARITE 

         TEST = EPSI2*DN1N2*NORME2
         IF(NORME1.LE.TEST) THEN
            CALL UTMESS('F','ANGCOU',' GENE_TUYAU '//
     +      'IL FAUT DONNER UN VECTEUR NON COLINEAIRE AU TUYAU')
         ENDIF

         CALL PROVEC(AXE,ZK1,ZZK1)
         CALL PROVEC(AXE,ZZK1,ZZZK1)
         CT=COS(THETA)
         ST=SIN(THETA)

         DO 4 I=1,3
            ZK2(I)=ZK1(I)+ST*ZZK1(I)+(1.D0-CT)*ZZZK1(I)
4        CONTINUE
         DO 41 I=1,3
            ZK3(I)=ZK1(I)+ST2*ZZK1(I)+(1.D0-CT2)*ZZZK1(I)
41        CONTINUE
         CALL NORMEV(ZK1,NORME1)
         CALL NORMEV(ZK2,NORME2)
         CALL NORMEV(ZK3,NORME3)         

C        OMEGA ANGLE ENTRE Z ET ZK1 ET AUSSI ENTRE Z ET ZK2

         CALL PSCAL(3,ZCOUD,ZK1,COSOME)
         CALL PROVEC(ZK1,ZCOUD,A)
         IF (IZK.LT.0) THEN
            CALL NORMEV(X2,NX2)
            CALL PSCAL(3,X2,A,SINOME)
         ELSE
            CALL NORMEV(X1,NX1)
            CALL PSCAL(3,X1,A,SINOME)
         ENDIF
         OMEGA2=ATAN2(SINOME,COSOME)

         CALL PSCAL(3,ZCOUD,ZK2,COSOME)
         CALL PROVEC(ZK2,ZCOUD,A)
         IF (IZK.GT.0) THEN
            CALL NORMEV(X2,NX2)
            CALL PSCAL(3,X2,A,SINOME)
         ELSE
            CALL NORMEV(X1,NX1)
            CALL PSCAL(3,X1,A,SINOME)
         ENDIF
         OMEGA=ATAN2(SINOME,COSOME)

         TEST = 0.D0
         IF (CRIT.EQ.'RELATIF') THEN
            IF (ABS(OMEGA).LT.R8PREM()) THEN
               TEST = R8PREM()
            ELSE
               TEST = EPSI2*ABS(OMEGA)
            ENDIF
         ELSEIF (CRIT.EQ.'ABSOLU') THEN
            TEST = EPSI2
         ENDIF

         IF (ABS(OMEGA2-OMEGA).GT.TEST) THEN
             CALL INFNIV ( IFM , NIV )
             WRITE(IFM,*) 'AFFE_CARA_ELEM : MOT CLE GENE_TUYAU'
             WRITE(IFM,*) 'PROBLEME : OMEGA DIFFERENT DE OMEGA2 '
             WRITE(IFM,*) 'OMEGA= ',OMEGA,' OMEGA2= ',OMEGA2
             CALL UTMESS('F','ANGCOU','ARRET DU CODE')
         ENDIF
      ENDIF
      END
