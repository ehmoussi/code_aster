      SUBROUTINE TE0063(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
C THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
C IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
C THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
C (AT YOUR OPTION) ANY LATER VERSION.

C THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
C WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
C MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
C GENERAL PUBLIC LICENSE FOR MORE DETAILS.

C YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
C ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
C    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
C ======================================================================
C CALCUL DES FLUX AUX NOEUDS
C ELEMENTS ISO 3D  OPTION : 'FLUX_ELNO_TEMP ' (CALCUL STD)
C 'FLUX_ELNO_SENS' (SENSIBILITE PAR RAPPORT A UNE DONNEE MATERIAU)

C     ENTREES  ---> OPTION : OPTION DE CALCUL
C              ---> NOMTE  : NOM DU TYPE ELEMENT
C   -------------------------------------------------------------------
C     ASTER INFORMATIONS:
C       30/04/02 (OB): CALCUL DE LA SENSIBILITE DU FLUX THERMIQUE VIA
C                      L'OPTION 'FLUX_ELNO_SENS' + MODIFS FORMELLES
C                      (IMPLICIT NONE, IDENTATION...)
C----------------------------------------------------------------------
C CORPS DU PROGRAMME
      IMPLICIT NONE

C PARAMETRES D'APPELS
      CHARACTER*16 OPTION,NOMTE

C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
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
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------

      CHARACTER*2 CODRET(3)
      CHARACTER*8 NOMRES(3)
      CHARACTER*16 PHENOM,PHESEN
      REAL*8 VALRES(3),LAMBDA,FLUXX,FLUXY,FLUXZ,TPG,DFDX(27),DFDY(27),
     &       DFDZ(27),POIDS,FPG(81),LAMBOR(3),FLUGLO(3),FLULOC(3),
     &       P(3,3),DIRE(3),ORIG(3),POINT(3),ANGL(3),LAMBS,PREC,R8PREM,
     &       LAMBOS(3),TRACE,FLUSX,FLUSY,FLUSZ,FLUGLS(3),FLULOS(3),
     &       R8DGRD,ALPHA,BETA
      INTEGER JGANO,IPOIDS,IVF,IDFDE,IGEOM,IMATE,NNO,KP,
     &        NPG1,I,IFLUX,ITEMPS,ITEMPE,IMATSE,ITEMSE,L,N1,N2,NDIM,
     &        NNOS,ICAMAS,IFPG,NUNO
      LOGICAL ANISO,GLOBAL,LSENS

C====
C 1.1 PREALABLES: RECUPERATION ADRESSES FONCTIONS DE FORMES...
C====
      PREC = R8PREM()
      CALL ELREF4(' ','GANO',NDIM,NNO,NNOS,NPG1,IPOIDS,IVF,IDFDE,
     &              JGANO)

C====
C 1.2 PREALABLES LIES AUX CALCULS DE SENSIBILITE
C====
C CALCUL DE SENSIBILITE PART I
      IF (OPTION(11:14).EQ.'SENS') THEN
        LSENS = .TRUE.
        CALL JEVECH('PMATSEN','L',IMATSE)
        CALL JEVECH('PTEMSEN','L',ITEMSE)
      ELSE
        LSENS = .FALSE.
      END IF

C====
C 1.3 PREALABLES LIES AUX RECHERCHES DE DONNEES GENERALES
C====
      CALL JEVECH('PGEOMER','L',IGEOM)
      CALL JEVECH('PMATERC','L',IMATE)
      CALL JEVECH('PTEMPSR','L',ITEMPS)
      CALL JEVECH('PTEMPER','L',ITEMPE)
      CALL JEVECH('PFLUX_R','E',IFLUX)
      CALL RCCOMA(ZI(IMATE),'THER',PHENOM,CODRET)
C CALCUL DE SENSIBILITE PART II. TEST DE COHERENCE PHENOM STD/
C PHENOM MAT DERIVEE
      IF (LSENS) THEN
        CALL RCCOMA(ZI(IMATSE),'THER',PHESEN,CODRET)
        IF (PHESEN.NE.PHENOM) CALL U2MESS('F','ELEMENTS_38')
      END IF

C====
C 1.4 PREALABLES LIES A LA RECUPERATION DES DONNEES MATERIAUX EN
C     THERMIQUE LINEAIRE ISOTROPE OU ORTHOTROPE
C====
      LAMBDA = 0.D0
      IF (PHENOM.EQ.'THER') THEN
        NOMRES(1) = 'LAMBDA'
        CALL RCVALA(ZI(IMATE),' ',PHENOM,1,'INST',ZR(ITEMPS),1,NOMRES,
     &              LAMBDA,CODRET,'FM')
        ANISO = .FALSE.

C CALCUL DE SENSIBILITE PART III (ISOTROPE)
        IF (LSENS) THEN
          CALL RCVALA(ZI(IMATSE),' ',PHENOM,1,'INST',ZR(ITEMPS),1,
     &                NOMRES,LAMBS,CODRET,'FM')
C SI SENSIBILITE /RHO_CP OU /AUTRE LAMBDA ON A PAS DE TERME COMPLE
C MENTAIRE A ASSEMBLER
          IF (ABS(LAMBS).LT.PREC) LSENS = .FALSE.
        END IF

      ELSE IF (PHENOM.EQ.'THER_ORTH') THEN
        NOMRES(1) = 'LAMBDA_L'
        NOMRES(2) = 'LAMBDA_T'
        NOMRES(3) = 'LAMBDA_N'
        CALL RCVALA(ZI(IMATE),' ',PHENOM,1,'INST',ZR(ITEMPS),3,NOMRES,
     &              VALRES,CODRET,'FM')
        LAMBOR(1) = VALRES(1)
        LAMBOR(2) = VALRES(2)
        LAMBOR(3) = VALRES(3)
        ANISO = .TRUE.

C CALCUL DE SENSIBILITE PART IV (ORTHOTROPE)
        IF (LSENS) THEN
          CALL RCVALA(ZI(IMATSE),' ',PHENOM,1,'INST',ZR(ITEMPS),3,
     &             NOMRES,   VALRES,CODRET,'FM')
C SI SENSIBILITE /RHO_CP OU /AUTRE LAMBDA ON A PAS DE TERME COMPLE
C MENTAIRE A ASSEMBLER
          LAMBOS(1) = VALRES(1)
          LAMBOS(2) = VALRES(2)
          LAMBOS(3) = VALRES(3)
          TRACE = LAMBOS(1) + LAMBOS(2) + LAMBOS(3)
          IF (ABS(TRACE).LT.PREC) LSENS = .FALSE.
        END IF

      ELSE IF (PHENOM.EQ.'THER_NL') THEN
        ANISO = .FALSE.

C CALCUL DE SENSIBILITE PART V (THERMIQUE NON-LINEAIRE)
        IF (LSENS) THEN
          TPG = 0.D0
          CALL RCVALA(ZI(IMATSE),' ',PHENOM,1,'TEMP',TPG,1,'LAMBDA',
     &               LAMBS, CODRET,'FM')
          IF (ABS(LAMBS).LT.PREC) LSENS = .FALSE.
        END IF

      ELSE
        CALL U2MESS('F','MODELISA5_46')
      END IF

C====
C 1.5 PREALABLES LIES A L'ANISOTROPIE
C====
      GLOBAL = .FALSE.
      IF (ANISO) THEN
        CALL JEVECH('PCAMASS','L',ICAMAS)
        IF (ZR(ICAMAS).GT.0.D0) THEN
          GLOBAL = .TRUE.
          ANGL(1) = ZR(ICAMAS+1)*R8DGRD()
          ANGL(2) = ZR(ICAMAS+2)*R8DGRD()
          ANGL(3) = ZR(ICAMAS+3)*R8DGRD()
          CALL MATROT(ANGL,P)
        ELSE
          ALPHA = ZR(ICAMAS+1)*R8DGRD()
          BETA = ZR(ICAMAS+2)*R8DGRD()
          DIRE(1) = COS(ALPHA)*COS(BETA)
          DIRE(2) = SIN(ALPHA)*COS(BETA)
          DIRE(3) = -SIN(BETA)
          ORIG(1) = ZR(ICAMAS+4)
          ORIG(2) = ZR(ICAMAS+5)
          ORIG(3) = ZR(ICAMAS+6)
        END IF
      END IF

C====
C 2. CALCULS TERMES DE FLUX (STD ET/OU SENSIBLE)
C====
      DO 50 KP = 1,NPG1
        IFPG = (KP-1)*3
        L = (KP-1)*NNO
        CALL DFDM3D ( NNO, KP, IPOIDS, IDFDE,
     &                ZR(IGEOM), DFDX, DFDY, DFDZ, POIDS )

C     CALCUL DE T ET DE GRAD(T) AUX POINTS DE GAUSS (EN STD)
C     OU DE DT/DS ET GRAD(DT/DS) (EN SENSIBILITE)
        TPG = 0.0D0
        FLUXX = 0.0D0
        FLUXY = 0.0D0
        FLUXZ = 0.0D0
        IF (.NOT.GLOBAL .AND. ANISO) THEN
          POINT(1) = 0.D0
          POINT(2) = 0.D0
          POINT(3) = 0.D0
          DO 20 NUNO = 1,NNO
            POINT(1) = POINT(1) + ZR(IVF+L+NUNO-1)*ZR(IGEOM+3*NUNO-3)
            POINT(2) = POINT(2) + ZR(IVF+L+NUNO-1)*ZR(IGEOM+3*NUNO-2)
            POINT(3) = POINT(3) + ZR(IVF+L+NUNO-1)*ZR(IGEOM+3*NUNO-1)
   20     CONTINUE
          CALL UTRCYL(POINT,DIRE,ORIG,P)
        END IF

        DO 30 I = 1,NNO
          TPG = TPG + ZR(ITEMPE-1+I)*ZR(IVF+L+I-1)
          FLUXX = FLUXX + ZR(ITEMPE-1+I)*DFDX(I)
          FLUXY = FLUXY + ZR(ITEMPE-1+I)*DFDY(I)
          FLUXZ = FLUXZ + ZR(ITEMPE-1+I)*DFDZ(I)
   30   CONTINUE
C CALCUL DE SENSIBILITE PART VI : CALCUL DE T ET DE GRAD(T)
        IF (LSENS) THEN
          TPG = 0.0D0
          FLUSX = 0.0D0
          FLUSY = 0.0D0
          FLUSZ = 0.0D0
          DO 40 I = 1,NNO
            TPG = TPG + ZR(ITEMSE-1+I)*ZR(IVF+L+I-1)
            FLUSX = FLUSX + ZR(ITEMSE-1+I)*DFDX(I)
            FLUSY = FLUSY + ZR(ITEMSE-1+I)*DFDY(I)
            FLUSZ = FLUSZ + ZR(ITEMSE-1+I)*DFDZ(I)
   40     CONTINUE
        END IF
        IF (PHENOM.EQ.'THER_NL') CALL RCVALA(ZI(IMATE),' ',PHENOM,1,
     &                       'TEMP',TPG,1,'LAMBDA',LAMBDA,CODRET,'FM')

        IF (.NOT.ANISO) THEN
          FLUGLO(1) = LAMBDA*FLUXX
          FLUGLO(2) = LAMBDA*FLUXY
          FLUGLO(3) = LAMBDA*FLUXZ
C CALCUL DE SENSIBILITE PART VII: RAJOUT TERME COMPLEMENTAIRE (ISO)
          IF (LSENS) THEN
            FLUGLO(1) = FLUGLO(1) + LAMBS*FLUSX
            FLUGLO(2) = FLUGLO(2) + LAMBS*FLUSY
            FLUGLO(3) = FLUGLO(3) + LAMBS*FLUSZ
          END IF
        ELSE
          FLUGLO(1) = FLUXX
          FLUGLO(2) = FLUXY
          FLUGLO(3) = FLUXZ
          N1 = 1
          N2 = 3
          CALL UTPVGL(N1,N2,P,FLUGLO,FLULOC)
          FLULOC(1) = LAMBOR(1)*FLULOC(1)
          FLULOC(2) = LAMBOR(2)*FLULOC(2)
          FLULOC(3) = LAMBOR(3)*FLULOC(3)
          N1 = 1
          N2 = 3
          CALL UTPVLG(N1,N2,P,FLULOC,FLUGLO)
C CALCUL DE SENSIBILITE PART VIII: RAJOUT DU TERME COMPLEMENTAIRE (ORT)
          IF (LSENS) THEN
            FLUGLS(1) = FLUSX
            FLUGLS(2) = FLUSY
            FLUGLS(3) = FLUSZ
            N1 = 1
            N2 = 3
            CALL UTPVGL(N1,N2,P,FLUGLS,FLULOS)
            FLULOS(1) = LAMBOS(1)*FLULOS(1)
            FLULOS(2) = LAMBOS(2)*FLULOS(2)
            FLULOS(3) = LAMBOS(3)*FLULOS(3)
            N1 = 1
            N2 = 3
            CALL UTPVLG(N1,N2,P,FLULOS,FLUGLS)
            FLUGLO(1) = FLUGLO(1) + FLUGLS(1)
            FLUGLO(2) = FLUGLO(2) + FLUGLS(2)
            FLUGLO(3) = FLUGLO(3) + FLUGLS(3)
          END IF
        END IF

        FPG(IFPG+1) = -FLUGLO(1)
        FPG(IFPG+2) = -FLUGLO(2)
        FPG(IFPG+3) = -FLUGLO(3)
   50 CONTINUE

      CALL PPGAN2(JGANO,3,FPG,ZR(IFLUX))
   60 CONTINUE

      END
