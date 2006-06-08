      SUBROUTINE LRMMF3 ( FID, NOMAMD,
     >                    RANGFA, CARAFA,
     >                    NBNOEU, FAMNOE,
     >                    NMATYP, JFAMMA, JNUMTY,
     >                    VAATFA, NOGRFA, TABAUX,
     >                    NOMGRO, NUMGRO, NUMENT,
     >                    INFMED, NIVINF, IFM )
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF MODELISA  DATE 22/05/2006   AUTEUR REZETTE C.REZETTE 
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
C     LECTURE DU MAILLAGE - FORMAT MED - LES FAMILLES - 3
C     -    -     -                 -         -          -
C-----------------------------------------------------------------------
C    . SI LA DESCRIPTION D'UNE FAMILLE CONTIENT DES NOMS DE GROUPES, ON
C    VA CREER AUTANT DE GROUPES QUE DECRITS ET ILS PORTERONT CES NOMS.
C    TOUTES LES ENTITES DE LA FAMILLE APPARTIENDRONT A CES GROUPES. UN
C    GROUPE PEUT APPARAITRE DANS LA DESCRIPTION DE PLUSIEURS FAMILLES.
C    SON CONTENU SERA DONC ENRICHI AU FUR ET A MESURE DE L'EXPLORATION
C    DES FAMILLES.
C    . SI LA DESCRIPTION D'UNE FAMILLE NE CONTIENT PAS DE NOMS DE GROUPE
C    ON CREERA DES GROUPES EN SE BASANT SUR UNE IDENTITE D'ATTRIBUTS.
C    LE NOM DE CHAQUE GROUPE EST 'GN' OU 'GM' SELON QUE C'EST UN GROUPE
C    DE NOEUDS OU DE MAILLES, SUIVI DE LA VALEUR DE L'ATTRIBUT. UN MEME
C    ATTRIBUT PEUT APPARAITRE DANS LA DESCRIPTION DE PLUSIEURS FAMILLES.
C    LE CONTENU DU GROUPE ASSOCIE SERA DONC ENRICHI AU FUR ET A MESURE
C    DE L'EXPLORATION DES FAMILLES.
C
C    LE PREMIER CAS APPARAIT QUAND ON RELIT UN FICHIER MED CREE PAR
C    ASTER, OU PAR UN LOGICIEL QUI UTILISERAIT LA NOTION DE GROUPE DE
C    LA MEME MANIERE.
C    LE SECOND CAS A LIEU QUAND LE FICHIER MED A ETE CREE PAR UN
C    LOGICIEL QUI IGNORE LA NOTION DE GROUPE.
C
C ENTREES :
C   FID    : IDENTIFIANT DU FICHIER MED
C   NOMAMD : NOM DU MAILLAGE MED
C   RANGFA : RANG DE LA FAMILLE EN COURS D'EXAMEN
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
C   VAATFA : VALEUR DES ATTRIBUTS ASSOCIES A CHAQUE FAMILLE.
C   NOGRFA : NOM DES GROUPES ASSOCIES A CHAQUE FAMILLE.
C   TABAUX :
C DIVERS
C   INFMED : NIVEAU DES INFORMATIONS SPECIFIQUES A MED A IMPRIMER
C   NIVINF : NIVEAU DES INFORMATIONS GENERALES
C   IFM    : UNITE LOGIQUE DU FICHIER DE MESSAGE
C ENTREES/SORTIES :
C   CARAFA : CARACTERISTIQUES DE CHAQUE FAMILLE
C     CARAFA(1,I) = NOMBRE DE GROUPES
C     CARAFA(2,I) = NOMBRE D'ATTRIBUTS
C     CARAFA(3,I) = NOMBRE D'ENTITES
C-----------------------------------------------------------------------
C
      IMPLICIT NONE
C
      INTEGER NTYMAX
      PARAMETER (NTYMAX = 48)
C
C 0.1. ==> ARGUMENTS
C
      INTEGER FID 
      INTEGER RANGFA, CARAFA(3,*)
      INTEGER NBNOEU, FAMNOE(NBNOEU)
      INTEGER NMATYP(NTYMAX), JFAMMA(NTYMAX), JNUMTY(NTYMAX)
      INTEGER VAATFA(*)
      INTEGER TABAUX(*)
      INTEGER INFMED
      INTEGER IFM, NIVINF
C
      CHARACTER*(*) NOMGRO, NUMGRO, NUMENT
      CHARACTER*80 NOGRFA(*)
      CHARACTER*(*) NOMAMD
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
      PARAMETER ( NOMPRO = 'LRMMF3' )
C
      INTEGER CODRET
      INTEGER IAUX, JAUX, KAUX,JAU2
      INTEGER ITYP
      INTEGER NUMFAM
      INTEGER NBATTR, NBGROU, NBENFA
      INTEGER IDATFA(200)
      INTEGER ADNOMG, ADNUMG, ADNUME
C
      CHARACTER*2 SAUX02
      CHARACTER*8 SAUX08
      CHARACTER*32 NOMFAM
      CHARACTER*200 DESCAT(200)
C
      INTEGER LXLGUT
C
C     ------------------------------------------------------------------
C
      IF ( NIVINF.GE.2 ) THEN
        WRITE (IFM,1001) NOMPRO
 1001 FORMAT( 60('-'),/,'DEBUT DU PROGRAMME ',A)
      ENDIF
C
C====
C 1. CARACTERISTIQUES DE LA FAMILLE
C====
C
C 1.1. ==> LECTURE DANS LE FICHIER MED
C
      CALL EFFAMI ( FID,  NOMAMD, RANGFA, NOMFAM, NUMFAM, 
     >              IDATFA, VAATFA, DESCAT, NBATTR, 
     >              NOGRFA, NBGROU, CODRET)
      IF ( CODRET.NE.0 ) THEN
        CALL CODENT ( CODRET,'G',SAUX08 )
        CALL UTMESS ('F',NOMPRO,'MED: ERREUR EFFAMI NUMERO '//SAUX08)
      ENDIF
C
C 1.2. ==> INFORMATION EVENTUELLE
C
      IF ( INFMED.GE.2 ) THEN
        IF ( NUMFAM.GT.0 ) THEN
          JAUX = 1
        ELSE
          JAUX = 2
        ENDIF
        KAUX = -1
        CALL DESGFA ( JAUX, NUMFAM, NOMFAM,
     >                NBGROU, NOGRFA, NBATTR, VAATFA,
     >                KAUX, KAUX,
     >                IFM, CODRET )
      ENDIF
C
C====
C 2. SI LA FAMILLE N'EST PAS LA FAMILLE NULLE, DECODAGE
C====
C
      IF ( NUMFAM.NE.0 ) THEN
C
C 2.0. ==> CONTROLE DE LA LONGUEUR DES NOMS DES GROUPES
C          C'EST TEMPORAIRE. ESPERONS-LE.
C
        IF ( NBGROU.GT.0 ) THEN
C
          KAUX = 0
          DO 20 , IAUX = 1 , NBGROU
            JAUX = LXLGUT(NOGRFA(IAUX))
            IF ( JAUX.GT.8 ) THEN
              KAUX = KAUX + 1
              WRITE (IFM,2001) NOMFAM, IAUX, JAUX, NOGRFA(IAUX)
            ELSEIF(JAUX.EQ.0)THEN
              JAU2 = LXLGUT(NOMFAM)
              CALL UTDEBM('F','LRMMF3','LE NOM DE GROUPE ')
              CALL UTIMPI('S','NUMERO',1,IAUX)
              CALL UTIMPK('S','DE LA FAMILLE',1,NOMFAM(1:JAU2))
              CALL UTIMPK('S',' EST VIDE.',0,' ')
              CALL UTFINM()
            ENDIF
   20     CONTINUE
C
          IF ( KAUX.GT.0 ) THEN
            WRITE (IFM,2002)
            CALL UTMESS ('F',NOMPRO,'IMPOSSIBLE DE LIRE CE FICHIER.')
          ENDIF
C
 2001 FORMAT (/,'FAMILLE : ',A,
     >/,'LE NOM DU GROUPE NUMERO',I3,' EST TROP LONG (',I2,
     >  ' CARACTERES) :',/,A)
 2002 FORMAT (/,'CELA EST CONFORME AUX CONVENTIONS MED : ',
     >  'LE NOM D''UN GROUPE DOIT ETRE AU PLUS DE 80 CARACTERES.',
     >/,'MAIS CODE_ASTER NE SAIT TRAITER QUE DES NOMS D''AU',
     >  ' PLUS 8 CARACTERES.',
     >/,'DECLAREZ UNE ANOMALIE')
C
        ENDIF
C
C 2.1. ==> IL FAUT AU MOINS UN GROUPE OU UN ATTRIBUT
C
        IF ( NBGROU.EQ.0 .AND. NBATTR.EQ.0 ) THEN
          CALL UTMESS ('F',NOMPRO,
     >    'LA FAMILLE '//NOMFAM//'N''A NI GROUPE, NI ATTRIBUT.')
        ENDIF
C
C 2.2. ==> COHERENCE DES NOMBRES DE GROUPES OU D'ATTRIBUTS
C
        IAUX = 0
        IF ( NBGROU.NE.CARAFA(1,RANGFA) ) THEN
          IAUX = IAUX + 1
          WRITE (IFM,2201) NOMFAM, 'GROUPES', CARAFA(1,RANGFA), NBGROU
        ENDIF
        IF ( NBATTR.NE.CARAFA(2,RANGFA) ) THEN
          IAUX = IAUX + 1
          WRITE (IFM,2201) NOMFAM, 'ATTRIBUTS', CARAFA(2,RANGFA), NBATTR
        ENDIF
        IF ( IAUX.GT.0 ) THEN
          CALL UTMESS ('F',NOMPRO,'IMPOSSIBLE DE LIRE CE FICHIER.')
        ENDIF
C
 2201 FORMAT (/,'FAMILLE ',A,
     >  ' : PROBLEMES SUR LES NOMBRES DE ',A,
     >/,'SELON LE PROGRAMME MED DE LECTURE, ON EN TROUVE',
     >  I4,' OU',I4)
C
C 2.3. ==> CREATION :
C        COLLECTION INVERSE       FAM I -> NUMNO(MA)X,NUMNO(MA)Y..
C     ET VECTEUR DES LONGUEURS    FAM I -> NBNUMNO(MA)
C       (POUR EVITER DE FAIRE DES TONNES DE JELIRA APRES)
C          MEMORISATION DU DU NOMBRE D'ENTITES QUE LA FAMILLE CONTIENT
C
        NBENFA = 0
C
C 2.3.1. ==> POUR UNE FAMILLE DE NOEUDS : LE TABLEAU TABAUX CONTIENDRA
C            LA LISTE DES NOEUDS DE LA FAMILLE
C
        IF ( NUMFAM.GT.0 ) THEN
C
          DO 231 , IAUX = 1 , NBNOEU
            IF ( NUMFAM.EQ.FAMNOE(IAUX) ) THEN
              NBENFA = NBENFA + 1
              TABAUX(NBENFA) = IAUX
            ENDIF
  231     CONTINUE
C
C 2.3.2. ==> POUR UNE FAMILLE DE MAILLES : LE TABLEAU TABAUX CONTIENDRA
C            LA LISTE DES MAILLES DE LA FAMILLE, TYPE PAR TYPE.
C
        ELSEIF ( NUMFAM.LT.0 ) THEN
C
          DO 232 , ITYP = 1 , NTYMAX
            IF ( NMATYP(ITYP).NE.0 ) THEN
              DO 2321 , IAUX = 1 , NMATYP(ITYP)
                IF ( NUMFAM.EQ.ZI(JFAMMA(ITYP)+IAUX-1) ) THEN
                  NBENFA = NBENFA + 1
                  TABAUX(NBENFA) = ZI(JNUMTY(ITYP)+IAUX-1)
                ENDIF  
 2321         CONTINUE
            ENDIF  
  232     CONTINUE
C
        ENDIF
C
        CARAFA(3,RANGFA) = NBENFA
C
C 2.4. ==> MEMORISATION DES NUMEROS DES ENTITES DE LA FAMILLE
C
        IF ( NBENFA.GT.0 ) THEN
C
          CALL JUCROC ( NUMENT, SAUX08, RANGFA, NBENFA, ADNUME )
          ADNUME = ADNUME - 1
          DO 24 , IAUX = 1 , NBENFA
            ZI(ADNUME+IAUX) = TABAUX(IAUX)
   24     CONTINUE
C
        ENDIF
C
C 2.5. ==> CREATION DES NOMS DES GROUPES ASSOCIES
C         POUR FORMER LES COLLECTIONS FAM I -> NOMGNO X , NOMGMA Y ...
C                                     FAM J -> NUMGNO X , NUMGMA Y ...
C         ON MET LE NUMERO DE GROUPE A +-99999999. AINSI, LE PROGRAMME
C         DE CREATION, LRMNGR, FERA UNE NUMEROTATION AUTOMATIQUE. 
C         CONVENTION : SI GROUPE DE MAILLES => NUMGRP< 0 SINON NUMGRP>0
C
C         SI AUCUN GROUPE N'A ETE DEFINI, ON CREE DES GROUPES DONT LE
C         NOM EST BATI SUR LA VALEUR DES ATTRIBUTS. ATTENTION, ASTER
C         REFUSE LES SIGNES '-' DANS LES NOMS DES GROUPES ... DE MEME,
C         IL FAUT DISTINGUER LES GROUPES DE NOEUDS ET DE MAILLES
C         SINON, ON COPIE LES NOMS PRESENTS DANS LE DESCRIPTIF DE LA
C         FAMILLE.
C
        IF ( NBENFA.GT.0 ) THEN
C
          IAUX = MAX ( 1, NBATTR, NBGROU )
          CALL JUCROC ( NOMGRO, SAUX08, RANGFA, IAUX, ADNOMG )
          CALL JUCROC ( NUMGRO, SAUX08, RANGFA, IAUX, ADNUMG )
C
          IF ( NUMFAM.GT.0 ) THEN
            SAUX02 = 'GN'
            JAUX =  99999999
          ELSE
            SAUX02 = 'GM'
            JAUX = -99999999
          ENDIF
          ADNOMG = ADNOMG - 1
          ADNUMG = ADNUMG - 1
C
          IF ( NBGROU.EQ.0 ) THEN
C
            DO 251 , IAUX = 1 , NBATTR
              CALL CODENT (VAATFA(IAUX),'G',SAUX08)
              IF ( VAATFA(IAUX).LT.0 ) THEN
                SAUX08(3:8) = 'M'//SAUX08(2:6)
              ELSE
                SAUX08(3:8) = 'P'//SAUX08(1:5)
              ENDIF
              SAUX08(1:2) = SAUX02
              ZK8(ADNOMG+IAUX) = SAUX08
              ZI(ADNUMG+IAUX)  = JAUX
  251       CONTINUE
C
          ELSE
C
            DO 252 , IAUX = 1 , NBGROU
              ZK8(ADNOMG+IAUX) = NOGRFA(IAUX)(1:8)
              ZI(ADNUMG+IAUX) = JAUX
  252       CONTINUE
C
          ENDIF
C
        ENDIF
C
      ENDIF
C
      IF ( NIVINF.GE.2 ) THEN
C
        WRITE (IFM,4001) NOMPRO
 4001 FORMAT(/,'FIN DU PROGRAMME ',A,/,60('-'))
C
      ENDIF
C
      END
