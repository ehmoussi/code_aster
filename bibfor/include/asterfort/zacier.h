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
!
interface
    subroutine zacier(jv_mater,&
                      nbhist, ftrc, trc, coef,&
                      fmod, ckm, nbtrc, tpg0, tpg1,&
                      tpg2, dt10, dt21, tamp, metapg)
        integer, intent(in) :: jv_mater
        integer :: nbtrc
        integer :: nbhist
        real(kind=8) :: ftrc((3*nbhist), 3)
        real(kind=8) :: trc((3*nbhist), 5)
        real(kind=8) :: coef(*)
        real(kind=8) :: fmod(*)
        real(kind=8) :: ckm(6*nbtrc)
        real(kind=8) :: tpg0
        real(kind=8) :: tpg1
        real(kind=8) :: tpg2
        real(kind=8) :: dt10
        real(kind=8) :: dt21
        real(kind=8) :: tamp(7)
        real(kind=8) :: metapg(7)
    end subroutine zacier
end interface
