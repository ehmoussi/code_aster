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

subroutine coor_bary(coor,xm,dim,lino,cobary)
!
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "blas/dgels.h"
!
!
    real(kind=8), intent(in) :: coor(*)
    real(kind=8), intent(in) :: xm(3)
    integer, intent(in) :: dim
    integer, intent(in) :: lino(*)
    real(kind=8), intent(out) :: cobary(*)
!
! --------------------------------------------------------------------------------------------------
!
! But : determiner les coordonnees barycentriques du point xm par rapport aux dim+1
!       noeuds de lino
!
! --------------------------------------------------------------------------------------------------
!
! In  coor          : coordonnees des noeuds du maillage
! In  xm            : coordonnees du point
! In  dim           : 0/1/2/3
! In  lino          : liste des numeros des noeuds sommets du simplexe
! Out cobary        : coordonnees barycentriques de xm :
!                     xm= somme k=1,dim+1 (cobary(k)*coor(lino(k)))
!
! --------------------------------------------------------------------------------------------------
!

    integer :: m,n,k
    integer, parameter :: nrhs=1,lda=4,ldb=4,lwork=128
    blas_int :: info
    real(kind=8) ::   a( lda, lda ), b( ldb, 1 ), work( lwork ), ym(3)

!
! --------------------------------------------------------------------------------------------------
!
      if (dim.eq.0) then
         cobary(1)=1.d0
         goto 999
      endif

      b(1,1)=1.d0
      b(2:4,1)=xm(1:3)

      do k=1,dim+1
         a(1,k)=1.d0
         a(2:4,k)=coor(3*(lino(k)-1)+1:3*(lino(k)-1)+3)
      enddo

      m=4
      n=dim+1
      call dgels( 'N', m, n, nrhs, a, lda, b, ldb, work, lwork, info)
      ASSERT(info.eq.0)
      cobary(1:dim+1)=b(1:dim+1,1)

999   continue

!     -- verif :
      ym(1:3)=0.d0
      do k=1,dim+1
         ym(1:3)=ym(1:3)+cobary(k)*coor(3*(lino(k)-1)+1:3*(lino(k)-1)+3)
      enddo
end subroutine
