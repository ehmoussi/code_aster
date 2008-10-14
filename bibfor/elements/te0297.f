      SUBROUTINE TE0297(OPTION,NOMTE)
      IMPLICIT NONE
      CHARACTER*16 OPTION,NOMTE
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 14/10/2008   AUTEUR DELMAS J.DELMAS 
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
C RESPONSABLE GENIAUT S.GENIAUT
C
C    - FONCTION REALISEE:  CALCUL DES OPTIONS DE POST-TRAITEMENT
C                          EN M�CANIQUE DE LA RUPTURE 
C                          POUR LES �L�MENTS X-FEM
C
C    - ARGUMENTS:
C        DONNEES:      OPTION       -->  OPTION DE CALCUL
C                      NOMTE        -->  NOM DU TYPE ELEMENT
C ......................................................................


C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ---------------------
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ---------------------

      INTEGER NDIM,NNO,NNOP,NPG,KK,IRET,IER
      INTEGER DDLH,NFE,DDLC,NIT,CPT,IT,NSE,ISE,IN,INO,NSEMAX(3)
      INTEGER JPINTT,JCNSET,JHEAVT,JLONCH,JBASLO,JCOORS,IGEOM,IDEPL
      INTEGER IPRES,IPREF,ITEMPS,JPTINT,JAINT,JCFACE,JLONGC,IMATE,IROTA
      INTEGER ITHET,I,J,COMPT,IGTHET,IBID,JLSN,JLST,IDECPG,ICODE,IPESA
      INTEGER NINTER,NFACE,CFACE(5,3),IFA,SINGU,IFORC,IFORF
      REAL*8  HE,THET,R8PREM,VALRES(3),DEVRES(3),PRESN(27),VALPAR(4)
      REAL*8  PRES,RHO,OM,OMO,FNO(81),RBID
      CHARACTER*2   CODRET(3)
      CHARACTER*8   ELREFP,ELRESE(3),FAMI(3),NOMRES(3),NOMPAR(4)
      CHARACTER*16  PHENOM
      CHARACTER*24  COORSE
      LOGICAL FONC
      DATA    NSEMAX / 2 , 3 , 6 /
      DATA    ELRESE /'SE2','TR3','TE4'/
      DATA    FAMI   /'BID','RIGI','XINT'/
      DATA    NOMRES /'E','NU','ALPHA'/

      CALL ELREF1(ELREFP)
      CALL JEVECH('PTHETAR','L',ITHET)
      CALL ELREF4(' ','RIGI',NDIM,NNOP,IBID,IBID,IBID,IBID,IBID,IBID)


C     SI LA VALEUR DE THETA EST NULLE SUR L'�L�MENT, ON SORT
      COMPT = 0
      DO 10 I = 1,NNOP
        THET = 0.D0
        DO 11 J = 1,NDIM
          THET = THET + ABS(ZR(ITHET+NDIM*(I-1)+J-1))
 11     CONTINUE
        IF (THET.LT.R8PREM()) COMPT = COMPT + 1
 10   CONTINUE
      IF (COMPT.EQ.NNOP) GOTO 9999

C     SOUS-ELEMENT DE REFERENCE : RECUP DE NNO, NPG ET IVF
      CALL ELREF4(ELRESE(NDIM),FAMI(NDIM),IBID,NNO,IBID,NPG,
     &                                          IBID,IBID,IBID,IBID)

C     INITIALISATION DES DIMENSIONS DES DDLS X-FEM
      CALL XTEINI(NOMTE,DDLH,NFE,SINGU,DDLC,IBID,IBID,IBID)


C     ------------------------------------------------------------------
C              CALCUL DE G, K1, K2, K3 SUR L'ELEMENT MASSIF
C     ------------------------------------------------------------------
C
C     PARAM�TRES PROPRES � X-FEM
      CALL JEVECH('PPINTTO','L',JPINTT)
      CALL JEVECH('PCNSETO','L',JCNSET)
      CALL JEVECH('PHEAVTO','L',JHEAVT)
      CALL JEVECH('PLONCHA','L',JLONCH)
      CALL JEVECH('PBASLOR','L',JBASLO)
      CALL JEVECH('PLSN','L',JLSN) 
      CALL JEVECH('PLST','L',JLST)
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PDEPLAR','L',IDEPL)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PGTHETA','E',IGTHET)

C     PARAMETRES DES FORCES VOLUMIQUES
      IF (OPTION.EQ.'CALC_K_G') THEN
        FONC=.FALSE.
        CALL JEVECH('PFRVOLU','L',IFORC)
      ELSEIF (OPTION.EQ.'CALC_K_G_F') THEN
        FONC=.TRUE.
        CALL JEVECH('PFFVOLU','L',IFORF)
        CALL JEVECH('PTEMPSR','L',ITEMPS)
      ENDIF

      CALL TECACH('ONN','PPESANR',1,IPESA,IRET)
      CALL TECACH('ONN','PROTATR',1,IROTA,IRET)

C - RECUPERATION DES CHARGES VOLUMIQUES AUX NOEUD DE L'ELEM PARENT : FNO
      CALL LCINVN(NDIM*NNOP,0.D0,FNO)

C     CAS DES FORCES VOLUMIQUES FONCTION
      IF (FONC) THEN 

        NOMPAR(1) = 'X'
        NOMPAR(2) = 'Y'
        VALPAR(NDIM+1) = ZR(ITEMPS)
        IF (NDIM.EQ.2) THEN
          NOMPAR(3) = 'INST'
        ELSEIF (NDIM.EQ.3) THEN
          NOMPAR(3) = 'Z'
          NOMPAR(4) = 'INST'
        ENDIF        

C       INTERPOLATION DE LA FORCE (FONCTION PAR ELEMENT) AUX NOEUDS
        DO 30 INO = 1,NNOP
          DO 31 J = 1,NDIM
            VALPAR(J) = ZR(IGEOM+NDIM*(INO-1)+J-1)
 31       CONTINUE
          DO 32 J = 1,NDIM
            KK = NDIM*(INO-1)+J
            CALL FOINTE('FM',ZK8(IFORF+J-1),NDIM+1,NOMPAR,VALPAR,
     &                                               FNO(KK),IER)
 32       CONTINUE
 30     CONTINUE
 
C     CAS DES FORCE VOLUMIQUES AUX NOEUDS
      ELSE
      
        DO 33 INO = 1,NNOP
          DO 34 J = 1,NDIM
            FNO(NDIM*(INO-1)+J) = ZR(IFORC+NDIM*(INO-1)+J-1)
 34       CONTINUE
 33     CONTINUE
 
      ENDIF
      
C     CAS DES FORCES DE PESANTEUR OU DE ROTATION            
      IF ((IPESA.NE.0).OR.(IROTA.NE.0)) THEN
      
        CALL RCCOMA(ZI(IMATE),'ELAS',PHENOM,CODRET)
        CALL RCVALB('RIGI',1,1,'+',ZI(IMATE),' ',PHENOM,
     &              1,' ',RBID,1,'RHO',RHO,CODRET,'FM')
     
        IF (IPESA.NE.0) THEN
          DO 60 INO=1,NNOP
            DO 61 J=1,NDIM
              KK = NDIM*(INO-1)+J
              FNO(KK) = FNO(KK) + RHO*ZR(IPESA)*ZR(IPESA+J)
 61         CONTINUE
 60       CONTINUE
        ENDIF
        
        IF (IROTA.NE.0) THEN
          OM = ZR(IROTA)
          DO 62 INO=1,NNOP
            OMO = 0.D0
            DO 63 J=1,NDIM
              OMO = OMO + ZR(IROTA+J)* ZR(IGEOM+NDIM*(INO-1)+J-1)
 63         CONTINUE
            DO 64 J=1,NDIM
              KK = NDIM*(INO-1)+J
              FNO(KK)=FNO(KK)+RHO*OM*OM*(ZR(IGEOM+KK-1)-OMO*ZR(IROTA+J))
 64         CONTINUE
 62       CONTINUE
        ENDIF
        
      ENDIF

C     R�CUP�RATION DE LA SUBDIVISION L'�L�MENT PARENT EN NIT TETRAS 
      NIT=ZI(JLONCH-1+1)

      CPT=0
C     BOUCLE SUR LES NIT TETRAS
      DO 100 IT=1,NIT

C       R�CUP�RATION DU D�COUPAGE EN NSE SOUS-�L�MENTS 
        NSE=ZI(JLONCH-1+1+IT)

C       BOUCLE D'INT�GRATION SUR LES NSE SOUS-�L�MENTS
        DO 110 ISE=1,NSE

          CPT=CPT+1

C         COORD DU SOUS-�LT EN QUESTION
          COORSE='&&TE0297.COORSE'
          CALL WKVECT(COORSE,'V V R',NDIM*(NDIM+1),JCOORS)

C         BOUCLE SUR LES 4 (OU 3) SOMMETS DU SOUS-TETRA (OU SOUS-TRIA)
          DO 111 IN=1,NNO
            INO=ZI(JCNSET-1+(NDIM+1)*(CPT-1)+IN)
            DO 112 J=1,NDIM 
              IF (INO.LT.1000) THEN
                ZR(JCOORS-1+NDIM*(IN-1)+J)=ZR(IGEOM-1+NDIM*(INO-1)+J)
              ELSE
                ZR(JCOORS-1+NDIM*(IN-1)+J)=
     &                               ZR(JPINTT-1+NDIM*(INO-1000-1)+J)
              ENDIF
 112        CONTINUE
 111      CONTINUE

C         FONCTION HEAVYSIDE CSTE SUR LE SS-�LT
          HE = ZI(JHEAVT-1+NSEMAX(NDIM)*(IT-1)+ISE)
          IDECPG = NPG * ( NSEMAX(NDIM)*(IT-1)+ (ISE-1))

          CALL XSIFEL(ELREFP,NDIM,COORSE,IGEOM,HE,DDLH,DDLC,NFE,RHO,
     &                ZR(JBASLO),NNOP,NPG,ZR(IDEPL),ZR(JLSN),ZR(JLST),
     &                IDECPG,IGTHET,FNO)

          CALL JEDETR(COORSE)

 110    CONTINUE

 100  CONTINUE

C     ------------------------------------------------------------------
C              CALCUL DE G, K1, K2, K3 SUR LES LEVRES 
C     ------------------------------------------------------------------

      IF (OPTION.EQ.'CALC_K_G') THEN
C       SI LA PRESSION N'EST CONNUE SUR AUCUN NOEUD, ON LA PREND=0.
        CALL JEVECD('PPRESSR',IPRES,0.D0)
      ELSEIF (OPTION.EQ.'CALC_K_G_F') THEN
        CALL JEVECH('PPRESSF','L',IPREF)
        CALL JEVECH('PTEMPSR','L',ITEMPS)

C       RECUPERATION DES PRESSIONS AUX NOEUDS PARENTS
        NOMPAR(1)='X'
        NOMPAR(2)='Y'
        IF (NDIM.EQ.3) NOMPAR(3)='Z'
        IF (NDIM.EQ.3) NOMPAR(4)='INST'
        IF (NDIM.EQ.2) NOMPAR(3)='INST'
        DO 70 I = 1,NNOP
          DO 80 J = 1,NDIM
            VALPAR(J) = ZR(IGEOM+NDIM*(I-1)+J-1)
 80       CONTINUE
          VALPAR(NDIM+1)= ZR(ITEMPS)
          CALL FOINTE('FM',ZK8(IPREF),NDIM+1,NOMPAR,VALPAR,
     &                                      PRESN(I),ICODE)
 70     CONTINUE
      ENDIF

C     SI LA VALEUR DE LA PRESSION EST NULLE SUR L'�L�MENT, ON SORT
      COMPT = 0
      DO 90 I = 1,NNOP
        IF (OPTION.EQ.'CALC_K_G')   PRES = ABS(ZR(IPRES-1+I))
        IF (OPTION.EQ.'CALC_K_G_F') PRES = ABS(PRESN(I))
        IF (PRES.LT.R8PREM()) COMPT = COMPT + 1
 90   CONTINUE
      IF (COMPT.EQ.NNOP) GOTO 9999

C     PARAMETRES PROPRES A X-FEM
      CALL JEVECH('PPINTER','L',JPTINT)
      CALL JEVECH('PAINTER','L',JAINT)
      CALL JEVECH('PCFACE' ,'L',JCFACE)
      CALL JEVECH('PLONGCO','L',JLONGC)

C     R�CUP�RATIONS DES DONN�ES SUR LA TOPOLOGIE DES FACETTES
      NINTER=ZI(JLONGC-1+1)
      IF (NINTER.LT.NDIM) GOTO 9999
      NFACE=ZI(JLONGC-1+2)
      DO 20 I=1,NFACE
        DO 21 J=1,NDIM
          CFACE(I,J)=ZI(JCFACE-1+NDIM*(I-1)+J)
 21     CONTINUE
 20   CONTINUE

C     RECUPERATION DES DONNEES MATERIAU AU 1ER POINT DE GAUSS DE 
C     DE L'ELEMENT PARENT !!
C     LE MAT�RIAU DOIT ETRE HOMOGENE DANS TOUT L'ELEMENT
      CALL RCVAD2('RIGI',1,1,'+',ZI(IMATE),'ELAS',3,NOMRES,
     &            VALRES,DEVRES,CODRET)
      IF ((CODRET(1).NE.'OK') .OR. (CODRET(2).NE.'OK')) THEN
        CALL U2MESS('F','RUPTURE1_25')
      END IF
      IF (CODRET(3) .NE. 'OK') THEN
        VALRES(3) = 0.D0
        DEVRES(3) = 0.D0
      END IF

C     BOUCLE SUR LES FACETTES
      DO 200 IFA=1,NFACE
        CALL XSIFLE(NDIM,IFA,JPTINT,JAINT,CFACE,IGEOM,DDLH,SINGU,
     &              NFE,DDLC,JLST,IPRES,IPREF,ITEMPS,ZR(IDEPL),NNOP,
     &              VALRES,ZR(JBASLO),ITHET,NOMPAR,PRESN,OPTION,IGTHET)
 200  CONTINUE



9999  CONTINUE
      END
