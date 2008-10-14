      SUBROUTINE MMINFP(IZ    ,DEFICO,RESOCO,QUESTZ ,
     &                  IREP  ,RREP  ,KREP  ,LREP   )
C     
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGORITH  DATE 14/10/2008   AUTEUR DESOZA T.DESOZA 
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
C RESPONSABLE ABBAS M.ABBAS
C
      IMPLICIT NONE
      CHARACTER*24  DEFICO,RESOCO
      INTEGER       IZ
      CHARACTER*(*) QUESTZ
      INTEGER       IREP(*)
      REAL*8        RREP(*)
      CHARACTER*(*) KREP(*)
      LOGICAL       LREP(*)
C      
C ----------------------------------------------------------------------
C
C ROUTINE UTILITAIRE POUR LE CONTACT (CONTACT CONTINUE ET XFEM)
C
C REPOND A UNE QUESTION SUR UNE OPTION/CARACTERISTIQUE DU CONTACT
C METHODE CONTINUE
C
C ----------------------------------------------------------------------
C
C
C IN  DEFICO : SD POUR LA DEFINITION DU CONTACT
C IN  RESOCO : SD POUR LA RESOLUTION DU CONTACT
C IN  IZONE  : NUMERO DE LA ZONE DE CONTACT QU'ON INTERROGE
C                0 CARACTERISTIQUE COMMUNE A TOUTES LES ZONES
C IN  QUESTI : QUESTION POSEE
C               'FOND_FISSURE': DETECTION FOND_FISSURE ACTIVEE
C OUT IREP   : VALEUR SI C'EST UN ENTIER
C OUT RREP   : VALEUR SI C'EST UN REEL
C I/O KREP   : VALEUR SI C'EST UNE CHAINE
C OUT LREP   : VALEUR SI C'EST UN BOOLEEN
C
C -------------- DEBUT DECLARATIONS NORMALISEES JEVEUX -----------------
C
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
C
C ---------------- FIN DECLARATIONS NORMALISEES JEVEUX -----------------
C
      INTEGER      IZONE,IRET,NBZONE
      INTEGER      CFMMVD,ZCMCF,ZMETH,ZTOLE,ZECPD,ZEXCL,ZDIRN
      CHARACTER*24 CARACF,DIRNOR,METHCO,ECPDON
      INTEGER      JCMCF,JDIRNO,JMETH,JECPD
      CHARACTER*24 TOLECO,DIRAPP,NDIMCO,EXCLFR
      INTEGER      JTOLE,JDIRAP,JDIM,JEXCLF 
      CHARACTER*24 JEUPOU,JEUCOQ
      INTEGER      JJPOU,JJCOQ 
      INTEGER      NNOCO   
      CHARACTER*24 QUESTI
C
C ----------------------------------------------------------------------
C
      CALL JEMARQ()
C 
C --- INITIALISATIONS
C
      IF (IZ.EQ.0) THEN
        IZONE = 1
      ELSE
        IZONE = IZ
      ENDIF
      IREP(1) = 0
      RREP(1) = 0.D0
      LREP(1) = .FALSE.
      QUESTI = QUESTZ
C   
C --- ACCES AUX SDS
C 
      CARACF = DEFICO(1:16)//'.CARACF'
      DIRAPP = DEFICO(1:16)//'.DIRAPP'
      DIRNOR = DEFICO(1:16)//'.DIRNOR'     
      METHCO = DEFICO(1:16)//'.METHCO'
      NDIMCO = DEFICO(1:16)//'.NDIMCO'
      ECPDON = DEFICO(1:16)//'.ECPDON'
      TOLECO = DEFICO(1:16)//'.TOLECO'
      JEUPOU = DEFICO(1:16)//'.JEUPOU'
      JEUCOQ = DEFICO(1:16)//'.JEUCOQ' 
      EXCLFR = DEFICO(1:16)//'.EXCLFR'     
C
      ZMETH = CFMMVD('ZMETH')
      ZTOLE = CFMMVD('ZTOLE')
      ZCMCF = CFMMVD('ZCMCF')
      ZECPD = CFMMVD('ZECPD')
      ZEXCL = CFMMVD('ZEXCL')  
      ZDIRN = CFMMVD('ZDIRN')                 
C
C --- QUESTIONS
C
      IF     (QUESTI.EQ.'FOND_FISSURE') THEN
        CALL JEEXIN(CARACF,IRET)
        IF (IRET.EQ.0) THEN
          LREP(1) = .FALSE.
        ELSE
          CALL JEVEUO(CARACF,'L',JCMCF)
          IF (ZR(JCMCF+ZCMCF*(IZONE-1)+11) .EQ. 0.D0) THEN
            LREP(1) = .FALSE.
          ELSE
            LREP(1) = .TRUE.
          ENDIF
        ENDIF
C        
      ELSEIF (QUESTI.EQ.'RACCORD_LINE_QUAD') THEN
        CALL JEVEUO(CARACF,'L',JCMCF)
        IF (ZR(JCMCF+ZCMCF*(IZONE-1)+12) .EQ. 0.D0) THEN
          LREP(1) = .FALSE.
        ELSE
          LREP(1) = .TRUE.
        ENDIF
C
      ELSEIF (QUESTI.EQ.'XFEM_ALGO_LAGR') THEN
        CALL JEVEUO(CARACF,'L',JCMCF)
        IREP(1) = NINT(ZR(JCMCF+ZCMCF*(IZONE-1)+24))                    
C
      ELSEIF (QUESTI.EQ.'EXCLUSION_PIV_NUL') THEN
        CALL JEVEUO(CARACF,'L',JCMCF)
        NBZONE  = NINT(ZR(JCMCF))
        LREP(1) = .FALSE.
        IF (IZ.EQ.0) THEN
          DO 9 IZONE=1,NBZONE        
            IF (ZR(JCMCF+ZCMCF*(IZONE-1)+22) .NE. 0.D0) THEN
              LREP(1) = .TRUE.
              GOTO 99
            ENDIF
   9      CONTINUE    
        ELSE 
          IF (ZR(JCMCF+ZCMCF*(IZONE-1)+22) .EQ. 0.D0) THEN
            LREP(1) = .FALSE.
          ELSE
            LREP(1) = .TRUE.
          ENDIF
        ENDIF         
C
      ELSEIF (QUESTI.EQ.'DIST_POUTRE') THEN
        CALL JEVEUO(NDIMCO,'L',JDIM  )
        CALL JEVEUO(JEUPOU,'L',JJPOU )
        NNOCO  = ZI(JDIM+4)
        IF ( ZR(JJPOU-1+NNOCO+1).GT.0.5D0 ) THEN
          LREP(1) = .TRUE.
        ELSE
          LREP(1) = .FALSE.
        ENDIF        
C
      ELSEIF (QUESTI.EQ.'DIST_COQUE') THEN
        CALL JEVEUO(NDIMCO,'L',JDIM  )
        CALL JEVEUO(JEUCOQ,'L',JJCOQ )
        NNOCO  = ZI(JDIM+4)
        IF ( ZR(JJCOQ-1+NNOCO+1).GT.0.5D0 ) THEN
          LREP(1) = .TRUE.
        ELSE
          LREP(1) = .FALSE.
        ENDIF
C
      ELSEIF (QUESTI.EQ.'COMPLIANCE') THEN
        CALL JEVEUO(CARACF,'L',JCMCF)
        IF (ZR(JCMCF+ZCMCF*(IZONE-1)+7) .EQ. 0.D0) THEN
          LREP(1) = .FALSE.
        ELSE
          LREP(1) = .TRUE.
        ENDIF
C
      ELSEIF (QUESTI.EQ.'COEF_REGU_CONT') THEN
        CALL JEVEUO(CARACF,'L',JCMCF)
        RREP(1) = ZR(JCMCF+ZCMCF*(IZONE-1)+2)
C
      ELSEIF (QUESTI.EQ.'COEF_REGU_FROT') THEN
        CALL JEVEUO(CARACF,'L',JCMCF)
        RREP(1) = ZR(JCMCF+ZCMCF*(IZONE-1)+3)  
C
      ELSEIF (QUESTI.EQ.'COEF_ECHELLE') THEN
        CALL JEVEUO(CARACF,'L',JCMCF)
        RREP(1) = ZR(JCMCF+ZCMCF*(IZONE-1)+23)               
C
      ELSEIF (QUESTI.EQ.'COEF_COULOMB') THEN
        CALL JEVEUO(CARACF,'L',JCMCF)
        RREP(1) = ZR(JCMCF+ZCMCF*(IZONE-1)+4)       
C
      ELSEIF (QUESTI.EQ.'FROTTEMENT') THEN
        CALL JEVEUO(CARACF,'L',JCMCF)
        NBZONE  = NINT(ZR(JCMCF))
        IREP(1) = 0
        LREP(1) = .FALSE.
        DO 10 IZONE=1,NBZONE
          IREP(1) = NINT(ZR(JCMCF+ZCMCF*(IZONE-1)+5))
          IF (IREP(1).EQ.3) THEN
            LREP(1) = .TRUE.
            GOTO 99
          ENDIF
  10    CONTINUE
       ELSEIF (QUESTI.EQ.'FROTTEMENT_ZONE') THEN
        CALL JEVEUO(CARACF,'L',JCMCF)
        LREP(1) = .FALSE.
        IREP(1) = NINT(ZR(JCMCF+ZCMCF*(IZONE-1)+5))
        IF (IREP(1).EQ.3) THEN
          LREP(1) = .TRUE.
        ENDIF     
C
      ELSEIF (QUESTI.EQ.'SANS_GROUP_NO') THEN
        CALL JEVEUO(CARACF,'L',JCMCF) 
        IF (NINT(ZR(JCMCF+25)).EQ.1) THEN
          LREP(1) = .TRUE.
        ELSE
          LREP(1) = .FALSE.
        ENDIF   
C
      ELSEIF (QUESTI.EQ.'SANS_GROUP_NO_FR') THEN
        CALL JEVEUO(CARACF,'L',JCMCF) 
        IF (NINT(ZR(JCMCF+25)).EQ.2) THEN
          LREP(1) = .TRUE.
        ELSE
          LREP(1) = .FALSE.
        ENDIF             
C        
      ELSEIF (QUESTI.EQ.'USURE') THEN
        CALL JEVEUO(CARACF,'L',JCMCF)
        IF (ZR(JCMCF+ZCMCF*(IZONE-1)+13) .EQ. 0.D0) THEN
          LREP(1) = .FALSE.
        ELSE
          LREP(1) = .TRUE.
        ENDIF
C        
      ELSEIF (QUESTI.EQ.'USURE_K') THEN
        CALL JEVEUO(CARACF,'L',JCMCF)
        RREP(1)  = ZR(JCMCF+ZCMCF*(IZONE-1)+14)  
C        
      ELSEIF (QUESTI.EQ.'USURE_H') THEN
        CALL JEVEUO(CARACF,'L',JCMCF)
        RREP(1)  = ZR(JCMCF+ZCMCF*(IZONE-1)+15)                 
C
      ELSEIF (QUESTI.EQ.'PROJ_NEWT_ITER') THEN
        IREP(1) = 20
C        
      ELSEIF (QUESTI.EQ.'PROJ_NEWT_EPSI') THEN
        RREP(1) = 1D-4
C
      ELSEIF (QUESTI.EQ.'RESI_FROT') THEN
        RREP(1) = 1D-4
C
      ELSEIF (QUESTI.EQ.'RESI_GEOM') THEN
        RREP(1) = 1D-4
C
      ELSEIF (QUESTI.EQ.'TOLE_PROJ_EXT') THEN
        CALL JEVEUO(TOLECO,'L',JTOLE)
        RREP(1) = ZR(JTOLE+ZTOLE*(IZONE-1))
C        
      ELSEIF (QUESTI.EQ.'TOLE_APPA') THEN
        CALL JEVEUO(TOLECO,'L',JTOLE)
        RREP(1) = ZR(JTOLE+ZTOLE*(IZONE-1)+6)                
C
      ELSEIF (QUESTI.EQ.'FLIP_FLOP_IMAX') THEN
        IREP(1) = 20
C
      ELSEIF (QUESTI.EQ.'CONTACT_INIT') THEN
        CALL JEVEUO(ECPDON,'L',JECPD)
        IF (ZI(JECPD+ZECPD*(IZONE-1)+5) .EQ. 1) THEN
          LREP(1) = .TRUE.
        ELSE
          LREP(1) = .FALSE.
        ENDIF
C
      ELSEIF (QUESTI.EQ.'LISSAGE') THEN
        CALL JEVEUO(METHCO,'L',JMETH)
        IF (ZI(JMETH+ZMETH*(IZONE-1)+10).EQ.0) THEN
          LREP(1) = .FALSE.
        ELSEIF (ZI(JMETH+ZMETH*(IZONE-1)+10).EQ.1) THEN
          LREP(1) = .TRUE.
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
C
      ELSEIF (QUESTI.EQ.'NORMALE') THEN
        CALL JEVEUO(METHCO,'L',JMETH)
        IREP(1) = ZI(JMETH+ZMETH*(IZONE-1)+8)             
C
      ELSEIF (QUESTI.EQ.'MAIT') THEN
        CALL JEVEUO(METHCO,'L',JMETH)
        IF (ZI(JMETH+ZMETH*(IZONE-1)+8).EQ.0) THEN
          LREP(1) = .TRUE.
        ELSE
          LREP(1) = .FALSE.
        ENDIF 
C
      ELSEIF (QUESTI.EQ.'MAIT_ESCL') THEN
        CALL JEVEUO(METHCO,'L',JMETH)
        IF (ZI(JMETH+ZMETH*(IZONE-1)+8).EQ.1) THEN
          LREP(1) = .TRUE.
        ELSE
          LREP(1) = .FALSE.
        ENDIF
C
      ELSEIF (QUESTI.EQ.'ESCL') THEN
        CALL JEVEUO(METHCO,'L',JMETH)
        IF (ZI(JMETH+ZMETH*(IZONE-1)+8).EQ.2) THEN
          LREP(1) = .TRUE.
        ELSE
          LREP(1) = .FALSE.
        ENDIF    
C
      ELSEIF (QUESTI.EQ.'VECT_MAIT') THEN
        CALL JEVEUO(METHCO,'L',JMETH)
        IREP(1) = ZI(JMETH+ZMETH*(IZONE-1)+11)
        IF (ZI(JMETH+ZMETH*(IZONE-1)+11).GT.0) THEN
          CALL JEVEUO(DIRNOR,'L',JDIRNO)
          RREP(1) = ZR(JDIRNO+ZDIRN*(IZONE-1))
          RREP(2) = ZR(JDIRNO+ZDIRN*(IZONE-1)+1)
          RREP(3) = ZR(JDIRNO+ZDIRN*(IZONE-1)+2)  
        ELSE
          RREP(1) = 0.D0
          RREP(2) = 0.D0
          RREP(3) = 0.D0  
        ENDIF                     
C
      ELSEIF (QUESTI.EQ.'VECT_ESCL') THEN
        CALL JEVEUO(METHCO,'L',JMETH)
        IREP(1) = ZI(JMETH+ZMETH*(IZONE-1)+12)
        IF (ZI(JMETH+ZMETH*(IZONE-1)+12).GT.0) THEN
          CALL JEVEUO(DIRNOR,'L',JDIRNO)
          RREP(1) = ZR(JDIRNO+ZDIRN*(IZONE-1)+3)
          RREP(2) = ZR(JDIRNO+ZDIRN*(IZONE-1)+4)
          RREP(3) = ZR(JDIRNO+ZDIRN*(IZONE-1)+5)  
        ELSE
          RREP(1) = 0.D0
          RREP(2) = 0.D0
          RREP(3) = 0.D0  
        ENDIF                                           
C
      ELSEIF (QUESTI.EQ.'SEUIL_INIT') THEN
        CALL JEVEUO(CARACF,'L',JCMCF)
        RREP(1) = ZR(JCMCF+ZCMCF*(IZONE-1)+6)
C      
      ELSEIF (QUESTI.EQ.'INTEGRATION') THEN
        CALL JEVEUO(CARACF,'L',JCMCF)
        IREP(1) = NINT(ZR(JCMCF+ZCMCF*(IZONE-1)+1))
        RREP(1) = ZR(JCMCF+ZCMCF*(IZONE-1)+1)                
C
      ELSEIF (QUESTI.EQ.'TYPE_APPA') THEN
        CALL JEVEUO(METHCO,'L',JMETH)
        IF (ZI(JMETH+ZMETH*(IZONE-1)+9).EQ.0) THEN
          LREP(1) = .FALSE.
          RREP(1) = 0.D0
          RREP(2) = 0.D0
          RREP(3) = 0.D0        
        ELSEIF (ZI(JMETH+ZMETH*(IZONE-1)+9).EQ.1) THEN
          CALL JEVEUO(DIRAPP,'L',JDIRAP)
          LREP(1) = .TRUE.
          RREP(1) = ZR(JDIRAP+3*(IZONE-1))
          RREP(2) = ZR(JDIRAP+3*(IZONE-1)+1)
          RREP(3) = ZR(JDIRAP+3*(IZONE-1)+2)
        ELSE
          CALL ASSERT(.FALSE.)
        ENDIF
C
      ELSEIF (QUESTI.EQ.'EXCL_FROT_1') THEN
        CALL JEVEUO(METHCO,'L',JMETH)
        IF (ZI(JMETH+ZMETH*(IZONE-1)+2).EQ.1) THEN
          CALL JEVEUO(EXCLFR,'L',JEXCLF)
          LREP(1) = .TRUE.
          RREP(1) = ZR(JEXCLF+ZEXCL*(IZONE-1))
          RREP(2) = ZR(JEXCLF+ZEXCL*(IZONE-1)+1)
          RREP(3) = ZR(JEXCLF+ZEXCL*(IZONE-1)+2)
        ELSE
          LREP(1) = .FALSE.
          RREP(1) = 0.D0
          RREP(2) = 0.D0
          RREP(3) = 0.D0
        ENDIF
C
      ELSEIF (QUESTI.EQ.'EXCL_FROT_2') THEN
        IF (ZI(JMETH+ZMETH*(IZONE-1)+2).EQ.1) THEN
          CALL JEVEUO(EXCLFR,'L',JEXCLF)
          LREP(1) = .TRUE.
          RREP(1) = ZR(JEXCLF+ZEXCL*(IZONE-1)+3)
          RREP(2) = ZR(JEXCLF+ZEXCL*(IZONE-1)+4)
          RREP(3) = ZR(JEXCLF+ZEXCL*(IZONE-1)+5)
        ELSE
          LREP(1) = .FALSE.
          RREP(1) = 0.D0
          RREP(2) = 0.D0
          RREP(3) = 0.D0
        ENDIF
C
      ELSEIF (QUESTI.EQ.'ASPERITE') THEN
        CALL JEVEUO(CARACF,'L',JCMCF)
        RREP(1) = ZR(JCMCF+ZCMCF*(IZONE-1)+8)
C
      ELSEIF (QUESTI.EQ.'GLISSIERE') THEN
        CALL JEVEUO(METHCO,'L',JMETH)
        IF (ZI(JMETH+ZMETH*(IZONE-1)+6) .EQ. 8) THEN
          LREP(1) = .TRUE.
        ELSEIF (ZI(JMETH+ZMETH*(IZONE-1)+6) .EQ. 12) THEN
          LREP(1) = .TRUE.          
        ELSE
          LREP(1) = .FALSE.
        ENDIF
C        
      ELSEIF (QUESTI.EQ.'ITER_CONT_MAXI') THEN
        CALL JEVEUO(ECPDON,'L',JECPD)
        IREP(1) = ZI(JECPD+2)
C
      ELSEIF (QUESTI.EQ.'ITER_FROT_MAXI') THEN
        CALL JEVEUO(ECPDON,'L',JECPD)
        IREP(1) = ZI(JECPD+3)
C
      ELSEIF (QUESTI.EQ.'ITER_GEOM_MAXI') THEN
        CALL JEVEUO(ECPDON,'L',JECPD)
        IREP(1) = ZI(JECPD+4)
C
      ELSEIF (QUESTI.EQ.'FORMUL_VITE') THEN
        CALL JEVEUO(ECPDON,'L',JECPD)
        IF (ZI(JECPD+ZECPD*(IZONE-1)+6).EQ.2) THEN
          LREP(1) = .TRUE.
        ELSE
          LREP(1) = .FALSE.
        ENDIF
C
      ELSEIF (QUESTI.EQ.'XFEM_GG') THEN 
        CALL JEVEUO(ECPDON,'L',JECPD)
         IREP(1) = ZI(JECPD+4)
         IF (IREP(1).GT.0) THEN
           LREP(1) = .TRUE.
         ELSE
           LREP(1) = .FALSE.
         ENDIF      
C
      ELSE
        WRITE(6,*) '   NUM. ZONE    : <',IZONE  ,'>'
        WRITE(6,*) '   QUESTION     : <',QUESTI ,'>'
        WRITE(6,*) '   REPONSE  - I : <',IREP(1),'>'
        WRITE(6,*) '   REPONSE  - R : <',RREP(1),'>'
        WRITE(6,*) '   REPONSE  - L : <',LREP(1),'>'            
        CALL ASSERT(.FALSE.)
      ENDIF  
C
 99   CONTINUE          
C
      CALL JEDEMA()
      END
