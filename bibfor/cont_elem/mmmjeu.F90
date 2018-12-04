! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine mmmjeu(ndim  , iresog, jeusup,&
                  geome , geomm ,&
                  ddeple, ddeplm,&
                  norm  , mprojt,&
                  jeu   , djeu  , djeut )
!
implicit none
!
#include "asterfort/assert.h"
!
integer, intent(in) :: ndim, iresog
real(kind=8), intent(in) :: jeusup,  norm(3)
real(kind=8), intent(in):: geomm(3), geome(3)
real(kind=8), intent(in) :: ddeple(3), ddeplm(3)
real(kind=8), intent(in) :: mprojt(3, 3)
real(kind=8), intent(out) :: jeu, djeu(3), djeut(3)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Compute gaps
!
! --------------------------------------------------------------------------------------------------
!
! In  ndim             : dimension of problem (2 or 3)
! In  iresog           : algorithm for geometry
!                        0 - Fixed point
!                        1 - Newton
! In  jeusup           : gap from DIST_ESCL/DIST_MAIT
! In  norm             : normal at current contact point
! In  geome            : coordinates for contact point
! In  geomm            : coordinates for projection of contact point
! In  ddeple           : increment of displacement for contact point
! In  ddeplm           : increment of displacement for projection of contact point
! In  mprojt           : matrix of tangent projection
! Out jeu              : normal gap
! Out djeu             : increment of gap
! Out djeut            : increment of tangent gaps
!
! --------------------------------------------------------------------------------------------------
!
    integer :: idim, i, j
!
! --------------------------------------------------------------------------------------------------
!
    djeu(:)  = 0.d0
    djeut(:) = 0.d0
    jeu      = 0.d0
!
! - Increment of normal gap
!
    do idim = 1, 3
        djeu(idim) = ddeple(idim) - ddeplm(idim)
    end do
!
! - Normal gap
!
    jeu = jeusup
    do idim = 1, ndim
        jeu = jeu + (geome(idim)+(1-iresog)*ddeple(idim) &
                  -  geomm(idim)-(1-iresog)*ddeplm(idim))*norm(idim)
    end do
!
! - Increment of tangent gaps
!
    do i = 1, ndim
        do j = 1, ndim
            djeut(i) = mprojt(i,j)*djeu(j)+djeut(i)
        end do
    end do
!
end subroutine
