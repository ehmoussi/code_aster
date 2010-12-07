      SUBROUTINE UTPPGL ( NN , NC , P , SG , SL )
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C            CONFIGURATION MANAGEMENT OF EDF VERSION
C MODIF UTILIFOR  DATE 23/10/2008   AUTEUR TORKHANI M.TORKHANI 
C ======================================================================
C COPYRIGHT (C) 1991 - 2008  EDF R&D                  WWW.CODE-ASTER.ORG
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
C ======================================================================
      IMPLICIT NONE
      REAL*8              P(3,3) , SL(*) , SG(*)
      INTEGER             NN, NC, N, N1, NDDL
      REAL*8     MATSY1(12,12), MATSY2(12,12)
      REAL*8     MATAS2(12,12), MATSYM(12,12)
      REAL*8     MATASY(12,12)
      REAL*8     PARSYM(78), PARASY(78)
      REAL*8     PARSMG(12,12), PARAYG(12,12)
      REAL*8     MATRIL(12,12), MATRIG(12,12)
      REAL*8     VECSYM(78), VECASY(78)
C     ------------------------------------------------------------------
C     PASSAGE D'UNE MATRICE TRIANGULAIRE ANTISYMETRIQUE DE NN*NC LIGNES
C     DU REPERE LOCAL AU REPERE GLOBAL (3D)
C     ------------------------------------------------------------------
CIN   I   NN   NOMBRE DE NOEUDS
CIN   I   N    NOMBRE DE NOEUDS
CIN   I   NC   NOMBRE DE COMPOSANTES
CIN   R   P    MATRICE DE PASSAGE 3D DE GLOBAL A LOCAL
CIN   R   SL   NN*NC COMPOSANTES DE LA TRIANGULAIRE SL DANS LOCAL
COUT  R   SG   NN*NC COMPOSANTES DE LA TRIANGULAIRE SG DANS GLOBAL
C     ------------------------------------------------------------------
      CALL JEMARQ()

      NDDL = NN * NC
      N    = NDDL*NDDL
      N1   = (NDDL+1)*NDDL/2
C
      CALL VECMAP (SG,N,MATRIL,NDDL)
      CALL LCTR2M (NDDL,MATRIL,MATSY1) 
      CALL LCSO2M (NDDL,MATRIL,MATSY1,MATSY2)
      CALL LCDI2M (NDDL,MATRIL,MATSY1,MATAS2)
      CALL LCPS2M (NDDL,0.5D0,MATSY2,MATSYM)
      CALL MAVEC (MATSYM,NDDL,VECSYM,N1)
      CALL LCPS2M (NDDL,0.5D0,MATAS2,MATASY)
      CALL MAVEC (MATASY,NDDL,VECASY,N1)
      CALL UTPSGL (NN,NC,P,VECSYM,PARSYM)
      CALL UPLSTR (NDDL,PARSMG,PARSYM)
      CALL UTPAGL (NN,NC,P,VECASY,PARASY)
      CALL UPLETR (NDDL,PARAYG,PARASY)
      CALL LCSO2M (NDDL,PARSMG,PARAYG,MATRIG)
      CALL MAPVEC (MATRIG,NDDL,SL,N)
C      
      CALL JEDEMA()

      END
