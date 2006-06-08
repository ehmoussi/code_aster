      SUBROUTINE IMPTIT(IMPRCO,TITMAX,LIGMAX,LARMAX,LARGE,NBCOL,
     &                  COLONN,TITRE)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 24/08/2005   AUTEUR MABBAS M.ABBAS 
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
C
      IMPLICIT      NONE
      CHARACTER*24  IMPRCO
      INTEGER       TITMAX
      INTEGER       LIGMAX
      INTEGER       LARMAX
      INTEGER       LARGE
      INTEGER       NBCOL
      CHARACTER*255 COLONN
      CHARACTER*255 TITRE(TITMAX)
C
C ----------------------------------------------------------------------
C ROUTINE APPELEE PAR : NMIMPR 
C ----------------------------------------------------------------------
C
C PREPARATION DE LA LIGNE DE TITRE POUR LE TABLEAU DE CONVERGENCE
C 
C IN  IMPRCO : SD SUR L'AFFICHAGE DES COLONNES       
C IN  TITMAX : NOMBRE MAXI DE LIGNES D'UN TITRE 
C IN  LIGMAX : LARGEUR MAXI D'UNE LIGNE  
C IN  LARMAX : LARGEUR MAXI D'UNE COLONNE
C IN  LARGE  : LARGEUR TOTALE DE LA LIGNE
C IN  NBCOL  : NOMBRE DE COLONNES ACTIVES
C IN  COLONN : COLONNES DU TABLEAU DE CONVERGENCE
C OUT TITRE  : LIGNES DE TITRE
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
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
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      INTEGER      POS,ICOL,ICOD,IBID,K,ISUI,NBSUIV
      CHARACTER*16 TITCOL(TITMAX)
      CHARACTER*1  FOR1
      CHARACTER*24 SUIVCO
      CHARACTER*24 IMPSUI
      INTEGER      JIMPSU
      CHARACTER*24 SUICHA,SUICOM,SUICNP,SUINOE,SUIVMA,SUIPOI
      INTEGER      KCHAM,KCOMP,KNUCM,KNOEU,KMAIL,KPOIN
      CHARACTER*24 SUICNT,SUIINF
      INTEGER      KNUCT,KINFO
C
C ----------------------------------------------------------------------
C
      IF (LARMAX.NE.16) THEN
         CALL UTMESS('F','IMPTIT',
     &     'ERREUR SUR LARGEUR COLONNE (DVLP)')
      ENDIF
C
C --- SPECIAL POUR LE SUIVI
C
      IMPSUI = IMPRCO(1:14)//'SUIVI'
      CALL JEVEUO(IMPSUI,'L',JIMPSU)
      SUIVCO = ZK24(JIMPSU-1+1)

      SUIINF = SUIVCO(1:14)//'.INFO'
      CALL JEVEUO(SUIINF,'L',KINFO)
      NBSUIV = ZI(KINFO)

      IF (NBSUIV.NE.0) THEN
        SUICHA = SUIVCO(1:14)//'.NOM_CHAM'
        SUICOM = SUIVCO(1:14)//'.NOM_CMP'
        SUICNP = SUIVCO(1:14)//'.NUME_CMP'
        SUICNT = SUIVCO(1:14)//'.TYPE_CMP'
        SUINOE = SUIVCO(1:14)//'.NOEUD'
        SUIVMA = SUIVCO(1:14)//'.MAILLE'
        SUIPOI = SUIVCO(1:14)//'.POINT'
        CALL JEVEUO(SUICHA,'L',KCHAM)
        CALL JEVEUO(SUICOM,'L',KCOMP)
        CALL JEVEUO(SUICNP,'L',KNUCM)
        CALL JEVEUO(SUICNT,'L',KNUCT)
        CALL JEVEUO(SUINOE,'L',KNOEU)
        CALL JEVEUO(SUIVMA,'L',KMAIL)
        CALL JEVEUO(SUIPOI,'L',KPOIN)
      ENDIF
C
C --- LIGNES DE TITRE
C
      POS = 2
      DO 30 ICOL = 1,NBCOL
        CALL IMPSDA(IMPRCO(1:14),'LIRE',ICOL,
     &              ICOD,TITCOL,IBID,
     &              IBID,IBID,IBID,IBID)
        IF (TITCOL(1)(1:1).EQ.'&') THEN
           IF (TITCOL(1)(2:2).EQ.'1') THEN
             ISUI = 1
           ELSE IF (TITCOL(1)(2:2).EQ.'2') THEN
             ISUI = 2
           ELSE IF (TITCOL(1)(2:2).EQ.'3') THEN
             ISUI = 3
           ELSE IF (TITCOL(1)(2:2).EQ.'4') THEN
             ISUI = 4
           ELSE 
             CALL UTMESS('F','IMPTIT',
     &        'NUMERO SUIVI INCORRECT (DVLP)')
           ENDIF

           IF (NBSUIV.LT.ISUI) THEN
             CALL UTMESS('F','IMPTIT',
     &        'COLONNE DE SUIVI ACTIVEE SANS SUIVI ASSOCIE (DVLP)')
           ENDIF

           TITRE(1)                     = COLONN(1:LARGE)
           TITRE(1)(POS:POS+(LARMAX-1)) = ZK16(KCOMP-1+ISUI)

           IF (ZI(KNUCT-1+ICOL).EQ.1) THEN
             TITRE(2)                     = COLONN(1:LARGE)
             TITRE(2)(POS:POS+(LARMAX-1)) = ZK8(KNOEU-1+ISUI)
           ELSE IF (ZI(KNUCT-1+ICOL).EQ.2) THEN
             TITRE(2)                     = COLONN(1:LARGE)
             TITRE(2)(POS:POS+(LARMAX-1)) = ZK8(KMAIL-1+ISUI)
             TITRE(3)                     = COLONN(1:LARGE)
             WRITE(FOR1,'(I1)') ZI(KPOIN-1+ISUI)
             TITRE(3)(POS:POS+(LARMAX-1)) = 'SOUS-POINT '//FOR1
           ELSE
             CALL UTMESS('F','IMPTIT',
     &        'TYPE DE COMPOSANTE SUIVI INCORRECTE (DVLP)')
           ENDIF
            
           DO 31 K = 4,TITMAX
             TITRE(K)                     = COLONN(1:LARGE)
 31        CONTINUE
        ELSE         
           DO 32 K = 1,TITMAX
             TITRE(K)                     = COLONN(1:LARGE)
             TITRE(K)(POS:POS+(LARMAX-1)) = TITCOL(K)
 32        CONTINUE
        ENDIF
        POS = POS+LARMAX+1
 30   CONTINUE

    

      END
