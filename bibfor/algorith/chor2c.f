      SUBROUTINE CHOR2C(LICHNO)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 16/12/2004   AUTEUR VABHHTS J.PELLET 
C ======================================================================
C COPYRIGHT (C) 1991 - 2002  EDF R&D                  WWW.CODE-ASTER.ORG
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
C                                                                       
C                                                                       
C ======================================================================
C RESPONSABLE CAMBIER S.CAMBIER
C ----------------------------------------------------------------------
C      TRANSFORMATION D'UNE COLLECTION DE CHAM_NO A VALEURS REELLES EN
C      UNE COLLECTION DE CHAM_NO A VALEURS COMPLEXES AVEC PARTIE
C      IMAGINAIRE NULLE 
C     ------------------------------------------------------------------
C
C     IN / OUT : LICHNO : LISTE DES CHAMNO A MODIFIER, LE NOM DE LA SD
C                          RESTE LE MEME
C
C     ------------------------------------------------------------------

      IMPLICIT NONE

C 0.1. ==> ARGUMENTS
      CHARACTER*24 LICHNO

C 0.2. ==> COMMUNS
C     ----- DEBUT DES COMMUNS JEVEUX -----------------------------------
      INTEGER          ZI
      COMMON  /IVARJE/ ZI(1)
      REAL*8           ZR
      COMMON  /RVARJE/ ZR(1)
      COMPLEX*16       ZC
      COMMON  /CVARJE/ ZC(1)
      LOGICAL          ZL
      COMMON  /LVARJE/ ZL(1)
      CHARACTER*8      ZK8
      CHARACTER*16            ZK16
      CHARACTER*24                    ZK24
      CHARACTER*32                            ZK32
      CHARACTER*80                                    ZK80
      COMMON  /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
      CHARACTER*32  JEXNUM
C     ----- FIN DES COMMUNS JEVEUX -------------------------------------

C 0.3. ==> VARIABLES LOCALES
C
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'CHOR2C' )

      CHARACTER*19  CHAMNO
      CHARACTER*8   K8B

      INTEGER    IRET, JVEC, K, JCN, KVALE, IVALE
      INTEGER    NBVEC, NBVDIM, NBVALE

C ----------------------------------------------------------------------
C 1.0  ==> DEBUT

      CALL JEMARQ() 
 
      CALL JEEXIN(LICHNO,IRET)
      IF (IRET.EQ.0) CALL UTMESS('F',NOMPRO,'LA LISTE DES ' //
     &                     'CHAM_NO N''EXISTE PAS')
       
      CALL JELIRA(LICHNO,'LONMAX',NBVEC,K8B)
      IF (NBVEC.EQ.0) CALL UTMESS('F',NOMPRO,'IL N''Y A ' //
     &                      'AUCUN CHAM_NO DANS LA LISTE')

C  DIMENSIONNEMENT SD DE SAUVEGARDE
      CALL JEVEUO(LICHNO,'L',JVEC)
      CHAMNO = ZK24(JVEC) (1:19)
      CALL JELIRA(CHAMNO//'.VALE','LONMAX',NBVDIM,K8B)
      CALL WKVECT('&&'//NOMPRO//'.COPIE_TRAVAIL','V V R',
     &                                       NBVDIM,KVALE)

C -- BOUCLES SUR LES CHAMNO
      DO 10 K = 1,NBVEC  

        CHAMNO = ZK24(JVEC+K-1) (1:19)  
        CALL JEVEUO(CHAMNO//'.VALE','L',JCN)
        CALL JELIRA(CHAMNO//'.VALE','LONMAX',NBVALE,K8B)
        
        IF (NBVDIM.NE.NBVALE) CALL UTMESS('F',NOMPRO,      
     &           'LES CHAM_NO N''ONT PAS TOUS LA MEME LONGUEUR')

C       SAUVEGARDE DES VALEURS
        CALL DCOPY(NBVALE,ZR(JCN),1,ZR(KVALE),1)
        
C       DESTRUCTION CHAMNO A VALEURS REELLES        
        CALL JEDETR(CHAMNO//'.VALE')
        
C       CREATION CHAMNO A VALEURS COMPLEXES        
        CALL WKVECT(CHAMNO//'.VALE','V V C',NBVALE,JCN)
        DO 20 IVALE=1,NBVALE
          ZC(JCN+IVALE-1) = DCMPLX(ZR(KVALE+IVALE-1),0.D0)
20      CONTINUE

C       CHANGEMENT DE LA REFERNCE A LA GRANDEUR
        CALL SDCHGD(CHAMNO,'C')

10    CONTINUE
C --
      CALL JEDETR('&&'//NOMPRO//'.COPIE_TRAVAIL')
      
C FIN ------------------------------------------------------------------
      CALL JEDEMA()      
      END
