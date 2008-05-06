      SUBROUTINE PROMOR(NUZ,BASE)
      IMPLICIT NONE
      CHARACTER*(*) NUZ
      CHARACTER*1 BASE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ASSEMBLA  DATE 06/05/2008   AUTEUR PELLET J.PELLET 
C RESPONSABLE PELLET J.PELLET
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
C     CALCUL DE LA STRUCTURE COMPACTE D'UNE MATRICE
C     ------------------------------------------------------------------
C IN  K*14 NU     : NOM DE LA SD_UME_DDL A COMPLETER.
C OUT K*14 NU     : L'OBJET NU EST COMPLETE DES OBJETS .SMOS.XXXX
C IN  K1  BASE    : BASE DE CREATION DU STOCKAGE
C     ------------------------------------------------------------------

C     ------------------------------------------------------------------
      CHARACTER*32 JEXNUM,JEXATR
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      CHARACTER*8 ZK8,MA,MO,KBID,EXIELE,EXIVF
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C----------------------------------------------------------------------
      CHARACTER*14 NU
      LOGICAL LFETI
      CHARACTER*19 NOMLIG
      INTEGER IMAIL,J,ICONX1,ICONX2,ILI,IGREL,IADLIE,IEL,IADNEM
      INTEGER ZZCONX,ZZNBNE,ZZLIEL,ZZNGEL,ZZNSUP,ZZNELG,NUNOEL,L,IDPRN1
      INTEGER ZZNEMA,ZZPRNO,IDPRN2,IFM,NIV,IRET,IBID,IER,NNOE,NBEC,JNUEQ
      INTEGER VALI(2),NEQX,IILIB,IGR,NUMA,K1,N1,IAD1,NDDL1
      INTEGER IDDL,JDDL,IAMAIL,JSMHC,NCOEF,JSMDE,IGD,NBSS
      INTEGER IASSSA,IERD,IADEQU,NLILI,NEQU,IIMAX,JNOIP,JSUIV,MXDDLT
      INTEGER IMA,NDDLT,JALM,JSMDI,NEL,NEC,NBSMA,ITYPEL
      INTEGER NNOV,NUMAV,KVOIS

      CHARACTER*16 CODVOI,NOMTE
      INTEGER NVOIMA,NSCOMA,JREPE,JPTVOI,JELVOI,NBVOIS
      PARAMETER(NVOIMA=100,NSCOMA=4)
      INTEGER LIVOIS(1:NVOIMA),TYVOIS(1:NVOIMA),NBNOVO(1:NVOIMA)
      INTEGER NBSOCO(1:NVOIMA),LISOCO(1:NVOIMA,1:NSCOMA,1:2)

C-----------------------------------------------------------------------
C     FONCTIONS LOCALES D'ACCES AUX DIFFERENTS CHAMPS DES
C     S.D. MANIPULEES DANS LE SOUS PROGRAMME
C-----------------------------------------------------------------------
C---- FONCTION D ACCES AU CHAMP CONNEX DE LA S.D. MAILLA DE TYPE
C     MAILLAGE
C     ZZCONX(IMAIL,J) = NUMERO DANS LA NUMEROTATION DU MAILLAGE
C         DU NOEUD J DE LA MAILLE IMAIL
      ZZCONX(IMAIL,J)=ZI(ICONX1-1+ZI(ICONX2+IMAIL-1)+J-1)

C---- NBRE DE NOEUDS DE LA MAILLE IMAIL DU MAILLAGE

      ZZNBNE(IMAIL)=ZI(ICONX2+IMAIL)-ZI(ICONX2+IMAIL-1)

C---- FONCTION D ACCES AUX ELEMENTS DES CHAMPS LIEL DES S.D. LIGREL
C     REPERTORIEES DANS LE REPERTOIRE TEMPORAIRE .MATAS.LILI
C     ZZLIEL(ILI,IGREL,J) =
C      SI LA JIEME MAILLE DU LIEL IGREL DU LIGREL ILI EST:
C          -UNE MAILLE DU MAILLAGE : SON NUMERO DANS LE MAILLAGE
C          -UNE MAILLE TARDIVE : -POINTEUR DANS LE CHAMP .NEMA

      ZZLIEL(ILI,IGREL,J)=ZI(ZI(IADLIE+3*(ILI-1)+1)-1+
     &                    ZI(ZI(IADLIE+3*(ILI-1)+2)+IGREL-1)+J-1)

C---- NBRE DE GROUPES D'ELEMENTS (DE LIEL) DU LIGREL ILI

      ZZNGEL(ILI)=ZI(IADLIE+3*(ILI-1))

C---- NBRE DE NOEUDS DE LA MAILLE TARDIVE IEL ( .NEMA(IEL))
C     DU LIGREL ILI REPERTOIRE .LILI
C     (DIM DU VECTEUR D'ENTIERS .LILI(ILI).NEMA(IEL) )

      ZZNSUP(ILI,IEL)=ZI(ZI(IADNEM+3*(ILI-1)+2)+IEL)-
     &                ZI(ZI(IADNEM+3*(ILI-1)+2)+IEL-1)-1

C---- NBRE D ELEMENTS DU LIEL IGREL DU LIGREL ILI DU REPERTOIRE TEMP.
C     .MATAS.LILI(DIM DU VECTEUR D'ENTIERS .LILI(ILI).LIEL(IGREL) )

      ZZNELG(ILI,IGREL)=ZI(ZI(IADLIE+3*(ILI-1)+2)+IGREL)-
     &                  ZI(ZI(IADLIE+3*(ILI-1)+2)+IGREL-1)-1

C---- NBRE D ELEMENTS SUPPLEMENTAIRE (.NEMA) DU LIGREL ILI DU
C     REPERTOIRE TEMPORAIRE .MATAS.LILI


C---- FONCTION D ACCES AUX ELEMENTS DES CHAMPS NEMA DES S.D. LIGREL
C     REPERTORIEES DANS LE REPERTOIRE TEMPO. .MATAS.LILI

      ZZNEMA(ILI,IEL,J)=ZI(ZI(IADNEM+3*(ILI-1)+1)-1+
     &                  ZI(ZI(IADNEM+3*(ILI-1)+2)+IEL-1)+J-1)

C---- FONCTION D ACCES AUX ELEMENTS DES CHAMPS PRNO DES S.D. LIGREL
C     REPERTORIEES DANS NU.LILI DE LA S.D. NUME_DDL ET A LEURS ADRESSES
C     ZZPRNO(ILI,NUNOEL,1) = NUMERO DE L'EQUATION ASSOCIEES AU 1ER DDL
C                            DU NOEUD NUNOEL DANS LA NUMEROTATION LOCALE
C                            AU LIGREL ILI DE .LILI
C     ZZPRNO(ILI,NUNOEL,2) = NOMBRE DE DDL PORTES PAR LE NOEUD NUNOEL
C     ZZPRNO(ILI,NUNOEL,2+1) = 1ER CODE
C     ZZPRNO(ILI,NUNOEL,2+NEC) = NEC IEME CODE

      ZZPRNO(ILI,NUNOEL,L)=ZI(IDPRN1-1+ZI(IDPRN2+ILI-1)+
     &                     (NUNOEL-1)*(NEC+2)+L-1)
C----------------------------------------------------------------------

      CALL INFNIV(IFM,NIV)
      CALL JEMARQ()
      NU=NUZ

C     -- FETI OR NOT FETI ?
      CALL JEEXIN('&FETI.MAILLE.NUMSD',IRET)
      IF (IRET.NE.0) THEN
        CALL INFMUE()
        CALL INFNIV(IFM,NIV)
        LFETI=.TRUE.
      ELSE
        LFETI=.FALSE.
      ENDIF


      CALL DISMOI('F','NOM_MODELE',NU,'NUME_DDL',IBID,MO,IER)
      CALL DISMOI('F','NUM_GD_SI',NU,'NUME_DDL',IGD,KBID,IER)
      CALL DISMOI('F','NOM_MAILLA',NU,'NUME_DDL',IBID,MA,IER)

      CALL JEEXIN(MA//'.CONNEX',IRET)
      IF (IRET.GT.0) THEN
        CALL JEVEUO(MA//'.CONNEX','L',ICONX1)
        CALL JEVEUO(JEXATR(MA//'.CONNEX','LONCUM'),'L',ICONX2)
      ENDIF

      IF (MO.EQ.' ') THEN
        NBSS=0
      ELSE
        CALL DISMOI('F','NB_SS_ACTI',MO,'MODELE',NBSS,KBID,IERD)
        IF (NBSS.GT.0) THEN
          CALL DISMOI('F','NB_SM_MAILLA',MO,'MODELE',NBSMA,KBID,IERD)
          CALL JEVEUO(MO//'.MODELE    .SSSA','L',IASSSA)
        ENDIF
      ENDIF


      CALL JEVEUO(NU//'     .ADNE','E',IADNEM)
      CALL JEVEUO(NU//'     .ADLI','E',IADLIE)
      CALL JEVEUO(NU//'.NUME.NEQU','L',IADEQU)
      CALL JELIRA(NU//'.NUME.PRNO','NMAXOC',NLILI,KBID)
      CALL JEVEUO(NU//'.NUME.PRNO','L',IDPRN1)
      CALL JEVEUO(JEXATR(NU//'.NUME.PRNO','LONCUM'),'L',IDPRN2)
      CALL JEVEUO(NU//'.NUME.NUEQ','L',JNUEQ)

      NEC=NBEC(IGD)
      NEQU=ZI(IADEQU)



C---- CREATION DE 2 TABLEAUX DE TRAVAIL :
C      .NOIP   :   TABLE DES NUMEROS DE LIGNE
C      .NOSUIV :   TABLE DES CHAINAGES DE LA STRUCTURE CHAINEE
C                  QUI EST CONTRUITE AVANT D'OBTENIR LA
C                  STRUCTURE COMPACTE (SMDI,SMHC) DE LA MATRICE
C     CES 2 OBJETS SONT AGRANDIS SI NECESSAIRE DANS MOINSR.F
C     ON COMMENCE AVEC IIMAX=10
      IIMAX=10
      CALL WKVECT('&&PROMOR.NOIP','V V I',IIMAX,JNOIP)
      CALL WKVECT('&&PROMOR.NOSUIV','V V I',IIMAX,JSUIV)



C     -- ALLOCATION DU VECTEUR &&PROMOR.ANCIEN.LM
C     CE VECTEUR SERA AGRANDI SI NECESSAIRE
      MXDDLT=100
      CALL WKVECT('&&PROMOR.ANCIEN.LM','V V I',MXDDLT,JALM)




C     -- ALLOCATION DE .SMOS.SMDI
      CALL WKVECT(NU//'.SMOS.SMDI',BASE//' V I',NEQU,JSMDI)


C---- INITIALISATION DES TABLEAUX POUR LE STOCKAGE MORSE
C     ATTENTION:   PENDANT LA CONSTRUCTION DE LA STRUCTURE CHAINEE
C                  (SMDI,SMHC,ISUIV) DE LA MATRICE ON A
C     ZI(JSMDI+.): POINTEUR DEBUT DE CHAINE
C     ZI(JSMHC-1+II) : MAILLON QUI CONTIENT L'INDICE COLONNE
C                       DE LA CHAINE II
C     ISUIV(II)     : MAILLON SUIVANT DE LA MEME CHAINE.

C     NEQX   : COMPTEUR DU NOMBRE D'EQUATION (CONTROLE)
      NEQX=0

C     IILIB  : 1-ERE PLACE LIBRE
      IILIB=1


C     -- BOUCLE SUR LES LIGREL DE NU//'.NUME.LILI' :
C     -----------------------------------------------
      DO 140 ILI=2,NLILI
        CALL JENUNO(JEXNUM(NU//'.NUME.LILI',ILI),NOMLIG)
        CALL DISMOI('F','EXI_ELEM',NOMLIG,'LIGREL',IBID,EXIELE,IERD)
        CALL DISMOI('F','EXI_VF',NOMLIG,'LIGREL',IBID,EXIVF,IERD)

        IF (NOMLIG(1:8).EQ.MO) THEN
          CALL DISMOI('F','NB_SS_ACTI',MO,'MODELE',NBSS,KBID,IERD)
        ELSE
          NBSS=0
        ENDIF
        IF (EXIELE.EQ.'NON')GOTO 90


C       1. TRAITEMENT DES ELEMENTS FINIS CLASSIQUES:
C       --------------------------------------------
        IF (EXIVF.EQ.'NON') THEN
        DO 80 IGR=1,ZZNGEL(ILI)
          NEL=ZZNELG(ILI,IGR)
          DO 70 IEL=1,NEL
            NDDLT=0
            NUMA=ZZLIEL(ILI,IGR,IEL)
            IF (NUMA.GT.0) THEN
C             -- MAILLES DU MAILLAGE :
                NNOE=ZZNBNE(NUMA)
                DO 30 K1=1,NNOE
                  N1=ZZCONX(NUMA,K1)
                  IAD1=ZZPRNO(1,N1,1)
                  NDDL1=ZZPRNO(1,N1,2)
                  IF (MXDDLT.LT.(NDDLT+NDDL1)) THEN
                    MXDDLT=2*(NDDLT+NDDL1)
                    CALL JUVECA('&&PROMOR.ANCIEN.LM',MXDDLT)
                    CALL JEVEUO('&&PROMOR.ANCIEN.LM','E',JALM)
                  ENDIF
                  DO 20 IDDL=1,NDDL1
                    ZI(JALM+NDDLT+IDDL-1)=ZI(JNUEQ-1+IAD1+IDDL-1)
   20             CONTINUE
                  NDDLT=NDDLT+NDDL1
   30           CONTINUE

            ELSE
C             -- MAILLES TARDIVES :
              NUMA=-NUMA
              NNOE=ZZNSUP(ILI,NUMA)
              DO 50 K1=1,NNOE
                N1=ZZNEMA(ILI,NUMA,K1)
                IF (N1.LT.0) THEN
                  N1=-N1
                  IAD1=ZZPRNO(ILI,N1,1)
                  NDDL1=ZZPRNO(ILI,N1,2)
                ELSE
                  IAD1=ZZPRNO(1,N1,1)
                  NDDL1=ZZPRNO(1,N1,2)
                ENDIF
                IF (MXDDLT.LT.(NDDLT+NDDL1)) THEN
                  MXDDLT=2*(NDDLT+NDDL1)
                  CALL JUVECA('&&PROMOR.ANCIEN.LM',MXDDLT)
                  CALL JEVEUO('&&PROMOR.ANCIEN.LM','E',JALM)
                ENDIF
                DO 40 IDDL=1,NDDL1
                  ZI(JALM+NDDLT+IDDL-1)=ZI(JNUEQ-1+IAD1+IDDL-1)
   40           CONTINUE
                NDDLT=NDDLT+NDDL1
   50         CONTINUE
            ENDIF

C           -- TRI EN ORDRE CROISSANT POUR L'INSERTION DES COLONNES
            CALL ASSERT(NDDLT.LE.MXDDLT)
            CALL UTTRII(ZI(JALM),NDDLT)

C           -- INSERTION DES COLONNES DE L'ELEMENT DANS
C               LA STRUCTURE CHAINEE
            DO 60 IDDL=0,NDDLT-1
              JDDL=JSMDI+ZI(JALM+IDDL)-1
              IF (ZI(JDDL).EQ.0)NEQX=NEQX+1
              CALL MOINSR(ZI(JALM+IDDL),IDDL+1,JALM,JSMDI,JSUIV,
     &        '&&PROMOR.NOSUIV',JNOIP,'&&PROMOR.NOIP',IILIB,IIMAX)
   60       CONTINUE
   70     CONTINUE
   80   CONTINUE



C       2. TRAITEMENT DES ELEMENTS FINIS DE TYPE VOISIN_VF :
C       ----------------------------------------------------
        ELSEIF (EXIVF.EQ.'OUI') THEN
        CALL JEVEUO(NOMLIG//'.REPE','L',JREPE)
        CALL JEVEUO(MA//'.VGE.PTVOIS','L',JPTVOI)
        CALL JEVEUO(MA//'.VGE.ELVOIS','L',JELVOI)
        DO 81 IGR=1,ZZNGEL(ILI)
          NEL=ZZNELG(ILI,IGR)
          ITYPEL=ZZLIEL(ILI,IGR,NEL+1)
          CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',ITYPEL),NOMTE)
          CALL TEATTR(NOMTE,'S','TYPE_VOISIN',CODVOI,IBID)
          DO 71 IEL=1,NEL
            NDDLT=0
            NUMA=ZZLIEL(ILI,IGR,IEL)
            CALL ASSERT(NUMA.GT.0)
            NNOE=ZZNBNE(NUMA)
            CALL VOIUTI(NUMA,CODVOI,NVOIMA,NSCOMA,JREPE,JPTVOI,JELVOI,
     &                  NBVOIS,LIVOIS,TYVOIS,NBNOVO,NBSOCO,LISOCO)
            DO 32,KVOIS=1,NBVOIS
              NUMAV=LIVOIS(KVOIS)
              NNOE=ZZNBNE(NUMA)
              DO 31 K1=1,NNOE
                N1=ZZCONX(NUMA,K1)
                IAD1=ZZPRNO(1,N1,1)
                NDDL1=ZZPRNO(1,N1,2)
                IF (MXDDLT.LT.(NDDLT+NDDL1)) THEN
                  MXDDLT=2*(NDDLT+NDDL1)
                  CALL JUVECA('&&PROMOR.ANCIEN.LM',MXDDLT)
                  CALL JEVEUO('&&PROMOR.ANCIEN.LM','E',JALM)
                ENDIF
                DO 21 IDDL=1,NDDL1
                  ZI(JALM+NDDLT+IDDL-1)=ZI(JNUEQ-1+IAD1+IDDL-1)
   21           CONTINUE
                NDDLT=NDDLT+NDDL1
   31         CONTINUE
              CALL ASSERT(NDDLT.LE.MXDDLT)

              NNOV=ZZNBNE(NUMAV)
              DO 33 K1=1,NNOV
                N1=ZZCONX(NUMAV,K1)
                IAD1=ZZPRNO(1,N1,1)
                NDDL1=ZZPRNO(1,N1,2)
                IF (MXDDLT.LT.(NDDLT+NDDL1)) THEN
                  MXDDLT=2*(NDDLT+NDDL1)
                  CALL JUVECA('&&PROMOR.ANCIEN.LM',MXDDLT)
                  CALL JEVEUO('&&PROMOR.ANCIEN.LM','E',JALM)
                ENDIF
                DO 23 IDDL=1,NDDL1
                  ZI(JALM+NDDLT+IDDL-1)=ZI(JNUEQ-1+IAD1+IDDL-1)
   23           CONTINUE
                NDDLT=NDDLT+NDDL1
   33         CONTINUE
              CALL ASSERT(NDDLT.LE.MXDDLT)

              CALL UTTRII(ZI(JALM),NDDLT)
              DO 61 IDDL=0,NDDLT-1
                JDDL=JSMDI+ZI(JALM+IDDL)-1
                IF (ZI(JDDL).EQ.0)NEQX=NEQX+1
                CALL MOINSR(ZI(JALM+IDDL),IDDL+1,JALM,JSMDI,JSUIV,
     &          '&&PROMOR.NOSUIV',JNOIP,'&&PROMOR.NOIP',IILIB,IIMAX)
   61         CONTINUE
   32       CONTINUE
   71     CONTINUE
   81   CONTINUE




        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF



C       3. TRAITEMENT DES SOUS-STRUCTURES STATIQUES :
C       ---------------------------------------------
   90   CONTINUE
        IF (NBSS.GT.0) THEN
          DO 130,IMA=1,NBSMA
            IF (ZI(IASSSA-1+IMA).EQ.0)GOTO 130
            NDDLT=0
            CALL JEVEUO(JEXNUM(MA//'.SUPMAIL',IMA),'L',IAMAIL)
            CALL JELIRA(JEXNUM(MA//'.SUPMAIL',IMA),'LONMAX',NNOE,KBID)
            DO 110 K1=1,NNOE
              N1=ZI(IAMAIL-1+K1)
              CALL ASSERT(N1.NE.0)
              IAD1=ZZPRNO(1,N1,1)
              NDDL1=ZZPRNO(1,N1,2)
              IF (MXDDLT.LT.(NDDLT+NDDL1)) THEN
                MXDDLT=2*(NDDLT+NDDL1)
                CALL JUVECA('&&PROMOR.ANCIEN.LM',MXDDLT)
                CALL JEVEUO('&&PROMOR.ANCIEN.LM','E',JALM)
              ENDIF
              DO 100 IDDL=1,NDDL1
                ZI(JALM+NDDLT+IDDL-1)=ZI(JNUEQ-1+IAD1+IDDL-1)
  100         CONTINUE
              NDDLT=NDDLT+NDDL1
  110       CONTINUE

            CALL ASSERT(NDDLT.LE.MXDDLT)
            CALL UTTRII(ZI(JALM),NDDLT)
            DO 120 IDDL=0,NDDLT-1
              JDDL=JSMDI+ZI(JALM+IDDL)-1
              IF (ZI(JDDL).EQ.0)NEQX=NEQX+1
              CALL MOINSR(ZI(JALM+IDDL),IDDL+1,JALM,JSMDI,JSUIV,
     &         '&&PROMOR.NOSUIV',JNOIP,'&&PROMOR.NOIP',IILIB,IIMAX)
  120       CONTINUE
  130     CONTINUE
        ENDIF
  140 CONTINUE

      IF (NEQX.NE.NEQU) THEN
        VALI(1)=NEQU
        VALI(2)=NEQX
        CALL U2MESG('F','ASSEMBLA_65',0,' ',2,VALI,0,0.D0)
      ENDIF



C     DESIMBRIQUATION DE CHAINES POUR OBTENIR LA STRUCTURE COMPACTE
C     (SMDI,SMHC) DE LA MATRICE
      CALL WKVECT(NU//'.SMOS.SMHC',BASE//' V I',IIMAX,JSMHC)
      CALL MOINIP(NEQX,NCOEF,ZI(JSMDI),ZI(JSUIV),ZI(JNOIP),ZI(JSMHC))


C     -- CREATION ET REMPLISSAGE DE .SMDE
      CALL WKVECT(NU//'.SMOS.SMDE',BASE//' V I',6,JSMDE)
      ZI(JSMDE-1+1)=NEQU
      ZI(JSMDE-1+2)=NCOEF
      ZI(JSMDE-1+3)=1


      CALL JEDETR('&&PROMOR.NOIP')
      CALL JEDETR('&&PROMOR.NOSUIV')
      CALL JEDETR('&&PROMOR.ANCIEN.LM   ')

      IF (NIV.GE.1) THEN
        WRITE (IFM,*)'--- NOMBRE DE COEFFICIENTS NON NULS DANS LA '//
     &    'MATRICE : ',NCOEF
      ENDIF

      IF (LFETI) CALL INFBAV()
      CALL JEDEMA()

 9000 FORMAT (1X,'LIGNE ',I4)
 9010 FORMAT (1X,12I5)
      END
