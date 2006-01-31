      SUBROUTINE RECHCO(PREMIE,LREAC,NZOCO,NSYME,INST,NOMA,NEWGEO,
     &                  DEFICO,RESOCO)
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 31/01/2006   AUTEUR CIBHHLV L.VIVAN 
C RESPONSABLE MABBAS M.ABBAS
C ======================================================================
C COPYRIGHT (C) 1991 - 2001  EDF R&D                  WWW.CODE-ASTER.ORG
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
C
      IMPLICIT NONE
      LOGICAL PREMIE
      LOGICAL LREAC
      INTEGER NZOCO
      INTEGER NSYME
      REAL*8 INST
      CHARACTER*8 NOMA
      CHARACTER*24 NEWGEO
      CHARACTER*24 DEFICO
      CHARACTER*24 RESOCO
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : CFGEOM
C ----------------------------------------------------------------------
C
C LISTE DES NOEUDS ESCLAVES COURANTS. RECHERCHE DE LA MAILLE (OU DU
C NOEUD) MAITRE ASSOCIEE A CHAQUE NOEUD ESCLAVE.
C
C IN  PREMIE : VAUT .TRUE. SI C'EST LE PREMIER CALCUL (PAS DE PASSE)
C IN  LREAC  : VAUT .TRUE. SI REACTUALISATION GEOMETRIQUE
C IN  NZOCO  : NOMBRE DE ZONES DE CONTACT
C IN  NSYME  : NOMBRE DE ZONES DE CONTACT SYMETRIQUES
C IN  INST   : VALEUR DE L'INSTANT DE CALCUL
C IN  NOMA   : NOM DU MAILLAGE
C IN  NEWGEO : GEOMETRIE ACTUALISEE EN TENANT COMPTE DU CHAMP DE
C              DEPLACEMENTS COURANT
C IN  DEFICO : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
C VAR RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
C
C REMARQUE IMPORTANTE
C -------------------
C
C ON DOIT PRENDRE EN COMPTE UN EVENTUEL JEU FICTIF INTRODUIT
C PAR L'UTILISATEUR SOUS LES MOTS-CLES DIST_1 ET DIST_2, ET RANGE
C DANS LE TABLEAU JEUSUP : CE JEU DEVRA ETRE SOUSTRAIT AU VRAI JEU.
C ON MET PREALABLEMENT LE TABLEAU APJEU A ZERO POUR TOUS LES NOEUDS
C ESCLAVES POTENTIELS (NESMAX).
C
C * POUR LES ZONES SANS REACTUALISATION DE L'APPARIEMENT, ON AFFECTE
C   AU TABLEAU APJEU LA VALEUR DE JEUSUP POUR LA ZONE
C   A TOUS LES NOEUDS ESCLAVES (EN NOMBRE CONNU PUISQUE INCHANGE).
C   ON PASSERA ENSUITE DANS LES ROUTINES RECHNO ET CHMANO
C   (APPELEES PAR PROJCO) OU L'ON SOUSTRAIT (DANS RECHNO, SEULEMENT SI
C   PHASE='FINALE', C'EST-A-DIRE APPARIEMENT NODAL) CETTE VALEUR A LA
C   DISTANCE TROUVEE ENTRE LE NOEUD ESCLAVE ET LA MAILLE MAITRE.
C
C * POUR LES ZONES AVEC REACTUALISATION DE L'APPARIEMENT, ON NE CONNAIT
C   PAS A PRIORI LE NOMBRE DE NOEUDS ESCLAVES. DANS RECHNO ET CHMANO,
C   LA PARTIE D'APJEU UTILE VAUT 0, AUQUEL ON RAJOUTE LA DISTANCE
C   NOEUD-MAILLE. ENSUITE (ON CONNAIT DES LORS LE NOMBRE DE NOEUDS
C   ESCLAVES DE LA ZONE), ON SOUSTRAIT A CE JEU REEL LE JEU FICTIF
C   JEUSUP DE LA ZONE. ON NE REPASSERA PAS DANS PROJCO PUISQUE
C   L'APPARIEMENT A CHANGE (LA PROJECTION ET LE CALCUL DU JEU ONT ETE
C   FAITS DANS RECHCO).
C
C
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER ZMETH
      PARAMETER (ZMETH = 8)
      INTEGER ZREAC
      PARAMETER (ZREAC = 4)
      INTEGER ZAPPAR
      PARAMETER (ZAPPAR = 3)
      INTEGER NESOLD(NZOCO),IOLD(NZOCO)
      INTEGER NDIM,NESMAX,NESCL,NNOCO
      INTEGER IBID,K,IZONE,IESCL,IESCL0
      INTEGER REAAPP,REACTU,APPAR
      REAL*8       R8BID,DIST3,DIST4
      INTEGER      POSNOE,TYPALF
      INTEGER      JOLDAP,JOLDPT
      INTEGER      JCOOR
      CHARACTER*24 APDDL,APJEU,APMEMO,APPARI,APPOIN,COMAFO,CONTNO
      INTEGER      JAPDDL,JAPJEU,JAPMEM,JAPPAR,JAPPTR,JCOMA,JNOCO
      CHARACTER*24 APREAC,CARACF,FROTE,JEUFO1,JEUFO2,JEUFO3
      INTEGER      JREAC,JCMCF,JFRO,JJFO1,JJFO2,JJFO3
      CHARACTER*24 JEUSUP,METHCO,JEUINI,PENAL,JEUPOU
      INTEGER      JJSUP,JMETH,JDIM,JPENA,JJPOU
      CHARACTER*24 NDIMCO,APJEFX,APJEFY,APCOEF
      CHARACTER*8  K8BID
      INTEGER      IFM,NIV
C
C
C ----------------------------------------------------------------------
C
      CALL INFNIV(IFM,NIV)
      CALL JEMARQ
C
C --- INFOS SUR LA CHARGE DE CONTACT
C
      CALL CFDISC(DEFICO,'              ',IBID,TYPALF,IBID,IBID)
C
C ======================================================================
C                      RECUPERATION D'ADRESSES
C ======================================================================
C
C --- LECTURE DES SD POUR LE CONTACT POTENTIEL
C
      APCOEF = RESOCO(1:14) // '.APCOEF'
      APDDL  = RESOCO(1:14) // '.APDDL'
      APJEFX = RESOCO(1:14) // '.APJEFX'
      APJEFY = RESOCO(1:14) // '.APJEFY'
      APJEU  = RESOCO(1:14) // '.APJEU'
      APMEMO = RESOCO(1:14) // '.APMEMO'
      APPARI = RESOCO(1:14) // '.APPARI'
      APPOIN = RESOCO(1:14) // '.APPOIN'
      APREAC = RESOCO(1:14) // '.APREAC'
      CARACF = DEFICO(1:16) // '.CARACF'
      COMAFO = DEFICO(1:16) // '.COMAFO'
      CONTNO = DEFICO(1:16) // '.NOEUCO'
      FROTE  = DEFICO(1:16) // '.FROTE'
      JEUFO1 = DEFICO(1:16) // '.JFO1CO'
      JEUFO2 = DEFICO(1:16) // '.JFO2CO'
      JEUFO3 = DEFICO(1:16) // '.JFO3CO'
      JEUINI = RESOCO(1:14) // '.JEUINI'
      JEUSUP = DEFICO(1:16) // '.JSUPCO'
      METHCO = DEFICO(1:16) // '.METHCO'
      NDIMCO = DEFICO(1:16) // '.NDIMCO'
      PENAL  = DEFICO(1:16) // '.PENAL'
      JEUPOU = DEFICO(1:16) // '.JEUPOU'
C
      CALL JEVEUO(APDDL,'E',JAPDDL)
      CALL JEVEUO(APJEU,'E',JAPJEU)
      CALL JEVEUO(APMEMO,'L',JAPMEM)
      CALL JEVEUO(APPARI,'E',JAPPAR)
      CALL JEVEUO(APPOIN,'E',JAPPTR)
      CALL JEVEUO(APREAC,'E',JREAC)
      CALL JEVEUO(CARACF,'L',JCMCF)
      CALL JEVEUO(COMAFO,'E',JCOMA)
      CALL JEVEUO(CONTNO,'L',JNOCO)
      CALL JEVEUO(FROTE,'E',JFRO)
      CALL JEVEUO(JEUFO1,'L',JJFO1)
      CALL JEVEUO(JEUFO2,'L',JJFO2)
      CALL JEVEUO(JEUFO3,'L',JJFO3)
      CALL JEVEUO(JEUSUP,'E',JJSUP)
      CALL JEVEUO(METHCO,'L',JMETH)
      CALL JEVEUO(NDIMCO,'E',JDIM)
      CALL JEVEUO(PENAL,'E',JPENA)
      CALL JEVEUO (JEUPOU,'L',JJPOU)
C
      NDIM   = ZI(JDIM)
      NNOCO  = ZI(JDIM+4)
      NESMAX = ZI(JDIM+8)
C
C --- COORDONNEES DES NOEUDS DU MAILLAGE
C
      CALL JEVEUO(NEWGEO(1:19)//'.VALE','L',JCOOR)
C
C --- ACTUALISATION DES NORMALES POUR LES NOEUDS POTENTIELS DE CONTACT
C
      CALL CFNORM(NDIM,NNOCO,NOMA,NEWGEO,RESOCO,DEFICO)
C
C ----------------------------------------------------------------------
C --- SAUVEGARDE DE RESULTATS DU PASSE SI ON N'EST PAS AU 1ER CALCUL
C ----------------------------------------------------------------------
C
C
      IF (.NOT. PREMIE) THEN
        IF (NIV .GE. 2) THEN
          WRITE (IFM,*) ' <CONTACT> <> APPARIEMENT - SAUVEGARDE DONNEES'
        END IF
C
        NESCL = ZI(JAPPAR)
C
C - RECOPIE DANS DES TABLEAUX DE TRAVAIL DE APPARI ET APPOIN
C
        CALL WKVECT('&&RECHCO.APPARI','V V I',3*NESCL+1,JOLDAP)
        CALL WKVECT('&&RECHCO.APPOIN','V V I',NESCL+1,JOLDPT)
C
        DO 5 K = 1,3*NESCL+1
          ZI(JOLDAP+K-1) = ZI(JAPPAR+K-1)
 5      CONTINUE
        DO 6 K = 0,NESCL
          ZI(JOLDPT+K) = ZI(JAPPTR+K)
 6      CONTINUE
C
C --- STOCKAGE DU NOMBRE DE NOEUDS ESCLAVES ET DU DECALAGE DES ADRESSES
C --- DE DEBUT DANS L'ANCIENNE CONFIGURATION
C
        IOLD(1) = 0
        DO 7 IZONE = 1,NZOCO
          NESOLD(IZONE) = ZI(JDIM+8+IZONE)
          IF (IZONE .GE. 2) THEN
            IOLD(IZONE) = IOLD(IZONE-1) + ZI(JDIM+8+IZONE-1)
          END IF
 7      CONTINUE
      END IF
C
C ======================================================================
C                           APPARIEMENT
C ======================================================================
C
      IESCL = 0
      ZI(JAPPTR) = 0
C
C --- MISE A ZERO DU JEU
C
      DO 8 K = 1,NESMAX
        ZR(JAPJEU+K-1) = 0.D0
 8    CONTINUE
C
      DO 10 IZONE = 1,NZOCO
C
C --- REACTUALISATIONS A FAIRE
C
        IF (.NOT. LREAC) THEN
          REAAPP = 0
        ELSE
          REAAPP = ZI(JREAC+ZREAC*(IZONE-1))
        END IF
C
C ----------------------------------------------------------------------
C     SI PAS DE REACTUALISATION DE L'APPARIEMENT POUR CETTE ZONE
C ----------------------------------------------------------------------
C
        IF (REAAPP .EQ. 0) THEN
C
          IF (NIV .GE. 2) THEN
            WRITE (IFM,1000) IZONE, ' - PAS DE REACTUALISATION '
          END IF
C
C --- INCREMENTATION DU COMPTEUR D'APPARIEMENT FIXE POUR LA ZONE
C
          ZI(JREAC+ZREAC*(IZONE-1)+1) = ZI(JREAC+ZREAC*(IZONE-1)+1) + 1
C
C --- RECOPIE DES MORCEAUX ENCORE VALABLES DES TABLEAUX 
C
          DO 40 K = 1,NESOLD(IZONE)
            ZI(JAPPAR+3*(IESCL+K-1)+1) =
     &        ZI(JOLDAP+3*(IOLD(IZONE)+K-1)+1)
            ZI(JAPPAR+3*(IESCL+K-1)+2) =
     &        ZI(JOLDAP+3*(IOLD(IZONE)+K-1)+2)
            ZI(JAPPAR+3*(IESCL+K-1)+3) = ZI(JREAC+4*(IZONE-1)+2)
            ZI(JAPPTR+IESCL+K) = ZI(JOLDPT+IOLD(IZONE)+K)
 40       CONTINUE
C
C --- INCREMENTATION DU NOMBRE DE NOEUDS ESCLAVES
C
          IESCL = IESCL + NESOLD(IZONE)
C
C --- PASSAGE A LA ZONE SUIVANTE
C
          GOTO 10
C
         END IF
C
C ----------------------------------------------------------------------
C         SI REACTUALISATION DE L'APPARIEMENT POUR CETTE ZONE
C     OU PASSAGE INITIAL POUR REMPLIR LES SD (CAS SANS APPARIEMENT)
C ----------------------------------------------------------------------
C
C
C --- DEBUT DU STOCKAGE DES INFOS SUR LES NOEUDS ESCLAVES 
C --- POUR LA ZONE COURANTE
C
        IESCL0 = IESCL
C
C --- COMPTEUR D'APPARIEMENT FIXE NUL POUR LA ZONE
C
        ZI(JREAC+ZREAC*(IZONE-1)+1) = 0
C
C --- DETERMINATION DES CARACTERISTIQUES DE LA REACTUALISATION
C
        REACTU = ZI(JREAC+ZREAC*(IZONE-1)+2)
C
C --- TYPE D'APPARIEMENT
C
        APPAR = ZI(JMETH+ZMETH*(IZONE-1)+1)
C
C --- APPEL DE LA METHODE D'APPARIEMENT
C
C
        IF (APPAR .EQ. -1) THEN
C
          CALL RECHPA(IZONE,REACTU,NEWGEO,DEFICO,RESOCO,IESCL)
C
        ELSEIF ((APPAR.EQ.0) .OR. (APPAR.EQ.4)) THEN
C
          CALL RECHNO(IZONE,REAAPP,REACTU,NEWGEO,DEFICO,RESOCO,IESCL)
C
        ELSEIF (APPAR .EQ. 1) THEN
C
C
          CALL RECHME(IZONE,REAAPP,REACTU,NZOCO,NSYME,NOMA,NEWGEO,
     &                DEFICO,RESOCO,IESCL)
C
        ELSEIF (APPAR .EQ. 2) THEN
C
          CALL UTMESS('F','RECHCO',
     &               'L''APPARIEMENT PAR LA METHODE'//
     &               ' DES TERRITOIRES N''EST PAS OPERATIONNEL')
C
        ELSEIF (APPAR .EQ. 3) THEN
C
          CALL UTMESS('F','RECHCO',
     &               'L''APPARIEMENT PAR LA METHODE'//
     &               ' HIERARCHIQUE N''EST PAS OPERATIONNEL')
C
         END IF
C
        DO 60 K = IESCL0+1,IESCL
C
C --- CALCUL DU JEU FICTIF DE LA ZONE
C
          POSNOE = ZI(JAPPAR+ZAPPAR*(K-1)+1)
          DIST3 = 0.D0
          DIST4 = 0.D0
          CALL CFDIST(IZONE,POSNOE,INST,JNOCO,JCOOR,JJFO1,JJFO2,JJFO3,
     &                JJSUP,JJPOU,NNOCO,DIST3,DIST4)
C
C --- ADDITION DU JEU FICTIF DE LA ZONE DANS APJEU
C
          ZR(JAPJEU+K-1) = ZR(JAPJEU+K-1) - ZR(JJSUP+IZONE-1) - DIST4
C
C --- CARACTERISTIQUES DU FROTTEMENT POUR METHODES
C --- "PENALISATION" ET "LAGRANGIEN"
C
          ZR(JFRO-1+K) = ZR(JCMCF+10*(IZONE-1)+4)
          ZR(JPENA-1+2*K-1) = ZR(JCMCF+10*(IZONE-1)+2)
          ZR(JPENA-1+2*K) = ZR(JCMCF+10*(IZONE-1)+3)
          ZR(JCOMA-1+K) = ZR(JCMCF+10*(IZONE-1)+6)
 60     CONTINUE
C
C --- NOMBRE DE NOEUDS ESCLAVES DANS LA ZONE
C
        ZI(JDIM+8+IZONE) = IESCL - IESCL0
C
 10   CONTINUE
C
C --- STOCKAGE DES LONGUEURS EFFECTIVES
C
      NESCL = IESCL
      ZI(JAPPAR) = NESCL
      IF (NESCL .GT. NESMAX) THEN
        CALL UTMESS('F','RECHCO_04',
     &             'ERREUR DE DIMENSIONNEMENT : '//
     &             'NOMBRE MAXIMAL DE NOEUDS ESCLAVES')
      END IF
      IF (ZI(JAPPTR+NESCL) .GT. 30*NESMAX) THEN
        CALL UTMESS('F','RECHCO_05',
     &             'ERREUR DE DIMENSIONNEMENT '//
     &             'DES TABLEAUX APCOEF ET APDDL')
      END IF
      CALL JEECRA(APPARI,'LONUTI',3*NESCL+1,K8BID)
      CALL JEECRA(APPOIN,'LONUTI',NESCL+1,K8BID)
      CALL JEECRA(APJEU,'LONUTI',NESCL,K8BID)
      CALL JEECRA(JEUINI,'LONUTI',NESCL,K8BID)
      CALL JEECRA(APCOEF,'LONUTI',ZI(JAPPTR+NESCL),K8BID)
      CALL JEECRA(APDDL,'LONUTI',ZI(JAPPTR+NESCL),K8BID)
      IF (TYPALF .NE. 0) THEN
        CALL JEECRA(APJEFX,'LONUTI',NESCL,K8BID)
        CALL JEECRA(APJEFY,'LONUTI',NESCL,K8BID)
      END IF
C
C --- NETTOYAGE DES VECTEURS DE TRAVAIL
C
      CALL JEDETR('&&RECHCO.APPARI')
      CALL JEDETR('&&RECHCO.APPOIN')
C
C ----------------------------------------------------------------------
C
 1000 FORMAT (' <CONTACT> <> APPARIEMENT - ZONE: ',I6,A16)
C
      CALL JEDEMA
      END
