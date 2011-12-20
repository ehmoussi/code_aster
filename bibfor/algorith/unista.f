      SUBROUTINE UNISTA (H, LDH, V, LDV, DDLSTA, N, VECTP, CSTA,
     &                   BETA,ETAT,LDYNFA,DDLEXC,REDEM)
C-----------------------------------------------------------------------
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 20/12/2011   AUTEUR BEAURAIN J.BEAURAIN 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
C-----------------------------------------------------------------------
C
C ROUTINE PRINCIPALE - ALGORITHME D'OPTIMISATION SOUS CONTRAINTES
C POUR LES ETUDES DE STABILITE
C
C ----------------------------------------------------------------------
C
C IN  H        : MATRICE REDUITE
C IN  LDH      : NOMBRE DE COEFFICIENTS DE H
C IN  V        : MATRICE DE CHANGEMENT DE BASE
C IN  LDV      : NOMBRE DE COEFFICIENTS DE V
C IN  DDLSTA   : POSITION DES DDL_STAB
C IN  N        : DIMENSION ESPACE GLOBAL
C IN/OUT VECTP : MODE DE STABILITE
C OUT CSTA     : VALEUR CRITERE DE STABILITE
C IN  BETA     : PLUS GRANDE VALEUR PROPRE NEGATIVE
C IN  ETAT     : =0 TTES LES VP SONT POSITIVES
C                =1 AU MOINS UNE VP EST NEGATIVE
C IN  LDYNFA   : DESCRIPTEUR OPERATEUR TANGENT
C IN  DDLEXC   : POSITION DDL IMPOSES
C IN  REDEM    : NOMBRE REDEMARRAGES METHODE SORENSEN
C
C ----------------------------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE      

C     %-----------------%
C     | ARRAY ARGUMENTS |
C     %-----------------%

      INTEGER DDLSTA(N),DDLEXC(N)
      REAL*8  H(LDH,LDH),V(LDV,LDH)
      REAL*8  VECTP(LDV)

C     %------------------%
C     | SCALAR ARGUMENTS |
C     %------------------%

      INTEGER N,LDH,LDV,ETAT,LDYNFA
      INTEGER REDEM
      REAL*8  BETA,CSTA

C     %--------------------%
C     | DECLARATION JEVEUX |
C     %--------------------%

      REAL*8 ZR
      COMMON /RVARJE/ZR(1)

C     %------------------------%
C     | LOCAL SCALARS & ARRAYS |
C     %------------------------%

      INTEGER I,J,IRET,INDICO,PROJ
      INTEGER VECTT,XSOL,VECT2
      INTEGER IFM,NIV
      INTEGER Q,B
      REAL*8  GAMA,DET,DNRM2
      REAL*8  VTEST,ERR
      REAL*8  ZERO,ONE
      PARAMETER (ONE = 1.0D+0, ZERO = 0.0D+0)
      CHARACTER*4 CARA
C
      CALL INFNIV(IFM,NIV)
C
      CALL WKVECT('&&INESTA.VECT.TEM1','V V R',
     &             LDV,VECTT)
      CALL WKVECT('&&INESTA.VECT.TEM2','V V R',
     &             LDV,XSOL)
      CALL WKVECT('&&INESTA.VECT.TEM3','V V R',
     &             LDV,VECT2)
      CALL WKVECT('&&INESTA.VECT.TEM4','V V R',
     &             LDH*LDH,Q)     
      CALL WKVECT('&&INESTA.VECT.TEM5','V V R',
     &             LDH*LDH,B)
C
      CALL R8INIR(LDV,0.D0,ZR(VECTT),1)
      CALL R8INIR(LDV,0.D0,ZR(XSOL),1)
      CALL R8INIR(LDV,0.D0,ZR(VECT2),1)
      CALL R8INIR(LDH*LDH,0.D0,ZR(Q),1)
      CALL R8INIR(LDH*LDH,0.D0,ZR(B),1)
C
      INDICO = 0
      PROJ = 0
C
      IF (ETAT.EQ.0) THEN
C
C     1ER APPEL A LA METHODE DES PUISSANCES
C              
        CALL MPPSTA (H,LDH,V,LDV,DDLSTA,N,ZR(VECTT),
     &               DDLEXC,INDICO,PROJ) 
C        
      ENDIF  
C      
      IF (ETAT.EQ.1) THEN
C
C     MISE EN PLACE SHIFT POUR VALEUR NEGATIVE
C
        GAMA = ABS(BETA)+1.D0
C	
        DO 10 I = 1,LDH
          DO 20 J = 1,LDH
            ZR(Q+(J-1)*LDH+I-1) = -H(I,J)
  20      CONTINUE
  10    CONTINUE
        DO 30 I = 1,LDH
          ZR(Q+(I-1)*(LDH+1)) = GAMA+ZR(Q+(I-1)*(LDH+1))
  30    CONTINUE
C
C     2ND APPEL A LA METHODE DES PUISSANCES
C
        PROJ = 1

        CALL MPPSTA (ZR(Q),LDH,V,LDV,DDLSTA,N,ZR(VECTT),
     &               DDLEXC,INDICO,PROJ)
C
      ENDIF
C
      ERR = DNRM2(LDV,ZR(VECTT),1) 
      CALL DSCAL ( LDV,ONE/ERR,ZR(VECTT),1 )
      CALL MRMULT('ZERO',LDYNFA,ZR(VECTT),' ',ZR(XSOL),1)
C
      VTEST = 0.D0
      DO 50 I = 1,LDV
        VTEST = VTEST +ZR(VECTT+I-1)*ZR(XSOL+I-1)
        IF (DDLSTA(I).EQ.0 .AND. PROJ.EQ.1) THEN
          IF (ZR(VECTT+I-1).LT.ZERO) THEN
            CALL ASSERT (.FALSE.)
          ENDIF
        ENDIF
  50  CONTINUE
C
      WRITE (IFM,*) 'VAL1_STAB : ',VTEST
C
      IF (VTEST.LT.0.D0 .OR. ETAT.EQ.0) THEN
        DO 90 I = 1,LDV
          VECTP(I) = ZR(VECTT+I-1)
  90    CONTINUE        
        CSTA = VTEST
        GOTO 300
      ENDIF                        
C   
C     CALCUL DU CRITERE
C       
      DO 60 I = 1,LDH
        DO 70 J = 1,LDH
          IF (I.EQ.J) THEN
            ZR(B+(I-1)*LDH+J-1) = 1.D0
          ELSE
            ZR(B+(I-1)*LDH+J-1) = 0.D0
          ENDIF    
  70    CONTINUE
  60  CONTINUE 
C
      CARA='NFSP'    
C          
      CALL MGAUSS(CARA,H,ZR(B),LDH,LDH,LDH,DET,IRET)   
      
      PROJ = 0   
           
      CALL MPPSTA (ZR(B),LDH,V,LDV,DDLSTA,N,ZR(VECT2),
     &             DDLEXC,INDICO,PROJ)      
      
      ERR = DNRM2(LDV,ZR(VECT2),1) 
      CALL DSCAL ( LDV,ONE/ERR,ZR(VECT2),1 )            
      CALL MRMULT('ZERO',LDYNFA,ZR(VECT2),' ',ZR(XSOL),1)
      VTEST = 0.D0
      DO 55 I = 1,LDV
        VTEST = VTEST +ZR(VECT2+I-1)*ZR(XSOL+I-1)   
  55  CONTINUE      
C  
C      WRITE (IFM,*) 'VAL_PROPRE_MAX : ',VTEST
C      
      DO 15 I = 1,LDH
        DO 25 J = 1,LDH
          ZR(Q+(I-1)*LDH+J-1) = -ZR(B+(I-1)*LDH+J-1)-
     &                           ZR(B+(J-1)*LDH+I-1)
  25    CONTINUE
  15  CONTINUE      
      DO 35 I = 1,LDH
C        Q(I,I) = 2*VTEST*(1.D0/4.D0)+Q(I,I)
        ZR(Q+(I-1)*LDH+I-1) = 2*VTEST*(1.5D0/2.D0)+
     &                        ZR(Q+(I-1)*LDH+I-1)
  35  CONTINUE            
  
      IF (REDEM.EQ.0) THEN
        DO 80 I = 1,LDV
          VECTP(I) = ZR(VECTT+I-1)
  80    CONTINUE                
      ENDIF  
C
      INDICO = 1  
      PROJ = 1
C
      CALL MPPSTA (ZR(Q),LDH,V,LDV,DDLSTA,N,VECTP,
     &             DDLEXC,INDICO,PROJ)      
            
      ERR = DNRM2(LDV,VECTP,1) 
      CALL DSCAL ( LDV,ONE/ERR,VECTP,1 )      
      CALL MRMULT('ZERO',LDYNFA,VECTP,' ',ZR(XSOL),1)
      VTEST = 0.D0
      DO 65 I = 1,LDV
        VTEST = VTEST +VECTP(I)*ZR(XSOL+I-1)
        IF (DDLSTA(I).EQ.0) THEN
          IF (VECTP(I).LT.ZERO) THEN
            CALL ASSERT (.FALSE.)
          ENDIF
        ENDIF    
  65  CONTINUE
C
      WRITE (IFM,*) 'VAL2_STAB : ',VTEST
      WRITE (IFM,9070)
      WRITE (IFM,9080) 
C                      
      CSTA = VTEST    
  
  300 CONTINUE

      REDEM = REDEM +1
C
C ----------------------------------------------
C
C      CALL JEDEMA()
C
C 9000 FORMAT ('MAX_KINV',10X,I20,/)
C 9050 FORMAT ('VALEUR_PROPRE_DECALAGE',10X,I20,/)
C 9060 FORMAT ('MIN_K_CONTRAINT',10X,I20,/)
 9070 FORMAT (72(' '))
 9080 FORMAT (72('-'))
C
C ----------------------------------------------
C
      CALL JEDETC('V','&&INESTA',1)
C
C     %---------------%
C     | END OF PROSTA |
C     %---------------%

      END
