      SUBROUTINE  NMED2D(NNO,NPG,IPOIDS,IVF,IDFDE,GEOM,TYPMOD,
     &                   OPTION,IMATE,COMPOR,LGPG,CRIT,
     &                   DEPLM,DDEPL,SIGM,VIM,DFDI,DEF,SIGP,VIP,
     &                   MATUU,VECTU,CODRET)
     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 26/04/2005   AUTEUR LAVERNE J.LAVERNE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2005  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_21

      IMPLICIT NONE
      
      INTEGER       NNO, NPG, IMATE, LGPG, CODRET,COD(9)
      INTEGER       IPOIDS,IVF,IDFDE
      CHARACTER*8   TYPMOD(*)
      CHARACTER*16  OPTION, COMPOR(4)
      REAL*8        GEOM(2,NNO), CRIT(3)
      REAL*8        DEPLM(1:2,1:NNO),DDEPL(1:2,1:NNO)
      REAL*8        DFDI(NNO,2),DEF(4,NNO,2)
      REAL*8        SIGM(4,NPG),SIGP(4,NPG)
      REAL*8        VIM(LGPG,NPG),VIP(LGPG,NPG)
      REAL*8        MATUU(*),VECTU(2,NNO)

C----------------------------------------------------------------------
C     BUT:  CALCUL DES OPTIONS RIGI_MECA_TANG, RAPH_MECA ET FULL_MECA
C           POUR L'ELEMENT A DISCONTINUITE INTERNE EN 2D
C----------------------------------------------------------------------
C IN  NNO     : NOMBRE DE NOEUDS DE L'ELEMENT
C IN  NPG     : NOMBRE DE POINTS DE GAUSS
C IN  IPOIDS  : POINTEUR SUR LES POIDS DES POINTS DE GAUSS
C IN  IVF     : POINTEUR SUR LES VALEURS DES FONCTIONS DE FORME
C IN  IDFDE   : POINTEUR SUR DERIVEES DES FONCT DE FORME DE ELEM REFE
C IN  GEOM    : COORDONEES DES NOEUDS
C IN  TYPMOD  : TYPE DE MODELISATION
C IN  OPTION  : OPTION DE CALCUL
C IN  IMATE   : MATERIAU CODE
C IN  COMPOR  : COMPORTEMENT
C IN  LGPG    : "LONGUEUR" DES VARIABLES INTERNES POUR 1 POINT DE GAUSS
C               CETTE LONGUEUR EST UN MAJORANT DU NBRE REEL DE VAR. INT.
C IN  CRIT    : CRITERES DE CONVERGENCE LOCAUX
C IN  DEPLM   : DEPLACEMENT A L'INSTANT PRECEDENT
C IN  DDEPL   : INCREMENT DE DEPLACEMENT
C IN  SIGM    : CONTRAINTES A L'INSTANT PRECEDENT
C IN  VIM     : VARIABLES INTERNES A L'INSTANT PRECEDENT
C OUT DFDI    : DERIVEE DES FONCTIONS DE FORME  AU DERNIER PT DE GAUSS
C OUT DEF     : PRODUIT DER. FCT. FORME PAR F   AU DERNIER PT DE GAUSS
C OUT SIGP    : CONTRAINTES DE CAUCHY (RAPH_MECA ET FULL_MECA)
C OUT VIP     : VARIABLES INTERNES    (RAPH_MECA ET FULL_MECA)
C OUT MATUU   : MATRICE DE RIGIDITE PROFIL (RIGI_MECA_TANG ET FULL_MECA)
C OUT VECTU   : FORCES NODALES (RAPH_MECA ET FULL_MECA)
C-----------------------------------------------------------------------

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

      LOGICAL GRAND,AXI,RESI,RIGI,ELAS

      INTEGER KPG,KK,KKD,N,I,M,J,J1,KL,K

      REAL*8  DSIDEP(6,6),F(3,3),DEPS(6),R,SIGMA(6),SIGN(6)
      REAL*8  POIDS,TMP,DUM,SIG(6)
      REAL*8  BUM(6), BDU(6),NORMA
      REAL*8  RAC2
      REAL*8  ALPHAM(2),ALPHAP(2)
      REAL*8  S(2),Q(2,2),DSDU(2,8),SG(2),QG(2,2),DSDUG(2,8),D(4,2)
      REAL*8  DDA,XA,XB,YA,YB
      REAL*8  ROT(2,2),COTMP,SITMP,CO,SI,DROT ,RTEMP(4,2)
      REAL*8  DALFU(2,8),DH(4,8),H(2,2),DALFS(2,2),DET            
                    
C - INITIALISATIONS
C------------------

      RESI = OPTION.EQ.'RAPH_MECA' .OR. OPTION.EQ.'FULL_MECA'
      RIGI = OPTION.EQ.'FULL_MECA' .OR. OPTION.EQ.'RIGI_MECA_TANG'
      
      IF (.NOT. RESI .AND. .NOT. RIGI) 
     &  CALL UTMESS('F','NMED2D','OPTION '//OPTION//' NON TRAITEE')

      CALL R8INIR(2,  0.D0, S,1)
      CALL R8INIR(4,  0.D0, Q,1)
      CALL R8INIR(16, 0.D0, DSDU,1)
      
      RAC2   = SQRT(2.D0)
      GRAND  = .FALSE.
      AXI    = TYPMOD(1) .EQ. 'AXIS' 
      
C     INITIALISATION CODES RETOURS
      DO 1955 KPG=1,NPG
         COD(KPG)=0
1955  CONTINUE


C MATRICE DE CHANGEMENT DE REPERE : DU GLOBAL AU LOCAL  : 
C    ROT X = XLOC
C SOIT A ET B LES MILIEUX DES COTES [14] ET [23]  
C t TANGENT AU COTE [AB]
    
      XA = ( GEOM(1,1) + GEOM(1,4) ) / 2
      YA = ( GEOM(2,1) + GEOM(2,4) ) / 2
      
      XB = ( GEOM(1,2) + GEOM(1,3) ) / 2
      YB = ( GEOM(2,2) + GEOM(2,3) ) / 2      

      COTMP = (YB - YA)
      SITMP = (XA - XB)
      
      CO = COTMP / SQRT(COTMP*COTMP + SITMP*SITMP)
      SI = SITMP / SQRT(COTMP*COTMP + SITMP*SITMP)  
            
      ROT(1,1) =  CO
      ROT(2,1) = -SI
      ROT(1,2) =  SI
      ROT(2,2) =  CO


C - 1ERE BOUCLE SUR LES POINTS DE GAUSS
C -------------------------------------
C   (CALCUL DE S ET Q NECESSAIRE POUR LE CALCUL DU SAUT ALPHA)

      DO 800 KPG=1,NPG

C       CALCUL DE DFDI,F,EPS (BUM),DEPS (BDU),R(EN AXI) ET POIDS

        CALL R8INIR(6, 0.D0, BUM,1)
        CALL R8INIR(6, 0.D0, BDU,1)

        CALL NMGEOM(2,NNO,AXI,GRAND,GEOM,KPG,IPOIDS,
     &              IVF,IDFDE,DEPLM,POIDS,DFDI,F,BUM,R)
     
        CALL NMGEOM(2,NNO,AXI,GRAND,GEOM,KPG,IPOIDS,
     &              IVF,IDFDE,DDEPL,POIDS,DFDI,F,BDU,R)        
        
        
C       CALCUL DE D (LES AUTRES TERMES SONT NULS):  

        CALL R8INIR(8, 0.D0, D,1)
   
        D(1,1) = - (DFDI(1,1) + DFDI(2,1))   
        D(4,1) = - RAC2*(DFDI(1,2) + DFDI(2,2))/2      
        D(2,2) = - (DFDI(1,2) + DFDI(2,2))
        D(4,2) = - RAC2*(DFDI(1,1) + DFDI(2,1))/2   
                
C       CHANGEMENT DE REPERE DANS D : ON REMPLACE D PAR DRt : 

        CALL R8INIR(8, 0.D0, RTEMP,1)
       
        DO 32 I=1,4
          DO 33 J=1,2
            DROT = 0.D0
            DO 34 K=1,2
              DROT = DROT + D(I,K)*ROT(J,K)
  34        CONTINUE
            RTEMP(I,J) = DROT
  33      CONTINUE         
  32    CONTINUE 
  
        DO 38 I=1,4
          DO 39 J=1,2                         
            D(I,J) = RTEMP(I,J)
  39      CONTINUE
  38    CONTINUE   
                                        
C       CALCUL DES PRODUITS SYMETR. DE F PAR N,

        CALL R8INIR(32, 0.D0, DEF,1)
        DO 40 N=1,NNO
          DO 30 I=1,2
            DEF(1,N,I) =  F(I,1)*DFDI(N,1)
            DEF(2,N,I) =  F(I,2)*DFDI(N,2)
            DEF(3,N,I) =  0.D0
            DEF(4,N,I) = (F(I,1)*DFDI(N,2) + F(I,2)*DFDI(N,1))/RAC2
 30       CONTINUE
 40     CONTINUE

C       TERME DE CORRECTION (3,3) AXI QUI PORTE EN FAIT SUR LE DDL 1

        IF (AXI) THEN
          DO 50 N=1,NNO
            DEF(3,N,1) = F(3,3)*ZR(IVF+N+(KPG-1)*NNO-1)/R            
 50       CONTINUE
        ENDIF

        DO 60 I=1,3
          SIGN(I) = SIGM(I,KPG)
 60     CONTINUE
        SIGN(4) = SIGM(4,KPG)*RAC2

C       CALCUL DE S ET Q AU POINT DE GAUSS COURANT I.E. SG ET QG :

        CALL NMEDSQ(SG,QG,DSDUG,D,NPG,TYPMOD,IMATE,BUM,BDU,
     &              SIGN,VIM,OPTION,GEOM,NNO,LGPG,KPG,DEF)     

C       CALCUL DES S ET Q POUR L'ELEMENT :

        DO 64 I=1,2              
          S(I) = S(I) + POIDS*SG(I)        
          DO 65 J=1,2
            Q(I,J) = Q(I,J) + POIDS*QG(I,J)
   65     CONTINUE      
          DO 66 J=1,8
            DSDU(I,J) = DSDU(I,J)  + POIDS*DSDUG(I,J)
   66     CONTINUE      
   64   CONTINUE  
                 
  800 CONTINUE
 
  
C - APPEL DU COMPORTEMENT : 
C--------------------------
 
      CALL NMEDCO(COMPOR,OPTION,IMATE,NPG,LGPG,S,Q,VIM,VIP,ALPHAP,DALFS)


C - 2ND BOUCLE SUR LES POINTS DE GAUSS 
C ------------------------------------------------- 
C   (CALCUL DE LA CONTRAINTE , FORCE INT ET MATRICE TANGENTE)

      DO 801 KPG=1,NPG
  
C       CALCUL DE DFDI,F,BUM, BDU ,R(EN AXI) ET POIDS

        CALL R8INIR(6, 0.D0, BUM,1)
        CALL R8INIR(6, 0.D0, BDU,1)
  
        CALL NMGEOM(2,NNO,AXI,GRAND,GEOM,KPG,IPOIDS,
     &              IVF,IDFDE,DEPLM,POIDS,DFDI,F,BUM,R)
     

        CALL NMGEOM(2,NNO,AXI,GRAND,GEOM,KPG,IPOIDS,
     &              IVF,IDFDE,DDEPL,POIDS,DFDI,F,BDU,R)
  
                  
C       CALCUL DE D (LES AUTRES TERMES SONT NULS):  
   
        CALL R8INIR(8, 0.D0, D,1)
   
        D(1,1) = - (DFDI(1,1) + DFDI(2,1))   
        D(4,1) = - RAC2*(DFDI(1,2) + DFDI(2,2))/2      
        D(2,2) = - (DFDI(1,2) + DFDI(2,2))
        D(4,2) = - RAC2*(DFDI(1,1) + DFDI(2,1))/2
        
C       CHANGEMENT DE REPERE DANS D : ON REMPLACE D PAR DRt : 

        CALL R8INIR(8, 0.D0, RTEMP,1)
       
        DO 35 I=1,4
          DO 36 J=1,2
            DROT = 0.D0
            DO 37 K=1,2
              DROT = DROT + D(I,K)*ROT(J,K)
  37        CONTINUE
            RTEMP(I,J) = DROT
  36      CONTINUE         
  35    CONTINUE 
   
        DO 52 I=1,4
          DO 53 J=1,2                         
            D(I,J) = RTEMP(I,J)
  53      CONTINUE
  52    CONTINUE
                 
C       CALCUL DES PRODUITS SYMETR. DE F PAR N,

        CALL R8INIR(32, 0.D0, DEF,1)
        DO 41 N=1,NNO
          DO 31 I=1,2
            DEF(1,N,I) =  F(I,1)*DFDI(N,1)
            DEF(2,N,I) =  F(I,2)*DFDI(N,2)
            DEF(3,N,I) =  0.D0
            DEF(4,N,I) = (F(I,1)*DFDI(N,2) + F(I,2)*DFDI(N,1))/RAC2
 31       CONTINUE
 41     CONTINUE

C       TERME DE CORRECTION (3,3) AXI QUI PORTE EN FAIT SUR LE DDL 1

        IF (AXI) THEN
          DO 51 N=1,NNO
            DEF(3,N,1) = F(3,3)*ZR(IVF+N+(KPG-1)*NNO-1)/R
 51       CONTINUE
        ENDIF
C
        DO 61 I=1,3
          SIGN(I) = SIGM(I,KPG)
 61     CONTINUE
        SIGN(4) = SIGM(4,KPG)*RAC2
             
C       LA VARIATION DE DEF DEPS : DEVIENT LA SOMME DES VARIATION
C       DE DEF LIEE AU DEPL : 'BDU' PLUS CELLE LIEE AU SAUT : 'DDA'

        ALPHAM(1) = VIM(1,KPG)
        ALPHAM(2) = VIM(2,KPG)
        DO 80 I=1,4
          DDA = 0.D0
          DO 70 J=1,2 
            DDA = DDA + D(I,J)*(ALPHAP(J)-ALPHAM(J))
 70       CONTINUE
          DEPS(I) =  BDU(I) + DDA
 80     CONTINUE

C CALCUL DE LA CONTRAINTE
C------------------------

C       APPEL DE LA LDC ELASTIQUE : SIGMA=A.EPS AVEC EPS=BU-DA 
C       ON PASSE EN ARG LA VARIATION DE DEF 'DEPS' ET LA CONTRAINTE -
C       'SIGN' ET ON SORT LA CONTAINTE + 'SIGMA'
        CALL NMEDEL(2,TYPMOD,IMATE,DEPS,SIGN,OPTION,SIGMA,DSIDEP)
    
     
C CALCUL DES EFFORTS INTERIEURS ET MATRICE TANGENTE :
C ---------------------------------------------------

        IF (RIGI) THEN

C CALCUL DE DH : TERME MANQUANT DANS LA MATRICE TANGENTE :   
 
          IF (OPTION.EQ.'RIGI_MECA_TANG') THEN
            ELAS=(NINT(VIM(4,KPG)).EQ.0)
          ELSE
            ELAS=(NINT(VIP(4,KPG)).EQ.0)
          ENDIF
        
          IF ( (ELAS) .AND. (VIM(3,KPG).EQ.0.D0) ) THEN   
                 
            CALL R8INIR(32, 0.D0,DH,1)
            
          ELSE

C CALCUL DE LA DERIVE DE ALPHA PAR RAPPORT A U : 'DALFU' EN UTILISANT LA
C DERIVEE ALPHA PAR RAPPORT A S : 'DALFS' (CALCULE DANS LE COMPORTEMENT
C CF NMEDCO.F) ET DE LA DERIVEE DE S PAR RAPPORT A U : 'DSDU'.

            CALL R8INIR(16, 0.D0,DALFU,1)
            DO 73 I=1,2
              DO 74 J=1,8
                DO 75 K=1,2
                  DALFU(I,J) = DALFU(I,J) + DALFS(I,K)*DSDU(K,J)
   75           CONTINUE          
   74         CONTINUE
   73       CONTINUE


C ON MET LE PRODUIT D.DALFU DANS DH :
C DH  =  D  DALFU
C 4x8 = 4x2  2x8

            CALL R8INIR(32, 0.D0,DH,1)
            DO 76 I=1,4
              DO 77 J=1,8
                DO 78 K=1,2
                  DH(I,J) = DH(I,J) + D(I,K)*DALFU(K,J)
   78           CONTINUE            
   77         CONTINUE
   76       CONTINUE
   
          ENDIF

C - CALCUL DE LA MATRICE DE RIGIDITE

          DO 160 N=1,NNO
            DO 150 I=1,2
              DO 151,KL=1,4
                SIG(KL)=0.D0
                SIG(KL)=SIG(KL) + DEF(1,N,I)*DSIDEP(1,KL)
                SIG(KL)=SIG(KL) + DEF(2,N,I)*DSIDEP(2,KL)
                SIG(KL)=SIG(KL) + DEF(3,N,I)*DSIDEP(3,KL)
                SIG(KL)=SIG(KL) + DEF(4,N,I)*DSIDEP(4,KL)
151           CONTINUE
              DO 140 J=1,2
                DO 130 M=1,N
                  IF (M.EQ.N) THEN
                    J1 = I
                  ELSE
                    J1 = 2
                  ENDIF

C                 RIGIDITE ELASTIQUE + TERME LIE AU SAUT : 
C                 TMP = Bt E (B + DH)

                  TMP=0.D0 
                  TMP=TMP + SIG(1)*( DEF(1,M,J) + DH(1, 2*(M-1)+J) )
                  TMP=TMP + SIG(2)*( DEF(2,M,J) + DH(2, 2*(M-1)+J) )
                  TMP=TMP + SIG(3)*( DEF(3,M,J) + DH(3, 2*(M-1)+J) )
                  TMP=TMP + SIG(4)*( DEF(4,M,J) + DH(4, 2*(M-1)+J) )

C                 STOCKAGE EN TENANT COMPTE DE LA SYMETRIE
                  IF (J.LE.J1) THEN
                     KKD = (2*(N-1)+I-1) * (2*(N-1)+I) /2
                     KK = KKD + 2*(M-1)+J
                     MATUU(KK) = MATUU(KK) + TMP*POIDS
                  ENDIF
C
 130            CONTINUE
 140          CONTINUE
 150        CONTINUE
 160      CONTINUE
 
        ENDIF

C - CALCUL DE LA FORCE INTERIEURE ET DES CONTRAINTES DE CAUCHY

        IF (RESI) THEN
C
          DO 230 N=1,NNO
            DO 220 I=1,2
              DO 210 KL=1,4
                VECTU(I,N) = VECTU(I,N) + DEF(KL,N,I)*SIGMA(KL)*POIDS
 210          CONTINUE
 220        CONTINUE
 230      CONTINUE
C
          DO 310 KL=1,3
            SIGP(KL,KPG) = SIGMA(KL)
 310      CONTINUE
          SIGP(4,KPG) = SIGMA(4)/RAC2
C
        ENDIF
        
 801  CONTINUE


1976  CONTINUE

C - SYNTHESE DES CODES RETOURS
      CALL CODERE(COD,NPG,CODRET)
      
      END
