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

subroutine cdnfo2(mater, kfonc, xx, dn, fxx, ier)
!
    implicit none
!
#include "asterfort/rcvale.h"
    integer :: dn, ier
    character(len=16) :: kfonc, kaux
    character(len=8) :: mater, k8b
    real(kind=8) :: xx, fxx, wfxx(1)
    integer :: icodr2(1)
    character(len=32) :: phenom
!
    phenom = 'GLRC_DAMAGE'
    k8b = 'X '
    ier = 0
    if (dn .eq. 0) then
!
        call rcvale(mater, phenom, 1, k8b, [xx],&
                    1, kfonc, wfxx, icodr2(1), 1)
    else if (dn .eq. 1) then
!
        write (kaux,'(A1,A7)') 'D',kfonc(1:7)
        call rcvale(mater, phenom, 1, k8b, [xx],&
                    1, kaux, wfxx, icodr2(1), 1)
    else if (dn .eq. 2) then
!
        write (kaux,'(A2,A6)') 'DD',kfonc(1:6)
        call rcvale(mater, phenom, 1, k8b, [xx],&
                    1, kaux, wfxx, icodr2(1), 1)
    else
        ier = 3
    endif
    if (ier .eq. 0) then
        fxx = wfxx(1)
    endif
!
end subroutine
