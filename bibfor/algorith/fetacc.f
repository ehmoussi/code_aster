      SUBROUTINE FETACC(OPTION,RANG,DIMTET,IMSMI,IMSMK,NBREOA,ITPS,
     &                  IRG,IRR,IVLAGI,NBI,IR1,IR2,IR3,NOMGGT,LRIGID,
     &                  DIMGI,SDFETI,IPIV,NBSD,VSDF,VDDL,MATAS,NOMGI,
     &                  LSTOGI,INFOFE,IREX,IPRJ,NBPROC)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 10/10/2005   AUTEUR BOITEAU O.BOITEAU 
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
C-----------------------------------------------------------------------
C    - FONCTION REALISEE:  PROCEDURE D'ACCELERATION DE ALFETI
C   IN OPTION  : IN : 1 -> MISE A JOUR LAMBDA0, R0 ET G0 POUR ACSM
C                     2 -> MISE A JOUR DU RESIDU PROJETE SCALE HK_TILDE
C                          PRECONDITIONNE
C                          INPUT ZR(IR1)= A*GK, ZR(IR2)=M-1*A*GK
C                          OUTPUT ZR(IR2)= ZR(IR2) + CORRECTION  
C   IN RANG    : IN : RANG DU PROCESSUS
C   IN DIMTET  : IN : DIM MAX DE L'ESPACE DE PROJECTION
C   IN IMSMI/K : IN : ADRESSES JEVEUX OBJETS DE REORTHO
C                     '&FETI.MULTIPLE.SM.K24'/'IN'
C   IN NBREOA  : IN : NOMBRE DE PAS DE TEMPS EFFECTIF A REORTHOGONALISER
C   IN ITPS    : IN : INDICE DU PAS DE TEMPS COURANT
C   IN/OUT IRG/IRR/IVLAGI : IN : ADRESSES G0, R0 ET LAMBDA0
C   IN NBI     : IN : TAILLE DU PROBLEME D'INTERFACE
C   IN/OUT IR1/IR2/IR3 : IN : ADRESSES JEVEUX DE VECTEURS AUXILIAIRES
C                    DE TAILLE NBI
C ARGUMENTS USUELS DE FETPRJ
C   IN NOMGGT/LRIGID/DIMGI/SDFETI/IPIV/NBSD/VSDF/VDDL/MATAS/NOMGI
C      LSTOGI/INFOFE/IREX/IPRJ/NBPROC
C----------------------------------------------------------------------
C TOLE CRP_21
C RESPONSABLE BOITEAU O.BOITEAU
C CORPS DU PROGRAMME
      IMPLICIT NONE

C DECLARATION PARAMETRES D'APPELS
      INTEGER      OPTION,RANG,DIMTET,IMSMI,IMSMK,NBREOA,ITPS,IRG,IRR,
     &             IVLAGI,NBI,IR1,IR2,IR3,DIMGI,IPIV,NBSD,VSDF(NBSD),
     &             VDDL(NBSD),IREX,IPRJ,NBPROC
      CHARACTER*19 SDFETI,MATAS
      CHARACTER*24 NOMGGT,NOMGI,INFOFE
      LOGICAL      LRIGID,LSTOGI
      
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER            ZI
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
      
C DECLARATION VARIABLES LOCALES
      INTEGER      IMSMR,I,NBDDSM,IPSRO,IDDRO,IDDFRO,J,IAUX1,IFM,NIV,
     &             IMSMR1,IMSMR2,IMSMR3,IMSMR4,NBI1,J1
      REAL*8       DDOT
      CHARACTER*8  K8BID1
      CHARACTER*24 K24BID
 
C CORPS DU PROGRAMME
      CALL JEMARQ()
      CALL INFNIV(IFM,NIV)
      NBI1=NBI-1
      IF (OPTION.EQ.1) THEN

C  ON REMET A JOUR LAMBDA0, RO ET G0 SI TAILLE ESPACE DE PROJECTION NON
C  NUL ET PROC. 0
        IF ((RANG.EQ.0).AND.(DIMTET.NE.0)) THEN
C  CALCUL DU TERME CORRECTIF A AJOUTER A G0 (ZR(IRG))
          CALL WKVECT('&&FETI.MSM.R1','V V R',DIMTET,IMSMR)         
          DO 30 I=1,NBREOA
            NBDDSM=ZI(IMSMI-1+I)
C  POUR SAUTER LES PAS DE TEMPS SANS INFORMATION
            IF (NBDDSM.NE.0) THEN                 
              K8BID1=ZK24(IMSMK-1+I)(1:8)
              CALL JEVEUO('&&FETI.PS.'//K8BID1,'L',IPSRO)
              CALL JEVEUO('&&FETI.DD.'//K8BID1,'L',IDDRO)
              CALL JEVEUO('&&FETI.FIDD.'//K8BID1,'L',IDDFRO)        
              DO 20 J=1,NBDDSM
                ZR(IMSMR+J-1)=DDOT(NBI,ZR(IDDRO+J*NBI),1,ZR(IRG),1)/
     &                        ZR(IPSRO+J)
   20         CONTINUE
C  MISE A JOUR DU RESIDU ET RESIDU PROJETE
              IAUX1=IDDFRO+NBI
              CALL DGEMV('N',NBI,NBDDSM,1.D0,ZR(IAUX1),NBI,ZR(IMSMR),1,
     &                   0.D0,ZR(IR1),1)
              CALL DAXPY(NBI,-1.D0,ZR(IR1),1,ZR(IRR),1)
              K24BID(1:4)='VIDE'
              CALL FETPRJ(NBI,ZR(IR1),ZR(IR2),NOMGGT,LRIGID,DIMGI,1,
     &              SDFETI,IPIV,NBSD,VSDF,VDDL,MATAS,NOMGI,
     &              LSTOGI,INFOFE,IREX,IPRJ,NBPROC,RANG,K24BID)
              CALL DAXPY(NBI,-1.D0,ZR(IR2),1,ZR(IRG),1)
C  MISE A JOUR DU LAGRANGE INITIAL
              IAUX1=IDDRO+NBI
              CALL DGEMV('N',NBI,NBDDSM,1.D0,ZR(IAUX1),NBI,ZR(IMSMR),1,
     &                   1.D0,ZR(IVLAGI),1)
              CALL JELIBE('&&FETI.PS.'//K8BID1)
              CALL JELIBE('&&FETI.DD.'//K8BID1)
              CALL JELIBE('&&FETI.FIDD.'//K8BID1)
            ENDIF
   30     CONTINUE
          CALL JEDETR('&&FETI.MSM.R1')
          IF (INFOFE(1:1).EQ.'T')
     &      WRITE(IFM,*)'<FETI/FETACC',RANG,
     &                  '> ACCELERATION_SM MAJ G0/R0/LAMBDA0'
C  FIN DU IF RANG ET DIMTET
        ENDIF

      ELSE IF (OPTION.EQ.2) THEN

C  ON REMET A JOUR HK_TILDE SI TAILLE ESPACE DE PROJECTION NON
C  NUL ET PROC. 0
        IF ((RANG.EQ.0).AND.(DIMTET.NE.0)) THEN

          CALL WKVECT('&&FETI.MMA.R1','V V R',NBI,IMSMR1)
          CALL WKVECT('&&FETI.MMA.R2','V V R',NBI,IMSMR2)
          CALL WKVECT('&&FETI.MMA.R3','V V R',DIMTET,IMSMR3)
          CALL WKVECT('&&FETI.MMA.R4','V V R',DIMTET,IMSMR4)
          DO 50 I=1,NBREOA
            NBDDSM=ZI(IMSMI-1+I)
C  POUR SAUTER LES PAS DE TEMPS SANS INFORMATION
            IF (NBDDSM.NE.0) THEN
              K8BID1=ZK24(IMSMK-1+I)(1:8)
              CALL JEVEUO('&&FETI.PS.'//K8BID1,'L',IPSRO)
              CALL JEVEUO('&&FETI.DD.'//K8BID1,'L',IDDRO)
              CALL JEVEUO('&&FETI.FIDD.'//K8BID1,'L',IDDFRO)
              IF (I.NE.1) THEN
C SOMME M-1*GK + SIGMA J=1 A I-1: VJ * THETAJ         
                DO 40 J=0,NBI1
                  ZR(IMSMR2+J)=ZR(IMSMR1+J)+ZR(IR2+J)
   40           CONTINUE
              ELSE
C INIT VECTEUR POUR STOCKER SIGMA I=NBREOA A ITPS: VI * THETAI
                DO 42 J=0,NBI1
                  ZR(IMSMR1+J)=0.D0
   42           CONTINUE
                CALL DCOPY(NBI,ZR(IR2),1,ZR(IMSMR2),1)
              ENDIF
              DO 43 J=1,DIMTET
                ZR(IMSMR3+J-1)=0.D0
                ZR(IMSMR4+J-1)=0.D0
   43         CONTINUE
C PRODUIT MATRICE-VECTEUR (AI*VI)T * SOMME PRECEDENTE
              IAUX1=IDDFRO+NBI
              CALL DGEMV('T',NBI,NBDDSM,1.D0,ZR(IAUX1),NBI,ZR(IMSMR2),
     &                   1,0.D0,ZR(IMSMR3),1)
C PRODUIT MATRICE-VECTEUR VIT * GK
              IAUX1=IDDRO+NBI
              CALL DGEMV('T',NBI,NBDDSM,1.D0,ZR(IAUX1),NBI,ZR(IR1),1,
     &                   0.D0,ZR(IMSMR4),1)
C THETAI                                  
              DO 45 J=1,NBDDSM
                J1=J-1          
                ZR(IMSMR3+J1)=(ZR(IMSMR4+J1)-ZR(IMSMR3+J1))/ZR(IPSRO+J)
   45         CONTINUE
C PRODUIT MATRICE-VECTEUR VI * THETAI ET MISE A JOUR STOCKAGE
              IAUX1=IDDRO+NBI
              CALL DGEMV('N',NBI,NBDDSM,1.D0,ZR(IAUX1),NBI,ZR(IMSMR3),1,
     &                   1.D0,ZR(IMSMR1),1)
              CALL JELIBE('&&FETI.PS.'//K8BID1)
              CALL JELIBE('&&FETI.DD.'//K8BID1)
              CALL JELIBE('&&FETI.FIDD.'//K8BID1)
            ENDIF
   50     CONTINUE
C MISE A JOUR VECTEUR SOLUTION
          CALL DAXPY(NBI,1.D0,ZR(IMSMR1),1,ZR(IR2),1)
          CALL JEDETR('&&FETI.MMA.R1')
          CALL JEDETR('&&FETI.MMA.R2')
          CALL JEDETR('&&FETI.MMA.R3')
          CALL JEDETR('&&FETI.MMA.R4')      
          IF (INFOFE(1:1).EQ.'T')
     &      WRITE(IFM,*)'<FETI/FETACC',RANG,'> ACCELERATION_MA MAJ'//
     &                  ' HK_TILDE'
C  FIN DU IF RANG ET DIMTET
        ENDIF
        
      ELSE
        CALL UTMESS('F','FETACC','OPTION NON PREVUE !')
C  FIN DU IF OPTION
      ENDIF      
      CALL JEDEMA()
      END
