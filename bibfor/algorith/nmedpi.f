      SUBROUTINE NMEDPI(SPG,SDG,QG,D,NPG,TYPMOD,MATE,
     &                        UP,UD,GEOM,NNO,DEF)
      
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
      
      IMPLICIT NONE
       
      INTEGER       NNO, NPG,MATE
      CHARACTER*8   TYPMOD(*)
      REAL*8        SPG(2),SDG(2),QG(2,2),D(4,2)
      REAL*8        GEOM(2,NNO)
      REAL*8        UP(8),UD(8),DEF(4,NNO,2)
         
C--------------------------------------------------------
C  CALCUL DE SPG, SDG et QG AU POINT DE GAUSS COURANT
C  POUR LE PILOTAGE.
C--------------------------------------------------------

      INTEGER I,J,K,KL,N
      REAL*8  VALRES(2)
      REAL*8  LONG,E,NU,DEUXMU,TROISK,VAL
      REAL*8  MTEMP(2,4),MATS(2,8),DSIDEP(6,6)
      REAL*8  XA,XB,YA,YB
      CHARACTER*8 NOMRES(2)
      CHARACTER*2 CODRET(2)
      LOGICAL AXI
            
      AXI  = TYPMOD(1) .EQ. 'AXIS'
            
      CALL R8INIR(2 , 0.D0, SPG    ,1)
      CALL R8INIR(2 , 0.D0, SDG    ,1)
      CALL R8INIR(4 , 0.D0, QG     ,1)
      CALL R8INIR(36, 0.D0, DSIDEP ,1)
      
C SOIT A ET B LES MILIEUX DES COTES [14] ET [23]  
C t TANGENT AU COTE [AB]
    
      XA = ( GEOM(1,1) + GEOM(1,4) ) / 2
      YA = ( GEOM(2,1) + GEOM(2,4) ) / 2
      
      XB = ( GEOM(1,2) + GEOM(1,3) ) / 2
      YB = ( GEOM(2,2) + GEOM(2,3) ) / 2
            
C     LONGUEUR DE L'ELEMENT : NORME DU COTE [AB]   
      LONG = SQRT( (XA-XB)*(XA-XB) + (YA-YB)*(YA-YB) )      
      IF (AXI) THEN 
        LONG = LONG * (XA + XB)/2.D0    
      ENDIF                             
      
C CALCUL DE SG ET QG :
C --------------------      
          
C RECUPERATION DES CARACTERISTIQUES
      NOMRES(1)='E'
      NOMRES(2)='NU'

      CALL RCVALA ( MATE,' ','ELAS',0,' ',0.D0,2,
     +                 NOMRES(1),VALRES(1),CODRET(1), 'F ' )
      E      = VALRES(1)
      NU     = VALRES(2)
            
      DEUXMU = E/(1.D0+NU)
      TROISK = E/(1.D0-2.D0*NU)


C CALCUL DE DSIDEP
      CALL R8INIR(36,0.D0,DSIDEP,1)
      DO 130 K=1,3
        DO 131 J=1,3
          DSIDEP(K,J) = TROISK/3.D0 - DEUXMU/(3.D0)
 131    CONTINUE
 130  CONTINUE
      DO 120 K=1,4
        DSIDEP(K,K) = DSIDEP(K,K) + DEUXMU
 120  CONTINUE

C CALCUL DE MATS = Dt E B = Dt*DSIDEP*DEF   
      CALL R8INIR(8, 0.D0,MTEMP,1) 
      DO 10 I=1,2
        DO 11 J=1,4
          VAL=0.D0
          DO 12 K=1,4
            VAL = VAL + D(K,I)*DSIDEP(K,J)
   12     CONTINUE
          MTEMP(I,J)=VAL
   11   CONTINUE
   10 CONTINUE

      CALL R8INIR(16, 0.D0,MATS,1)
      DO 13 K=1,2      
        DO 14 N=1,NNO       
          DO 15 I=1,2
            KL=2*(N-1)+I 
            DO 16 J=1,4
              MATS(K,KL) = MATS(K,KL) + MTEMP(K,J)*DEF(J,N,I)        
   16       CONTINUE         
   15     CONTINUE
   14   CONTINUE
   13 CONTINUE 
   

C CALCUL DE SPG ET SDG :   

      DO 40 I=1,2
        DO 50 KL=1,8              
          SPG(I) = SPG(I) - MATS(I,KL)*UP(KL)/LONG  
          SDG(I) = SDG(I) - MATS(I,KL)*UD(KL)/LONG
 50     CONTINUE 
 40   CONTINUE  
 

C CALCUL DE QG = Dt E D (Dt*DSIDEP*D)   

      DO 17 I=1,2
        DO 18 J=1,2
          VAL=0.D0
          DO 19 K=1,4
             VAL = VAL - MTEMP(I,K)*D(K,J)/LONG 
   19     CONTINUE 
          QG(I,J)=VAL
   18   CONTINUE
   17 CONTINUE   


      END
