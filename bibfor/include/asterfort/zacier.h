! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
    subroutine zacier(metaSteelPara, nb_phase ,&
                      tpg0         , tpg1     , tpg2,&
                      dt10         , dt21     ,&
                      meta_prev    , meta_curr)
        use Metallurgy_type
        type(META_SteelParameters), intent(in) :: metaSteelPara
        integer, intent(in) :: nb_phase
        real(kind=8), intent(in) :: tpg0, tpg1, tpg2
        real(kind=8), intent(in) :: dt10, dt21
        real(kind=8), intent(in) :: meta_prev(nb_phase+3)
        real(kind=8), intent(out) :: meta_curr(nb_phase+3)
    end subroutine zacier
end interface
