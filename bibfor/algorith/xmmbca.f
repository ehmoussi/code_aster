      SUBROUTINE XMMBCA(MA,MODELE,DEFICO,OLDGEO,DEPPLU,DEPMOI,INCOCA)

C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 11/10/2005   AUTEUR VABHHTS J.PELLET 
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
C RESPONSABLE VABHHTS J.PELLET
C
      IMPLICIT NONE
C
      INTEGER       INCOCA
      CHARACTER*8   MA,MODELE
      CHARACTER*24  DEFICO,OLDGEO,DEPPLU,DEPMOI

C ----------------------------------------------------------------------
C                    MISE � JOUR DU STATUT DES POINTS DE CONTACT
C              ET RENVOIE INCOCA (INDICE DE CONVERGENCE DE LA BOUCLE
C                         SUR LES CONTRAINTES ACTIVES)


C IN 
C   MA      : OBJET MAILLAGE
C   MODELE  : OBJET MODELE
C   DEFICO  : DONN�ES DU CONTACT
C   OLDGEO  : G�OM�TRIE
C   DEPPLU  : D�PLACEMENTS ACTUELS
C   DEPMOI  : D�PLACEMENTS � L'�QUILIBRE PR�C�DENT

C OUT
C   INCOCA  : INDICE DE CONVERGENCE DE LA BOUCLE SUR LES C.A.
C   DEFICO  : DONN�ES DU CONTACT AVEC STATUTS MODIFI�S

C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------

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

C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------

      INTEGER       JFISS,IBID,SINCO,JINDIC,IRET,NBMA,JCESD,JCESL,JCESV
      INTEGER       IMA,IAD,JINDCO,I,JCES,NBMA1,NBMA3
      REAL*8        RBID
      COMPLEX*16    CBID
      CHARACTER*8   LPAIN(10),LPAOUT(2),LICMP(2),KBID
      CHARACTER*19  LIGREL,CICOCA,CINDOO,LEVSET,LCHIN(10),LCHOUT(2)
      CHARACTER*19  CES1,CES2,PINTER,AINTER,CFACE,LONCHA
C ----------------------------------------------------------------------

      CALL JEMARQ()

      LIGREL = MODELE//'.MODELE'
      CICOCA = '&&XMMBCA.CICOCA'

C     CR�ATION DU CHAMP ELEM SIMPLE DE SORTIE � 12*5 SS PG 
      CINDOO = '&&XMMBCA.INDOUT'

      LICMP(1) = 'NPG_DYN'
      LICMP(2) = 'NCMP_DYN'
      CALL DISMOI('F','NB_MA_MAILLA',MA,'MAILLAGE',NBMA,KBID,IBID)
      CALL CESCRE('V',CINDOO,'ELEM',MA,'DCEL_I',2,LICMP,-1,-1,-2)
      CALL JEVEUO(CINDOO//'.CESD','L',JCESD)
      CALL JEVEUO(CINDOO//'.CESL','E',JCESL)
      CALL JEVEUO(CINDOO//'.CESV','E',JCESV)
      DO 10,IMA = 1,NBMA
        CALL CESEXI('C',JCESD,JCESL,IMA,1,1,1,IAD)
        IF (IAD.GE.0) CALL UTMESS('F','XMMBCA','STOP1')
        ZL(JCESL-1-IAD) = .TRUE.
        ZI(JCESV-1-IAD) = 60

        CALL CESEXI('C',JCESD,JCESL,IMA,1,1,2,IAD)
        IF (IAD.GE.0) CALL UTMESS('F','XMMBCA','STOP2')
        ZL(JCESL-1-IAD) = .TRUE.
        ZI(JCESV-1-IAD) = 1
 10   CONTINUE

C     RECUPERATION DE LA LEVEL SET NORMALE
C     ET DES DONN�ES TOPOLOGIQUES SUR LES FACETTES
      CALL JEVEUO(MODELE//'.FISS','L',JFISS)
      LEVSET=ZK8(JFISS)//'.LNNO'
      PINTER=ZK8(JFISS)//'.TOPOFAC.PINTER'
      AINTER=ZK8(JFISS)//'.TOPOFAC.AINTER'
      CFACE =ZK8(JFISS)//'.TOPOFAC.CFACE'
      LONCHA=ZK8(JFISS)//'.TOPOFAC.LONCHAM'

C     CREATION DES LISTES DES CHAMPS IN ET OUT
      LPAIN(1) = 'PGEOMER'
      LCHIN(1) = OLDGEO
      LPAIN(2) = 'PDEPL_M'
      LCHIN(2) = DEPMOI
      LPAIN(3) = 'PDEPL_P'
      LCHIN(3) = DEPPLU
      LPAIN(4) = 'PINDCOI'
      LCHIN(4) = DEFICO(1:16)//'.IN'
      LPAIN(5) = 'PLEVSET'
      LCHIN(5) = LEVSET
      LPAIN(6) = 'PPINTER'
      LCHIN(6) = PINTER
      LPAIN(7) = 'PAINTER'
      LCHIN(7) = AINTER
      LPAIN(8) = 'PCFACE'
      LCHIN(8) = CFACE
      LPAIN(9) = 'PLONCHA'
      LCHIN(9) = LONCHA
      LPAIN(10) = 'PDONCO'
      LCHIN(10) = DEFICO(1:16)//'.DO'   

      LPAOUT(1) = 'PINCOCA'
      LCHOUT(1) = CICOCA
      LPAOUT(2) = 'PINDCOO'
      LCHOUT(2) = CINDOO

      CALL CALCUL('S','XCVBCA',LIGREL,10,LCHIN,LPAIN,2,
     &                                   LCHOUT,LPAOUT,'V')

C     ON FAIT SINCO = SOMME DES CICOCA SUR LES �LTS DU LIGREL 
      CALL MESOMM(CICOCA,1,SINCO,RBID,CBID,0,IBID)

      INCOCA=1

C     ON COMPARE SINCO AU NB DE MAILLES DE CONTACT
      CALL JEVEUO(ZK8(JFISS)//'.MAILFISS .INDIC','L',JINDIC)
      NBMA1=ZI(JINDIC+1)
      NBMA3=ZI(JINDIC+5)

      IF (SINCO.LT.(NBMA1+NBMA3)) INCOCA=0
      
C     ON COPIE CINDO DANS DEFICO.IN  
      CALL COPISD('CHAMP_GD','V',LCHOUT(2),DEFICO(1:16)//'.IN')

      CALL JEDEMA()
      END
