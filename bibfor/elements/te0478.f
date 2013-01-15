      SUBROUTINE TE0478 ( OPTION , NOMTE )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 15/01/2013   AUTEUR DELMAS J.DELMAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2013  EDF R&D                  WWW.CODE-ASTER.ORG
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
      INCLUDE 'jeveux.h'

      CHARACTER*16        OPTION , NOMTE
C ----------------------------------------------------------------------
C     CALCUL DES COORDONNEES DES POINTS DE GAUSS + POIDS
C     POUR LES ELEMENTS : BARRE, CABLE, DISCRET, POUTRE
C
C
C
C
      INTEGER  NDIM,NNO,NNOS,NPG,JGANO,ICOPG,IDFDE,IPOIDS,IVF,IGEOM
      INTEGER  TAB(2),IRET,NDIM1,IGEPO
      INTEGER  INBF,NBFIB,JACF,IORIEN,NBSP,NBCOU,NBSEC
      INTEGER  NCARFI,ISEC,ICOU,ISP,ICOQ
C      INTEGER  IADZI,IAZK24,NUMAIL,IPEL,IPGA
      INTEGER  IG,IFI,DECGA,LX,K
      REAL*8   XL2,COPG(4,4),COPG2(3,4),PGL(3,3),GM1(3),GM2(3)
      REAL*8   EPCOU,PI,ALPHA,RAYON,EP,Y,Z,HH
      REAL*8   DFDX(3),COUR,JACP,COSA,SINA,SPOID
      PARAMETER    (PI=3.141592653589793238462643D0)
C ----------------------------------------------------------------------
      CALL ELREF4(' ','RIGI',NDIM1,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)

C     NDIM1 EST LA DIMENSION TOPOLOGIQUE. IL FAUT CALCULER LA
C     DIMENSION DE L'ESPACE NDIM (2 OU 3) :
      CALL TECACH('OOO','PGEOMER','L',2,TAB,IRET)
      NDIM  = TAB(2)/NNO
      IGEOM = TAB(1)
C     ZR(ICOPG) : COORDONNEES POINTS DE GAUSS + POIDS
      CALL JEVECH('PCOORPG','E',ICOPG )

C ELEMENTS A SOUS POINTS : POUTRES MULTIFIBRES
      IF(NOMTE.EQ.'MECA_POU_D_EM'.OR.NOMTE.EQ.'MECA_POU_D_TGM') THEN
        CALL JEVECH('PNBSP_I','L',INBF)
        NBFIB = ZI(INBF)
        CALL JEVECH('PFIBRES','L',JACF)
        NCARFI = 3
        CALL JEVECH('PCAORIE','L',IORIEN)

C POSITION DES POINTS DE GAUSS SUR L'AXE
        CALL PPGA12(NDIM,NNO,NPG,ZR(IPOIDS),ZR(IVF),
     &              ZR(IGEOM),COPG)

C POIDS * JACOBIEN (JACOBIEN=L/2)
        LX=IGEOM-1
        XL2 = SQRT( (ZR(LX+4)-ZR(LX+1))**2
     &  + (ZR(LX+5)-ZR(LX+2))**2 + (ZR(LX+6)-ZR(LX+3))**2 )/2.D0

        CALL MATROT(ZR(IORIEN),PGL)

        IF(NOMTE.EQ.'MECA_POU_D_EM')THEN
          DECGA=NBFIB*4
        ELSE
          DECGA=NBFIB*4
        ENDIF
        GM1(1)=0.D0
C boucle sur les fibres (4 valeurs par fibre, X,Y,Z,W)
        DO 100 IFI=1,NBFIB
          GM1(2)=ZR(JACF+(IFI-1)*NCARFI)
          GM1(3)=ZR(JACF+(IFI-1)*NCARFI+1)
          CALL UTPVLG(1,3,PGL,GM1,GM2)
          DO 110 IG=1,NPG
            ZR(ICOPG+(IG-1)*DECGA+(IFI-1)*4+0)=COPG(1,IG)+GM2(1)
            ZR(ICOPG+(IG-1)*DECGA+(IFI-1)*4+1)=COPG(2,IG)+GM2(2)
            ZR(ICOPG+(IG-1)*DECGA+(IFI-1)*4+2)=COPG(3,IG)+GM2(3)
C pour le poids, on multiplie par l'aire des fibres
            ZR(ICOPG+(IG-1)*DECGA+(IFI-1)*4+3)=
     &               ZR(IPOIDS+IG-1)*XL2*ZR(JACF+(IFI-1)*NCARFI+2)
 110      CONTINUE
 100    CONTINUE

      ELSEIF((NOMTE(1:8).EQ.'MET3SEG3').OR. (NOMTE(1:8).EQ.'MET3SEG4')
     &                            .OR.(NOMTE(1:8).EQ.'MET6SEG3')) THEN
        CALL JEVECH('PNBSP_I','L',INBF)
        CALL JEVECH('PCAGEPO','L',IGEPO)
C       NOMBRE DE COUCHES ET NOMBRE DE SECTIONS
        NBCOU = ZI(INBF)
        NBSEC = 2*ZI(INBF+1)+1
C       NOMBRE DE SOUS POINTS PAR POINT DE GAUSS
        NBSP= NBSEC*(2*NBCOU+1)
C       RAYON ET EPAISSEUR DU TUYAUX
        RAYON=ZR(IGEPO)
        EP=ZR(IGEPO+1)
        EPCOU=EP/NBCOU
        CALL JEVECH('PCAORIE','L',IORIEN)
C       POSITION DES POINTS DE GAUSS SUR L'AXE
        CALL PPGA12(NDIM,NNO,NPG,ZR(IPOIDS),ZR(IVF),
     &              ZR(IGEOM),COPG)

        GM1(1)=0.D0
        DO 20 IG=1,NPG
C         CALCUL DE LA MATRICE DE PASSAGE DE LA BASE GLOBALE DANS LA
C         LOCAL
          CALL MATROT(ZR(IORIEN+3*(IG-1)),PGL)



C         CALCUL DES COORDONNEES ET STOCKAGE
C         LES SOUS POINTS SONT STOCKES NIVEAU PAR NIVEAU ( IL Y A
C         PLUSIEURS NIVEAUX PAR COUCHE)
C         EN COMMENCANT PAR LA SECTION Z LOCAL = 0 ET Y >0
          DO 30 ISEC=0,NBSEC-1
            ALPHA=2*PI/(NBSEC-1)
            Y=COS(-ISEC*ALPHA)
            Z=SIN(-ISEC*ALPHA)
            DO 40 ICOU=1,2*NBCOU+1
               GM1(2)=(RAYON-EP+(ICOU-1)*EPCOU/2)*Y
               GM1(3)=(RAYON-EP+(ICOU-1)*EPCOU/2)*Z
               CALL UTPVLG(1,3,PGL,GM1,GM2)

               ZR(ICOPG+4*(IG-1)*NBSP+4*(ICOU-1)*NBSEC+ISEC*4+0)=
     &                                              COPG(1,IG)+GM2(1)
               ZR(ICOPG+4*(IG-1)*NBSP+4*(ICOU-1)*NBSEC+ISEC*4+1)=
     &                                              COPG(2,IG)+GM2(2)
               ZR(ICOPG+4*(IG-1)*NBSP+4*(ICOU-1)*NBSEC+ISEC*4+2)=
     &                                              COPG(3,IG)+GM2(3)
C              ON LAISSE LE POIDS A 0
               ZR(ICOPG+4*(IG-1)*NBSP+4*(ICOU-1)*NBSEC+ISEC*4+3)=0

  40        CONTINUE
  30      CONTINUE
  20    CONTINUE

       ELSEIF((NOMTE(1:7).EQ.'METCSE3').OR. (NOMTE(1:7).EQ.'MECXSE3')
     &                            .OR.(NOMTE(1:7).EQ.'METDSE3')) THEN

        CALL JEVECH ('PCACOQU' , 'L' , ICOQ)
        CALL JEVECH('PNBSP_I','L',INBF)
        NBCOU=ZI(INBF)
        EP=ZR(ICOQ)
        EPCOU=EP/NBCOU
        CALL PPGA12(NDIM,NNO,NPG,ZR(IPOIDS),ZR(IVF),
     &              ZR(IGEOM),COPG2)
      DO 50 IG=1,NPG
C       CALCUL DU VECTEUR NORMAL UNITAIRE AU POINT DE GAUSS
        K = (IG-1)*NNO
        CALL DFDM1D(NNO,ZR(IPOIDS+IG-1),ZR(IDFDE+K),ZR(IGEOM),DFDX,COUR,
     &              JACP,COSA,SINA)
        GM2(1)=COSA
        GM2(2)=SINA

        DO 60 ICOU=1,NBCOU

            DO 70 ISP=1,3
                HH=-EP/2+(ICOU-1+0.5D0*(ISP-1))*EPCOU
                ZR(ICOPG+(IG-1)*9*NBCOU+(ICOU-1)*9+(ISP-1)*3+0)=
     &                                        COPG2(1,IG)+HH*GM2(1)
                ZR(ICOPG+(IG-1)*9*NBCOU+(ICOU-1)*9+(ISP-1)*3+1)=
     &                                        COPG2(2,IG)+HH*GM2(2)
                IF (ISP.EQ.2) THEN
                    SPOID=2.0D0/3
                ELSE
                    SPOID=1.0D0/6
                ENDIF
                ZR(ICOPG+(IG-1)*9*NBCOU+(ICOU-1)*9+(ISP-1)*3+2)=
     &                              1.0D0/NBCOU*ZR(IPOIDS+IG-1)*SPOID
  70        CONTINUE
  60    CONTINUE

  50  CONTINUE

      ELSE
C AUTRES ELEMENTS
         CALL PPGA12(NDIM,NNO,NPG,ZR(IPOIDS),ZR(IVF),
     &               ZR(IGEOM),ZR(ICOPG))
      ENDIF


      END
