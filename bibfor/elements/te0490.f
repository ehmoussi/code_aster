      SUBROUTINE TE0490(OPTION,NOMTE)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ELEMENTS  DATE 19/11/2012   AUTEUR SELLENET N.SELLENET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C TOLE CRP_20
C
      IMPLICIT NONE
C
C     BUTS: .CALCUL DES INDICATEURS GLOBAUX
C            DE PERTE DE PROPORTIONNALITE DU CHARGEMENT
C            POUR LES ELEMENTS ISOPARAMETRIQUES 2D
C           .CALCUL DES ENERGIES DE DEFORMATION ELASTIQUE ET TOTALE
C
C -----------------------------------------------------------------
C
C  OPTION INDIC_ENER : CALCUL DE  L'INDICATEUR GLOBAL
C  =================   ENERGETIQUE DETERMINE PAR L'EXPRESSION SUIVANTE:
C
C            IE = (SOMME_DOMAINE((1 - PSI(EPS)/OMEGA(EPS,VARI)).DV)/V
C
C        OU  .OMEGA EST LA DENSITE D'ENERGIE TOTALE
C            (I.E. OMEGA = SOMME_0->T(SIGMA:D(EPS)/DT).DTAU
C            .PSI EST LA DENSITE D'ENERGIE ELASTIQUE 'TOTALE'
C            (I.E. ASSOCIEE A LA COURBE DE TRACTION SI ON
C                  CONSIDERAIT LE MATERIAU ELASTIQUE NON-LINEAIRE)
C            .V EST LE VOLUME DU GROUPE DE MAILLES TRAITE
C -----------------------------------------------------------------
C
C  OPTION INDIC_SEUIL : CALCUL DE  L'INDICATEUR GLOBAL
C  ==================   DETERMINE PAR L'EXPRESSION SUIVANTE :
C
C   IS = (SOMME_DOMAINE(1 - ((SIG-X):EPS_PLAST)/((SIG_Y+R)*P)).DV)/V
C
C        OU  .SIG       EST LE TENSEUR DES CONTRAINTES
C            .X         EST LE TENSEUR DE RAPPEL
C            .EPS_PLAST EST LE TENSEUR DES DEFORMATIONS PLASTIQUES
C            .SIG_Y     EST LA LIMITE D'ELASTICITE
C            .R         EST LA FONCTION D'ECROUISSAGE
C            .P         EST LA DEFORMATION PLASTIQUE CUMULEE
C            .V         EST LE VOLUME DU GROUPE DE MAILLES TRAITE
C
C -----------------------------------------------------------------
C
C -----------------------------------------------------------------

C  OPTION ENEL_ELEM : CALCUL DE L'ENERGIE DE DEFORMATION ELASTIQUE
C  ================   DETERMINEE PAR L'EXPRESSION SUIVANTE :

C  EN HPP
C   ENELAS =  SOMME_VOLUME((SIG_T*(1/D)*SIG).DV)
C
C        OU  .SIG       EST LE TENSEUR DES CONTRAINTES DE CAUCHY
C            .D         EST LE TENSEUR DE HOOKE
C
C  EN GRANDES DEFORMATIONS SIMO MIEHE POUR ELAS OU VMIS_ISOT
C   ENERLAS = ENERGIE ELASTIQUE SPECIFIQUE
C           = K(0.5(J^2-1)-lnJ)+0.5mu(tr(J^(-2/3)be)-3)
C           SI PRESENCE DE THERMIQUE, ON AJOUTE UNE CORRECTION
C           SPECIFIQUE PRESENTEE DANS LA DOC R
C  EN GRANDES DEFORMATIONS GDEF_LOG
C   ENERELAS = SOMME_VOLUME((T_T*(1/D)*T).DV)
C        OU  .T       EST LE TENSEUR DES CONTRAINTES DU FORMALISME
C            .D         EST LE TENSEUR DE HOOKE
C -----------------------------------------------------------------
C
C  OPTION ENER_TOTALE : CALCUL DE L'ENERGIE DE DEFORMATION TOTALE
C  ==================   DETERMINEE PAR LES EXPRESSIONS SUIVANTES :
C
C   1-   ENER_TOTALE =  ENELAS + EPLAS
C
C          AVEC : ENELAS =  SOMME_VOLUME((SIG_T*(1/D)*SIG).DV)
C                 ENELAS EST L'ENERGIE DE DEFORMATION ELASTIQUE
C
C           OU  .SIG       EST LE TENSEUR DES CONTRAINTES
C               .D         EST LE TENSEUR DE HOOKE
C
C          ET   : EPLAS = SOMME_VOLUME((R(P))*D(P))
C                 EPLAS EST L'ENERGIE DE DEFORMATION PLASTIQUE
C
C           OU  .P         EST LA DEFORMATION PLASTIQUE CUMULEE
C           ET   R(P) EST CALCULE POUR LES COMPORTEMENTS SUIVANTS :
C                      .VMIS_ISOT_LINE
C                      .VMIS_ISOT_TRAC
C
C   2-   ENER_TOTALE= SOMME_VOLUME(OMEGA_ELEMENTAIRE)
C
C           AVEC : OMEGA_ELEMENTAIRE=
C            1/2(SIGMA(T1)*EPSI(T1)+SOMME(SIGMA(T(I))*DELTA(EPSI))+
C                SOMME(SIGMA(T(I+1))*DELTA(EPSI))
C
C   REMARQUE : EN GRANDE DEFORMATION ON INTEGRE SUR LE VOLUME INITIALE
C -----------------------------------------------------------------
C          ELEMENTS ISOPARAMETRIQUES 2D
C
C          OPTIONS : 'INDIC_ENER'
C                    'INDIC_SEUIL'
C                    'ENEL_ELEM'
C                    'ENER_TOTALE'
C
C     ENTREES  ---> OPTION : OPTION DE CALCUL
C              ---> NOMTE  : NOM DU TYPE ELEMENT
C.......................................................................
C
      INCLUDE 'jeveux.h'
C-----------------------------------------------------------------------
      INTEGER IDCONM ,IDENE1 ,IDENE2 ,IDEPL ,IDEPLM ,IDEPMM
      INTEGER IDFDE ,IDSIG ,IDSIGM ,IDVARI ,IGAU ,IGEOM ,IMATE,ITEMPS
      INTEGER IPOIDS ,IRET1 ,IVF ,JGANO ,JPROL ,JVALE ,MXCMEL
      INTEGER NBSGM ,NBSIG ,NBSIG2 ,NBVAL ,NBVARI ,NDIM ,NNO
      INTEGER NNOS ,NPG,NBSIGM, IRET,IDIM,I,JTAB(7),ICODRE(5)
      PARAMETER (MXCMEL = 162)
      PARAMETER (NBSGM  =   6)
      REAL*8 AIREP ,C1 ,C2 ,DEUX ,DEUXMU ,DSDE ,E
      REAL*8 ENELAS ,ENELDV ,ENELSP ,ENELTO ,EPLAEQ ,EPLAST ,EPSEQ
      REAL*8 EPSTHE ,OMEGA ,P ,POIDS ,PSI ,R8PREM ,RP
      REAL*8 RPRIM ,SIGEQ ,SIGY ,TEMPG ,TREPSM ,TROIS ,TRSIG
      REAL*8 UN ,UNDEMI ,UNTIER ,VOLUME ,WELAS ,WTOTAL
      REAL*8 ZERO,VALRES(5)
      REAL*8 SIGMA(NBSGM), EPSDV(NBSGM)
      REAL*8 EPSEL(NBSGM), EPSPLA(NBSGM), X(NBSGM)
      REAL*8 EPSIM(NBSGM),DELTA(NBSGM),SIGMM(NBSGM)
      REAL*8 EPSI(NBSGM),EPSSM(MXCMEL),EPSS(MXCMEL)
      REAL*8 REPERE(7), INSTAN, NHARM,INTEG,INTEG1
      REAL*8 EPSM(MXCMEL),INTEG2,NU, K, INDIGL,XYZ(3),RESU
      REAL*8 F(3,3),R,EPS(6),TRAV(81), RBID
      CHARACTER*4  FAMI
      CHARACTER*8  NOMRES(5),TYPE
      CHARACTER*16 NOMTE,OPTION, OPTIO2,COMPOR(3)
      LOGICAL GRAND, AXI
      LOGICAL LTEATT
C-----------------------------------------------------------------------

C
C ---- INITIALISATIONS :

      ZERO        = 0.0D0
      UNDEMI      = 0.5D0
      UN          = 1.0D0
      DEUX        = 2.0D0
      TROIS       = 3.0D0
      UNTIER      = 1.0D0/3.0D0
      NHARM       = ZERO
      OMEGA       = ZERO
      PSI         = ZERO
      VOLUME      = ZERO
      INDIGL      = ZERO
      ENELAS      = ZERO
      EPLAST      = ZERO
      WELAS       = ZERO
      WTOTAL      = ZERO
      INSTAN      = ZERO

C ---- CARACTERISTIQUES DU TYPE D'ELEMENT :
C ---- GEOMETRIE ET INTEGRATION
C
C
      FAMI = 'RIGI'
      CALL ELREF4(' ',FAMI,NDIM,NNO,NNOS,NPG,IPOIDS,IVF,IDFDE,JGANO)

C --- TYPE DE MODELISATION

      IF (LTEATT(' ','AXIS','OUI')) THEN
        AXI=.TRUE.
      ELSE
        AXI=.FALSE.
      ENDIF

C ---- NOMBRE DE CONTRAINTES ASSOCIE A L'ELEMENT :

      NBSIG = NBSIGM()

C ---- RECUPERATION DES COORDONNEES DES CONNECTIVITES :

      CALL JEVECH('PGEOMER','L',IGEOM)

C ---- RECUPERATION DU MATERIAU :

      CALL JEVECH('PMATERC','L',IMATE)

C ---- RECUPERATION  DES DONNEEES RELATIVES AU REPERE D'ORTHOTROPIE :
C     COORDONNEES DU BARYCENTRE ( POUR LE REPRE CYLINDRIQUE )

      XYZ(1) = 0.D0
      XYZ(2) = 0.D0
      XYZ(3) = 0.D0
      DO 150 I = 1,NNO
        DO 140 IDIM = 1,NDIM
          XYZ(IDIM) = XYZ(IDIM)+ZR(IGEOM+IDIM+NDIM*(I-1)-1)/NNO
 140    CONTINUE
 150  CONTINUE

      CALL ORTREP(ZI(IMATE),NDIM,XYZ,REPERE)

C ---- RECUPERATION DU CHAMP DE DEPLACEMENTS AUX NOEUDS  :

      CALL JEVECH('PDEPLR','L',IDEPL)

C ---- RECUPERATION DU CHAMP DE CONTRAINTES AUX POINTS D'INTEGRATION :

      CALL JEVECH('PCONTPR','L',IDSIG)

C ---- RECUPERATION DE L'INSTANT DE CALCUL
C      -----------------------------------
      CALL TECACH('NNN','PTEMPSR',1,ITEMPS,IRET)
      IF (ITEMPS.NE.0)  INSTAN = ZR(ITEMPS)

C ----RECUPERATION DU TYPE DE COMPORTEMENT  :
C     N'EXISTE PAS EN LINEAIRE
      CALL TECACH('NNN','PCOMPOR',7,JTAB,IRET)
      COMPOR(1)='ELAS'
      COMPOR(2)=' '
      COMPOR(3)='PETIT'
      IF (IRET.EQ.0) THEN
         COMPOR(1)=ZK16(JTAB(1))
         COMPOR(3)=ZK16(JTAB(1)+2)
      ENDIF

C     GRANDES DEFORMATIONS

      IF ((COMPOR(3).EQ.'SIMO_MIEHE').OR.
     &    (COMPOR(3).EQ.'GDEF_LOG').OR.
     &    (COMPOR(3).EQ.'GDEF_HYPO_ELAS')) THEN
         GRAND = .TRUE.
      ELSE
         GRAND = .FALSE.
      ENDIF

C ON TESTE LA RECUPERATION DU CHAMP DE CONTRAINTES DU PAS PRECEDENT

      IF ( OPTION.EQ.'ENER_TOTALE') THEN
         IF (GRAND) THEN
            CALL U2MESG('F','COMPOR1_78',1,COMPOR(3),0,0,0,0.D0)
         ENDIF
         IF((COMPOR(1)(1:9).NE.'VMIS_ISOT')
     &    .AND.(COMPOR(1)(1:4).NE.'ELAS')) THEN
            CALL TECACH('NNN','PCONTMR',1,IDCONM,IRET)
            IF (IDCONM.NE.0) THEN
               CALL JEVECH('PCONTMR','L',IDSIGM)
            ENDIF
          ENDIF
      ENDIF


C ---- RECUPERATION DU CHAMP DE DEPLACEMENTS AUX NOEUDS
C AU PAS PRECEDENT :

      IF ( OPTION.EQ.'ENER_TOTALE') THEN
       CALL TECACH('NNN','PDEPLM',1,IDEPLM,IRET)
       IF (IDEPLM.NE.0) THEN
        CALL JEVECH('PDEPLM','L',IDEPMM)
       ENDIF
      ENDIF

C ----   RECUPERATION DU CHAMP DE VARIABLES INTERNES  :
C        N'EXISTE PAS EN LINEAIRE
         CALL TECACH('ONN','PVARIPR',7,JTAB,IRET)
         IF (IRET.EQ.0) THEN
            IDVARI=JTAB(1)
            NBVARI = MAX(JTAB(6),1)*JTAB(7)
         ELSE
            IDVARI=1
            NBVARI=0
         ENDIF

C -- CALCUL DES DEFORMATIONS TOTALES DANS LE CAS DE
C -- ENERGIE TOTALE A L INSTANT COURANT ET CELUI D AVANT

      IF( (COMPOR(1)(1:9).NE.'VMIS_ISOT').AND.
     &   (COMPOR(1)(1:4).NE.'ELAS')) THEN

       IF ( OPTION.EQ.'ENER_TOTALE') THEN

C  CALCUL DE B.U

        CALL EPS1MC(NNO,NDIM,NBSIG,NPG,IPOIDS,IVF,IDFDE,
     &              ZR(IGEOM),ZR(IDEPL),NHARM,EPSS)

        IF (IDEPLM.NE.0)THEN
         CALL EPS1MC(NNO,NDIM,NBSIG,NPG,IPOIDS,IVF,IDFDE,
     &               ZR(IGEOM),ZR(IDEPMM),NHARM,EPSSM)
        ENDIF
       ENDIF
      ENDIF

C ---- CALCUL DES DEFORMATIONS HORS THERMIQUES CORRESPONDANTES AU
C ---- CHAMP DE DEPLACEMENT I.E. EPSM = EPST - EPSTH
C ---- OU EPST  SONT LES DEFORMATIONS TOTALES
C ----    EPST = B.U
C ---- ET EPSTH SONT LES DEFORMATIONS THERMIQUES
C ----    EPSTH = ALPHA*(T-TREF) :
C         ----------------------
      OPTIO2 = 'EPME_ELGA'
      CALL EPSVMC(FAMI, NNO, NDIM, NBSIG, NPG, IPOIDS,
     &            IVF,IDFDE,ZR(IGEOM), ZR(IDEPL),
     &            INSTAN,  ZI(IMATE), REPERE, NHARM,
     &            OPTIO2, EPSM)

C                      ===========================
C                      =                         =
C                      = OPTION   "INDIC_ENER"   =
C                      = OPTION   "ENEL_ELEM"    =
C                      = OPTION   "ENER_TOTALE"  =
C                      =                         =
C                      ===========================

      IF (OPTION.EQ.'INDIC_ENER'.OR.OPTION.EQ.'ENEL_ELEM'.OR.
     &   OPTION.EQ.'ENER_TOTALE') THEN

C --- BOUCLE SUR LES POINTS D'INTEGRATION

       DO 10 IGAU = 1, NPG

        OMEGA = ZERO
        PSI   = ZERO

C --- TENSEUR DES CONTRAINTES AU POINT D'INTEGRATION COURANT :

        DO 20 I = 1, NBSIG
          SIGMA(I) = ZR(IDSIG+(IGAU-1)*NBSIG+I-1)
  20    CONTINUE

C --- CALCUL DU JACOBIEN AU POINT D'INTEGRATION COURANT :

        CALL NMGEOM(2,NNO,AXI,GRAND,ZR(IGEOM),IGAU,IPOIDS,
     &              IVF,IDFDE,ZR(IDEPL),.TRUE.,POIDS,TRAV,F,EPS,R)

        CALL ENELPG(FAMI,ZI(IMATE),INSTAN,IGAU,REPERE,XYZ,COMPOR,
     &         F,SIGMA,NBVARI,ZR(IDVARI+(IGAU-1)*NBVARI),ENELAS)



        IF (OPTION.EQ.'ENEL_ELEM') THEN

         WELAS = WELAS + ENELAS*POIDS

         GOTO 10

C  ===============================================
C  = FIN TRAITEMENT DE L'OPTION ENEL_ELEM        =
C  ===============================================


        ENDIF

C --- RECUPERATION DES CARACTERISTIQUES DU MATERIAU :

          NOMRES(1) = 'E'
          NOMRES(2) = 'NU'

          CALL RCVALB(FAMI,IGAU,1,'+',ZI(IMATE),' ','ELAS',0,' ',
     &                0.D0,2,NOMRES,VALRES,ICODRE,2)


          E = VALRES(1)
          NU = VALRES(2)

C-------------------------------------------------------
C   CACUL DU TERME OMEGA REPRESENTANT L'ENERGIE TOTALE -
C   OMEGA = SOMME_0->T(SIGMA:D(EPS)/DT).DTAU           -
C-------------------------------------------------------
C --- TRAITEMENT DU CAS DE L'ECROUISSAGE LINEAIRE ISOTROPE :

        IF (COMPOR(1).EQ.'VMIS_ISOT_LINE') THEN

C --- RECUPERATION DE LA LIMITE D'ELASTICITE SY
C --- ET DE LA PENTE DE LA COURBE DE TRACTION D_SIGM_EPSI :

         NOMRES(1) = 'D_SIGM_EPSI'
         NOMRES(2) = 'SY'

         CALL RCVALB(FAMI,IGAU,1,'+',ZI(IMATE),' ','ECRO_LINE',
     &               0,' ',0.D0,2,NOMRES,VALRES,ICODRE,2)

         DSDE  = VALRES(1)
         SIGY  = VALRES(2)

C --- RECUPERATION DE LA DEFORMATION PLASTIQUE CUMULEE :

         P  = ZR(IDVARI+(IGAU-1)*NBVARI+1-1)

C --- PENTE DE LA COURBE DE TRACTION DANS LE DIAGRAMME 'REDRESSE' :

         RPRIM = E*DSDE/(E-DSDE)

C --- CONTRAINTE UNIAXIALE SUR LA COURBE DE TRACTION :

         RP  = SIGY + RPRIM*P

C --- TRAVAIL PLASTIQUE 'EQUIVALENT' :

         EPLAST = UNDEMI*(SIGY+RP)*P

C --- TRAITEMENT DU CAS DE L'ECROUISSAGE NON-LINEAIRE ISOTROPE :

        ELSEIF (COMPOR(1).EQ.'VMIS_ISOT_TRAC') THEN

C --- RECUPERATION DE LA COURBE DE TRACTION :

C  --- TEMPERATURE AU POINT D'INTEGRATION COURANT :

        CALL RCVARC(' ','TEMP','+',FAMI,IGAU,1,TEMPG,IRET1)
        CALL RCTYPE(ZI(IMATE),1,'TEMP',TEMPG,RESU,TYPE)
        IF ((TYPE(1:4).EQ.'TEMP').AND.(IRET1.EQ.1))
     &              CALL U2MESS('F','CALCULEL_31')
        CALL RCTRAC(ZI(IMATE),1,'SIGM', RESU,
     &              JPROL, JVALE, NBVAL, E)

C --- RECUPERATION DE LA DEFORMATION PLASTIQUE CUMULEE :

         P  = ZR(IDVARI+(IGAU-1)*NBVARI+1-1)

C --- TRAVAIL PLASTIQUE 'EQUIVALENT' :

         CALL RCFONC('V',1,JPROL,JVALE,NBVAL,RBID,RBID,
     &               RBID,P,RP,RPRIM,AIREP,RBID,RBID)

         EPLAST = AIREP
        ENDIF

C ---  AFFECTATION A OMEGA QUI EST L'ENERGIE TOTALE
C ---  DE LA CONTRIBUTION AU POINT D'INTEGRATION DE L'ENERGIE
C ---  ELASTIQUE ET DE L'ENERGIE PLASTIQUE :

       OMEGA = OMEGA + ENELAS + EPLAST

C ---  TRAITEMENT DE L'OPTION ENER_TOTALE :

       IF (OPTION.EQ.'ENER_TOTALE') THEN

          IF( (COMPOR(1)(1:9) .NE.'VMIS_ISOT').AND.
     &      (  COMPOR(1)(1:4).NE.'ELAS')) THEN

C ---       TENSEUR DES CONTRAINTES AU POINT D'INTEGRATION PRECEDENT
C           ON LE CALCULE SEULEMENT DANS LE CAS DE LOI DE COMPORTEMENT
C           NI VMIS_ISOT_ NI ELAS

            IF (IDCONM.NE.0) THEN
               DO 25 I = 1, NBSIG
                   SIGMM(I) = ZR(IDSIGM+(IGAU-1)*NBSIG+I-1)
  25           CONTINUE
            ENDIF

C ---       TENSEUR DES DEFORMATIONS AU POINT D'INTEGRATION COURANT
C           ON LE CALCULE SEULEMENT DANS LE CAS DE LOI DE COMPORTEMENT
C           NI VMIS_ISOT_ NI ELAS

            DO 30 I=1,NBSIG
               EPSI(I)= EPSS(I+(IGAU-1)*NBSIG)
  30       CONTINUE

C ---      TENSEUR DES DEFORMATIONS AU POINT D'INTEGRATION PRECEDENT
C          ON LE CALCULE SEULEMENT DANS LE CAS DE LOI DE COMPORTEMENT
C          NI VMIS_ISOT_ NI ELAS

           IF (IDEPLM.NE.0) THEN
              DO 35 I = 1, NBSIG
                  EPSIM(I) = EPSSM(I+(IGAU-1)*NBSIG)
  35          CONTINUE
            ENDIF

            IF ((IDCONM.NE.0).AND.(IDEPLM.NE.0))THEN
               DO 50 I=1,NBSIG
                  DELTA(I)=EPSI(I)-EPSIM(I)
 50           CONTINUE

C---          CALCUL DES TERMES A SOMMER

              INTEG1=SIGMM(1)*DELTA(1)+SIGMM(2)*DELTA(2)+
     &               SIGMM(3)*DELTA(3)+2.0D0*SIGMM(4)*DELTA(4)
              INTEG2=SIGMA(1)*DELTA(1)+SIGMA(2)*DELTA(2)+
     &               SIGMA(3)*DELTA(3)+2.0D0*SIGMA(4)*DELTA(4)
              INTEG=UNDEMI*(INTEG1+INTEG2)*POIDS

            ELSE

C---          CAS OU LE NUMERO D ORDRE EST UN

              INTEG= SIGMA(1)*EPSI(1)+SIGMA(2)*EPSI(2)+
     &               SIGMA(3)*EPSI(3)+2.0D0*SIGMA(4)*EPSI(4)
              INTEG=UNDEMI*INTEG*POIDS
            ENDIF

            WTOTAL=WTOTAL+INTEG

          ELSE

            WTOTAL = WTOTAL + (ENELAS + EPLAST)*POIDS

          ENDIF

C  ===============================================
C  = FIN TRAITEMENT DE L'OPTION ENER_TOTALE      =
C  ===============================================

          GOTO 10

       ENDIF

C---------------------------------------------------------
C   CACUL DU TERME PSI REPRESENTANT L'ENERGIE ELASTIQUE  -
C   NON-LINEAIRE TOTALE ASSOCIEE A LA COURBE DE TRACTION -
C---------------------------------------------------------

C --- COEFFICIENTS DU MATERIAU ( DE LAME : MU ET MODULE DE
C --- COMPRESSIBILITE : K) :

        DEUXMU = E/(UN+NU)
        K      = UNTIER*E/(UN - DEUX*NU)

        EPLAST = ZERO
        P      = ZERO


C  -- DEFORMATION THERMIQUE AU POINT D'INTEGRATION COURANT :

        CALL VERIFT(FAMI,IGAU,1,'+',ZI(IMATE),'ELAS',1,EPSTHE,IRET)


C --- TRAITEMENT DU CAS CONTRAINTES PLANES :

        IF (LTEATT(' ','C_PLAN','OUI')) THEN

C --- CALCUL DE LA COMPOSANTE EPSZZ DE LA DEFORMATION TOTALE
C --- EN ECRIVANT EPSZZ = EPSZZ_ELAS   + EPSZZ_PLAS
C --- SOIT        EPSZZ = D-1*SIGMA(3) - EPSXX_PLAS - EPSYY_PLAS:

        C1     = (UN + NU)/E
        C2     =  NU/E
             TRSIG = SIGMA(1) + SIGMA(2)
         EPSEL(1) = C1*SIGMA(1) - C2*TRSIG
         EPSEL(2) = C1*SIGMA(2) - C2*TRSIG
         EPSEL(3) =             - C2*TRSIG

         EPSM(3+(IGAU-1)*NBSIG)= EPSEL(3) + EPSTHE
     &                       - EPSM(1+(IGAU-1)*NBSIG) + EPSEL(1)
     &                       - EPSM(2+(IGAU-1)*NBSIG) + EPSEL(2)
        ENDIF

C --- CALCUL DE LA DILATATION VOLUMIQUE AU POINT D'INTEGRATION COURANT:

        TREPSM =  EPSM(1+(IGAU-1)*NBSIG)
     &        + EPSM(2+(IGAU-1)*NBSIG)
     &        + EPSM(3+(IGAU-1)*NBSIG)

C --- CALCUL DU DEVIATEUR DES DEFORMATIONS AU POINT D'INTEGRATION
C --- COURANT :

        EPSDV(1) =  EPSM(1+(IGAU-1)*NBSIG) - UNTIER*TREPSM
        EPSDV(2) =  EPSM(2+(IGAU-1)*NBSIG) - UNTIER*TREPSM
        EPSDV(3) =  EPSM(3+(IGAU-1)*NBSIG) - UNTIER*TREPSM
        EPSDV(4) =  EPSM(4+(IGAU-1)*NBSIG)

C --- CALCUL DE LA DEFORMATION ELASTIQUE EQUIVALENTE AU
C --- POINT D'INTEGRATION COURANT :

        EPSEQ = SQRT(TROIS/DEUX*
     &        (EPSDV(1)*EPSDV(1) +      EPSDV(2)*EPSDV(2)
     &       + EPSDV(3)*EPSDV(3) + DEUX*EPSDV(4)*EPSDV(4)))

C --- CALCUL DE LA CONTRAINTE ELASTIQUE EQUIVALENTE AU
C --- POINT D'INTEGRATION COURANT :

        SIGEQ = DEUXMU*EPSEQ

C --- PARTIE SPHERIQUE DE L'ENERGIE DE DEFORMATION ELASTIQUE :

        ENELSP = UNDEMI*K*TREPSM*TREPSM

C --- TRAITEMENT DU CAS DE L'ECROUISSAGE LINEAIRE ISOTROPE :

        IF (COMPOR(1).EQ.'VMIS_ISOT_LINE') THEN

C --- RECUPERATION DE LA LIMITE D'ELASTICITE SY
C --- ET DE LA PENTE DE LA COURBE DE TRACTION D_SIGM_EPSI :

         NOMRES(1) = 'D_SIGM_EPSI'
         NOMRES(2) = 'SY'

         CALL RCVALB(FAMI,IGAU,1,'+',ZI(IMATE),' ','ECRO_LINE',
     &               0,' ',0.D0,2,NOMRES,VALRES,ICODRE,2)

         DSDE  = VALRES(1)
         SIGY  = VALRES(2)

C --- PENTE DE LA COURBE DE TRACTION DANS LE DIAGRAMME 'REDRESSE' :

         RPRIM = E*DSDE/(E-DSDE)

C --- DEFORMATION NON-LINEAIRE CUMULEE EQUIVALENTE :

         P  = (SIGEQ - SIGY)/(RPRIM + TROIS/DEUX*DEUXMU)
         IF (P.LE.R8PREM()) P = ZERO

C --- CONTRAINTE UNIAXIALE SUR LA COURBE DE TRACTION :

         RP  = SIGY + RPRIM*P

C ---  TRAVAIL ELASTIQUE NON-LINEAIRE 'EQUIVALENT' :

         EPLAST = UNDEMI*(SIGY+RP)*P

C ---  TRAITEMENT DU CAS DE L'ECROUISSAGE NON-LINEAIRE ISOTROPE :

        ELSEIF (COMPOR(1).EQ.'VMIS_ISOT_TRAC') THEN

C ---  RECUPERATION DE LA COURBE DE TRACTION :

         CALL RCTRAC(ZI(IMATE),1,'SIGM', TEMPG,
     &             JPROL, JVALE, NBVAL, E)

C --- CALCUL DE LA LIMITE ELASTIQUE SIGY :

         CALL RCFONC('S',1,JPROL,JVALE,NBVAL,SIGY,
     &              RBID,RBID,RBID,RBID,RBID,RBID,RBID,RBID)

         IF (SIGEQ.GE.SIGY) THEN

C --- CALCUL DU TRAVAIL ELASTIQUE NON-LINEAIRE ET DE LA
C --- CONTRAINTE EQUIVALENTE :

          CALL RCFONC('E',1,JPROL,JVALE,NBVAL,RBID,
     &               E,NU,ZERO,RP,RPRIM,AIREP,SIGEQ,P)

C --- TRAVAIL ELASTIQUE NON-LINEAIRE 'EQUIVALENT' :

          EPLAST = AIREP
         ENDIF
        ELSE
         CALL U2MESS('F','ELEMENTS4_2')
        ENDIF

C --- PARTIE DEVIATORIQUE DE L'ENERGIE DE DEFORMATION ELASTIQUE
C --- TOTALE 'EQUIVALENTE' (I.E. ASSOCIEE A LA COURBE DE
C --- TRACTION SI ON CONSIDERAIT LE MATERIAU ELASTIQUE
C --- NON-LINEAIRE :

        IF (P.LE.R8PREM()) THEN
         ENELDV = EPSEQ*EPSEQ*DEUXMU/TROIS
        ELSE
         ENELDV = RP*RP/DEUXMU/TROIS
        ENDIF

C --- ENERGIE DE DEFORMATION ELASTIQUE TOTALE AU POINT
C --- D'INTEGRATION COURANT :

        ENELTO = ENELSP + ENELDV + EPLAST

C --- AFFECTATION A PSI QUI EST L'ENERGIE ELASTIQUE TOTALE
C --- DE LA CONTRIBUTION AU POINT D'INTEGRATION DE CETTE ENERGIE :

        PSI = PSI + ENELTO

C --- VOLUME DE L'ELEMENT :

        VOLUME = VOLUME + POIDS

C --- INDICATEUR GLOBAL ENERGETIQUE (NON NORMALISE) :

        IF (OMEGA.GE.1D04*R8PREM()) THEN
         IF (PSI.LT.OMEGA) THEN
          INDIGL = INDIGL + (UN - PSI/OMEGA)*POIDS
         ENDIF
        ENDIF

  10   CONTINUE

C ----   RECUPERATION ET AFFECTATION DES GRANDEURS EN SORTIE
C ----   AVEC RESPECTIVEMENT LA VALEUR DE L'INDICATEUR GLOBAL SUR
C ----   L'ELEMENT ET LE VOLUME DE L'ELEMENT POUR L'OPTION
C ----   INDIC_ENER
C ----   AFFECTATION DE L'ENERGIE DE DEFORMATION ELASTIQUE
C ----   ET DE L'ENERGIE DE DEFORMATION TOTALE RESPECTIVEMENT
C ----   POUR LES OPTIONS ENEL_ELEM ET ENER_TOTALE :

       IF (OPTION.EQ.'INDIC_ENER') THEN
        CALL JEVECH('PENERD1','E',IDENE1)
        ZR(IDENE1) = INDIGL
        CALL JEVECH('PENERD2','E',IDENE2)
        ZR(IDENE2) = VOLUME
       ELSEIF (OPTION.EQ.'ENEL_ELEM') THEN
        CALL JEVECH('PENERD1','E',IDENE1)
        ZR(IDENE1) = WELAS
       ELSEIF (OPTION.EQ.'ENER_TOTALE') THEN
        CALL JEVECH('PENERD1','E',IDENE1)
        ZR(IDENE1) = WTOTAL
       ENDIF

C  ===========================
C  =                         =
C  = OPTION   "INDIC_SEUIL"  =
C  =                         =
C  ===========================

      ELSEIF (OPTION.EQ.'INDIC_SEUIL') THEN

C --- BOUCLE SUR LES POINTS D'INTEGRATION

       DO 60 IGAU = 1, NPG



C --- RECUPERATION DES CARACTERISTIQUES DU MATERIAU :

        NOMRES(1) = 'E'
        NOMRES(2) = 'NU'

        CALL RCVALB(FAMI,IGAU,1,'+',ZI(IMATE),' ','ELAS',
     &              0,' ',0.D0,2,NOMRES,VALRES,ICODRE,2)

        E     = VALRES(1)
        NU    = VALRES(2)

C --- TENSEUR DES CONTRAINTES AU POINT D'INTEGRATION COURANT :

        DO 70 I = 1, NBSIG
         SIGMA(I) = ZR(IDSIG+(IGAU-1)*NBSIG+I-1)
  70    CONTINUE

C --- CALCUL DES DEFORMATIONS ELASTIQUES AU POINT
C --- D'INTEGRATION COURANT EN CONSIDERANT LE MATERIAU ISOTROPE :
C --- EPS_ELAS    = 1/D*SIGMA
C ---             = ((1+NU)/E)*SIGMA-(NU/E)*TRACE(SIGMA) :

        C1     = (UN + NU)/E
        C2     =  NU/E

C --- CAS DES CONTRAINTES PLANES :

        IF (LTEATT(' ','C_PLAN','OUI')) THEN
         TRSIG  = SIGMA(1) + SIGMA(2)
         EPSEL(1) = C1*SIGMA(1)-C2*TRSIG
         EPSEL(2) = C1*SIGMA(2)-C2*TRSIG
         EPSEL(3) =            -C2*TRSIG
         EPSEL(4) = C1*SIGMA(4)

C --- CAS AXI ET DEFORMATIONS PLANES :

        ELSE
         TRSIG  = SIGMA(1) + SIGMA(2) + SIGMA(3)
         EPSEL(1) = C1*SIGMA(1)-C2*TRSIG
         EPSEL(2) = C1*SIGMA(2)-C2*TRSIG
         EPSEL(3) = C1*SIGMA(3)-C2*TRSIG
         EPSEL(4) = C1*SIGMA(4)
        ENDIF

C --- CALCUL DES DEFORMATIONS PLASTIQUES AU POINT
C --- D'INTEGRATION COURANT
C --- EPS_PLAST = EPS_TOT - EPS_ELAS - EPSTH :
C --- EPS_PLAST = EPS_HORS_THERMIQUE - EPS_ELAS  :

        EPSPLA(1) = EPSM(1+(IGAU-1)*NBSIG) - EPSEL(1)
        EPSPLA(2) = EPSM(2+(IGAU-1)*NBSIG) - EPSEL(2)
        EPSPLA(3) = EPSM(3+(IGAU-1)*NBSIG) - EPSEL(3)
        EPSPLA(4) = EPSM(4+(IGAU-1)*NBSIG) - EPSEL(4)

C --- CAS DE L'ECROUISSAGE CINEMATIQUE :
C --- LE TENSEUR A PRENDRE EN CONSIDERATION POUR LE CALCUL
C --- DU TRAVAIL PLASTIQUE EST SIGMA - X OU X EST LE TENSEUR DE RAPPEL :

        IF (COMPOR(1).EQ.'VMIS_CINE_LINE') THEN
         NBSIG2 = 7
         CALL ASSERT(IDVARI.NE.1)
         DO 75 I = 1, NBSIG
          X(I) = ZR(IDVARI+(IGAU-1)*NBSIG2+I-1)
  75     CONTINUE
         DO 80 I = 1, NBSIG
          SIGMA(I) = SIGMA(I) - X(I)
  80     CONTINUE
        ENDIF

C --- CALCUL DU TRAVAIL PLASTIQUE AU POINT D'INTEGRATION COURANT :

        EPLAST =  SIGMA(1)*EPSPLA(1) + SIGMA(2)*EPSPLA(2)
     &        + SIGMA(3)*EPSPLA(3) + DEUX*SIGMA(4)*EPSPLA(4)
C VALEUR ABSOLUE DU TRAVAIL PLASTIQUE
         EPLAST=ABS(EPLAST)
C --- CALCUL DU TRAVAIL PLASTIQUE EQUIVALENT AU POINT
C --- D'INTEGRATION COURANT :

C --- TRAITEMENT DU CAS DE L'ECROUISSAGE LINEAIRE  :

        IF (COMPOR(1).EQ.'VMIS_ISOT_LINE'.OR.
     &     COMPOR(1).EQ.'VMIS_CINE_LINE'    ) THEN

C --- RECUPERATION DE LA LIMITE D'ELASTICITE SY
C --- ET DE LA PENTE DE LA COURBE DE TRACTION D_SIGM_EPSI :

         NOMRES(1) = 'D_SIGM_EPSI'
         NOMRES(2) = 'SY'
         CALL RCVALB(FAMI,IGAU,1,'+',ZI(IMATE),' ','ECRO_LINE',
     &               0,' ',0.D0,2,NOMRES,VALRES,ICODRE,2)

         DSDE  = VALRES(1)
         SIGY  = VALRES(2)

C --- CALCUL DE LA DEFORMATION PLASTIQUE EQUIVALENTE :

         EPSEQ = SQRT(TROIS/DEUX*(EPSPLA(1)*EPSPLA(1)
     &                  +        EPSPLA(2)*EPSPLA(2)
     &                  +        EPSPLA(3)*EPSPLA(3)
     &                  +  DEUX* EPSPLA(4)*EPSPLA(4)))

C --- DEFORMATION PLASTIQUE CUMULEE :

C --- (TEMPORAIRE POUR L'ECROUISSAGE CINEMATIQUE)
         IF (COMPOR(1).EQ.'VMIS_CINE_LINE') THEN
          P = EPSEQ
         ELSEIF (COMPOR(1).EQ.'VMIS_ISOT_LINE') THEN
          P = ZR(IDVARI+(IGAU-1)*NBVARI+1-1)
         ENDIF

C --- PENTE DE LA COURBE DE TRACTION DANS LE DIAGRAMME 'REDRESSE' :

         RPRIM = E*DSDE/(E-DSDE)

C --- CONTRAINTE UNIAXIALE SUR LA COURBE DE TRACTION :

         RP  = SIGY + RPRIM*P

C --- TRAVAIL PLASTIQUE 'EQUIVALENT' :

         EPLAEQ = RP*P

C --- TRAITEMENT DU CAS DE L'ECROUISSAGE NON-LINEAIRE ISOTROPE :

        ELSEIF (COMPOR(1).EQ.'VMIS_ISOT_TRAC') THEN

C --- RECUPERATION DE LA COURBE DE TRACTION :

         CALL RCVARC(' ','TEMP','+',FAMI,IGAU,1,TEMPG,IRET1)
         CALL RCTRAC(ZI(IMATE),1,'SIGM', TEMPG,
     &              JPROL, JVALE, NBVAL, E)

C --- RECUPERATION DE LA DEFORMATION PLASTIQUE CUMULEE :

         P  = ZR(IDVARI+(IGAU-1)*NBVARI+1-1)

C --- TRAVAIL PLASTIQUE 'EQUIVALENT' :

         CALL RCFONC('V',1,JPROL,JVALE,NBVAL,RBID,
     &               RBID,RBID,P,RP,RPRIM,AIREP,RBID,RBID)

         EPLAEQ = RP*P
        ELSE
         CALL U2MESS('F','ELEMENTS4_3')
        ENDIF

C --- CALCUL DU JACOBIEN AU POINT D'INTEGRATION COURANT :

        CALL NMGEOM(2,NNO,AXI,GRAND,ZR(IGEOM),IGAU,
     &              IPOIDS,IVF,IDFDE,ZR(IDEPL),.TRUE.,POIDS,TRAV,F,EPS,R
     &)

C --- VOLUME DE L'ELEMENT :

        VOLUME = VOLUME + POIDS

C --- INDICATEUR GLOBAL ENERGETIQUE (NON NORMALISE) :

        IF (EPLAEQ.GE.1D04*R8PREM()) THEN
         INDIGL = INDIGL + (UN - EPLAST/EPLAEQ)*POIDS
        ENDIF

  60   CONTINUE

C ---- RECUPERATION ET AFFECTATION DES GRANDEURS EN SORTIE
C ---- AVEC RESPECTIVEMENT LA VALEUR DE L'INDICATEUR GLOBAL SUR
C ---- L'ELEMENT ET LE VOLUME DE L'ELEMENT :

       CALL JEVECH('PENERD1','E',IDENE1)
       ZR(IDENE1) = INDIGL
       CALL JEVECH('PENERD2','E',IDENE2)
       ZR(IDENE2) = VOLUME

      ENDIF

      END
