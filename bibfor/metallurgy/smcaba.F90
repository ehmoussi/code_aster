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

subroutine smcaba(ftrc, trc, nbhist, x, dz,&
                  ind)
    implicit   none
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/rslsvd.h"
#include "asterfort/smcosl.h"
    integer :: ind(6), nbhist
    real(kind=8) :: ftrc((3*nbhist), 3), trc((3*nbhist), 5), x(5), dz(4)
!
!         CALCUL DES COORDONNEES BARYCENTRIQUES ET DE DZT
!-----------------------------------------------------------------------
    integer :: ifail, i, nz
    real(kind=8) :: som, alemb(6), a(6, 6), b(6)
    real(kind=8) :: epsmac, work(96), zero, s(6), u(6, 6), v(6, 6)
!     ------------------------------------------------------
!
!     CALCUL DES COORDONNEES BARYCENTRIQUES
!
    zero = 0.d0
    call smcosl(trc, ind, a, b, x,&
                nbhist)
!
    epsmac = r8prem()
!
    call rslsvd(6, 6, 6, a(1, 1), s(1),&
                u(1, 1), v(1, 1), 1, b(1), epsmac,&
                ifail, work(1))
!
!     PROBLEME DANS LA RESOLUTION DU SYSTEME SOUS CONTRAINT VSRSRR
    ASSERT(ifail .eq. 0)
!
    do 10 i = 1, 6
        alemb(i) = b(i)
10  end do
    som = zero
    do 20 i = 1, 6
        if (alemb(i) .lt. zero) alemb(i)=zero
        som = som + alemb(i)
20  end do
    if (som .eq. zero) then
        do 30 nz = 1, 3
            dz(nz) = ftrc(ind(1),nz)
30      continue
    else
        do 50 nz = 1, 3
            dz(nz) = zero
            do 40 i = 1, 6
                dz(nz) = dz(nz) + alemb(i)*ftrc(ind(i),nz)/som
40          continue
50      continue
    endif
!
end subroutine
