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

subroutine jni091(elrefe, nmaxob, liobj, nbobj)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jeexin.h"
#include "asterfort/wkvect.h"
    character(len=8) :: elrefe
! person_in_charge: jacques.pellet at edf.fr
! ----------------------------------------------------------------------
!
    integer :: iret, npg1
    integer :: l, ll, i1, i
    integer :: mzr, nbobj, nmaxob
    real(kind=8) :: x3(3), xi3, ff(3)
    character(len=24) :: demr, liobj(nmaxob)
! DEB -----------------------------------------------------------------
!
    ASSERT(elrefe(1:6).eq.'THCOSE')
    demr = '&INEL.'//elrefe//'.DEMR'
!
    nbobj = 1
    ASSERT(nmaxob.gt.nbobj)
    liobj(1) = demr
!
    call jeexin(demr, iret)
    if (iret .ne. 0) goto 30
!
!
! --------- NPG1 POINTS POUR INTEGRER LES FONCTIONS D'INTERPOLATION
!           (EPAISSEUR)
    npg1 = 3
!
    x3(1) = -0.774596669241483d0
    x3(2) = 0.d0
    x3(3) = 0.774596669241483d0
!
! --------- 16 PLACES MEMOIRES RESERVEES AU CAS OU ON PREND 4 PTS DE
!             GAUSS (AVEC 3 PTS 9 PLACES AURAIENT SUFFI)
!
    call wkvect(demr, 'V V R', 16, mzr)
!
    do 20 i = 1, npg1
        xi3 = x3(i)
!
        ff(1) = 1 - xi3*xi3
        ff(2) = -xi3* (1-xi3)/2.d0
        ff(3) = xi3* (1+xi3)/2.d0
!
        ll = 3* (i-1)
        do 10 l = 1, 3
            i1 = ll + l
            zr(mzr-1+i1) = ff(l)
10      continue
20  end do
!
    zr(mzr-1+13) = 0.555555555555556d0
    zr(mzr-1+14) = 0.888888888888889d0
    zr(mzr-1+15) = 0.555555555555556d0
!
!
30  continue
!
end subroutine
