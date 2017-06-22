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
interface 
    subroutine b3d_sd(ss6, t33, n33, l3, vt33,&
                      young0, xnu0, gf0, fr, rt,&
                      epic, beta1, gama1, reg, erreur,&
                      d03, dt3, st3, vss33, vss33t,&
                      local, e23, nfid1, rrr, rapp6,&
                      dpic0, istep)
#include "asterf_types.h"
        real(kind=8) :: ss6(6)
        real(kind=8) :: t33(3, 3)
        real(kind=8) :: n33(3, 3)
        real(kind=8) :: l3(3)
        real(kind=8) :: vt33(3, 3)
        real(kind=8) :: young0
        real(kind=8) :: xnu0
        real(kind=8) :: gf0
        real(kind=8) :: fr
        real(kind=8) :: rt
        real(kind=8) :: epic
        real(kind=8) :: beta1
        real(kind=8) :: gama1
        real(kind=8) :: reg
        integer :: erreur
        real(kind=8) :: d03(3)
        real(kind=8) :: dt3(3)
        real(kind=8) :: st3(3)
        real(kind=8) :: vss33(3, 3)
        real(kind=8) :: vss33t(3, 3)
        aster_logical :: local
        real(kind=8) :: e23(3)
        real(kind=8) :: nfid1
        aster_logical :: rrr
        real(kind=8) :: rapp6(6)
        real(kind=8) :: dpic0
        integer :: istep
    end subroutine b3d_sd
end interface 
