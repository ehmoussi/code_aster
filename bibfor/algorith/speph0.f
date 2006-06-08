      SUBROUTINE SPEPH0(NOMU,TABLE)
      IMPLICIT   NONE
      CHARACTER*8 NOMU,TABLE
C-----------------------------------------------------------------------
C MODIF ALGORITH  DATE 08/03/2004   AUTEUR REZETTE C.REZETTE 
C ======================================================================
C            CONFIGURATION MANAGEMENT OF EDF VERSION
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
C-----------------------------------------------------------------------
C   RESTITUTION D'UN INTERSPECTRE DE REPONSE MODALE DANS LA BASE
C   PHYSIQUE  OPERATEUR REST_SPEC_PHYS
C-----------------------------------------------------------------------
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
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
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------

      INTEGER IBID,NBPAR,IVAL(2),NBMOD1,NBTROU,LNUMOR,NBMODE,ILMODE,IM,
     &        IMOD1,IAD,NAPEXC,ILNOEX,NCMPEX,IRET,ILCPEX,IDIM1,IDIM0,
     &        NBN,INOEN,ICMPN,NBMAIL,I,IMAIN,INDDL,INOEUD,IDDL,NUPO,
     &        IVARI,NAPEX1,NBMR,IDIM,IMR,NUMOD,IN,NBPF,NBFO1,IFON,IF1,
     &        IFOR,IFOI,IDIS,ICHAM1,ISIP,ICHAM,NBN1,NBN2
      PARAMETER (NBPAR=8)
      REAL*8 R8B,BANDE(2),FREQ1
      COMPLEX*16 C16B
      LOGICAL INTMOD,INTPHY,INTDON
      CHARACTER*8 K8B,MODMEC,MODSTA,NOEUD,NOMA,CMP,TYPAR(NBPAR)
      CHARACTER*16 MOVREP,OPTCAL,OPTCHA,NOPAR(NBPAR),NOPAOU(2),KVAL(2),
     &             TYPCHA,ACCES,TYPMEC,NOCHAM,OPTCH1,MAILLE
      CHARACTER*24 CHAM19,NOMFON

      DATA NOPAOU/'NUME_ORDRE_I','NUME_ORDRE_J'/
      DATA NOPAR/'NOM_CHAM','OPTION','DIMENSION','NOEUD_I','NOM_CMP_I',
     &     'NOEUD_J','NOM_CMP_J','FONCTION'/
      DATA TYPAR/'K16','K16','I','K8','K8','K8','K8','K24'/

C-----------------------------------------------------------------------
      CALL JEMARQ()

      CALL GETVID(' ','MODE_MECA',1,1,1,MODMEC,IBID)
      CALL GETTCO(MODMEC,TYPMEC)

      CALL RSORAC(MODMEC,'LONUTI',IBID,R8B,K8B,C16B,0.0D0,K8B,NBMOD1,1,
     &            NBTROU)
      CALL WKVECT('&&SPEPH0.NUMERO.ORDRE','V V I',NBMOD1,LNUMOR)
      CALL RSORAC(MODMEC,'TOUT_ORDRE',IBID,R8B,K8B,C16B,0.0D0,K8B,
     &            ZI(LNUMOR),NBMOD1,NBTROU)

      CALL GETVIS(' ','NUME_ORDRE',1,1,0,IBID,NBMODE)
      NBMODE = -NBMODE
      IF (NBMODE.EQ.0) THEN
        CALL GETVR8(' ','BANDE',1,1,2,BANDE,IBID)
        IF (IBID.EQ.0) THEN
          CALL UTMESS('F','SPEPH0','IL FAUT DEFINIR UNE BANDE '//
     &                'OU UN NUME_ORDRE')
        END IF
        CALL WKVECT('&&SPEPH0.LISTEMODES','V V I',NBMOD1,ILMODE)
        DO 10 IM = 1,NBMOD1
          IMOD1 = ZI(LNUMOR+IM-1)
          CALL RSADPA(MODMEC,'L',1,'FREQ',IMOD1,0,IAD,K8B)
          FREQ1 = ZR(IAD)
          IF ((FREQ1-BANDE(1))* (FREQ1-BANDE(2)).LE.0.D0) THEN
            NBMODE = NBMODE + 1
            ZI(ILMODE-1+NBMODE) = IMOD1
          END IF
   10   CONTINUE
        IF (NBMODE.EQ.0) THEN
          CALL UTMESS('F','SPEPH0','LA BANDE DE FREQUENCE RETENUE '//
     &                'NE COMPORTE PAS DE MODES PROPRES')
        END IF
      ELSE
        CALL GETVIS(' ','NUME_ORDRE',1,1,0,ILMODE,IBID)
        IF (IBID.EQ.0) THEN
          CALL UTMESS('F','SPEPH0','IL FAUT DEFINIR UNE "BANDE" OU '//
     &                'UNE LISTE DE "NUME_ORDRE"')
        END IF
        CALL WKVECT('&&SPEPH0.LISTEMODES','V V I',NBMODE,ILMODE)
        CALL GETVIS(' ','NUME_ORDRE',1,1,NBMODE,ZI(ILMODE),IBID)
        DO 20 IM = 1,NBMODE
          IF (ZI(ILMODE-1+IM).GT.NBMOD1) THEN
            CALL UTMESS('F','SPEPH0','VOUS AVEZ DEMANDE DES MODES '//
     &                  'QUI NE SONT PAS CALCULES')
          END IF
   20   CONTINUE
      END IF

      NAPEXC = 0
      MOVREP = 'RELATIF'
      CALL GETVID(' ','MODE_STAT',1,1,1,MODSTA,IBID)
      IF (IBID.NE.0) THEN
        CALL GETVID('EXCIT','NOEUD',1,1,0,K8B,NAPEXC)
        NAPEXC = -NAPEXC
        IF (NAPEXC.NE.0) THEN
          CALL WKVECT('&&SPEPH0.LISTENOEEXC','V V K8',NAPEXC,ILNOEX)
          CALL GETVID('EXCIT','NOEUD',1,1,NAPEXC,ZK8(ILNOEX),IBID)
        END IF

        CALL GETVTX('EXCIT','NOM_CMP',1,1,0,K8B,NCMPEX)
        NCMPEX = -NCMPEX
        IF (NCMPEX.NE.0) THEN
          CALL WKVECT('&&SPEPH0.LISTECMPEXC','V V K8',NCMPEX,ILCPEX)
          CALL GETVTX('EXCIT','NOM_CMP',1,1,NCMPEX,ZK8(ILCPEX),IBID)
        END IF

        CALL GETVTX(' ','MOUVEMENT',1,1,1,MOVREP,IBID)
      END IF

      IDIM1 = NBMODE + NAPEXC
      CALL TBLIVA(TABLE,0,K8B,IBID,R8B,C16B,K8B,K8B,R8B,'DIMENSION',K8B,
     &            IDIM0,R8B,C16B,K8B,IRET)
      IF (IRET.NE.0) CALL UTMESS('F','OP0148','Y A UN BUG 1')
      IF (IDIM1.NE.IDIM0) THEN
        CALL UTMESS('F','SPEPH0','DIMENSION SPECTRALE FAUSSE')
      END IF

C     --- OPTION DE RECOMBINAISON ---

      CALL GETVTX(' ','NOM_CHAM',0,1,1,OPTCHA,IBID)

C     --- VERIFICATION DES DONNEES INTERSPECTRE ---

      CALL TBLIVA(TABLE,0,K8B,IBID,R8B,C16B,K8B,K8B,R8B,'NOM_CHAM',K8B,
     &            IBID,R8B,C16B,NOCHAM,IRET)
      IF (IRET.NE.0) CALL UTMESS('F','OP0148','Y A UN BUG 2')
      IF (NOCHAM.EQ.'ACCE_GENE') THEN
        IF (OPTCHA(1:4).EQ.'ACCE') THEN
        ELSE
          CALL UTMESS('F','SPEPH0','L''INTERSPECTRE MODAL EST DE '//
     &        'TYPE "ACCE", ON NE PEUT QUE RESTITITUER UNE ACCELERATION'
     &                )
        END IF
      ELSE IF (NOCHAM.EQ.'VITE_GENE') THEN
        IF (OPTCHA(1:4).EQ.'VITE') THEN
        ELSE
          CALL UTMESS('F','SPEPH0','L''INTERSPECTRE MODAL EST DE '//
     &             'TYPE "VITE", ON NE PEUT QUE RESTITITUER UNE VITESSE'
     &                )
        END IF
      ELSE IF (NOCHAM.EQ.'DEPL_GENE') THEN
        IF (OPTCHA(1:4).EQ.'ACCE') THEN
          CALL UTMESS('F','SPEPH0','L''INTERSPECTRE MODAL EST DE '//
     &        'TYPE "DEPL", ON NE PEUT PAS RESTITITUER UNE ACCELERATION'
     &                )
        ELSE IF (OPTCHA(1:4).EQ.'VITE') THEN
          CALL UTMESS('F','SPEPH0','L''INTERSPECTRE MODAL EST DE '//
     &             'TYPE "DEPL", ON NE PEUT PAS RESTITITUER UNE VITESSE'
     &                )
        END IF
      END IF
      OPTCH1 = OPTCHA
      IF (OPTCHA(1:4).EQ.'VITE') OPTCH1 = 'DEPL'
      IF (OPTCHA(1:4).EQ.'ACCE') OPTCH1 = 'DEPL'

C     --- RECUPERATION DES NOEUDS, NOM_CMP ET MAILLE ---

      CALL GETVID(' ','NOEUD',0,1,0,K8B,NBN1)
      CALL GETVTX(' ','NOM_CMP',0,1,0,K8B,NBN2)
      IF (NBN1.NE.NBN2) THEN
        CALL UTMESS('F','SPEPH0','IL FAUT AUTANT DE "NOEUD" '//
     &              ' QUE DE "NOM_CMP"')
      END IF
      NBN = -NBN1
      CALL WKVECT('&&SPEPH0.NOEUD_REP','V V K8',NBN,INOEN)
      CALL WKVECT('&&SPEPH0.NOCMP_REP','V V K8',NBN,ICMPN)
      CALL GETVID(' ','NOEUD',0,1,NBN,ZK8(INOEN),IBID)
      CALL GETVTX(' ','NOM_CMP',0,1,NBN,ZK8(ICMPN),IBID)

      CALL GETVID(' ','MAILLE',0,1,0,K8B,NBMAIL)
      IF (NBMAIL.NE.0) THEN
        NBMAIL = -NBMAIL
        IF (NBN.NE.NBMAIL) THEN
          CALL UTMESS('F','SPEPH0','IL FAUT AUTANT DE "MAILLE" '//
     &                ' QUE DE "NOEUD"')
        END IF
        CALL WKVECT('&&SPEPH0.MAILLE_REP','V V K8',NBN,IMAIN)
        CALL GETVID(' ','MAILLE',0,1,NBN,ZK8(IMAIN),IBID)
      END IF

C     --- RECUPERATION DU NUMERO DU DDL ---

      CALL RSEXCH(MODMEC,OPTCH1,ZI(ILMODE),CHAM19,IRET)
      IF (IRET.NE.0) THEN
        CALL UTDEBM('F','SPEPH0','MANQUE LA DEFORMEE MODALE')
        CALL UTIMPK('L',' NOM_CHAM ',1,OPTCH1)
        CALL UTIMPI('S',' POUR LE MODE ',1,ZI(ILMODE))
        CALL UTFINM()
      END IF

      CALL WKVECT('&&SPEPH0.NUME_DDL','V V I',NBN,INDDL)
      CALL DISMOI('F','TYPE_SUPERVIS',CHAM19,'CHAMP',IBID,TYPCHA,IRET)
      IF (TYPCHA(1:7).EQ.'CHAM_NO') THEN
        DO 30 I = 1,NBN
          NOEUD = ZK8(INOEN+I-1)
          CMP = ZK8(ICMPN+I-1)
          CALL POSDDL('CHAM_NO',CHAM19,NOEUD,CMP,INOEUD,IDDL)
          IF (INOEUD.EQ.0) THEN
            CALL UTMESS('F','SPEPH0','LE NOEUD '//NOEUD//
     &                  ' N''EXISTE PAS.')
          ELSE IF (IDDL.EQ.0) THEN
            CALL UTMESS('F','SPEPH0','LA COMPOSANTE '//CMP//
     &                  ' DU NOEUD '//NOEUD//' N''EXISTE PAS.')
          END IF
          ZI(INDDL+I-1) = IDDL
   30   CONTINUE
      ELSE IF (TYPCHA(1:9).EQ.'CHAM_ELEM') THEN
        IF (NBMAIL.EQ.0) THEN
          CALL UTMESS('F','SPEPH0','IL FAUT DEFINIR UNE LISTE DE '//
     &                'MAILLES POUR POST-TRAITER UN CHAM_ELEM')
        END IF
        CALL DISMOI('F','NOM_MAILLA',CHAM19,'CHAM_ELEM',IBID,NOMA,IRET)
        NUPO = 0
        IVARI = 1
        DO 40 I = 1,NBN
          MAILLE = ZK8(IMAIN+I-1)
          NOEUD = ZK8(INOEN+I-1)
          CMP = ZK8(ICMPN+I-1)
          CALL UTCHDL(CHAM19,NOMA,MAILLE,NOEUD,NUPO,0,IVARI,CMP,IDDL)
          IF (IDDL.EQ.0) THEN
            CALL UTMESS('F','SPEPH0','LA COMPOSANTE '//CMP//
     &                  ' DU NOEUD '//NOEUD//' POUR LA MAILLE '//
     &                  MAILLE//' N''EXISTE PAS.')
          END IF
          ZI(INDDL+I-1) = IDDL
   40   CONTINUE
      ELSE
        CALL UTMESS('F','SPEPH0','TYPE DE CHAMP INCONNU')
      END IF

      CALL GETVTX(' ','OPTION',0,1,1,OPTCAL,IBID)
      INTPHY = .FALSE.
      INTMOD = .FALSE.
      IF (OPTCAL(1:4).EQ.'TOUT') INTPHY = .TRUE.
      IF (OPTCAL(6:9).EQ.'TOUT') INTMOD = .TRUE.

C --- CARACTERISATION DU CONTENU DE LA TABLE   ---
C --- INTERSPECTRES OU AUTOSPECTRES UNIQUEMENT ---

      CALL TBLIVA(TABLE,0,K8B,IBID,R8B,C16B,K8B,K8B,R8B,'OPTION',K8B,
     &            IBID,R8B,C16B,K8B,IRET)
      IF (IRET.NE.0) CALL UTMESS('F','SPEPH0','Y A UN BUG 1')

      INTDON = .TRUE.
      IF (K8B(1:4).EQ.'DIAG') INTDON = .FALSE.
      IF (INTMOD .AND. .NOT.INTDON) THEN
        CALL UTMESS('F','SPEPH0','LA TABL_INTSP DE REPONSE MODALE NE '//
     &         'CONTIENT QUE DES AUTOSPECTRES. LE CALCUL DEMANDE N EST '
     &              //'DONC PAS REALISABLE.')
      END IF

C     --- ON NE PREND EN COMPTE QUE LES MODES DYNAMIQUES ---

      NBMOD1 = NBMODE
      NAPEX1 = NAPEXC
      IF (MOVREP.EQ.'DIFFERENTIEL') NBMOD1 = 0
      IF (MOVREP.EQ.'RELATIF') NAPEX1 = 0
      NBMR = NAPEX1 + NBMOD1
      IDIM = NBMR*NBN
      CALL WKVECT('&&SPEPH0_CHAM','V V R',IDIM,ICHAM)

      DO 60 IMR = 1,NAPEX1
        NOEUD = ZK8(ILNOEX+IMR-1)
        CMP = ZK8(ILCPEX+IMR-1)
        ACCES = NOEUD//CMP
        CALL RSORAC(MODSTA,'NOEUD_CMP',IBID,R8B,ACCES,C16B,R8B,K8B,
     &              NUMOD,1,NBTROU)
        IF (NBTROU.NE.1) THEN
          CALL UTDEBM('F','SPEPH0','DONNEES INCOMPATIBLES :')
          CALL UTIMPK('L',' POUR LE MODE_STAT  : ',1,MODSTA)
          CALL UTIMPK('L',' IL MANQUE LE CHAMP : ',1,ACCES)
          CALL UTFINM()
        END IF
        CALL RSEXCH(MODSTA,OPTCH1,NUMOD,CHAM19,IRET)
        IF (IRET.NE.0) THEN
          CALL UTDEBM('F','SPEPH0','MANQUE LE MODE STATIQUE')
          CALL UTIMPK('L',' NOM_CHAM ',1,OPTCH1)
          CALL UTIMPI('S',' POUR LE MODE ',1,NUMOD)
          CALL UTFINM()
        END IF
        CALL JEVEUO(CHAM19(1:19)//'.VALE','L',ISIP)
        DO 50 IN = 1,NBN
          ICHAM1 = ICHAM + NBN* (IMR-1) + IN - 1
          ZR(ICHAM1) = ZR(ISIP+ZI(INDDL+IN-1)-1)
   50   CONTINUE
   60 CONTINUE

      DO 90 IMR = 1,NBMOD1
        NUMOD = ZI(ILMODE+IMR-1)
        CALL RSEXCH(MODMEC,OPTCH1,NUMOD,CHAM19,IRET)
        IF (IRET.NE.0) THEN
          CALL UTDEBM('F','SPEPH0','MANQUE LA DEFORMEE MODALE')
          CALL UTIMPK('L',' NOM_CHAM ',1,OPTCH1)
          CALL UTIMPI('S',' POUR LE MODE ',1,NUMOD)
          CALL UTFINM()
        END IF
        CALL JEVEUO(CHAM19(1:19)//'.VALE','L',ISIP)
        IF (TYPMEC.EQ.'MODE_MECA_C') THEN
          DO 70 IN = 1,NBN
            ICHAM1 = ICHAM + NAPEX1*NBN + NBN* (IMR-1) + IN - 1
            ZR(ICHAM1) = DBLE(ZC(ISIP+ZI(INDDL+IN-1)-1))
   70     CONTINUE
        ELSE
          DO 80 IN = 1,NBN
            ICHAM1 = ICHAM + NAPEX1*NBN + NBN* (IMR-1) + IN - 1
            ZR(ICHAM1) = ZR(ISIP+ZI(INDDL+IN-1)-1)
   80     CONTINUE
        END IF
   90 CONTINUE

C     --- CREATION DE LA TABLE DE SORTIE ---

      CALL TBCRSD(NOMU,'G')
      CALL TBAJPA(NOMU,NBPAR,NOPAR,TYPAR)

      KVAL(1) = OPTCHA
      KVAL(2) = OPTCAL
      CALL TBAJLI(NOMU,3,NOPAR,NBN,R8B,C16B,KVAL,0)

      IVAL(1) = 1
      IVAL(2) = 1
      CALL TBLIVA(TABLE,2,NOPAOU,IVAL,R8B,C16B,K8B,K8B,R8B,'FONCTION',
     &            K8B,IBID,R8B,C16B,NOMFON,IRET)
      IF (IRET.NE.0) CALL UTMESS('F','SPEPH0','Y A UN BUG 3')
      CALL JELIRA(NOMFON(1:19)//'.VALE','LONUTI',NBPF,K8B)
      NBPF = NBPF/3

      NBFO1 = (NBMR* (NBMR+1))/2
      CALL WKVECT('&&SPEPH0.TEMP.FONR','V V R',NBPF*NBFO1,IFOR)
      CALL WKVECT('&&SPEPH0.TEMP.FONI','V V R',NBPF*NBFO1,IFOI)
      CALL WKVECT('&&SPEPH0.TEMP.DISC','V V R',NBPF,IDIS)

      CALL JEVEUO(NOMFON(1:19)//'.VALE','L',IFON)
      DO 100 IF1 = 1,NBPF
        ZR(IDIS+IF1-1) = ZR(IFON+IF1-1)
  100 CONTINUE

      CALL SPEPH2(MOVREP,NAPEXC,NBMODE,NBPF,INTMOD,TABLE,ZR(IFOR),
     &            ZR(IFOI))

      CALL SPEPH1(INTPHY,INTMOD,NOMU,ZR(ICHAM),ZR(IFOR),ZR(IFOI),
     &            ZR(IDIS),ZK8(INOEN),ZK8(ICMPN),NBMR,NBN,NBPF)

      CALL TITRE

      CALL JEDETR('&&SPEPH0.NUMERO.ORDRE')
      CALL JEDETR('&&SPEPH0.LISTEMODES')
      CALL JEDETR('&&SPEPH0.NUME_DDL')
      CALL JEDETR('&&SPEPH0_CHAM')
      CALL JEDETR('&&SPEPH0.TEMP.FONR')
      CALL JEDETR('&&SPEPH0.TEMP.FONI')
      CALL JEDETR('&&SPEPH0.TEMP.DISC')
      CALL JEDETR('&&SPEPH0.NOEUD_REP')
      CALL JEDETR('&&SPEPH0.NOCMP_REP')
      CALL JEEXIN('&&SPEPH0.LISTENOEEXC',IRET)
      IF (IRET.NE.0) CALL JEDETR('&&SPEPH0.LISTENOEEXC')
      CALL JEEXIN('&&SPEPH0.LISTECMPEXC',IRET)
      IF (IRET.NE.0) CALL JEDETR('&&SPEPH0.LISTECMPEXC')
      IF (NBMAIL.NE.0) CALL JEDETR('&&SPEPH0.MAILLE_REP')

  110 CONTINUE
      CALL JEDEMA()
      END
