      SUBROUTINE TE0548(OPTION,NOMTE)
      IMPLICIT   NONE
      CHARACTER*16 OPTION,NOMTE

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 25/01/2005   AUTEUR GENIAUT S.GENIAUT 
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
C.......................................................................
C
C                CONTACT X-FEM M�THODE CONTINUE : 
C             MISE � JOUR DU SEUIL DE FROTTEMENT
C
C
C  OPTION : 'XREACL' (X-FEM MISE � JOUR DU SEUIL DE FROTTEMENT)

C  ENTREES  ---> OPTION : OPTION DE CALCUL
C           ---> NOMTE  : NOM DU TYPE ELEMENT
C
C......................................................................
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX --------------------
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

C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX --------------------

      INTEGER      I,J,IFA,IPGF,ISSPG,NI,PLI
      INTEGER      IDEPPL,JAINT,JCFACE,JLONCH,JSEUIL,IPOIDF,IVFF,IDFDEF
      INTEGER      IADZI,IAZK24,IPOIDS,IVF,IDFDE,JGANO
      INTEGER      NDIM,NNO,NNOS,NPG,DDLH,DDLE,DDLC,NNOM
      INTEGER      NINTER,NFACE,CFACE(5,3),IBID,NNOF,NPGF,XOULA
      CHARACTER*8  TYPMA
      REAL*8       SEUIL,FFI
C......................................................................

      CALL JEMARQ()
C
C      WRITE(6,*)'TE 548 ',OPTION

      CALL ELREF4(' ','RIGI',NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)

C     DDL PAR NOEUD SOMMET : HEAVISIDE, ENRICHIS (FOND), CONTACT
      DDLH=3
      DDLE=0
      DDLC=3
C     NB DE 'NOEUDS MILIEU' SERVANT � PORTER DES DDL DE CONTACT
      NNOM=3*(NNO/2)

C     D�P ACTUEL (DEPPLU) : 'PDEPL_P'
      CALL JEVECH('PDEPL_P','L',IDEPPL)
      CALL JEVECH('PAINTER','L',JAINT)
      CALL JEVECH('PCFACE' ,'L',JCFACE)
      CALL JEVECH('PLONCHA','L',JLONCH)
      CALL JEVECH('PSEUIL' ,'E',JSEUIL)

C     R�CUP�RATIONS DES DONN�ES SUR LE CONTACT ET
C     SUR LA TOPOLOGIE DES FACETTES
      NINTER=ZI(JLONCH-1+1)
      NFACE=ZI(JLONCH-1+2)
      DO 15 I=1,NFACE
        DO 16 J=1,3
          CFACE(I,J)=ZI(JCFACE-1+3*(I-1)+J)
   16   CONTINUE
 15   CONTINUE
C
      IF (NINTER.LT.3)  GOTO 9999

      CALL TECAEL(IADZI,IAZK24)
      TYPMA=ZK24(IAZK24-1+3+ZI(IADZI-1+2)+3)

C     BOUCLE SUR LES FACETTES
      DO 100 IFA=1,NFACE

C       LA FAMILLE 'XCON' A 12 PG INTEGRE ORDRE I+J=6
        CALL ELREF4('TR3','XCON',IBID,NNOF,IBID,NPGF,IPOIDF,IVFF,
     &                                                     IDFDEF,IBID)
C
C       BOUCLE SUR LES POINTS DE GAUSS DES FACETTES
        DO 110 IPGF=1,NPGF
C
C         INDICE DE CE POINT DE GAUSS DANS PSEUIL
          ISSPG=NPGF*(IFA-1)+IPGF

C         CALCUL DU NOUVEAU SEUIL A PARTIR DES LAMBDA DE DEPPLU
          SEUIL = 0.D0
          DO 120 I = 1,NNOF
            FFI=ZR(IVFF-1+NNOF*(IPGF-1)+I)
            NI=XOULA(CFACE,IFA,I,JAINT,TYPMA)
            CALL XPLMAT(NDIM,DDLH,DDLE,DDLC,NNO,NNOM,NI,PLI)
            SEUIL = SEUIL + FFI * ZR(IDEPPL-1+PLI)
 120      CONTINUE

          ZR(JSEUIL-1+ISSPG)=SEUIL

 110    CONTINUE
 100  CONTINUE

 9999 CONTINUE
      
      CALL JEDEMA()
      END
