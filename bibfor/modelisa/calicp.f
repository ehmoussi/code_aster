      SUBROUTINE CALICP (CHARGZ)
      IMPLICIT REAL*8 (A-H,O-Z)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 29/05/2001   AUTEUR CIBHHPD D.NUNEZ 
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
      CHARACTER*8  CHARGE
      CHARACTER*(*) CHARGZ
C -------------------------------------------------------
C     TRAITEMENT DU MOT CLE LIAISON_COQUE DE AFFE_CHAR_MECA .
C     L'UTILISATION DE CE MOT CLE PERMET D'AFFECTER DES RELATIONS
C     LINEAIRES ENTRE DDLS TRADUISANT UN MOUVEMENT DE CORPS SOLIDE
C     ENTRE DES COUPLES DE NOEUDS DE 2 LISTES DE NOEUDS APPARTENANT
C     AU PLAN MOYEN DE 2 COQUES PERPENDICULAIRES
C -------------------------------------------------------
C  CHARGE        - IN    - K8   - : NOM DE LA SD CHARGE
C                - JXVAR -      -   LA  CHARGE EST ENRICHIE
C                                   DES RELATIONS LINEAIRES NECESSAIRES
C -------------------------------------------------------
C
C --------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ------
      CHARACTER*32       JEXNUM , JEXNOM , JEXR8 , JEXATR
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      REAL*8             ZR
      COMMON  / RVARJE / ZR(1)
      COMPLEX*16         ZC
      COMMON  / CVARJE / ZC(1)
      LOGICAL            ZL
      COMMON  / LVARJE / ZL(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE /ZK8(1),ZK16(1),ZK24(1),ZK32(1), ZK80(1)
C --------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ------
C
C --------- VARIABLES LOCALES ---------------------------
      REAL*8        CENTRE(3),THETA(3),T(3)
      CHARACTER*1   K1BID
      CHARACTER*2   TYPLAG
      CHARACTER*8   MOD, NOMG, K8BID, POSLAG
      CHARACTER*8   NOMA
      CHARACTER*16  MOTFAC
      CHARACTER*19  LIGRMO
      CHARACTER*19  LISREL
      CHARACTER*24  LISNOE, LISTYP
      CHARACTER*24  LISIN1, LISIN2, LISIN3, LISIN4, LISIN5, LISIN6
      CHARACTER*24  LISIN7, LISIN8, LISFI1, LISFI2, LISOU1, LISOU2
      CHARACTER*24  LISIND
C --------- FIN  DECLARATIONS  VARIABLES LOCALES --------
C
      CALL JEMARQ()
      LISNOE = '&&CALICP.LISTNOE'
      LISTYP = '&&CALICP.LISTYP'
      CHARGE = CHARGZ
      TYPLAG = '12'
      ZERO   = 0.0D0
C
      DO 10 I = 1, 3
        CENTRE(I) = ZERO
        THETA(I)  = ZERO
        T(I)      = ZERO
 10   CONTINUE
C
C --- NOM DE LA LISTE DE RELATIONS :
C     ----------------------------
      LISREL = '&&CALICP.RLLISTE'
C
C --- NOM DES LISTES DE TRAVAIL :
C     -------------------------
      LISIN1 = '&&CALICP.LISMA1'
      LISIN2 = '&&CALICP.LISGMA1'
      LISIN3 = '&&CALICP.LISNO1'
      LISIN4 = '&&CALICP.LISGNO1'
      LISIN5 = '&&CALICP.LISMA2'
      LISIN6 = '&&CALICP.LISGMA2'
      LISIN7 = '&&CALICP.LISNO2'
      LISIN8 = '&&CALICP.LISGNO2'
      LISFI1 = '&&CALICP.LISFI1'
      LISFI2 = '&&CALICP.LISFI2'
      LISOU1 = '&&CALICP.LISOU1'
      LISOU2 = '&&CALICP.LISOU2'
C
      MOTFAC = 'LIAISON_COQUE'
C
      CALL GETFAC(MOTFAC,NLIAI)
      IF (NLIAI.EQ.0) GOTO 99999
C
C --- MODELE ASSOCIE AU LIGREL DE CHARGE :
C     ----------------------------------
      CALL DISMOI('F','NOM_MODELE',CHARGE(1:8),'CHARGE',IBID,MOD,IER)
C
C ---  LIGREL DU MODELE :
C      ----------------
      LIGRMO = MOD(1:8)//'.MODELE'
C
C --- MAILLAGE ASSOCIE AU MODELE :
C     --------------------------
      CALL JEVEUO(LIGRMO//'.NOMA','L',JNOMA)
      NOMA = ZK8(JNOMA)
C
C --- DIMENSION ASSOCIEE AU MODELE :
C     ----------------------------
      CALL DISMOI('F','Z_CST',MOD,'MODELE',NDIMMO,K8BID,IER)
      NDIMMO = 3
      IF (K8BID.EQ.'OUI') NDIMMO = 2
C
C --- CREATION D'UN VECTEUR DE 2 TERMES K8 QUI SERONT LES NOMS DES
C --- NOEUDS A RELIER :
C     ---------------
      CALL WKVECT(LISNOE,'V V K8',2,IDLINO)
C
C --- CREATION D'UN VECTEUR DE 2 TERMES K8 QUI SERONT LES NOMS DES
C --- TYPES LICITES D'ELEMENTS A LA JONCTION DES COQUES, CE SONT
C --- DES SEG2 OU DES SEG3 :
C     --------------------
      CALL WKVECT(LISTYP,'V V K8',2,IDLITY)
      ZK8(IDLITY+1-1) = 'SEG2'
      ZK8(IDLITY+2-1) = 'SEG3'
C
C --- BOUCLE SUR LES OCCURENCES DU MOT-FACTEUR LIAISON_COQUE :
C     ------------------------------------------------------
      DO 20 IOCC =1, NLIAI
C
       CALL JEDETR(LISIN1)
       CALL JEDETR(LISIN2)
       CALL JEDETR(LISIN3)
       CALL JEDETR(LISIN4)
       CALL JEDETR(LISIN5)
       CALL JEDETR(LISIN6)
       CALL JEDETR(LISIN7)
       CALL JEDETR(LISIN8)
       CALL JEDETR(LISFI1)
       CALL JEDETR(LISFI2)
       CALL JEDETR(LISOU1)
       CALL JEDETR(LISOU2)
C
C ---  ON REGARDE SI LES MULTIPLICATEURS DE LAGRANGE SONT A METTRE
C ---  APRES LES NOEUDS PHYSIQUES LIES PAR LA RELATION DANS LA MATRICE
C ---  ASSEMBLEE :
C ---  SI OUI TYPLAG = '22'
C ---  SI NON TYPLAG = '12'
C      --------------------
       CALL GETVTX (MOTFAC,'NUME_LAGR',IOCC,1,0,K8BID,NARL)
       IF (NARL.NE.0) THEN
          CALL GETVTX (MOTFAC,'NUME_LAGR',IOCC,1,1,POSLAG,NRL)
          IF (POSLAG(1:5).EQ.'APRES') THEN
              TYPLAG = '22'
          ELSE
              TYPLAG = '12'
          ENDIF
       ELSE
         TYPLAG = '12'
       ENDIF
C
C ---  ACQUISITION DE LA LISTE DES NOEUDS SPECIFIEE APRES 
C ---  LE MOT CLE MAILLE_1 (CETTE LISTE EST NON REDONDANTE) :
C      ---------------------------------------------------- 
       CALL PAMANO(MOTFAC, 'MAILLE_1',NOMA, LISTYP, IOCC, LISIN1,LONLI1)
C
C ---  ACQUISITION DE LA LISTE DES NOEUDS SPECIFIEE APRES 
C ---  LE MOT CLE GROUP_MA_1 (CETTE LISTE EST NON REDONDANTE) :
C      ----------------------------------------------------- 
       CALL PAMANO(MOTFAC, 'GROUP_MA_1',NOMA, LISTYP, IOCC, LISIN2,
     +             LONLI2)
C
C ---  ACQUISITION DE LA LISTE DES NOEUDS SPECIFIEE APRES 
C ---  LE MOT CLE NOEUD_1 (CETTE LISTE EST NON REDONDANTE) :
C      ---------------------------------------------------
       CALL PAMANO(MOTFAC, 'NOEUD_1',NOMA, LISTYP, IOCC, LISIN3,LONLI3)
C
C ---  ACQUISITION DE LA LISTE DES NOEUDS SPECIFIEE APRES 
C ---  LE MOT CLE GROUP_NO_1 (CETTE LISTE EST NON REDONDANTE) :
C      ------------------------------------------------------
       CALL PAMANO(MOTFAC, 'GROUP_NO_1',NOMA, LISTYP, IOCC, LISIN4,
     +             LONLI4)
C
C ---  ACQUISITION DE LA LISTE DES NOEUDS SPECIFIEE APRES 
C ---  LE MOT CLE MAILLE_2 (CETTE LISTE EST NON REDONDANTE) :
C      ---------------------------------------------------- 
       CALL PAMANO(MOTFAC, 'MAILLE_2',NOMA, LISTYP, IOCC, LISIN5,LONLI5)
C
C ---  ACQUISITION DE LA LISTE DES NOEUDS SPECIFIEE APRES 
C ---  LE MOT CLE GROUP_MA_2 (CETTE LISTE EST NON REDONDANTE) :
C      ----------------------------------------------------- 
       CALL PAMANO(MOTFAC, 'GROUP_MA_2',NOMA, LISTYP, IOCC, LISIN6,
     +             LONLI6)
C
C ---  ACQUISITION DE LA LISTE DES NOEUDS SPECIFIEE APRES 
C ---  LE MOT CLE NOEUD_2 (CETTE LISTE EST NON REDONDANTE) :
C      ---------------------------------------------------
       CALL PAMANO(MOTFAC, 'NOEUD_2',NOMA, LISTYP, IOCC, LISIN7,LONLI7)
C
C ---  ACQUISITION DE LA LISTE DES NOEUDS SPECIFIEE APRES 
C ---  LE MOT CLE GROUP_NO_2 (CETTE LISTE EST NON REDONDANTE) :
C      ------------------------------------------------------
       CALL PAMANO(MOTFAC, 'GROUP_NO_2',NOMA, LISTYP, IOCC, LISIN8,
     +             LONLI8)
C
C ---  CONCATENATION DES LISTES DESTINEES A CONSTITUER LA PREMIERE  
C ---  LISTE DE NOEUDS A METTRE EN VIS A VIS DANS LE CAS
C ---  OU ELLES EXISTENT :
C      -----------------
       IF (LONLI1.NE.0) THEN
        CALL COCALI(LISFI1,LISIN1,'K8')
       ENDIF
       IF (LONLI2.NE.0) THEN
        CALL COCALI(LISFI1,LISIN2,'K8')
       ENDIF
       IF (LONLI3.NE.0) THEN
        CALL COCALI(LISFI1,LISIN3,'K8')
       ENDIF
       IF (LONLI4.NE.0) THEN
        CALL COCALI(LISFI1,LISIN4,'K8')
       ENDIF
C
C ---  CONCATENATION DES LISTES DESTINEES A CONSTITUER LA SECONDE  
C ---  LISTE DE NOEUDS A METTRE EN VIS A VIS DANS LE CAS
C ---  OU ELLES EXISTENT :
C      -----------------
       IF (LONLI5.NE.0) THEN
        CALL COCALI(LISFI2,LISIN5,'K8')
       ENDIF
       IF (LONLI6.NE.0) THEN
        CALL COCALI(LISFI2,LISIN6,'K8')
       ENDIF
       IF (LONLI7.NE.0) THEN
        CALL COCALI(LISFI2,LISIN7,'K8')
       ENDIF
       IF (LONLI8.NE.0) THEN
        CALL COCALI(LISFI2,LISIN8,'K8')
       ENDIF
C
C --- VERIFICATION DE LA CONSTITUTION DES LISTES DE NOEUDS A METTRE
C --- EN VIS A VIS :
C     ------------
       CALL JEEXIN(LISFI1,IRET1)
       IF (IRET1.EQ.0) THEN
        CALL UTMESS('F','CALICP','LA PREMIERE LISTE DE NOEUDS DONT '
     +            //'ON DOIT FAIRE LE VIS A VIS N''EXISTE PAS.')
       ENDIF
       CALL JEEXIN(LISFI2,IRET2)
       IF (IRET2.EQ.0) THEN
        CALL UTMESS('F','CALICP','LA SECONDE LISTE DE NOEUDS DONT '
     +            //'ON DOIT FAIRE LE VIS A VIS N''EXISTE PAS.')
       ENDIF
       CALL JELIRA(LISFI1, 'LONMAX', LONFI1, K1BID)
       CALL JELIRA(LISFI2, 'LONMAX', LONFI2, K1BID)
       IF (LONFI1.EQ.0) THEN
        CALL UTMESS('F','CALICP','LA PREMIERE LISTE DE NOEUDS DONT '
     +            //'ON DOIT FAIRE LE VIS A VIS EST VIDE.')
       ENDIF
       IF (LONFI2.EQ.0) THEN
        CALL UTMESS('F','CALICP','LA SECONDE LISTE DE NOEUDS DONT '
     +            //'ON DOIT FAIRE LE VIS A VIS EST VIDE.')
       ENDIF
C
C ---  ELIMINATION DES DOUBLONS DE LISFI1 ET LISFI2 :
C      ============================================
       CALL JEVEUO(LISFI1, 'E', IDLFI1)
       CALL JEVEUO(LISFI2, 'E', IDLFI2)
C
C ---  CREATION ET AFFECTATION D'UN TABLEAU D'INDICES DISANT POUR UN 
C ---  NOEUD S'IL EST DEJA APPARU DANS LA LISTE OU NON :
C      -----------------------------------------------
       CALL JEEXIN('&&CALICP.INDIC1',IRET1)
       IF (IRET1.NE.0) THEN
         CALL JEDETR('&&CALICP.INDIC1')
       ENDIF
       CALL JEEXIN('&&CALICP.INDIC2',IRET2)
       IF (IRET2.NE.0) THEN
         CALL JEDETR('&&CALICP.INDIC2')
       ENDIF
C
       CALL WKVECT ('&&CALICP.INDIC1','V V I',LONFI1,JIND1)
C
       DO 30 INO = 1, LONFI1
          DO 40 IN1 = INO+1, LONFI1
                IF (ZK8(IDLFI1+IN1-1).EQ.ZK8(IDLFI1+INO-1)) THEN
                      ZI(JIND1+IN1-1) = 1
                ENDIF
 40       CONTINUE
 30     CONTINUE
C
       INDLIS = 0
       DO 50 INO = 1, LONFI1
         IF (ZI(JIND1+INO-1).EQ.0) THEN
              INDLIS = INDLIS + 1
              ZK8(IDLFI1+INDLIS-1) = ZK8(IDLFI1+INO-1)
         ENDIF
 50    CONTINUE
C
      LONFI1 = INDLIS
C
C ---  CREATION ET AFFECTATION D'UN TABLEAU D'INDICES DISANT POUR UN 
C ---  NOEUD S'IL EST DEJA APPARU DANS LA LISTE OU NON :
C      -----------------------------------------------
       CALL WKVECT ('&&CALICP.INDIC2','V V I',LONFI2,JIND2)
C
       DO 60 INO = 1, LONFI2
          DO 70 IN1 = INO+1, LONFI2
                IF (ZK8(IDLFI2+IN1-1).EQ.ZK8(IDLFI2+INO-1)) THEN
                      ZI(JIND2+IN1-1) = 1
                ENDIF
 70       CONTINUE
 60    CONTINUE
C
       INDLIS = 0
       DO 80 INO = 1, LONFI2
         IF (ZI(JIND2+INO-1).EQ.0) THEN
              INDLIS = INDLIS + 1
              ZK8(IDLFI2+INDLIS-1) = ZK8(IDLFI2+INO-1)
         ENDIF
 80    CONTINUE
C
       LONFI2 = INDLIS
C
       IF (LONFI1.NE.LONFI2) THEN
        CALL UTMESS('F','CALICP','IMPOSSIBILITE DE FAIRE LE VIS A VIS'
     +            //' DES 2 LISTES DE NOEUDS, ELLES N''ONT PAS LE '
     +            //'MEME NOMBRE DE NOEUDS APRES ELIMINATION DES '
     +            //'DOUBLONS.')
       ENDIF
C
C ---  MISE EN VIS-A-VIS DES NOEUDS DES 2 LISTES DE NOEUDS LISFI1 ET 
C ---  LISFI2. LES LISTES REARRANGEES SONT LISOU1 ET LISOU2 :
C      ----------------------------------------------------
       CALL PACOAP(LISFI1,LISFI2,LONFI1,CENTRE,THETA,T,NOMA,LISOU1,
     +             LISOU2)
C
C ---  CREATION DES RELATIONS LINEAIRES TRADUISANT UN MOUVEMENT 
C ---  DE CORPS SOLIDE PAR COUPLE DE NOEUDS DES NOEUDS DES LISTES
C ---  LISOU1 ET LISOU2 :
C      ----------------
       CALL JEVEUO(LISOU1, 'L', IDLOU1)
       CALL JEVEUO(LISOU2, 'L', IDLOU2)
C
       DO 90 ICOUPL = 1, LONFI1
         ZK8(IDLINO+1-1) = ZK8(IDLOU1+ICOUPL-1)
         ZK8(IDLINO+2-1) = ZK8(IDLOU2+ICOUPL-1)
         IF (NDIMMO.EQ.2) THEN
           CALL DRZ12D (LISNOE ,2, CHARGE, TYPLAG, LISREL)
         ELSEIF (NDIMMO.EQ.3) THEN
           CALL DRZ13D (LISNOE ,2, CHARGE, TYPLAG, LISREL)
         ENDIF
  90   CONTINUE
C
 20   CONTINUE
C
C --- AFFECTATION DE LA LISTE_RELA A LA CHARGE :
C     ----------------------------------------
      CALL AFLRCH(LISREL,CHARGE)
C
      CALL JEDETC('V','&&CALICP',1)
99999 CONTINUE
      CALL JEDEMA()
      END
