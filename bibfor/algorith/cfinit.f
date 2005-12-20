      SUBROUTINE CFINIT(DEFICO,NUMEDD,CTCDIS,REINCR,
     &                  NUMINS,NEQ,AUTOC1,AUTOC2,
     &                  VECONT,LREAC)
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
C RESPONSABLE MABBAS M.ABBAS
C
      IMPLICIT     NONE
      CHARACTER*24 DEFICO
      CHARACTER*24 NUMEDD
      LOGICAL      CTCDIS
      INTEGER      REINCR
      INTEGER      NUMINS
      INTEGER      NEQ
      CHARACTER*19 AUTOC1
      CHARACTER*19 AUTOC2
      INTEGER      VECONT(2)
      LOGICAL      LREAC(2)
C
C ======================================================================
C ROUTINE APPELEE PAR : OP0070
C ======================================================================
C
C INITIALISATION DES PARAMETRES DE CONTACT POUR LA REACTUALISATION
C GEOMETRIQUE
C
C IN  NUMINS : NUMERO D'INSTANT
C IN  NEQ    : NOMBRE D'EQUATIONS
C IN  CTCDIS : FLAG POUR CONTACT DISCRET (CORRESPOND A FONACT(4))
C IN  DEFICO : SD DE DEFINITION DU CONTACT (ISSUE D'AFFE_CHAR_MECA)
C IN  NUMEDD : NUME_DDL DE LA MATRICE TANGENTE GLOBALE
C IN  NOMA   : NOM DU MAILLAGE
C IN  REINCR : VALEUR DE REACTUALISATION DE LA MATRICE TANGENTE 
C                REAC_INCR
C IN  DEPPLU : CHAMP DE DEPLACEMENTS A L'ITERATION DE NEWTON PRECEDENTE
C IN  DEPDEL : INCREMENT DE DEPLACEMENT CUMULE
C IN  DEPPLA : INCREMENT DE DEPLACEMENTS CALCULE EN IGNORANT LE CONTACT
C IN  AUTOC1 : NOM DE L'OBJET JEVEUX POUR LA REACTUALISATION
C               GEOMETRIQUE AUTOMATIQUE (NOM LIE A OP0069/OP0070)
C IN  AUTOC2 : NOM DE L'OBJET JEVEUX POUR LA REACTUALISATION
C               GEOMETRIQUE AUTOMATIQUE (NOM LIE A OP0069/OP0070)
C I/O VECONT : (1) = NOMBRE DE REACTUALISATION GEOMETRIQUE A EFFECTUER
C                     / -1 SI AUTOMATIQUE             
C                     /  0 SI PAS DE REACTUALISATION  
C                     /  N REACTUALISATIONS  
C              (2) = NOMBRE DE REACTUALISATIONS GEOMETRIQUES EFFECTUEES
C OUT LREAC  : (1) = TRUE  SI REACTUALISATION A FAIRE 
C              (2) = TRUE  SI ATTENTE POINT FIXE CONTACT
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
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
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      ZMETH
      PARAMETER    (ZMETH=8)
      INTEGER      II,IBID,JAUTO1,JAUTO2,IZONE,MATTAN
      CHARACTER*24 METHCO
      INTEGER      JMETH
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ ()
C
C --- AUTORISATION DE DESTRUCTION DE LA MATRICE TANGENTE (VOIR NMASFR)
C
      IF (REINCR.EQ.0) THEN
        CALL CFDISC(DEFICO,'              ',IBID,IBID,IBID,MATTAN)
          IF (MATTAN.EQ.1) THEN
            CALL UTMESS('F','INICNT',
     &                'NE PAS UTILISER REAC_INCR=0 AVEC LE FROTTEMENT')
          ENDIF
      ENDIF
C
C --- INITIALISATIONS
C
      IZONE    = 1 
      LREAC(1) = .FALSE.
      LREAC(2) = .FALSE.

      IF (CTCDIS) THEN
         METHCO    = DEFICO (1:16)//'.METHCO'
         CALL  JEVEUO(METHCO,'L',JMETH)
C ======================================================================
C --- PARAMETRES DE REACTUALISATION GEOMETRIQUE 
C ======================================================================
         VECONT(1) = ZI(JMETH+ZMETH*(IZONE-1)+7)
         VECONT(2) = 0
         LREAC(1)  = .TRUE.
         CALL JEEXIN(AUTOC1//'.VALE', IBID)
         IF (IBID.EQ.0) THEN
           CALL VTCREB(AUTOC1,NUMEDD,'V','R',NEQ)
           CALL VTCREB(AUTOC2,NUMEDD,'V','R',NEQ)
           CALL JEVEUO(AUTOC1//'.VALE','E',JAUTO1)
           CALL JEVEUO(AUTOC2//'.VALE','E',JAUTO2)
         ELSE
           CALL JEVEUO(AUTOC1//'.VALE','E',JAUTO1)
           CALL JEVEUO(AUTOC2//'.VALE','E',JAUTO2)
         ENDIF
         DO 10 II = 1, NEQ
           ZR(JAUTO1-1+II) = 0.0D0
           ZR(JAUTO2-1+II) = 0.0D0
10       CONTINUE
C ======================================================================
C --- PAS DE REACTUALISATION GEOMETRIQUE 
C ======================================================================
         IF (VECONT(1).EQ.0) THEN
            IF (NUMINS.NE.1) THEN
               LREAC(1) = .FALSE.
            ENDIF
         ENDIF
      ENDIF
C ======================================================================
      CALL JEDEMA ()

      END
