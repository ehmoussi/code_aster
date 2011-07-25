      SUBROUTINE NMDECO(SDDISC,NUMINS,ITERAT,IEVDAC,RETDEC)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 12/07/2011   AUTEUR ABBAS M.ABBAS 
C ======================================================================
C COPYRIGHT (C) 1991 - 2011  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      INTEGER      IEVDAC
      INTEGER      NUMINS,ITERAT
      CHARACTER*19 SDDISC
      INTEGER      RETDEC
C
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME)
C
C GESTION DE L'ACTION DECOUPE DU PAS DE TEMPS
C      
C ----------------------------------------------------------------------
C
C
C IN  SDDISC : SD DISCRETISATION TEMPORELLE
C IN  IEVDAC : INDICE DE L'EVENEMENT ACTIF
C IN  NUMINS : NUMERO D'INSTANTS
C IN  ITERAT : NUMERO D'ITERATION DE NEWTON
C OUT RETDEC : CODE RETOUR DECOUPE
C               0 ON N'A PAS DECOUPE
C               1 ON A DECOUPE
C
C -------------- DEBUT DECLARATIONS NORMALISEES  JEVEUX ----------------
C
      INTEGER ZI
      COMMON /IVARJE/ ZI(1)
      REAL*8 ZR
      COMMON /RVARJE/ ZR(1)
      COMPLEX*16 ZC
      COMMON /CVARJE/ ZC(1)
      LOGICAL ZL
      COMMON /LVARJE/ ZL(1)
      CHARACTER*8 ZK8
      CHARACTER*16 ZK16
      CHARACTER*24 ZK24
      CHARACTER*32 ZK32
      CHARACTER*80 ZK80
      COMMON /KVARJE/ ZK8(1),ZK16(1),ZK24(1),ZK32(1),ZK80(1)
C
C -------------- FIN  DECLARATIONS  NORMALISEES  JEVEUX ----------------
C
      CHARACTER*16 SUBMET,METLIS
      CHARACTER*8  K8BID
      REAL*8       R8BID,PASMIN,DT0,R8GAEM,DTMIN
      INTEGER      IBID,NBINI
      INTEGER      DININS,LENIVO,NBNIVO,INSPAS
      REAL*8       DIINST,DELTAT,INSTAM,INSTAP
      CHARACTER*24 NOMLIS
      INTEGER      JINST
      LOGICAL      LDECO
C 
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C
C --- INITIALISATIONS
C
      RETDEC = 0
      DT0    = 0.D0
      DTMIN  = R8GAEM()
      LDECO  = .FALSE.
      NOMLIS = '&&NMDECO.LISTE'
C
C --- LECTURE DES INFOS SUR LE PAS DE TEMPS
C
      CALL UTDIDT('L'   ,SDDISC,'LIST',IBID,'METHODE',
     &            R8BID ,IBID  ,METLIS)
C
      INSTAM = DIINST(SDDISC,NUMINS-1)
      INSTAP = DIINST(SDDISC,NUMINS)
      DELTAT = INSTAP-INSTAM
C
C --- NIVEAU DE REDECOUPAGE ACTUEL
C
      LENIVO = DININS(SDDISC,NUMINS)
C
C --- METHODE DE SUBDIVISION
C
      CALL UTDIDT('L'   ,SDDISC,'ECHE',IEVDAC,'SUBD_METHODE',
     &            R8BID ,IBID  ,SUBMET)
C
C --- NIVEAU MAXI DE SUBDIVISION
C
      CALL UTDIDT('L'   ,SDDISC,'ECHE',IEVDAC,'SUBD_NIVEAU',
     &            R8BID ,NBNIVO,K8BID )
C
C --- NIVEAU MAXIMUM DE REDECOUPAGE ATTEINT
C
      IF (( NBNIVO .GT. 1 ).AND.(LENIVO.EQ.NBNIVO) ) THEN
        CALL U2MESI('I','SUBDIVISE_3',1,LENIVO)
        RETDEC = 0
        GOTO 999
      ENDIF
C
C --- AUCUNE SUBDIVISION AUTORISEE : ON SORT
C
      IF (SUBMET .EQ. 'AUCUNE' ) THEN
        CALL U2MESS('I','SUBDIVISE_2')
        RETDEC = 0
        GOTO 999
      ELSEIF (SUBMET.EQ.'MANUEL'.OR. 
     &        SUBMET.EQ.'AUTO') THEN
        CALL U2MESK('I','SUBDIVISE_1',1,SUBMET)
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- LONGUEUR INITIALE DE LA LISTE D'INSTANTS
C
      CALL UTDIDT('L'   ,SDDISC,'LIST',IBID  ,'NBINST',
     &            R8BID ,NBINI ,K8BID )
C
C --- PAS MINIMUM
C  
      CALL UTDIDT('L'   ,SDDISC,'ECHE',IEVDAC,'SUBD_PAS_MINI',
     &            PASMIN,IBID  ,K8BID)
C
C --- REMPLISSAGE DE LA LISTE
C
      IF (SUBMET.EQ.'MANUEL') THEN
        CALL NMDECM(SDDISC,IEVDAC,NOMLIS,METLIS,INSTAM,
     &              DELTAT,INSPAS,DTMIN ,LDECO )
      ELSEIF (SUBMET.EQ.'AUTO') THEN
        CALL NMDECA(SDDISC,ITERAT,IEVDAC,METLIS,NOMLIS,
     &              INSTAM,DELTAT,INSPAS,DTMIN ,LDECO )
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
C --- TAILLE DE PAS MINIMALE ATTEINTE PENDANT LA SUBDIVISION
C
      IF ( DTMIN .LT. PASMIN ) THEN
        RETDEC = 0
        CALL U2MESR('I','SUBDIVISE_50',1,PASMIN)
        GOTO 999
      ELSE
        IF (.NOT.LDECO) THEN
          RETDEC = 0
          GOTO 999
        ELSE
          RETDEC = 1
        ENDIF
      ENDIF
C
C --- ACCES OBJET INST
C
      CALL JEVEUO(NOMLIS,'L',JINST )
C
C --- EXTENSION DE LA LISTE D'INSTANTS
C
      CALL NMDCEI(SDDISC,NUMINS,ZR(JINST),NBINI ,INSPAS,
     &            'DECO',DT0      )
C
C --- EXTENSION DE LA LISTE DES NIVEAUX DE DECOUPAGE
C     
      CALL NMDCEN(SDDISC,NUMINS,NBINI ,INSPAS)
C
C --- ENREGISTREMENT INFOS
C
      CALL UTDIDT('E'   ,SDDISC,'LIST',IBID  ,'DT-',
     &            DT0   ,IBID  ,K8BID )
C
 999  CONTINUE
C
C --- AFFICHAGE
C
      IF (RETDEC.EQ.0) THEN
        CALL U2MESS('I','SUBDIVISE_60')
      ELSEIF (RETDEC.EQ.1) THEN
        CALL U2MESS('I','SUBDIVISE_61')  
      ELSE
        CALL ASSERT(.FALSE.)
      ENDIF
C
      CALL JEDETR(NOMLIS)
C
      CALL JEDEMA()
      END
