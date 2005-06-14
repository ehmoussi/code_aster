      SUBROUTINE CALPIM ( GRAEXC, EXCMOD, NAPEXC, NBMODE, TYMMEC, 
     +                    MTRMAS, NUMER, NBDDL, NOEXIT, CPEXIT, NVASEX,
     +                    VECASS  )
      IMPLICIT   NONE
      INTEGER             NAPEXC, NBMODE, NBDDL, NVASEX
      CHARACTER*4         EXCMOD
      CHARACTER*8         MTRMAS, NUMER, TYMMEC, VECASS(*), NOEXIT(*),
     +                    CPEXIT(*)
      CHARACTER*16        GRAEXC
C-----------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/12/97   AUTEUR CIBHHLV L.VIVAN 
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
C  BUT:CALCUL DES COEFFICIENTS DE PARTICIPATION P:I,M  POUR
C        LE CALCUL DYNAMIQUE ALEATOIRE
C
C-----------------------------------------------------------------------
C IN  : GRAEXC : GRANDEUR EXCITATION
C IN  : EXCMOD : L'EXCITATION EST DE TYPE MODALE
C IN  : NAPEXC : NOMBRE D APPUIS (NOEUDS OU VECTEURS ASSEMBLES
C IN  : NBMODE : NOMBRE DE MODES DYNAMIQUES
C IN  : TYMMEC : TYPE R OU C DES VALEURS DU MODE MECA
C IN  : MTRMAS : MATRICE DE MASSE
C IN  : NUMER  : CONCEPT NUMEROTATION
C IN  : NBDDL  : NOMBRE DE DDL
C IN  : NOEXIT : NOMS DES NOEUDS APPUIS
C IN  : CPEXIT : NOMS DES DDLS  APPUIS
C IN  : NVASEX : NOMBRE DE VECTEURS ASSEMBLES
C IN  : VECASS : NOMS DES VECTEURS ASSEM  APPUIS
C-----------------------------------------------------------------------
C-------- DEBUT COMMUNS NORMALISES  JEVEUX  ----------------------------
      INTEGER         ZI
      COMMON  /IVARJE/ZI(1)      
      REAL*8          ZR
      COMMON  /RVARJE/ZR(1)
      COMPLEX*16      ZC
      COMMON  /CVARJE/ZC(1)
      LOGICAL         ZL
      COMMON  /LVARJE/ZL(1)
      CHARACTER*8     ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                     ZK24
      CHARACTER*32                              ZK32
      CHARACTER*80                                       ZK80
      COMMON  /KVARJE/ZK8(1), ZK16(1), ZK24(1), ZK32(1), ZK80(1)
C----------  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
      INTEGER      IADPIM, ITRAV1, IAD, IADRMG, ILAMOD, IRET, ILAMST, I,
     +             IBID, IDLRE1, IAD1, I4, I3, I2, I1
      REAL*8       VALFI
      CHARACTER*8  VEASS1
C     ------------------------------------------------------------------
C
      CALL JEMARQ()
C
      CALL WKVECT ( '&&OP0131.PIM'  ,'V V R8',NAPEXC*NBMODE, IADPIM )
      CALL WKVECT ( '&&OP0131.TRAV1','V V R8',NBDDL        , ITRAV1 )
C
      CALL JEVEUO ( '&&OP0131.MASSEGENE'  , 'E', IADRMG )
      CALL JEVEUO ( '&&OP0131.LISTADRMODE', 'E', ILAMOD )
      CALL JEEXIN ( '&&OP0131.LISTADRMODSTA', IRET )
      IF (IRET.GT.0) CALL JEVEUO('&&OP0131.LISTADRMODSTA','E', ILAMST )
C
      CALL MTDSCR ( MTRMAS )
      CALL JEVEUO ( MTRMAS//'           .&INT','E', IAD )
C
C  POUR OBTENIR JUSTE LA MATRICE DIAGONALE DES INVERSES
C  DES MASSES GENERALISEES, EXCITATION MODALE
C
      IF ( EXCMOD .EQ. 'OUI' ) THEN
         DO 12 I = 1,NBMODE
            ZR(IADPIM+(I-1)*NBMODE+I-1) = 1.D0 / ZR(IADRMG+I-1)
 12      CONTINUE
         GOTO 9999
      ENDIF

      DO 233 I1 = 1 , NAPEXC
C
         IF ( GRAEXC .EQ. 'DEPL_R' ) THEN
            CALL MRMULT ( 'ZERO',IAD, ZR(ZI(ILAMST+I1-1)), 'R',
     &                                ZR(ITRAV1), 1 )
         ELSEIF ( NVASEX .EQ. 0 ) THEN
            CALL POSDDL ( 'NUME_DDL', NUMER, NOEXIT(I1),
     &                                CPEXIT(I1), IBID, IDLRE1 )
            ZR(ITRAV1-1+IDLRE1)=1
         ELSE
            VEASS1 = VECASS(I1)
            CALL JEVEUO(VEASS1//'           .VALE','L', IAD1 )
            DO 237 I4 = 1,NBDDL
               ZR(ITRAV1-1+I4)=ZR(IAD1-1+I4)
 237        CONTINUE
         ENDIF
C
         DO 234 I2 = 1 , NBMODE
            IBID = IADPIM+(I1-1)*NBMODE+I2-1
            ZR(IBID) = 0
            IF ( (GRAEXC.EQ.'DEPL_R') .OR. (NVASEX.NE.0) ) THEN
               DO 235,I3=1,NBDDL
                  IF ( TYMMEC .EQ. 'R' ) THEN
                     VALFI = ZR(ZI(ILAMOD+I2-1)+I3-1)
                  ELSEIF ( TYMMEC .EQ. 'C' ) THEN
                     VALFI = DBLE(ZC(ZI(ILAMOD+I2-1)+I3-1))
                  ENDIF
                  ZR(IBID) = ZR(IBID) + ZR(ITRAV1+I3-1)*VALFI
  235          CONTINUE
            ELSE
               IF ( TYMMEC .EQ. 'R' ) THEN
                  VALFI = ZR(ZI(ILAMOD+I2-1)+IDLRE1-1)
               ELSEIF ( TYMMEC .EQ. 'C' ) THEN
                  VALFI = DBLE(ZC(ZI(ILAMOD+I2-1)+IDLRE1-1))
               ENDIF
               ZR(IBID) = VALFI
            ENDIF
            ZR(IBID) = ZR(IBID) / ZR(IADRMG+I2-1)
  234    CONTINUE
  233 CONTINUE
C
 9999 CONTINUE
      CALL JEDEMA()
      END
