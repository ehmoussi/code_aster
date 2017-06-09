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
interface
    subroutine mmvitm(nbdm, ndim, nne, nnm, ffe,&
                      ffm, jvitm, jaccm, jvitp, vitme,&
                      vitmm, vitpe, vitpm, accme, accmm)
        integer :: nbdm
        integer :: ndim
        integer :: nne
        integer :: nnm
        real(kind=8) :: ffe(9)
        real(kind=8) :: ffm(9)
        integer :: jvitm
        integer :: jaccm
        integer :: jvitp
        real(kind=8) :: vitme(3)
        real(kind=8) :: vitmm(3)
        real(kind=8) :: vitpe(3)
        real(kind=8) :: vitpm(3)
        real(kind=8) :: accme(3)
        real(kind=8) :: accmm(3)
    end subroutine mmvitm
end interface
