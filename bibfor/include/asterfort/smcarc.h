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
    subroutine smcarc(nbhist, ftrc, trc, coef, fmod,&
                      metaSteelPara, nbtrc    , ckm,&
                      tempe, tpoint,&
                      dt, zin, zout)
        use Metallurgy_type
        integer :: nbtrc
        integer :: nbhist
        real(kind=8) :: ftrc((3*nbhist), 3)
        real(kind=8) :: trc((3*nbhist), 5)
        real(kind=8) :: coef(*)
        real(kind=8) :: fmod(*)
        type(META_SteelParameters), intent(in) :: metaSteelPara
        real(kind=8) :: ckm(6*nbtrc)
        real(kind=8) :: tempe
        real(kind=8) :: tpoint
        real(kind=8) :: dt
        real(kind=8) :: zin(7)
        real(kind=8) :: zout(7)
    end subroutine smcarc
end interface
