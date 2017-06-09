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

!
!
#include "asterf_types.h"
!
interface
    subroutine glrc_sig_mat(lambda, deuxmu, lamf, deumuf, alf,&
                      alfmc, emp, efp, eps, vmp,&
                      vfp, tr2d, trot, treps, gmt,&
                      gmc, gf, da1, da2, ksi2d,&
                      qff, cof1, q2d, de33d1, de33d2,&
                      elas, elas1, elas2, coup, rigi,&
                      resi, option, dsidep, sig, cof2,&
                      dq2d)
        real(kind=8) :: lambda
        real(kind=8) :: deuxmu
        real(kind=8) :: lamf
        real(kind=8) :: deumuf
        real(kind=8) :: alf
        real(kind=8) :: alfmc
        real(kind=8) :: emp(2)
        real(kind=8) :: efp(2)
        real(kind=8) :: eps(2)
        real(kind=8) :: vmp(2, 2)
        real(kind=8) :: vfp(2, 2)
        real(kind=8) :: tr2d
        real(kind=8) :: trot
        real(kind=8) :: treps
        real(kind=8) :: gmt
        real(kind=8) :: gmc
        real(kind=8) :: gf
        real(kind=8) :: da1
        real(kind=8) :: da2
        real(kind=8) :: ksi2d
        real(kind=8) :: qff(2)
        real(kind=8) :: cof1(2)
        real(kind=8) :: q2d(2)
        real(kind=8) :: de33d1
        real(kind=8) :: de33d2
        aster_logical :: elas
        aster_logical :: elas1
        aster_logical :: elas2
        aster_logical :: coup
        aster_logical :: rigi
        aster_logical :: resi
        character(len=16) :: option
        real(kind=8) :: dsidep(6, 6)
        real(kind=8) :: sig(6)
        real(kind=8) :: cof2(2)
        real(kind=8) :: dq2d(2)
    end subroutine glrc_sig_mat
end interface
