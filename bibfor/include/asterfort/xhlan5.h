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
    subroutine xhlan5(ino, idepl, idepm, idep0, lact, ndim,&
                      pla, lamb, nvec, champ, job, dpf)
        integer :: ino
        integer :: idepl
        integer :: idepm
        integer :: idep0
        integer :: lact(16)
        integer :: ndim
        integer :: pla(27)
        real(kind=8) :: lamb(3)
        integer :: nvec
        character(len=8) :: champ
        character(len=8) :: job
        real(kind=8) :: dpf
    end subroutine xhlan5
end interface
