      SUBROUTINE LRMMF1 ( FID, NOMAMD,
     >                    NBRFAM, CARAFA,
     >                    NBNOEU, FAMNOE,
     >                    NMATYP, JFAMMA, JNUMTY,
     >                    TABAUX,
     >                    NOMGRO, NUMGRO, NUMENT,
     >                    INFMED, NIVINF, IFM,
     >                    VECGRM, NBCGRM )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 16/11/2009   AUTEUR SELLENET N.SELLENET 
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
C RESPONSABLE GNICOLAS G.NICOLAS
C-----------------------------------------------------------------------
C     LECTURE DU MAILLAGE - FORMAT MED - LES FAMILLES - 1
C     -    -     -                 -         -          -
C-----------------------------------------------------------------------
C
C ENTREES :
C   FID    : IDENTIFIANT DU FICHIER MED
C   NOMAMD : NOM DU MAILLAGE MED
C   NBRFAM : NOMBRE DE FAMILLES POUR CE MAILLAGE
C   NBNOEU : NOMBRE DE NOEUDS
C   FAMNOE : NUMERO DE FAMILLE POUR CHAQUE NOEUD
C   NMATYP : NOMBRE DE MAILLES DU MAILLAGE PAR TYPE DE MAILLES
C   JFAMMA : POUR UN TYPE DE MAILLE, ADRESSE DANS LE TABLEAU DES
C            FAMILLES D'ENTITES
C   JNUMTY : POUR UN TYPE DE MAILLE, ADRESSE DANS LE TABLEAU DES
C            RENUMEROTATIONS
C SORTIES :
C   NOMGRO : COLLECTION DES NOMS DES GROUPES A CREER
C   NUMGRO : COLLECTION DES NUMEROS DES GROUPES A CREER
C   NUMENT : COLLECTION DES NUMEROS DES ENTITES DANS LES GROUPES
C TABLEAUX DE TRAVAIL
C   CARAFA : CARACTERISTIQUES DE CHAQUE FAMILLE
C     CARAFA(1,I) = NOMBRE DE GROUPES
C     CARAFA(2,I) = NOMBRE D'ATTRIBUTS
C     CARAFA(3,I) = NOMBRE D'ENTITES
C   TABAUX :
C DIVERS
C   INFMED : NIVEAU DES INFORMATIONS SPECIFIQUES A MED A IMPRIMER
C   NIVINF : NIVEAU DES INFORMATIONS GENERALES
C   IFM    : UNITE LOGIQUE DU FICHIER DE MESSAGE
C-----------------------------------------------------------------------
C
      IMPLICIT NONE
C
      INTEGER NTYMAX
      PARAMETER (NTYMAX = 53)
C
C 0.1. ==> ARGUMENTS
C
      INTEGER FID 
      INTEGER NBRFAM, CARAFA(3,NBRFAM), NBCGRM
      INTEGER NBNOEU, FAMNOE(NBNOEU)
      INTEGER NMATYP(NTYMAX), JFAMMA(NTYMAX), JNUMTY(NTYMAX)
      INTEGER TABAUX(*)
      INTEGER INFMED
      INTEGER IFM, NIVINF
C
      CHARACTER*(*) NOMGRO, NUMGRO, NUMENT
      CHARACTER*(*) NOMAMD, VECGRM
C
C 0.2. ==> COMMUNS
C     ----- DEBUT COMMUNS NORMALISES  JEVEUX  --------------------------
      INTEGER            ZI
      COMMON  / IVARJE / ZI(1)
      CHARACTER*8        ZK8
      CHARACTER*16                ZK16
      CHARACTER*24                          ZK24
      CHARACTER*32                                    ZK32
      CHARACTER*80                                              ZK80
      COMMON  / KVARJE / ZK8(1) , ZK16(1) , ZK24(1) , ZK32(1) , ZK80(1)
C     -----  FIN  COMMUNS NORMALISES  JEVEUX  --------------------------
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'LRMMF1' )
C
      INTEGER IAUX
      INTEGER RANGFA
      INTEGER ADNOGR, ADVALA
      INTEGER NBGRMX, NBATMX, IBID, NBGRLO, JNOGRL, JNOGRC, JAUX
C
      CHARACTER*80 MK(3)
      CHARACTER*24 VAATFA, NOGRFA, NOGRLO, NOGRCO
C
C     ------------------------------------------------------------------
C
      IF ( NIVINF.GE.2 ) THEN
C
        WRITE (IFM,1001) NOMPRO
 1001 FORMAT( 60('-'),/,'DEBUT DU PROGRAMME ',A)
C
      ENDIF
C
C====
C 1. NOMBRE DE GROUPES ET D'ATTRIBUTS PAR FAMILLE
C====
C
      CALL LRMMF2 ( FID, NOMAMD, NBRFAM,
     >              CARAFA, NBGRMX, NBATMX,
     >              INFMED, NIVINF, IFM )
C
C====
C 2. ON ALLOUE AU MINIMUM A 1 LES LISTES CORRESPONDANT AUX GROUPES
C    ET AUX ATTRIBUTS, POUR QUE TOUT FONCTIONNE BIEN QUAND IL N'Y
C    EN A PAS.
C====
C               12   345678   9012345678901234
      VAATFA = '&&'//NOMPRO//'.VAL_AT_FAM     '
      NOGRFA = '&&'//NOMPRO//'.NOM_GR_FAM     '
C
      IAUX = MAX ( NBGRMX, 1 )
      CALL WKVECT ( NOGRFA, 'V V K80', IAUX, ADNOGR )
C
      IAUX = MAX ( NBATMX, 1 )
      CALL WKVECT ( VAATFA, 'V V I'  , IAUX, ADVALA )
C
C====
C 3. DECODAGE DE CHAQUE FAMILLE
C====
C
      NOGRLO = '&&LRMMF1.NOM_GR_LONG    '
      CALL WKVECT ( NOGRLO, 'V V K80', NBRFAM, IBID )
      NOGRCO = '&&LRMMF1.NOM_GR_COURT   '
      CALL WKVECT ( NOGRCO, 'V V K8', NBRFAM, IBID )
      NBGRLO = 0
      DO 3 , IAUX = 1 , NBRFAM
C
        RANGFA = IAUX
C
        CALL LRMMF3 ( FID, NOMAMD,
     >                RANGFA, CARAFA,
     >                NBNOEU, FAMNOE,
     >                NMATYP, JFAMMA, JNUMTY,
     >                ZI(ADVALA), ZK80(ADNOGR), TABAUX,
     >                NOMGRO, NUMGRO, NUMENT,
     >                INFMED, NIVINF, IFM,
     >                VECGRM, NBCGRM, NBGRLO )
C
    3 CONTINUE
C
      CALL JEVEUO(NOGRLO,'L',JNOGRL)
      CALL JEVEUO(NOGRCO,'L',JNOGRC)
      DO 4 , IAUX = 1 , NBGRLO
        IF ( ZK80(JNOGRL-1+IAUX).NE.ZK8(JNOGRC-1+IAUX) ) THEN
          DO 5 , JAUX = 1, NBGRLO
            IF ( JAUX.EQ.IAUX ) GOTO 5
            IF ( (ZK8(JNOGRC-1+IAUX).EQ.ZK8(JNOGRC-1+JAUX)) .AND.
     &           (ZK80(JNOGRL-1+IAUX).NE.ZK80(JNOGRL-1+JAUX)) ) THEN
              MK(1) = ZK80(JNOGRL-1+IAUX)
              MK(2) = ZK80(JNOGRL-1+JAUX)
              MK(3) = ZK8(JNOGRC-1+IAUX)
              CALL U2MESK('F', 'MED2_1', 3, MK)
            ENDIF
    5     CONTINUE
        ENDIF
    4 CONTINUE
      CALL JEDETR(NOGRLO)
      CALL JEDETR(NOGRCO)
C
C====
C 4. LA FIN
C====
C
      CALL JEDETR ( VAATFA )
      CALL JEDETR ( NOGRFA )
C
      IF ( INFMED.GE.2 ) THEN
C
        WRITE (IFM,4001)
        DO 41 , IAUX = 1 , NBRFAM
          WRITE (IFM,4002) IAUX, CARAFA(1,IAUX),
     >                     CARAFA(2,IAUX), CARAFA(3,IAUX)
   41 CONTINUE
        WRITE (IFM,4003)
C
      ENDIF
 4001 FORMAT(
     >  4X,53('*'),
     >/,4X,'*   RANG DE  *              NOMBRE DE               *',
     >/,4X,'* LA FAMILLE *  GROUPES   * ATTRIBUTS  *   ENTITES  *',
     >/,4X,53('*'))
 4002 FORMAT(4X,'*',I9,'   *',I9,'   *',I9,'   *',I9,'   *')
 4003 FORMAT(4X,53('*'))
C
      IF ( NIVINF.GE.2 ) THEN
        WRITE (IFM,4000) NOMPRO
 4000 FORMAT(/,'FIN DU PROGRAMME ',A,/,60('-'))
      ENDIF
C
      END
