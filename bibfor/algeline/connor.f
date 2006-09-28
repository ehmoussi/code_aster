      SUBROUTINE CONNOR (MELFLU,TYPFLU,FREQ,MODE,NUOR,AMOC,CARAC,
     &                   MASG,LNOE,NBM,VITE,RHO,ABSCUR)

      IMPLICIT NONE
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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

C  CALCUL DES VITESSES EFFICACES ET CRITIQUES PAR LA METHODE DE CONNORS
C  IN : MELFLU : NOM DU CONCEPT DE TYPE MELASFLU PRODUIT
C  IN : TYPFLU : NOM DU CONCEPT DE TYPE TYPE_FLUI_STRU DEFINISSANT LA
C                CONFIGURATION ETUDIEE
C  IN : FREQ   : LISTE DES FREQUENCES ETUDIES
C  IN : NUOR   : LISTE DES NUMEROS D'ORDRE DES MODES SELECTIONNES POUR
C                LE COUPLAGE (PRIS DANS LE CONCEPT MODE_MECA)
C  IN : AMOR   : LISTE DES AMORTISSEMENTS REDUITS MODAUX
C  IN : AMOC   : LISTE DES AMORTISSEMENTS REDUITS MODAUX DE CONNORS
C  IN : CARAC  : CARACTERISTIQUES GEOMETRIQUES DU TUBE
C  IN : MASG   : MASSES GENERALISEES DES MODES PERTURBES, SUIVANT LA
C                DIRECTION CHOISIE PAR L'UTILISATEUR
C  IN : LNOE   : NOMBRE DE NOEUDS
C  IN : NBM    : NOMBRE DE MODES PRIS EN COMPTE POUR LE COUPLAGE
C  IN : VITE   : LISTE DES VITESSES D'ECOULEMENT ETUDIEES
C  IN : RHO    : MASSE VOLUMIQUE DU TUBE
C  IN : ABSCUR : ABSCISSE CURVILIGNE DES NOEUDS
C-------------------   DECLARATION DES VARIABLES   ---------------------
C
C COMMUNS NORMALISES JEVEUX
C -------------------------
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
C
C ARGUMENTS
C ---------
      CHARACTER*19  MELFLU
      CHARACTER*8   TYPFLU
      INTEGER       NBM
      INTEGER       NUOR(NBM),LNOE
      REAL*8        AMOC(NBM),MASG(NBM),CARAC(2),FREQ(NBM)
      REAL*8        VITE(LNOE),ABSCUR(LNOE)
      REAL*8        RHO(2*LNOE),MODE(LNOE*NBM)
C

C
C VARIABLES LOCALES
C -----------------
      REAL*8       COEF(NBM),DELTA(NBM),AMORED(NBM),RHOTUB,RHOS
      INTEGER      IMODE,IM,IFSVR,IFSVI,NBMA,NBZEX,NMAMIN,NMAMAX
      INTEGER      IENER,IMA,IZONE,IVCN,IVEN,ICSTE,MODUL,NBVAL,I,J
      INTEGER      JCONN, MODUL2, K, JZONE
      REAL*8       DI,DE,MASTUB,DIAMEQ,LTUBE,NUMERA(NBM),DENOMI
      REAL*8       PAS,CORREL,R8PI,A,B,C,D,E,F,MPHI2(NBM)
      REAL*8       COEFF1,COEFF2,COEFF3,COEFF4,COEFF5,COEFF6
      CHARACTER*24 FSVR,FSVI

      CALL JEMARQ()
C     CALCUL DES CONSTANTES INDEPENDANTES DE L ABSCISSE CURVILIGNE
C     ------------------------------------------------------------

      FSVR = TYPFLU//'           .FSVR'
      CALL JEVEUO(FSVR,'L',IFSVR)

      FSVI = TYPFLU//'           .FSVI'
      CALL JEVEUO(FSVI,'L',IFSVI)

      CALL JEVEUO('&&MDCONF.TEMPO','L',JZONE)

C     CALCUL DE LA MASSE MOYENNE
      DE=CARAC(1)
      DI=CARAC(1)-2*CARAC(2)
      RHOTUB=ZR(IFSVR+2)
      PAS=ZR(IFSVR+1)
      NBMA=LNOE-1
      NBZEX=ZI(IFSVI+1)

      NBVAL=1
      DO 5 I=1,NBZEX
         NBVAL=NBVAL*ZI(IFSVI+1+NBZEX+I)
  5   CONTINUE

C =======================
C     VECTEUR DE TRAVAIL CONTENANT POUR CHAQUE MODE ET CHAQUE ZONE
C     LA VALEUR DE L ENERGIE DU AU FLUIDE
C     PAR ORDRE ON DONNE POUR LE MODE 1 LES VALEURS SUR CHAQUE ZONE
C     PUIS LE MODE 2 ET ETC

      CALL WKVECT('&&CONNOR.ENERGI','V V R',NBZEX*NBM,IENER)
      CALL WKVECT('&&CONNOR.CSTE','V V R',NBZEX,ICSTE)

      CALL WKVECT(MELFLU(1:8)//'.VCN','G V R',NBVAL*NBM,IVCN)
      CALL WKVECT(MELFLU(1:8)//'.VEN','G V R',NBM,IVEN)
      CALL WKVECT(MELFLU(1:8)//'.MASS','V V R',2,JCONN)

      IF (ZI(IFSVI).EQ.1) THEN
C     PAS CARRE
         DIAMEQ=PAS*(1.07D0+0.56D0*(PAS/DE))
      ELSE IF (ZI(IFSVI).EQ.2 ) THEN
C     PAS TRIANGLE
         DIAMEQ=PAS*(0.96D0+0.5D0*(PAS/DE))
      ELSE
         CALL U2MESS('F','ALGELINE_28')
      ENDIF

      CORREL=(R8PI()/2)*((DIAMEQ/DE)**2+1)/((DIAMEQ/DE)**2-1)
      MASTUB=0.D0
      RHOS=0.D0
      LTUBE=ABSCUR(LNOE)-ABSCUR(1)

      DO 10 IMA=1,NBMA

         MASTUB=MASTUB+(ABSCUR(IMA+1)-ABSCUR(IMA))*
     &   (RHOTUB+(DI**2/(DE**2-DI**2))*((RHO(IMA+LNOE)+
     &   RHO(IMA+LNOE+1))/2)+
     &   (2*CORREL/R8PI())*(DE**2/(DE**2-DI**2))*((RHO(IMA)+
     &   RHO(IMA+1))/2))
         RHOS=RHOS+(ABSCUR(IMA+1)-ABSCUR(IMA))*
     &   ((RHO(IMA)+RHO(IMA+1))/2)
 10   CONTINUE

      MASTUB=((R8PI()/4)*(DE**2-DI**2)*MASTUB)/LTUBE
      RHOS = RHOS/LTUBE
      ZR(JCONN)=MASTUB
      ZR(JCONN+1)=RHOS



C     CALCUL DE LA VITESSE CRITIQUE INTER TUBES POUR CHAQUE COMBINAISON
C     DES CONSTANTE DE CONNORS ET POUR CHAQUE MODE

      DO 20 IM=1,NBM

         IMODE=NUOR(IM)
C        LES LIGNES COMMENTARISEES CORRESPONDENT A
C        UN AMORTISSEMENT MODAL CALCULE PAR LA FORMULE :
C        AMORTISSEMENT/(4*PI*(MASSE GENERALISE*FREQUENCE)

C        AMORED(IMODE)=AMOC(IMODE)/(4*R8PI()*MASG(IMODE)*FREQ(IMODE))
C        DELTA(IMODE)=(2*R8PI()*AMORED(IMODE))/SQRT(1-AMORED(IMODE)**2)

         DELTA(IM)=(2*R8PI()*AMOC(IM))/SQRT(1-AMOC(IM)**2)
         COEF(IM)=FREQ(IMODE)*SQRT(MASTUB*DELTA(IM)/RHOS)

         DO 30 IZONE=1,NBZEX

            NMAMIN=ZI(JZONE+2*(IZONE-1)+1)
            NMAMAX=ZI(JZONE+2*(IZONE-1)+2)-1
C     RHO EST DE LA FORME A*S+B
C     V   EST DE LA FORME C*S+D
C     PHI EST DE LA GORME E*S+F
            DO 40 IMA=NMAMIN,NMAMAX
               A=(RHO(IMA+1)-RHO(IMA))/(ABSCUR(IMA+1)-ABSCUR(IMA))
               B=RHO(IMA)-A*ABSCUR(IMA)

               C=(VITE(IMA+1)-VITE(IMA))/(ABSCUR(IMA+1)-ABSCUR(IMA))
               D=VITE(IMA)-C*ABSCUR(IMA)

               E=(MODE(LNOE*(IM-1)+IMA+1)-MODE(LNOE*(IM-1)+IMA))
     &         /(ABSCUR(IMA+1)-ABSCUR(IMA))
               F=MODE(LNOE*(IM-1)+IMA)-E*ABSCUR(IMA)

C    COEFFICIENT DU POLYNOME DU 5 DEGRES RESULTAT DE RHO*V**2*PHI**2

               COEFF1=A*C**2*E**2
               COEFF2=2*A*E*F*(C**2)+2*A*(E**2)*C*D+(C**2)*(E**2)*B
               COEFF3=A*(F**2)*(C**2)+4*A*E*F*C*D+A*(E**2)*(D**2)+
     &         2*E*F*(C**2)*B+2*(E**2)*C*D*B
               COEFF4=2*A*C*D*(F**2)+2*A*E*F*(D**2)+(F**2)*(C**2)*B+
     &         4*E*F*C*D*B+(E**2)*(D**2)*B
               COEFF5=2*C*D*(F**2)*B+2*E*F*(D**2)*B+(D**2)*(F**2)*A
               COEFF6=(D**2)*(F**2)*B

               ZR(IENER-1+NBZEX*(IM-1)+IZONE)=
     &         ZR(IENER-1+NBZEX*(IM-1)+IZONE)+
     &         (COEFF1*(ABSCUR(IMA+1)**6-ABSCUR(IMA)**6))/6+
     &         (COEFF2*(ABSCUR(IMA+1)**5-ABSCUR(IMA)**5))/5+
     &         (COEFF3*(ABSCUR(IMA+1)**4-ABSCUR(IMA)**4))/4+
     &         (COEFF4*(ABSCUR(IMA+1)**3-ABSCUR(IMA)**3))/3+
     &         (COEFF5*(ABSCUR(IMA+1)**2-ABSCUR(IMA)**2))/2+
     &         COEFF6*(ABSCUR(IMA+1)-ABSCUR(IMA))
  40        CONTINUE
  30     CONTINUE
  20  CONTINUE

      DO 50 I=1,NBVAL
         MODUL=1

                DO 60 J=1,NBZEX
                   MODUL=1
                   DO 65 K=(J+1),NBZEX
                      MODUL=MODUL*ZI(IFSVI+1+NBZEX+K)
65                 CONTINUE
                   IF (J.EQ.1) THEN
                      PAS=(I-1)/MODUL
                   ELSE
                      MODUL2=MODUL*ZI(IFSVI+1+NBZEX+J)
                      PAS=(MOD((I-1),MODUL2))/MODUL
                   ENDIF
                   ZR(ICSTE-1+J)=ZR(IFSVR+3+2*(J-1))+PAS*
     &             (ZR(IFSVR+3+2*(J-1)+1)-ZR(IFSVR+3+2*(J-1)))
     &             /(ZI(IFSVI+1+NBZEX+J)-1)
60            CONTINUE

      DO 70 IM=1,NBM
         NUMERA(IM)=0.D0
         DENOMI=0.D0
         DO 80 IZONE=1,NBZEX
            NUMERA(IM)=NUMERA(IM)+
     &      ZR(IENER-1+NBZEX*(IM-1)+IZONE)
            DENOMI=DENOMI+ZR(ICSTE-1+IZONE)**(-2)*
     &      ZR(IENER-1+NBZEX*(IM-1)+IZONE)
 80      CONTINUE
            ZR(IVCN-1+(IM-1)*NBVAL+I)=
     &         SQRT((NUMERA(IM)/DENOMI))*COEF(IM)
 70   CONTINUE
 50   CONTINUE

C    CALCUL DE LA VITESSE EFFICACE POUR CHAQUE MODE PROPRE

      DO 90 IM=1,NBM

C    LA MASSE LINEIQUE DU TUBE EST DE LA FORME A*S+B
C    LE MODE PROPRE DU TUBE EST DE LA FORME C*S+D

         MPHI2(IM)=0.D0
         DO 100 IMA=1,NBMA

            A=(0.5D0*R8PI()*(DI**2)*(RHO(LNOE+IMA+1)-RHO(LNOE+IMA))+
     &         CORREL*(DE**2)*(RHO(IMA+1)-RHO(IMA)))/
     &        (2*(ABSCUR(IMA+1)-ABSCUR(IMA)))
            B=R8PI()*RHOTUB*(DE**2-DI**2)/4+R8PI()*(DI**2)/4*
     &      (RHO(LNOE+IMA)-(RHO(LNOE+IMA+1)-RHO(LNOE+IMA))/
     &      (ABSCUR(IMA+1)-ABSCUR(IMA))*ABSCUR(IMA))+
     &      CORREL*(DE**2)/2*(RHO(IMA)-(RHO(IMA+1)-RHO(IMA))/
     &      (ABSCUR(IMA+1)-ABSCUR(IMA))*ABSCUR(IMA))

            C=(MODE(LNOE*(IM-1)+IMA+1)-MODE(LNOE*(IM-1)+IMA))/
     &         (ABSCUR(IMA+1)-ABSCUR(IMA))
            D=MODE(LNOE*(IM-1)+IMA)-C*ABSCUR(IMA)

            COEFF1=A*(C**2)
            COEFF2=2*C*D*A+(C**2)*B
            COEFF3=(D**2)*A+2*C*D*B
            COEFF4=(D**2)*B
            MPHI2(IM)=MPHI2(IM)+
     &         (COEFF1*(ABSCUR(IMA+1)**4-ABSCUR(IMA)**4))/4+
     &         (COEFF2*(ABSCUR(IMA+1)**3-ABSCUR(IMA)**3))/3+
     &         (COEFF3*(ABSCUR(IMA+1)**2-ABSCUR(IMA)**2))/2+
     &         COEFF4*(ABSCUR(IMA+1)-ABSCUR(IMA))

 100     CONTINUE

         ZR(IVEN-1+IM)=SQRT((NUMERA(IM)*MASTUB)/
     &     (MPHI2(IM)*RHOS))

 90   CONTINUE

      CALL JEDEMA()
      END
