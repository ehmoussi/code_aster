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
    subroutine nxnpas(sddisc, solver    , nume_inst, ds_print,&
                      lnkry , l_evol    , l_stat   ,&
                      l_dry , result_dry, dry_prev , dry_curr,&
                      para  , time_curr , deltat   , reasma  ,&
                      tpsthe)
        use NonLin_Datastructure_type
        character(len=19), intent(in) :: sddisc, solver
        type(NL_DS_Print), intent(inout) :: ds_print
        integer, intent(in) :: nume_inst
        aster_logical, intent(in) :: lnkry, l_evol, l_stat
        aster_logical, intent(in) :: l_dry
        character(len=8), intent(in) :: result_dry
        character(len=24), intent(in) :: dry_prev, dry_curr
        real(kind=8), intent(inout) :: para(2)
        real(kind=8), intent(out) :: time_curr, deltat
        aster_logical, intent(out) :: reasma
        real(kind=8), intent(out) :: tpsthe(6)
    end subroutine nxnpas
end interface
