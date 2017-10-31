! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine lgvicb(ndim, nno1, nno2, npg, g,axi,r,&
                  bst, vff2, dfdi2, nddl,&
                  b)
!
    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/dfdmip.h"
#include "asterfort/r8inir.h"
    aster_logical :: axi
    integer :: ndim, nno1, nno2, npg,g
    real(kind=8) :: vff2(nno2),r,dfdi2(nno2*ndim)
    integer :: nddl
    real(kind=8) :: b(3*ndim+4,nddl),bst(6,nno1*ndim)

! ----------------------------------------------------------------------
!  CALCUL DES ELEMENTS CINEMATIQUES POUR LA MODELISATION GRAD_VARI
! ----------------------------------------------------------------------
! IN  NDIM   DIMENSION DE L'ESPACE
! IN  NNO1   NOMBRE DE NOEUDS TOTAL (SUPPORT DES DEPLACEMENTS)
! IN  NNO2   NOMBRE DE NOEUDS SOMMETS (SUPPORT DE VI ET LAGRANGE)
! IN  NPG    NOMBRE DE POINTS DE GAUSS
! IN  AXI    .TRUE. SI MODELISATION AXIS
! IN  GEOM   COORDONNEES DES NOEUDS
! IN  VFF1   VALEUR DE LA FAMILLE DE FONCTIONS DE FORME NO 1
! IN  VFF2   VALEUR DE LA FAMILLE DE FONCTIONS DE FORME NO 2
! IN  IDFDE1 POINTEUR SUR LES DER. REFERENCE FAMILLE FCT FORME NO 1
! IN  IDFDE2 POINTEUR SUR LES DER. REFERENCE FAMILLE FCT FORME NO 2
! IN  IW     POINTEUR SUR LES POIDS DES PTS DE GAUSS DE REFERENCE
! OUT NDDL   NOMBRE DE DDL / ELEMENT
! OUT NEPS   NBR DE COMPOSANTE DE DEFORMATION (GENERALISEE)
! OUT B      MATRICE CINEMATIQUE EPS = B.U
! OUT W      POIDS DES POINTS DE GAUSS REELS
! OUT NI2LDC CONVERSION CONTRAINTE STOCKEE -> CONTRAINTE LDC (AVEC RAC2)
! ! ----------------------------------------------------------------------
!     real(kind=8) :: rac2, r2, unsurr
! ! ----------------------------------------------------------------------
!     integer :: iu1, iu2, iub,ia, il, n, i, idfde2,ip,ig
!     real(kind=8) :: dff1, dff2,dfdi2(nno2*ndim)
!     iu1(n,i) = (n-1)*(ndim+4) + i
!     iu2(n,i) = nno2*4 + (n-1)*ndim + i
!     iub(n,i) = (n-1)*ndim + i
! 
!     ip(n) = (n-1)*(ndim+4) + ndim + 1
!     ig(n) = (n-1)*(ndim+4) + ndim + 2
!     ia(n) = (n-1)*(ndim+4) + ndim + 3
!     il(n) = (n-1)*(ndim+4) + ndim + 4
! !     dff1(n,i) = dfdi1(nno1*(i-1) + n)
!     dff2(n,i) = dfdi2(nno2*(i-1) + n)
! ! ----------------------------------------------------------------------
!     ASSERT(nno1.le.27)
!     ASSERT(nno2.le.8)
!     rac2 = sqrt(2.d0)
!     r2 = sqrt(2.d0)/2
!     nddl = nno1*ndim + nno2*4
!     b=0.
! !
! ! - AFFECTATION DE LA FONCTION DE TRANSFERT SIGMA NICE --> SIGMA LDC
! !
!         if (ndim .eq. 2) then
!             if (axi) then
!                 unsurr = 1./r
!             else
!                 unsurr = 0.
!             endif
! !
!             do 10 n = 1, nno2
!                 do 11 i = 1, 2
!                     b(1,iu1(n,i)) = bst(1,iub(n,i))
!                     b(2,iu1(n,i)) = bst(2,iub(n,i))
!                     b(3,iu1(n,i)) = bst(3,iub(n,i))
!                     b(4,iu1(n,i)) = bst(4,iub(n,i))
! 11              continue
! 
!                 b(5,ip(n)) = vff2(n)
!                 b(6,ig(n)) = vff2(n)
!                 b(7,ia(n)) = vff2(n)
!                 b(8,il(n)) = vff2(n)
!                 b(9,ia(n)) = dff2(n,1)
!                 b(10,ia(n)) = dff2(n,2)
! 10          continue
!             
!             do 20 n = nno2+1, nno1
!                 do 21 i =1, 2
!                     b(1,iu2(n,i)) = bst(1,iub(n,i))
!                     b(2,iu2(n,i)) = bst(2,iub(n,i))
!                     b(3,iu2(n,i)) = bst(3,iub(n,i))
!                     b(4,iu2(n,i)) = bst(4,iub(n,i))
! 21              continue
! 20          continue
! !             print*,'bi1 = ',b(:,4)
! !             print*,'bj5 = ',b(:,5)
! 
! !           print*, 'bst=', bst(1:6,1)
! 
!         else if (ndim.eq.3) then
!             do 30 n = 1, nno2
!                 do 31 i = 1, 3
!                     b(1,iu1(n,i)) = bst(1,iub(n,i))
!                     b(2,iu1(n,i)) = bst(2,iub(n,i))
!                     b(3,iu1(n,i)) = bst(3,iub(n,i))
!                     b(4,iu1(n,i)) = bst(4,iub(n,i))
!                     b(5,iu1(n,i)) = bst(5,iub(n,i))
!                     b(6,iu1(n,i)) = bst(6,iub(n,i))
! 31              continue
!                 b(7,ip(n)) = vff2(n)
!                 b(8,ig(n)) = vff2(n)
!                 b(9,ia(n)) = vff2(n)
!                 b(10,il(n)) = vff2(n)
!                 b(11,ia(n)) = dff2(n,1)
!                 b(12,ia(n)) = dff2(n,2)
!                 b(13,ia(n)) = dff2(n,3)
! 30          continue
! !
!             do 40 n = nno2+1, nno1
!                 do 41 i=1,3
!                     b(1,iu2(n,i)) = bst(1,iub(n,i))
!                     b(2,iu2(n,i)) = bst(2,iub(n,i))
!                     b(3,iu2(n,i)) = bst(3,iub(n,i))
!                     b(4,iu2(n,i)) = bst(4,iub(n,i))
!                     b(5,iu2(n,i)) = bst(5,iub(n,i))
!                     b(6,iu2(n,i)) = bst(6,iub(n,i))
! 41              continue
! 40          continue
!         endif


end subroutine
