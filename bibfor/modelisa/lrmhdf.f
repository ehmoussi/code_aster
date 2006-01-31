      SUBROUTINE LRMHDF ( NOMAMD,
     >                    NOMU,NOMMAI,NOMNOE,COOVAL,COODSC,COOREF,
     >                    GRPNOE,GRPMAI,CONNEX,TITRE,FORMM,TYPMAI,
     >                    ADAPMA,IFM,NROFIC,NIVINF,INFMED,
     >                    NBNOEU, NBMAIL, NBCOOR )
C     ------------------------------------------------------------------
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 31/01/2006   AUTEUR GNICOLAS G.NICOLAS 
C RESPONSABLE GNICOLAS G.NICOLAS
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
C TOLE CRP_21
C     LECTURE DU MAILLAGE - FORMAT MED/HDF
C     -    -                       -   ---
C-----------------------------------------------------------------------
C     ENTREES :
C        NOMAMD : NOM MED DU MAILLAGE A LIRE
C                 SI ' ' : ON LIT LE PREMIER MAILLAGE DU FICHIER 
C        NOMU   : NOM ASTER SOUS LEQUEL LE MAILLAGE SERA STOCKE
C ...
C     SORTIES:
C        NBNOEU : NOMBRE DE NOEUDS
C ...
C     ------------------------------------------------------------------
C
      IMPLICIT NONE
C
C 0.1. ==> ARGUMENTS
C
C     IN
C
      INTEGER IFM, NIVINF
      INTEGER NROFIC, INFMED
      CHARACTER*32 NOMAMD
      CHARACTER*24 COOVAL, COODSC, COOREF, GRPNOE, GRPMAI, CONNEX
      CHARACTER*24 FORMM,  TITRE,  NOMMAI, NOMNOE, TYPMAI 
      CHARACTER*24 ADAPMA
      CHARACTER*8 NOMU 
C
C     OUT
C
      INTEGER NBNOEU, NBMAIL, NBCOOR
C
C 0.2. ==> COMMUNS
C
C 0.3. ==> VARIABLES LOCALES
C
      CHARACTER*6 NOMPRO
      PARAMETER ( NOMPRO = 'LRMHDF' )
C
      INTEGER NTYMAX
      PARAMETER (NTYMAX = 48)
      INTEGER NNOMAX
      PARAMETER (NNOMAX=27)
      INTEGER EDLECT
      PARAMETER (EDLECT=0)
C
      INTEGER IAUX
      INTEGER NMATYP(NTYMAX)
      INTEGER NNOTYP(NTYMAX), TYPGEO(NTYMAX), NUANOM(NTYMAX,NNOMAX)
      INTEGER RENUMD(NTYMAX),MODNUM(NTYMAX),NUMNOA(NTYMAX,NNOMAX)
      INTEGER NBTYP
      INTEGER NDIM, FID, CODRET
      INTEGER NBNOMA
      INTEGER NBLTIT, NBGRNO, NBGRMA
      INTEGER VLIB(3), VFIC(3), IRET
C
      CHARACTER*1 SAUX01
      CHARACTER*6 SAUX06
      CHARACTER*8 NOMTYP(NTYMAX)
      CHARACTER*8 SAUX08
      CHARACTER*200 NOFIMD
      CHARACTER*255 KFIC
      CHARACTER*200 DESCFI
C
      LOGICAL EXISTM
C
C     ------------------------------------------------------------------
      CALL JEMARQ ( )
C
C====
C 1. PREALABLES
C====
C
      IF ( NIVINF.GT.1 ) THEN
        CALL UTFLSH (CODRET)
        WRITE (IFM,1001) 'DEBUT DE '//NOMPRO
      ENDIF
 1001 FORMAT(/,10('='),A,10('='),/)
C
C 1.1. ==> NOM DU FICHIER MED
C
      CALL ULISOG(NROFIC, KFIC, SAUX01)
      IF ( KFIC(1:1).EQ.' ' ) THEN
         CALL CODENT ( NROFIC, 'G', SAUX08 )
         NOFIMD = 'fort.'//SAUX08
      ELSE
         NOFIMD = KFIC(1:200)
      ENDIF
C
      IF ( NIVINF.GT.1 ) THEN
        WRITE (IFM,*) '<',NOMPRO,'> NOM DU FICHIER MED : ',NOFIMD
      ENDIF
C
C 1.2. ==> VERIFICATION DU FICHIER MED
C
C 1.2.1. ==> VERIFICATION DE LA VERSION HDF
C
      CALL EFFOCO ( NOFIMD, CODRET )
      IF ( CODRET.NE.0 ) THEN
        CALL UTDEBM ( 'A', NOMPRO, 'FICHIER ' )
        CALL UTIMPK ( 'S', 'MED : ', 1, NOFIMD )
        CALL UTIMPK ( 'L', 'MAILLAGE : ', 1, NOMAMD )
        CALL UTIMPI ( 'L', 'ERREUR EFFOCO NUMERO ', 1, CODRET )
        CALL UTFINM ()
        CALL UTMESS ( 'F', NOMPRO, 'SOIT LE FICHIER N''EXISTE PAS, '//
     >    'SOIT C''EST UNE MAUVAISE VERSION DE HDF (UTILISE PAR MED).')
      ENDIF
C
C 1.2.2. ==> VERIFICATION DE LA VERSION MED
C
      CALL EFVECO ( NOFIMD, CODRET )
      IF ( CODRET.NE.0 ) THEN
        CALL UTDEBM ( 'F', NOMPRO, 'LE FICHIER N''A PAS ETE CONSTRUIT'//
     >             ' AVEC LA MEME VERSION DE MED.' )
        CALL UTIMPI ( 'L', 'ERREUR EFVECO NUMERO ', 1, CODRET )
        CALL EFVEDO(VLIB(1),VLIB(2),VLIB(3),IRET)
        IF( IRET.EQ.0) THEN
          CALL UTIMPI ( 'L', 'VERSION DE LA BIBLIOTHEQUE MED '//
     >                       'UTILISEE PAR CODE_ASTER : ', 3, VLIB )
        ENDIF
        CALL EFOUVR ( FID, NOFIMD, EDLECT, CODRET )
        CALL EFVELI ( FID, VFIC(1),VFIC(2),VFIC(3), IRET )
        IF( IRET.EQ.0) THEN
          IF ( VFIC(2).EQ.-1 .OR. VFIC(3).EQ.-1) THEN
            CALL UTIMPI ( 'L', 'VERSION DE LA BIBLIOTHEQUE MED '//
     >                    'QUI A CREE LE FICHIER   : < 2.1.5', 0, IAUX )
          ELSE
            CALL UTIMPI ( 'L', 'VERSION DE LA BIBLIOTHEQUE MED '//
     >                       'POUR CREER LE FICHIER   : ', 3, VFIC )
          ENDIF
          IF (     VFIC(1).LT.VLIB(1)
     >      .OR. ( VFIC(1).EQ.VLIB(1) .AND. VFIC(2).LT.VLIB(2) )
     >      .OR. ( VFIC(1).EQ.VLIB(1) .AND. VFIC(2).EQ.VLIB(2) .AND.
     >             VFIC(3).EQ.VLIB(3) ) ) THEN
            CALL UTIMPI ( 'L', 'UN UTILITAIRE VOUS PERMET PEUT-ETRE '
     >         //'DE CONVERTIR VOTRE FICHIER (medimport)', 0, IAUX )
          ENDIF
        ENDIF
        CALL EFFERM ( FID, CODRET )
        CALL UTFINM ()
      ENDIF
C
C 1.3. ==> VERIFICATION DE L'EXISTENCE DU MAILLAGE A LIRE
C
C 1.3.1. ==> C'EST LE PREMIER MAILLAGE DU FICHIER
C            ON RECUPERE SON NOM ET SA DIMENSION.
C
      IF ( NOMAMD.EQ.' ' ) THEN
C
        CALL MDEXPM ( NOFIMD, NOMAMD, EXISTM, NDIM, CODRET )
        IF ( .NOT.EXISTM ) THEN
          CALL UTMESS ( 'F', NOMPRO, 'PAS DE MAILLAGE DANS '//NOFIMD )
        ENDIF
C
C 1.3.2. ==> C'EST UN MAILLAGE DESIGNE PAR UN NOM
C            ON RECUPERE SA DIMENSION.
C
      ELSE
C
        IAUX = 1
        CALL MDEXMA ( NOFIMD, NOMAMD, IAUX, EXISTM, NDIM, CODRET )
        IF ( .NOT.EXISTM ) THEN
          CALL UTMESS ( 'F', NOMPRO,
     >   'MAILLAGE '//NOMAMD//' INCONNU DANS '//NOFIMD )
        ENDIF
C
      ENDIF
C
      NBCOOR = NDIM
C
C====
C 2. DEMARRAGE
C====
C
C 2.1. ==> OUVERTURE FICHIER MED EN LECTURE
C
      CALL EFOUVR ( FID, NOFIMD, EDLECT, CODRET )
      IF ( CODRET.NE.0 ) THEN
        CALL UTDEBM ( 'A', NOMPRO, 'FICHIER ' )
        CALL UTIMPK ( 'S', 'MED : ', 1, NOFIMD )
        CALL UTIMPK ( 'L', 'MAILLAGE : ', 1, NOMAMD )
        CALL UTIMPI ( 'L', 'ERREUR EFOUVR NUMERO ', 1, CODRET )
        CALL UTFINM ()
        CALL UTMESS ( 'F', NOMPRO, 'PROBLEME A L OUVERTURE DU FICHIER' )
      ENDIF
C
C 2.2. ==> . RECUPERATION DES NB/NOMS/NBNO/NBITEM DES TYPES DE MAILLES
C            DANS CATALOGUE
C          . RECUPERATION DES TYPES GEOMETRIE CORRESPONDANT POUR MED
C          . VERIF COHERENCE AVEC LE CATALOGUE
C
      CALL LRMTYP ( NBTYP, NOMTYP,
     >              NNOTYP, TYPGEO, RENUMD,
     >              MODNUM, NUANOM, NUMNOA )
C
C====
C 3. DESCRIPTION
C====
C
      CALL LRMDES ( FID, NOMAMD,
     >              NBLTIT, DESCFI, TITRE, FORMM )
C
C====
C 4. DIMENSIONNEMENT
C====
C
      CALL LRMMDI ( FID, NOMAMD,
     >              TYPGEO, NOMTYP, NNOTYP,
     >              NMATYP,
     >              NBNOEU, NBMAIL, NBNOMA,
     >              DESCFI, ADAPMA )
C
C====
C 5. LES NOEUDS
C====
C
      CALL LRMMNO ( FID, NOMAMD, NDIM, NBNOEU,
     >              NOMU, NOMNOE, COOVAL, COODSC, COOREF,
     >              IFM, INFMED )
C
C====
C 6. LES MAILLES
C====
C
      SAUX06 = NOMPRO
C
      CALL LRMMMA ( FID, NOMAMD, NDIM, NBMAIL, NBNOMA,
     >              NBTYP, TYPGEO, NOMTYP, NNOTYP, RENUMD,
     >              NMATYP,
     >              NOMMAI, CONNEX, TYPMAI,
     >              SAUX06,
     >              INFMED, MODNUM, NUMNOA )
C
C====
C 7. LES FAMILLES
C====
C
      SAUX06 = NOMPRO
C
      CALL LRMMFA ( FID, NOMAMD,
     >              NBNOEU, NBMAIL,
     >              GRPNOE, GRPMAI, NBGRNO, NBGRMA,
     >              TYPGEO, NOMTYP, NMATYP,
     >              SAUX06,
     >              INFMED )
C
C====
C 8. LES EQUIVALENCES
C====
C
      CALL LRMMEQ ( FID, NOMAMD,
     >              INFMED )
C
C====
C 9. FIN
C====
C
C 9.1. ==> FERMETURE FICHIER
C
      CALL EFFERM ( FID, CODRET )
      IF ( CODRET.NE.0 ) THEN
        CALL UTDEBM ( 'A', NOMPRO, 'FICHIER ' )
        CALL UTIMPK ( 'S', 'MED : ', 1, NOFIMD )
        CALL UTIMPK ( 'L', 'MAILLAGE : ', 1, NOMAMD )
        CALL UTIMPI ( 'L', 'ERREUR EFFERM NUMERO ', 1, CODRET )
        CALL UTFINM ()
        CALL UTMESS ( 'F', NOMPRO, 'PROBLEME A LA FERMETURE DU FICHIER')
      ENDIF
C
C 9.2. ==> MENAGE
C
      CALL JEDETC ('V','&&'//NOMPRO,1)
C
      CALL JEDEMA ( )
C
      IF ( NIVINF.GT.1 ) THEN
        WRITE (IFM,1001) 'FIN DE '//NOMPRO
        CALL UTFLSH (CODRET)
      ENDIF
C
      END
