       SUBROUTINE PROMAT(A,NLAMAX,DIMAL,DIMAC,
     &                   B,NLBMAX,DIMBL,DIMBC,RES)
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF ALGELINE  DATE 06/01/95   AUTEUR G8BHHAC A.Y.PORTABILITE 
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
C
C    BUT : PRODUIT DE 2 MATRICES A*B DANS RES
C
C    IN  : NLAMAX    : NB DE LIGNES DE MATRICE A DIMENSIONNEES
C          DIMAL     : NB DE LIGNES DE MATRICE A UTILISEES
C          DIMAC     : NB DE COLONNES DE MATRICE A
C          A(DIMAL,DIMAC): MATRICE A
C          NLBMAX    : NB DE LIGNES DE MATRICE B DIMENSIONNEES
C          DIMBL     : NB DE LIGNES DE MATRICE B
C          DIMBC     : NB DE COLONNES DE MATRICE B
C          B(DIMBL,DIMBC): MATRICE B
C    
C    OUT : RES(DIMAL,DIMBC): MATRICE PRODUIT DE A*B
C ------------------------------------------------------------------
       IMPLICIT REAL*8 (A-H,O-Z)
       INTEGER DIMAC,DIMAL,DIMBC,DIMBL
       REAL*8 A(NLAMAX,*),B(NLBMAX,*),RES(NLAMAX,*)
       IF(DIMAC.NE.DIMBL) THEN
        CALL UTMESS('F','PROMAT','MATRICES A ET B INCOMPATIBLES'
     *   //' POUR L OPERATION * ')
       ENDIF
       DO 10 ILIG=1,DIMAL
         DO 10 ICOL=1,DIMBC
           XAUX=0.D0
           DO 5 K=1,DIMAC
             XAUX=XAUX+A(ILIG,K)*B(K,ICOL)
5          CONTINUE
         RES(ILIG,ICOL)=XAUX
10      CONTINUE
       END
