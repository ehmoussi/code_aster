      SUBROUTINE UTGTME(NBARG,NOMARG,VALARG,IRET)
      IMPLICIT NONE
      INTEGER          NBARG, IRET
      CHARACTER*8      NOMARG(*)
      REAL*8           VALARG(*)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILITAI  DATE 27/11/2012   AUTEUR LEFEBVRE J-P.LEFEBVRE 
C ======================================================================
C COPYRIGHT (C) 1991 - 2012  EDF R&D                  WWW.CODE-ASTER.ORG
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
C RESPONSABLE LEFEBVRE J-P.LEFEBVRE
C ----------------------------------------------------------------------
C     RENVOIE LA OU LES VALEURS ASSOCIEES AU(X) NOM(S) NOMARG DES 
C     PARAMETRES MEMOIRE EN MEGA OCTETS
C IN  NBARG   : NOMBRE D'ARGUMENTS (>1)
C IN  NOMARG  : NOMS DES PARAMETRES
C OUT VALARG  : VALEURS DES PARAMETRES
C OUT IRET    : CODE RETOUR
C                =0 TOUTES LES VALEURS ONT ETE TROUVEES
C               !=0 AU MOINS UNE VALEUR EST INVALIDE
C
C DEB ------------------------------------------------------------------
      REAL *8         SVUSE,SMXUSE   
      COMMON /STATJE/ SVUSE,SMXUSE  
      REAL *8         MXDYN, MCDYN, MLDYN, VMXDYN, VMET, LGIO
      COMMON /R8DYJE/ MXDYN, MCDYN, MLDYN, VMXDYN, VMET, LGIO(2)
      REAL *8         VMUMPS,VPETSC,RLQMEM,VMINIT,VMJDC
      COMMON /MSOLVE/ VMUMPS,VPETSC,RLQMEM,VMINIT,VMJDC
C ----------------------------------------------------------------------
      INTEGER K,IV(4),IVAL,MEMPID,LOISEM,LOIS
      CHARACTER*8 NOM
C ----------------------------------------------------------------------
      IRET = 0
      CALL ASSERT( NBARG .GE.1 )  
      LOIS = LOISEM()  
      IV(1) = 0
      IV(2) = 0
      IV(3) = 0
      IV(4) = 0
      IVAL =  MEMPID(IV)
C     IV(1)=VmData IV(2)=VmSize IV(3)=VmPeak IV(4)=VmRSS
      
      DO 100 K=1,NBARG
      
        NOM = NOMARG(K)
        IF ( NOM .EQ. 'VMPEAK' ) THEN
C     
C ----- PIC MEMOIRE TOTALE
C         
          IF ( IVAL .NE. -1 ) THEN 
            VALARG(K) = DBLE(IV(3))/1024
          ELSE   
            IRET = IRET - 1
            VALARG(K) = 0.D0
          ENDIF 
C          
        ELSE IF ( NOM .EQ. 'VMRSS' ) THEN
C     
C ----- MEMOIRE RESIDENTE
C         
          IF ( IVAL .NE. -1 ) THEN 
            VALARG(K) = DBLE(IV(4))/1024
          ELSE   
            IRET = IRET - 1
            VALARG(K) = 0.D0
          ENDIF 
        ELSE IF ( NOM .EQ. 'VMSIZE' ) THEN
C     
C ----- MEMOIRE INSTANTANNEE
C         
          IF ( IVAL .NE. -1 ) THEN 
            VALARG(K) = DBLE(IV(2))/1024
          ELSE   
            IRET = IRET - 1
            VALARG(K) = 0.D0
          ENDIF 
C          
        ELSE IF ( NOM .EQ. 'LIMIT_JV' ) THEN   
C     
C ----- LIMITE MEMOIRE JEVEUX (MODIFIEE PAR JERMXD)
C         
          VALARG(K) = VMXDYN*LOIS/(1024*1024)
C          
        ELSE IF ( NOM .EQ. 'COUR_JV ' ) THEN   
C     
C ----- CONSOMMATION MEMOIRE JEVEUX COURANTE (CUMUL DES ALLOCATIONS)
C         
          VALARG(K) =  MCDYN*LOIS/(1024*1024)  
C       	   
        ELSE IF ( NOM .EQ. 'CMAX_JV ' ) THEN   
C     
C ----- CONSOMMATION MAXIMUM MEMOIRE JEVEUX (MAX DES CUMULS) 
C         
          VALARG(K) =  MXDYN/(1024*1024)
C         
        ELSE IF ( NOM .EQ. 'CMXU_JV ' ) THEN   
C     
C ----- CONSOMMATION MAXIMUM MEMOIRE JEVEUX  
C       OBJETS JEVEUX UTILISES 
C         
          VALARG(K) =  (SMXUSE*LOIS)/(1024*1024)
C         
        ELSE IF ( NOM .EQ. 'CUSE_JV ' ) THEN   
C     
C ----- CONSOMMATION MEMOIRE COURANTE JEVEUX  
C       OBJETS JEVEUX UTILISES 
C         
          VALARG(K) =  (SVUSE*LOIS)/(1024*1024)
C          
        ELSE IF ( NOM .EQ. 'MEM_TOTA' ) THEN
C     
C ----- LIMITE MEMOIRE ALLOUEE LORS DE L'EXECUTION  
C     
          VALARG(K) = VMET*LOIS/(1024*1024)  
C       		  
        ELSE IF ( NOM .EQ. 'MEM_MUMP' ) THEN
C     
C ----- CONSOMMATION MEMOIRE DU SOLVEUR MUMPS  
C     
          VALARG(K) = VMUMPS/(1024*1024)  
C       	       
        ELSE IF ( NOM .EQ. 'MEM_PETS' ) THEN
C     
C ----- CONSOMMATION MEMOIRE DU SOLVEUR PETSC
C     
          VALARG(K) = VPETSC/(1024*1024)  
C       			 
        ELSE IF ( NOM .EQ. 'MEM_INIT' ) THEN
C     
C ----- CONSOMMATION MEMOIRE DU JDC
C     
          VALARG(K) = VMINIT/(1024*1024)  
C       			 
        ELSE IF ( NOM .EQ. 'MEM_JDC' ) THEN
C     
C ----- CONSOMMATION MEMOIRE DU JDC
C     
          VALARG(K) = VMJDC/(1024*1024)  
C       			 
        ELSE IF ( NOM .EQ. 'RLQ_MEM' ) THEN
C     
C ------ ESTIMATION DU RELIQUAT MEMOIRE   
C     
          VALARG(K) = RLQMEM/(1024*1024)
C     
        ELSE
          IRET = IRET - 1
        ENDIF
C
 100  CONTINUE  
C         
C FIN ------------------------------------------------------------------
      END      
