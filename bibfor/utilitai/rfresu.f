      SUBROUTINE RFRESU(IER)
      IMPLICIT NONE
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 23/01/2006   AUTEUR NICOLAS O.NICOLAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2006  EDF R&D                  WWW.CODE-ASTER.ORG
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
C     OPERATEUR "RECU_FONCTION"
C     ------------------------------------------------------------------
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
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER NBTROU,NUMER1,L,N1,N2,N3,IRET,IVARI
      INTEGER IER,NM,NGM,NPOINT,NP,NN,NPR,NGN,IBID,IE
      INTEGER NTA,NRES,IFM,NIV,N4,NBNO,NUSP
      REAL*8 EPSI,VALR
      COMPLEX*16 VALC
      CHARACTER*8 K8B,CRIT,MAILLE,NOMA,INTRES
      CHARACTER*8 NOEUD,CMP,NOGMA,NOGNO,NOMGD
      CHARACTER*16 NOMCMD,TYPCON,NOMCHA,NPRESU
      CHARACTER*19 NOMFON,CHAM19,RESU
C SENSIBILITE
      CHARACTER*8  NOPASE
      CHARACTER*19 RESUT,LAFON1
      CHARACTER*24 NORECG
      INTEGER NBPASS,ADRECG,NRPASS
C SENSIBILITE
C     ------------------------------------------------------------------
      CALL JEMARQ()
C
      CALL GETRES(NOMFON,TYPCON,NOMCMD)
      NORECG = '&&'//'RFRESU'//'_RESULTA_GD     '

C --- RECUPERATION DU NIVEAU D'IMPRESSION
      CALL INFMAJ
      CALL INFNIV(IFM,NIV)
C
      CALL GETVTX(' ','CRITERE',0,1,1,CRIT,N1)
      CALL GETVR8(' ','PRECISION',0,1,1,EPSI,N1)
      INTRES = 'NON     '
      CALL GETVTX(' ','INTERP_NUME',0,1,1,INTRES,N1)

      NPOINT = 0
      CMP = ' '
      NOEUD = ' '
      MAILLE = ' '
      NOGMA = ' '
      NOGNO = ' '
      CALL GETVID(' ','MAILLE',0,1,1,MAILLE,NM)
      CALL GETVID(' ','GROUP_MA',0,1,1,NOGMA,NGM)
      CALL GETVIS(' ','SOUS_POINT',0,1,1,NUSP,NP)
      IF (NP.EQ.0) NUSP = 0
      CALL GETVIS(' ','POINT',0,1,1,NPOINT,NP)
      CALL GETVID(' ','NOEUD',0,1,1,NOEUD,NN)
      CALL GETVID(' ','GROUP_NO',0,1,1,NOGNO,NGN)

C     -----------------------------------------------------------------
C                       --- CAS D'UN RESULTAT ---
C     -----------------------------------------------------------------
C
C        --- NOMBRE DE PASSAGES POUR LA SENSIBILITE ---
C
      CALL PSRESE ( ' ', 0, 1, NOMFON, 1,
     >              NBPASS, NORECG, IRET )
C
      IF ( IRET.EQ.0 ) THEN
        CALL JEVEUO ( NORECG, 'L', ADRECG )
      ENDIF

C============ DEBUT DE LA BOUCLE SUR LE NOMBRE DE PASSAGES ============
      CALL GETVID(' ','RESULTAT ',0,1,1,RESUT,NRES)
      DO 60 , NRPASS = 1 , NBPASS
        LAFON1 = '                   '
        LAFON1(1:8) = ZK24(ADRECG+2*NRPASS-2)(1:8)
        NOPASE = ZK24(ADRECG+2*NRPASS-1)(1:8)
        IF (NRES.NE.0) THEN
          IF (NOPASE.EQ.' ') THEN
             RESU = RESUT
           ELSE
             CALL PSRENC ( RESUT, NOPASE, RESU, IRET )
             IF ( IRET.NE.0 ) THEN
               CALL UTMESS ('F', 'OP0090',
     >    'IMPOSSIBLE DE TROUVER LE RESULTAT DERIVE ASSOCIE AU 
     >    RESULTAT '//RESUT//' ET AU PARAMETRE SENSIBLE '//NOPASE)
             ENDIF
          ENDIF

          CALL GETVTX(' ','NOM_PARA_RESU',0,1,1,NPRESU,NPR)
          IF (NPR.NE.0) THEN
            IF (INTRES(1:3).NE.'NON') THEN
              CALL UTMESS('F','OP0090','"INTERP_NUME" INTERDIT POUR '//
     &      'RECUPERER UN PARAMETRE EN FONCTION D''UNE VARIABLE 
     &       D''ACCES.')
            END IF
            CALL FOCRR3(LAFON1,RESU,NPRESU,'G',IRET)
            GO TO 10
          END IF

          CALL GETVTX(' ','NOM_CHAM',0,1,1,NOMCHA,L)
          CALL RSUTNC(RESU,NOMCHA,1,CHAM19,NUMER1,NBTROU)
          IF (NBTROU.EQ.0) CALL UTMESS('F','OP0090',
     &              'AUCUN CHAMP TROUVE POUR L''ACCES '
     &             //NOMCHA)
          CALL DISMOI('F','NOM_MAILLA',CHAM19,'CHAMP',IBID,NOMA,IE)
          CALL DISMOI('F','NOM_GD',CHAM19,'CHAMP',IBID,NOMGD,IE)
          IF (NGN.NE.0) THEN
            CALL UTNONO(' ',NOMA,'NOEUD',NOGNO,NOEUD,IRET)
            IF (IRET.EQ.10) THEN
              CALL UTMESS('F','OP0090','LE GROUP_NO : '//NOGNO//
     &                    'N''EXISTE PAS.')
            ELSE IF (IRET.EQ.1) THEN
              CALL UTDEBM('A','RECU_FONCTION',
     &                    'TROP DE NOEUDS DANS LE GROUP_NO')
              CALL UTIMPK('L','  NOEUD UTILISE: ',1,NOEUD)
              CALL UTFINM()
            END IF
          END IF
          IF (NGM.NE.0) THEN
            CALL UTNONO(' ',NOMA,'MAILLE',NOGMA,MAILLE,IRET)
            IF (IRET.EQ.10) THEN
              CALL UTMESS('F','OP0090','LE GROUP_MA : '//NOGMA//
     &                    'N''EXISTE PAS.')
            ELSE IF (IRET.EQ.1) THEN
              CALL UTDEBM('A','RECU_FONCTION',
     &                    'TROP DE MAILLES DANS LE GROUP_MA')
              CALL UTIMPK('L','  MAILLE UTILISEE: ',1,MAILLE)
              CALL UTFINM()
            END IF
          END IF
          CALL UTCMP1(NOMGD,' ',1,CMP,IVARI)
          IF (INTRES(1:3).EQ.'NON') THEN
            CALL FOCRRS(LAFON1,RESU,'G',NOMCHA,MAILLE,NOEUD,CMP,NPOINT,
     &                  NUSP,IVARI,IRET)
          ELSE
            CALL FOCRR2(LAFON1,RESU,'G',NOMCHA,MAILLE,NOEUD,CMP,
     &                  NPOINT,NUSP,IVARI,IRET)
          END IF
          GO TO 10
        END IF
  10    CONTINUE
        CALL FOATTR(' ',1,LAFON1)
C     --- VERIFICATION QU'ON A BIEN CREER UNE FONCTION ---
C         ET REMISE DES ABSCISSES EN ORDRE CROISSANT
        CALL ORDONN(LAFON1,NOMCMD,0)
C 
  60  CONTINUE
      CALL JEDETR ( NORECG )

      CALL TITRE
      IF (NIV.GT.1) CALL FOIMPR(LAFON1,NIV,IFM,0,K8B)

      CALL JEDEMA()
      END
