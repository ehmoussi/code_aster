      SUBROUTINE NMCHAR(MODE  ,PHASEZ,
     &                  MODELE,NUMEDD,MATE  ,CARELE,COMPOR,
     &                  LISCHA,CARCRI,NUMINS,SDDISC,PARCON,
     &                  FONACT,DEFICO,RESOCO,RESOCU,COMREF,
     &                  VALMOI,VALPLU,POUGD ,SOLALG,VEELEM,
     &                  MEASSE,VEASSE,SDSENS,SDDYNA)
C
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 13/10/2008   AUTEUR ABBAS M.ABBAS 
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
C RESPONSABLE MABBAS M.ABBAS
C TOLE CRP_20
C TOLE CRP_21
C
      IMPLICIT NONE
      CHARACTER*4   MODE
      CHARACTER*(*) PHASEZ
      CHARACTER*19  LISCHA
      CHARACTER*24  MODELE,MATE,CARELE, NUMEDD
      CHARACTER*24  VALMOI(8),VALPLU(8),POUGD(8)
      CHARACTER*24  COMPOR,CARCRI,SDSENS,COMREF
      CHARACTER*19  SDDYNA,SDDISC
      LOGICAL       FONACT(*)
      INTEGER       NUMINS
      REAL*8        PARCON(8)
      CHARACTER*24  DEFICO,RESOCO,RESOCU
      CHARACTER*19  VEELEM(*),MEASSE(*),VEASSE(*) 
      CHARACTER*19  SOLALG(*)   
C 
C ----------------------------------------------------------------------
C
C ROUTINE MECA_NON_LINE (ALGORITHME - CALCUL)
C
C CALCUL ET ASSEMBLAGE DES FORCES EXTERNES
C      
C ----------------------------------------------------------------------
C 
C
C IN  MODE   : 'FIXE' -> CALCUL CHARGES FIXES AU COURS DU TEMPS
C              'VARI' -> CALCUL CHARGES VARIABLES AU COURS DU TEMPS
C              'ACCI' -> CALCUL CHARGES POUR ACCELERATION INITIALE
C IN  PHASE  : PHASE DE CALCUL 
C               'CORRECTION' OU 'PREDICTION'
C IN  MODELE : MODELE
C IN  NUMEDD : NUME_DDL
C IN  LISCHA : LISTE DES CHARGES
C IN  MATE   : CHAMP MATERIAU
C IN  CARELE : CARACTERISTIQUES DES ELEMENTS DE STRUCTURE
C IN  COMPOR : CARTE DECRIVANT LE TYPE DE COMPORTEMENT
C IN  CARCRI : PARAMETRES DES METHODES D'INTEGRATION LOCALES
C IN  NUMEDD : NUME_DDL
C IN  NUMINS : NUMERO INSTANT
C IN  SDDISC : SD DISCRETISATION TEMPORELLE
C IN  PARCON : PARAMETRES DU CRITERE DE CONVERGENCE REFERENCE
C IN  FONACT : FONCTIONNALITES ACTIVEES
C IN  COMREF : VARI_COM DE REFERENCE
C IN  RESOCO : SD POUR LA RESOLUTION DE CONTACT
C IN  RESOCU : SD POUR LA RESOLUTION DE LIAISON_UNILATER
C IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
C IN  VALMOI : VARIABLE CHAPEAU POUR ETAT EN T-
C IN  VALPLU : VARIABLE CHAPEAU POUR ETAT EN T+
C IN  SOLALG : VARIABLE CHAPEAU POUR INCREMENTS SOLUTIONS
C IN  POUGD  : VARIABLE CHAPEAU POUR POUTRES EN GRANDES ROTATIONS
C IN  MEASSE : VARIABLE CHAPEAU POUR NOM DES MATR_ASSE
C IN  VEELEM : VARIABLE CHAPEAU POUR NOM DES VECT_ELEM
C IN  VEASSE : VARIABLE CHAPEAU POUR NOM DES VECT_ASSE
C IN  SDDYNA : SD DYNAMIQUE
C IN  SDSENS : SD SENSIBILITE
C
C --- DEBUT DECLARATIONS NORMALISEES JEVEUX ----------------------------
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
C --- FIN DECLARATIONS NORMALISEES JEVEUX ------------------------------
C 
      LOGICAL      LDYNA
      LOGICAL      LONDE,LSENS,LLAPL,LAMMO,LSSTF,LCTFC
      LOGICAL      LIMPE,LPILO,LCTCC,LXFCM,LTFCM,LGRFL,LMACR
      LOGICAL      NDYNLO,ISFONC
      INTEGER      NRPASE,IBID
      CHARACTER*24 K24BID,K24BLA
      REAL*8       R8BID
      CHARACTER*10 PHASE       
      INTEGER      NBVECT   
      CHARACTER*6  LTYPVE(20)
      CHARACTER*16 LOPTVE(20)
      LOGICAL      LASSVE(20),LCALVE(20)      
      INTEGER      IFM,NIV
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
      CALL INFDBG('MECA_NON_LINE',IFM,NIV)
C
C --- AFFICHAGE
C
      IF (NIV.GE.2) THEN
        WRITE (IFM,*) '<MECANONLINE><CHAR> CALCUL DU CHARGEMENT: ',MODE 
      ENDIF          
C
C --- INITIALISATIONS
C
      PHASE  = PHASEZ  
      CALL NMCVEC('INIT',' ',' ',.FALSE.,.FALSE.,
     &            NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)   
      K24BLA = ' '   
C
C --- FONCTIONNALITES ACTIVEES
C    
      LONDE  = NDYNLO(SDDYNA,'ONDE_PLANE') 
      LDYNA  = NDYNLO(SDDYNA,'DYNAMIQUE') 
      LLAPL  = ISFONC(FONACT,'LAPLACE')
      LIMPE  = NDYNLO(SDDYNA,'IMPE_ABSO')
      LAMMO  = NDYNLO(SDDYNA,'AMOR_MODAL')
      LPILO  = ISFONC(FONACT,'PILOTAGE')
      LCTCC  = ISFONC(FONACT,'CONT_CONTINU') 
      LXFCM  = ISFONC(FONACT,'CONT_XFEM') 
      LCTFC  = ISFONC(FONACT,'FROT_CONTINU')      
      LGRFL  = NDYNLO(SDDYNA,'FORCE_FLUIDE')
      LMACR  = ISFONC(FONACT,'MACR_ELEM_STAT')
      LSSTF  = ISFONC(FONACT,'SOUS_STRUC')
      LTFCM  = .FALSE.
      IF (LXFCM) THEN
        CALL MMINFP(0    ,DEFICO,K24BLA,'XFEM_GG',
     &              IBID ,R8BID ,K24BID,LTFCM)
      ENDIF  
C
C --- PAS DE SENSIBILITE
C      
      LSENS  = .FALSE.
      NRPASE = 0          
C 
C --- CHARGEMENTS FIXES PENDANT LE PAS DE TEMPS (ON EST EN PREDICTION)
C 
      IF (MODE.EQ.'FIXE') THEN   
C
C --- DEPLACEMENTS IMPOSES DONNES 
C                           
        CALL NMCVEC('AJOU','CNDIDO',' ',.TRUE.,.TRUE.,
     &              NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)        
C
C --- DEPLACEMENTS IMPOSES PILOTES                         
C
        IF (LPILO) THEN
          CALL NMCVEC('AJOU','CNDIPI',' ',.TRUE.,.TRUE.,
     &                NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE) 
        ENDIF
C
C --- CHARGEMENTS FORCES DE LAPLACE   
C             
        IF (LLAPL) THEN    
          CALL NMCVEC('AJOU','CNLAPL',' ',.TRUE.,.TRUE.,
     &                NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE) 
        ENDIF
C
C --- CHARGEMENTS ONDE_PLANE 
C
        IF (LONDE) THEN
          CALL NMCVEC('AJOU','CNONDP',' ',.TRUE.,.TRUE.,
     &                NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE) 
        ENDIF
C
C --- CHARGEMENTS MECANIQUES FIXES DONNES
C
        CALL NMCVEC('AJOU','CNFEDO',' ',.TRUE.,.TRUE.,
     &              NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)     
C
C --- CHARGEMENTS MECANIQUES PILOTES                    
C
        IF (LPILO) THEN
          CALL NMCVEC('AJOU','CNFEPI',' ',.TRUE.,.TRUE.,
     &                NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE) 
        ENDIF  
C
C --- CHARGEMENT GRAPPE_FLUIDE                    
C        
        IF (LGRFL) THEN
          CALL NMCVEC('AJOU','CNGRFL',' ',.FALSE.,.TRUE.,
     &                NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE) 
        ENDIF                   
C
C --- CONDITIONS CINEMATIQUES IMPOSEES  (AFFE_CHAR_CINE) 
C
        CALL NMCVEC('AJOU','CNCINE',' ',.FALSE.,.TRUE.,
     &              NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)
C
C --- FORCE DE REFERENCE LIEE AUX VAR. COMMANDES EN T+
C
        CALL NMCVEC('AJOU','CNVCF0',' ',.TRUE.,.TRUE.,
     &              NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)     
C
C --- FORCES NODALES (POUR PREDICTION) 
C
        CALL NMCVEC('AJOU','CNFNOD',' ',.TRUE.,.TRUE.,
     &              NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)     
C
C --- FORCES POUR VAR. COMM. (POUR PREDICTION) 
C
        CALL NMCVEC('AJOU','CNVCPR',' ',.FALSE.,.TRUE.,
     &              NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE) 
C        
C --- FORCES ISSUES DU CALCUL PAR SOUS-STRUCTURATION 
C
        IF (LSSTF) THEN
          CALL NMCVEC('AJOU','CNSSTF',' ',.TRUE.,.TRUE.,
     &                NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)
        ENDIF               
C
C --- CALCUL ET ASSEMBLAGE
C
        CALL NMXVEC(MODELE,MATE  ,CARELE,COMPOR,CARCRI,
     &              SDDISC,SDDYNA,NUMINS,VALMOI,VALPLU,
     &              POUGD ,SOLALG,LISCHA,COMREF,DEFICO,
     &              RESOCO,RESOCU,NUMEDD,PARCON,SDSENS,
     &              LSENS ,NRPASE,VEELEM,VEASSE,MEASSE,
     &              NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)      
C 
C --- CHARGEMENTS VARIABLES PENDANT LE PAS DE TEMPS
C
      ELSE IF (MODE.EQ.'VARI') THEN  

C
C --- FORCES SUIVEUSES DONNEES
C
        CALL NMCVEC('AJOU','CNFSDO',' ',.TRUE.,.TRUE.,
     &              NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE) 
C     
        IF (LDYNA) THEN
C
C --- FORCES D'EQUILIBRE DYNAMIQUE
C  
          CALL NMCVEC('AJOU','CNDYNA',' ',.FALSE.,.TRUE.,
     &                NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE) 
C
C --- FORCES D'AMORTISSEMENT MODAL
C           
          IF (LAMMO) THEN
            IF (PHASE.EQ.'PREDICTION') THEN
              CALL NMCVEC('AJOU','CNMODP',' ',.FALSE.,.TRUE.,
     &                  NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)            
            ELSEIF (PHASE.EQ.'CORRECTION') THEN    
              CALL NMCVEC('AJOU','CNMODC',' ',.FALSE.,.TRUE.,
     &                  NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)          
            ELSE
              CALL ASSERT(.FALSE.)
            ENDIF
          ENDIF    
C
C --- FORCES IMPEDANCES
C   
          IF (LIMPE) THEN
            IF (PHASE.EQ.'PREDICTION') THEN
              CALL NMCVEC('AJOU','CNIMPP',' ',.TRUE.,.TRUE.,
     &                  NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)            
            ELSEIF (PHASE.EQ.'CORRECTION') THEN    
              CALL NMCVEC('AJOU','CNIMPC',' ',.TRUE.,.TRUE.,
     &                  NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)          
            ELSE
              CALL ASSERT(.FALSE.)
            ENDIF             
          ENDIF 
        ENDIF
C
C --- FORCES DE CONTACT CONTINUE
C
        IF (LCTCC) THEN
          IF (.NOT.LXFCM) THEN
            CALL NMCVEC('AJOU','CNCTCC',' ',.TRUE.,.TRUE.,
     &                  NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)
          ENDIF  
        ENDIF
C
C --- FORCES DE FROTTEMENT CONTINUE
C        
        IF (LCTFC) THEN
          IF (.NOT.LXFCM) THEN                      
            CALL NMCVEC('AJOU','CNCTCF',' ',.TRUE.,.TRUE.,
     &                  NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE) 
            IF (PHASE.EQ.'CORRECTION') THEN
              CALL NMCVEC('AJOU','CNUSUR',' ',.TRUE.,.FALSE.,
     &                  NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE) 
            ENDIF  
          ENDIF     
        ENDIF
C 
C --- FORCES DE CONTACT/FROTTEMENT XFEM
C
        IF (LXFCM) THEN
          IF (LTFCM) THEN
            CALL NMCVEC('AJOU','CNXFTC',' ',.TRUE.,.TRUE.,
     &                   NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)        
            CALL NMCVEC('AJOU','CNXFTF',' ',.TRUE.,.TRUE.,
     &                   NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)            
          ELSE
            CALL NMCVEC('AJOU','CNXFEC',' ',.TRUE.,.TRUE.,
     &                   NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)        
            CALL NMCVEC('AJOU','CNXFEF',' ',.TRUE.,.TRUE.,
     &                  NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)  
          ENDIF      
        ENDIF       
C
C --- FORCES ISSUES DES MACRO-ELEMENTS 
C --- VECT_ASSE(MACR_ELEM) = MATR_ASSE(MACR_ELEM) * VECT_DEPL
C
        IF (LMACR) THEN
          CALL NMCVEC('AJOU','CNSSTR',' ',.FALSE.,.TRUE.,
     &                NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)   
        ENDIF                                 
C
C --- CALCUL EFFECTIF
C
        CALL NMXVEC(MODELE,MATE  ,CARELE,COMPOR,CARCRI,
     &              SDDISC,SDDYNA,NUMINS,VALMOI,VALPLU,
     &              POUGD ,SOLALG,LISCHA,COMREF,DEFICO,
     &              RESOCO,RESOCU,NUMEDD,PARCON,SDSENS,
     &              LSENS ,NRPASE,VEELEM,VEASSE,MEASSE,
     &              NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE) 


      ELSE IF (MODE.EQ.'CONT') THEN  

C
C --- FORCES DE CONTACT CONTINUE
C
        IF (LCTCC) THEN
          IF (.NOT.LXFCM) THEN        
            CALL NMCVEC('AJOU','CNCTCC',' ',.TRUE.,.TRUE.,
     &                  NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)
          ENDIF  
        ENDIF
C
C --- FORCES DE FROTTEMENT CONTINUE
C        
        IF (LCTFC) THEN 
          IF (.NOT.LXFCM) THEN             
            CALL NMCVEC('AJOU','CNCTCF',' ',.TRUE.,.TRUE.,
     &                  NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE) 
          ENDIF       
        ENDIF
C 
C --- FORCES DE CONTACT/FROTTEMENT XFEM
C
        IF (LXFCM) THEN
          IF (LTFCM) THEN
            CALL NMCVEC('AJOU','CNXFTC',' ',.TRUE.,.TRUE.,
     &                   NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)        
            CALL NMCVEC('AJOU','CNXFTF',' ',.TRUE.,.TRUE.,
     &                   NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)            
          ELSE
            CALL NMCVEC('AJOU','CNXFEC',' ',.TRUE.,.TRUE.,
     &                   NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)        
            CALL NMCVEC('AJOU','CNXFEF',' ',.TRUE.,.TRUE.,
     &                  NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)  
          ENDIF      
        ENDIF          
C
C --- FORCES ISSUES DES MACRO-ELEMENTS 
C --- VECT_ASSE(MACR_ELEM) = MATR_ASSE(MACR_ELEM) * VECT_DEPL
C
        IF (LMACR) THEN
          CALL NMCVEC('AJOU','CNSSTR',' ',.FALSE.,.TRUE.,
     &                NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)   
        ENDIF                             
C
C --- CALCUL EFFECTIF
C
        CALL NMXVEC(MODELE,MATE  ,CARELE,COMPOR,CARCRI,
     &              SDDISC,SDDYNA,NUMINS,VALMOI,VALPLU,
     &              POUGD ,SOLALG,LISCHA,COMREF,DEFICO,
     &              RESOCO,RESOCU,NUMEDD,PARCON,SDSENS,
     &              LSENS ,NRPASE,VEELEM,VEASSE,MEASSE,
     &              NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE) 

C 
C --- CHARGEMENTS POUR ACCELERATION INITIALE
C
      ELSE IF (MODE.EQ.'ACCI') THEN     
        IF (NUMINS.NE.0) THEN
          CALL ASSERT(.FALSE.)
        ENDIF      
C
C --- CHARGEMENTS MECANIQUES FIXES DONNES
C
        CALL NMCVEC('AJOU','CNFEDO',' ',.TRUE.,.TRUE.,
     &              NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)
C
C --- FORCES SUIVEUSES DONNEES
C
        CALL NMCVEC('AJOU','CNFSDO',' ',.TRUE.,.TRUE.,
     &              NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)
C
C --- DEPLACEMENTS IMPOSES DONNES 
C                           
        CALL NMCVEC('AJOU','CNDIDO',' ',.TRUE.,.TRUE.,
     &              NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE) 
C
C --- FORCES NODALES 
C
        CALL NMCVEC('AJOU','CNFNOD',' ',.TRUE.,.TRUE.,
     &              NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)     
C
C --- CONDITIONS CINEMATIQUES IMPOSEES  (AFFE_CHAR_CINE) 
C
        CALL NMCVEC('AJOU','CNCINE',' ',.FALSE.,.TRUE.,
     &              NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)
C
C --- FORCES ISSUES DES MACRO-ELEMENTS
C
        IF (LMACR) THEN
          CALL NMCVEC('AJOU','CNSSTR',' ',.FALSE.,.TRUE.,
     &                NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)        
        ENDIF  
C        
C --- FORCES ISSUES DU CALCUL PAR SOUS-STRUCTURATION 
C
        IF (LSSTF) THEN
          CALL NMCVEC('AJOU','CNSSTF',' ',.TRUE.,.TRUE.,
     &                NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)
        ENDIF
C
C --- FORCES IMPEDANCES
C   
        IF (LIMPE) THEN
          CALL NMCVEC('AJOU','CNIMPP',' ',.TRUE.,.TRUE.,
     &                NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)   
        ENDIF 
C
C --- CALCUL ET ASSEMBLAGE
C
        CALL NMXVEC(MODELE,MATE  ,CARELE,COMPOR,CARCRI,
     &              SDDISC,SDDYNA,NUMINS,VALMOI,VALPLU,
     &              POUGD ,SOLALG,LISCHA,COMREF,DEFICO,
     &              RESOCO,RESOCU,NUMEDD,PARCON,SDSENS,
     &              LSENS ,NRPASE,VEELEM,VEASSE,MEASSE,
     &              NBVECT,LTYPVE,LOPTVE,LCALVE,LASSVE)
      ELSE
        CALL ASSERT(.FALSE.)
      END IF

      CALL JEDEMA()
      END
