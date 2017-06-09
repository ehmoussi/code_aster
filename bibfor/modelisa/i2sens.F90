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

subroutine i2sens(chemin, nbrma2, limail, nbrma, connex,&
                  typmai, abscis)
    implicit none
#include "asterfort/assert.h"
#include "asterfort/i2extf.h"
    integer :: nbrma, nbrma2
    integer :: chemin(nbrma2), limail(nbrma)
    character(len=*) :: connex, typmai
    real(kind=8) :: abscis(2), delta
!
!-----------------------------------------------------------------------
    integer :: j, mi, mj, nid, nig, njd
    integer :: njg
!-----------------------------------------------------------------------
!
    mi = limail(chemin(1))
    call i2extf(mi, 1, connex, typmai, nig,&
                nid)
    delta = abscis(2)-abscis(1)
    mi = int(sign(1.d0*mi,delta))
    chemin(1) = mi

    do j = 2, nbrma
        mj = limail(chemin(j))
        call i2extf(mj, 1, connex, typmai, njg,&
                    njd)
!
        if ((nid .eq. njd) .or. (nig .eq. njg)) then
            mj = -mj*mi/abs(mi) 
        endif
!
        mi = mj
        nig = njg
        nid = njd
        chemin(j) = mi
    end do
end subroutine
