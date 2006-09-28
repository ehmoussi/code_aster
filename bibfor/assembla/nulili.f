      SUBROUTINE NULILI(LLIGR,LILI,BASE,MOLOCZ,NOMGDS,IGDS,MAILLA,NEC,
     &                  NCMP,NLILI)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ASSEMBLA  DATE 29/09/2006   AUTEUR VABHHTS J.PELLET 
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
C RESPONSABLE VABHHTS J.PELLET
      IMPLICIT NONE
      INTEGER IGDS,NEC,NLILI,NBELM,IADNEM,IADLIE,JLIGR2,K
      CHARACTER*(*) LLIGR
      CHARACTER*24 LILI
      CHARACTER*(*) MOLOCZ
      CHARACTER*8 MAILLA,MOLOC
      CHARACTER*1 BASE
C----------------------------------------------------------------------
C ---- OBJET : CREATION DU CHAMP .LILI D'UNE S.D. NUME_DDL
C              ET DES OJBETS TEMPORAIRES : .ADNE ET .ADLI
C----------------------------------------------------------------------
C IN  K24 LLIGR  : LISTE DES NOMS DES LIGRELS
C                  SUPPORTANT LA NUMEROTATION (VECTEUR DE K24)
C IN/JXOUT  K24 LILI   : NOM DE L OBJET LILI QUI SERA CREE
C IN  K1   BASE   : ' G ' POUR CREER LILI SUR BASE GLOBALE
C                   ' V ' POUR CREER LILI SUR BASE VOLATILE
C IN  K19 PREF   : PREFIXE DES OBJETS TEMPORAIRES CREES
C IN  K8  MOLOCZ : NOM DU MODE_LOCAL PRECISANT LES DDLS A NUMEROTER
C                   SI ' ' MOLOCZ EST DETERMINE GRACE AU PHENOMENE
C OUT K8  NOMGDS    : NOM DE LA GRANDEUR (SIMPLE) A NUMEROTER
C OUT I    IGDS     : NUMERO DE LA GRANDEUR  NOMGDS
C OUT K8   MAILLA : NOM DU MAILLAGE
C OUT I    NEC    : NBRE D ENTIERS CODES POUR IGDS
C OUT I    NCMP   : NBRE DE CMP POUR IGDS
C OUT I    NLILI  : DIMENSION DE L OBJET CREE LILI
C----------------------------------------------------------------------
C ATTENTION : NE PAS FAIRE JEMARQ/JEDEMA CAR CETTE ROUTINE
C             RECOPIE DES ADRESSES JEVEUX DANS .ADNE ET .ADLI
C----------------------------------------------------------------------


C    --- DESCRIPTION DES OBJETS ADNE ET ADLI ---
C     ADNE (1          ) = NBRE DE MAILLES DU MAILLAGE
C     ADNE (2          ) = 0
C     ADNE (3          ) = 0
C     ADLI (1          ) = 0
C     ADLI (2          ) = 0
C     ADLI (3          ) = 0
C     POUR 2<=ILI<=NLILI
C     ADNE (3*(ILI-1)+1) = NBRE MAX D'OBJETS DE LA COLLECTION
C                            LILI(ILI).NEMA
C     ADNE (3*(ILI-1)+2) = ADRESSE DE L'OBJET LILI(ILI).NEMA
C     ADNE (3*(ILI-1)+3) = ADRESSE DU VECTEUR DES LONG. CUMULEES DE
C                            LILI(ILI).NEMA
C     ADLI (3*(ILI-1)+1) = NBRE MAX D'OBJETS DE LA COLLECTION
C                            LILI(ILI).LIEL
C     ADLI (3*(ILI-1)+2) = ADRESSE DE L'OBJET LILI(ILI).LIEL
C     ADLI (3*(ILI-1)+3) = ADRESSE DU VECTEUR DES LONG. CUMULEES DE
C                            LILI(ILI).LIEL
C-----------------------------------------------------------------------

C     COMMUNS   JEVEUX
C-----------------------------------------------------------------------
      CHARACTER*32 JEXNUM,JEXNOM,JEXATR
      INTEGER ZI
      COMMON /IVARJE/ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ZR(1)
      CHARACTER*8 ZK8,NOMGDS,KBID
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)

C     VARIABLES LOCALES
C-----------------------
      CHARACTER*8 K8,EXIELE
      CHARACTER*16 PHENO,PHE,NOMTE
      CHARACTER*19 PREFIX,LIGREL,LIGRCF
      CHARACTER*24 NOMLI,LLIGR2
      INTEGER IAD,IBID,IER,IERC,IERD,IFM,IGR,NBGREL
      INTEGER ILLIGR,ILIGR,IRET,KKK,NBCMP,NBEC,TYPELE
      INTEGER NBGR,NBSUP,NCMP,NIV,NLIGR,JMOLOC,IMODE,ITE
      CHARACTER*1 K1BID

C----------------------------------------------------------------------
      CALL INFNIV(IFM,NIV)
      MOLOC=MOLOCZ

C     IFM = IUNIFI('MESSAGE')
      PREFIX = LILI(1:14)

C---- NBRE DE LIGRELS REFERENCES = DIM(LLIGR)

      CALL JEVEUO(LLIGR,'L',ILLIGR)
      CALL JELIRA(LLIGR,'LONUTI',NLIGR,K1BID)



C     SI LIGRCF EXISTE, ON LE RAJOUTE A .LLIGR:
C-------------------------------------------------------------
      LLIGR2='&&NULILI.LLIGR2'
      LIGRCF='&&OP0070.LIMECF'
      CALL JEEXIN(LIGRCF//'.LIEL',IRET)
      IF (IRET.GT.0) THEN
        CALL WKVECT(LLIGR2,'V V K24',NLIGR+1,JLIGR2)
        DO 661,K=1,NLIGR
          ZK24(JLIGR2-1+K) =ZK24(ILLIGR-1+K)
 661    CONTINUE
        ZK24(JLIGR2-1+NLIGR+1) =LIGRCF
        CALL JEECRA(LLIGR2,'LONUTI',NLIGR+1,K1BID)
        NLIGR=NLIGR+1
      ELSE
        CALL WKVECT(LLIGR2,'V V K24',NLIGR,JLIGR2)
        DO 662,K=1,NLIGR
          ZK24(JLIGR2-1+K) =ZK24(ILLIGR-1+K)
 662    CONTINUE
        CALL JEECRA(LLIGR2,'LONUTI',NLIGR,K1BID)
      END IF

      NLILI = NLIGR+1
      IF (NLILI.EQ.1) CALL U2MESS('F','ASSEMBLA_29')


C---- CREATION DU REPERTOIRE .LILI DE TOUS LES NOMS DE LIGRELS /=

      CALL JECREO(LILI,BASE//' N  K24 ')
      CALL JEECRA(LILI,'NOMMAX',NLILI,' ')
C---- LILI(1)= '&MAILLA'
      CALL JECROC(JEXNOM(LILI,'&MAILLA'))


C---- CREATION DES OBJETS .ADNE ET .ADLI SUR 'V'
      CALL JECREO(PREFIX//'.ADNE',' V V I')
      CALL JEECRA(PREFIX//'.ADNE','LONMAX',3*NLILI,' ')
      CALL JEVEUO(PREFIX//'.ADNE','E',IADNEM)
      CALL JECREO(PREFIX//'.ADLI',' V V I')
      CALL JEECRA(PREFIX//'.ADLI','LONMAX',3*NLILI,' ')
      CALL JEVEUO(PREFIX//'.ADLI','E',IADLIE)

C---- CHARGEMENT DE LILI, ADNE, ADLI

      DO 10 ILIGR = 1,NLIGR
        NOMLI = ZK24(JLIGR2+ILIGR-1)

C---- VERIFICATION DE L'UNICITE DU PHENOMENE
        CALL DISMOI('F','PHENOMENE',NOMLI,'LIGREL',KKK,PHE,IERC)
        IF (ILIGR.EQ.1) THEN
          PHENO = PHE
        ELSE IF (PHENO.NE.PHE) THEN
          CALL U2MESS('F','ASSEMBLA_30')
        END IF
        CALL JECROC(JEXNOM(LILI,NOMLI))

C---- RECUPERATION DU NOM DU MAILLAGE ET VERIFICATION DE SON UNICITE
        CALL JEVEUT(NOMLI(1:19)//'.NOMA','L',IAD)
        K8 = ZK8(IAD)
        IF (ILIGR.EQ.1) THEN
          MAILLA(1:8) = K8
        ELSE IF (MAILLA(1:8).NE.K8) THEN
          CALL UTDEBM('F','NULILI','1')
          CALL UTIMPK('L',' AU MOINS 2 MAILLAGES DIFFERENTS :',0,' ')
          CALL UTIMPK('L','- MAILLAGE 1:',1,MAILLA)
          CALL UTIMPK('L','- MAILLAGE 2:',1,K8)
          CALL UTFINM()
        END IF


C        -- SI LE LIGREL NE CONTIENT PAS D'ELEMENTS ON VA A FIN BCLE:
        CALL DISMOI('F','EXI_ELEM',NOMLI,'LIGREL',IBID,EXIELE,IERD)
        IF (EXIELE(1:3).EQ.'NON') GO TO 10

        CALL JEEXIN(NOMLI(1:19)//'.NEMA',IRET)
        IF (IRET.NE.0) THEN

C---- ADNE(3*(ILIGR)+1)=NBRE DE MAILLES SUP DU LIGREL NOMLI

          CALL JELIRA(NOMLI(1:19)//'.NEMA','NUTIOC',NBSUP,K1BID)
          ZI(IADNEM+3* (ILIGR)) = NBSUP
          CALL JEVEUT(NOMLI(1:19)//'.NEMA','L',IAD)
          ZI(IADNEM+3* (ILIGR)+1) = IAD
          CALL JEVEUT(JEXATR(NOMLI(1:19)//'.NEMA','LONCUM'),'L',IAD)
          ZI(IADNEM+3* (ILIGR)+2) = IAD
        ELSE
          ZI(IADNEM+3* (ILIGR)) = 0
          ZI(IADNEM+3* (ILIGR)+1) = 2**30
          ZI(IADNEM+3* (ILIGR)+2) = 2**30
        END IF

C---- ADLI(3*(ILIGR)+1)=NBRE DE MAILLES DU LIGREL NOMLI

        CALL JELIRA(NOMLI(1:19)//'.LIEL','NUTIOC',NBGR,K1BID)
        ZI(IADLIE+3* (ILIGR)) = NBGR
        CALL JEVEUT(NOMLI(1:19)//'.LIEL','L',IAD)
        ZI(IADLIE+3* (ILIGR)+1) = IAD
        CALL JEVEUT(JEXATR(NOMLI(1:19)//'.LIEL','LONCUM'),'L',IAD)
        ZI(IADLIE+3* (ILIGR)+2) = IAD
   10 CONTINUE


      CALL DISMOI('F','NB_MA_MAILLA',MAILLA(1:8),'MAILLAGE',NBELM,KBID,
     &            IERC)
      ZI(IADNEM) = NBELM


C---- CALCUL DE : NOMGDS, IGDS, NEC , NCMP
C------------------------------------------
      IF (MOLOC.EQ.' ') THEN
        CALL DISMOI('F','NOM_GD',PHENO,'PHENOMENE',IBID,NOMGDS,IER)
      ELSE
        LIGREL = ZK24(JLIGR2-1+1)
        DO 20 IGR = 1,NBGREL(LIGREL)
          ITE = TYPELE(LIGREL,IGR)
          CALL JENUNO(JEXNUM('&CATA.TE.NOMTE',ITE),NOMTE)
          CALL JENONU(JEXNOM('&CATA.TE.NOMMOLOC',NOMTE//MOLOC),IMODE)
          IF (IMODE.GT.0) THEN
            CALL JEVEUO(JEXNUM('&CATA.TE.MODELOC',IMODE),'L',JMOLOC)
            CALL JENUNO(JEXNUM('&CATA.GD.NOMGD',ZI(JMOLOC-1+2)),NOMGDS)
            GO TO 30
          END IF
   20   CONTINUE
        CALL U2MESS('F','CALCULEL_13')
   30   CONTINUE
      END IF
      CALL JENONU(JEXNOM('&CATA.GD.NOMGD',NOMGDS),IGDS)
      IF (IGDS.EQ.0) CALL U2MESS('F','CALCULEL_13')

      NEC = NBEC(IGDS)
      NCMP = NBCMP(IGDS)


   40 CONTINUE

      CALL JEDETR(LLIGR2)

      END
