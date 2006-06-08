      SUBROUTINE CNSRED(CNS1Z,NBNO,LINO,NBCMP,LICMP,BASE,CNS2Z)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF CALCULEL  DATE 27/08/2001   AUTEUR JMBHH01 J.M.PROIX 
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
C A_UTIL
      IMPLICIT NONE
      CHARACTER*(*) CNS1Z,CNS2Z,BASE
      INTEGER NBNO,NBCMP,LINO(NBNO)
      CHARACTER*(*) LICMP(NBCMP)
C ---------------------------------------------------------------------
C BUT: REDUIRE UN CHAM_NO_S SUR UN ENSEMBLE DE NOEUDS ET DE COMPOSANTES
C ---------------------------------------------------------------------
C     ARGUMENTS:
C CNS1Z   IN/JXIN  K19 : SD CHAM_NO_S A REDUIRE
C CNS2Z   IN/JXOUT K19 : SD CHAM_NO_S REDUITE
C BASE    IN       K1  : BASE DE CREATION POUR CNS2Z : G/V/L
C NBNO    IN        I   : NOMBRE DE NOEUDS DE LINO
C                         SI NBNO=0 : ON NE REDUIT PAS SUR LES NOEUDS
C LINO    IN        L_I : LISTE DES NUMEROS DE NOEUDS SUR LESQUELS
C                         ON VEUT REDUIRE LE CHAM_NO_S
C NBCMP   IN        I   : NOMBRE DE CMPS DE LICMP
C                         SI NBCMP=0 : ON NE REDUIT PAS SUR LES CMPS
C LICMP   IN        L_K8: LISTE DES NOMS DES CMPS SUR LESQUELLES
C                         ON VEUT REDUIRE LE CHAM_NO_S
C         SI NBCMP > 0 LES CMP DU CHAM_NO_S REDUIT SONT DANS L'ORDRE 
C         DE LICMP. SINON ELLES SONT DANS L'ORDRE DE CNS1Z

C REMARQUES :
C  - POUR REDUIRE SUR LES NOEUDS (ET GARDER TOUTES LES CMPS)
C        NBCMP=0 LICMP= KBID
C  - POUR REDUIRE SUR LES CMPS (ET GARDER TOUS LES NOEUDS)
C        NBNO=0 LINO= IBID
C  - SI NBCMP=0 ET NBNO=0 : CNS2Z=CNS1Z

C  - ON PEUT APPELER CETTE ROUTINE AVEC CNS2Z=CNS1Z
C    LA SD INITIALE (CNS1Z) EST ALORS PERDUE.

C-----------------------------------------------------------------------

C---- COMMUNS NORMALISES  JEVEUX
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
C     ------------------------------------------------------------------
      INTEGER JCN1K,JCN1D,JCN1V,JCN1L,JCN1C,NBNOM,NCMP2,JEXNO,KNO,ICMP2
      INTEGER JCN2D,JCN2V,JCN2L,JCN2C
      INTEGER IBID
      INTEGER NCMPMX,NCMP1,ICMP1
      INTEGER INO,INDIK8
      CHARACTER*1 KBID
      CHARACTER*8 MA,NOMGD,NOCMP
      CHARACTER*3 TSCA
      CHARACTER*19 CNS1,CNS2
      CHARACTER*32 JEXNOM,JEXNUM
C     ------------------------------------------------------------------
      CALL JEMARQ()


      CNS1 = CNS1Z
      CNS2 = CNS2Z

C     -- POUR NE PAS ECRASER LA SOURCE SI CNS2=CNS1 :
      IF (CNS2.EQ.CNS1) THEN
        CALL COPISD('CHAM_NO_S','V',CNS1,'&&CNSRED.CNS1')
        CNS1 = '&&CNSRED.CNS1'
      END IF


      CALL JEVEUO(CNS1//'.CNSK','L',JCN1K)
      CALL JEVEUO(CNS1//'.CNSD','L',JCN1D)
      CALL JEVEUO(CNS1//'.CNSC','L',JCN1C)
      CALL JEVEUO(CNS1//'.CNSV','L',JCN1V)
      CALL JEVEUO(CNS1//'.CNSL','L',JCN1L)

      MA = ZK8(JCN1K-1+1)
      NOMGD = ZK8(JCN1K-1+2)
      NBNOM = ZI(JCN1D-1+1)
      NCMP1 = ZI(JCN1D-1+2)

      CALL DISMOI('F','TYPE_SCA',NOMGD,'GRANDEUR',IBID,TSCA,IBID)
      CALL DISMOI('F','NB_CMP_MAX',NOMGD,'GRANDEUR',NCMPMX,KBID,IBID)

      IF (NBCMP.LT.0) THEN
        CALL UTMESS('F','CNSRED','NBCMP DOIT ETRE >=0')
      ELSE IF (NBCMP.GT.0) THEN
        NCMP2 = NBCMP
      ELSE
        NCMP2 = NCMP1
      END IF


C     1- CREATION DE CNS2 :
C     ---------------------------------------
      IF (NBCMP.GT.0) THEN
        CALL CNSCRE(MA,NOMGD,NCMP2,LICMP,BASE,CNS2)
      ELSE
        CALL CNSCRE(MA,NOMGD,NCMP2,ZK8(JCN1C),BASE,CNS2)
      END IF
      CALL JEVEUO(CNS2//'.CNSD','L',JCN2D)
      CALL JEVEUO(CNS2//'.CNSC','L',JCN2C)
      CALL JEVEUO(CNS2//'.CNSV','E',JCN2V)
      CALL JEVEUO(CNS2//'.CNSL','E',JCN2L)


C     2- ON TRANSFORME LINO EN LISTE DE BOOLEENS:
C     ------------------------------------------
      CALL WKVECT('&&CNSRED.EXINO','V V L',NBNOM,JEXNO)
      DO 10,KNO = 1,NBNOM
        ZL(JEXNO-1+KNO) = .FALSE.
   10 CONTINUE

      IF (NBNO.LT.0) THEN
        CALL UTMESS('F','CNSRED','NBNO DOIT ETRE >=0')

      ELSE IF (NBNO.EQ.0) THEN
        DO 20,KNO = 1,NBNOM
          ZL(JEXNO-1+KNO) = .TRUE.
   20   CONTINUE

      ELSE
        DO 30,KNO = 1,NBNO
          ZL(JEXNO-1+LINO(KNO)) = .TRUE.
   30   CONTINUE
      END IF




C     3- REMPLISSAGE DES OBJETS .CNSL ET .CNSV :
C     ------------------------------------------

      DO 50,ICMP2 = 1,NCMP2
        NOCMP = ZK8(JCN2C-1+ICMP2)
        ICMP1 = INDIK8(ZK8(JCN1C),NOCMP,1,NCMP1)
        IF (ICMP1.EQ.0) GO TO 50


        DO 40,INO = 1,NBNOM
          IF (ZL(JEXNO-1+INO)) THEN
            IF (ZL(JCN1L-1+ (INO-1)*NCMP1+ICMP1)) THEN
              ZL(JCN2L-1+ (INO-1)*NCMP2+ICMP2) = .TRUE.

              IF (TSCA.EQ.'R') THEN
                ZR(JCN2V-1+ (INO-1)*NCMP2+ICMP2) = ZR(JCN1V-1+
     &            (INO-1)*NCMP1+ICMP1)
              ELSE IF (TSCA.EQ.'C') THEN
                ZC(JCN2V-1+ (INO-1)*NCMP2+ICMP2) = ZC(JCN1V-1+
     &            (INO-1)*NCMP1+ICMP1)
              ELSE IF (TSCA.EQ.'I') THEN
                ZI(JCN2V-1+ (INO-1)*NCMP2+ICMP2) = ZI(JCN1V-1+
     &            (INO-1)*NCMP1+ICMP1)
              ELSE IF (TSCA.EQ.'L') THEN
                ZL(JCN2V-1+ (INO-1)*NCMP2+ICMP2) = ZL(JCN1V-1+
     &            (INO-1)*NCMP1+ICMP1)
              ELSE IF (TSCA.EQ.'K8') THEN
                ZK8(JCN2V-1+ (INO-1)*NCMP2+ICMP2) = ZK8(JCN1V-1+
     &            (INO-1)*NCMP1+ICMP1)
              ELSE
                CALL UTMESS('F','CNSRED','TYPE SCALAIRE INCONNU')
              END IF

            END IF
          END IF

   40   CONTINUE
   50 CONTINUE


C     5- MENAGE :
C     -----------
      CALL JEDETR('&&CNSRED.EXINO')
      IF (CNS1.EQ.'&&CNSRED.CNS1') CALL DETRSD('CHAM_NO_S',CNS1)

      CALL JEDEMA()
      END
