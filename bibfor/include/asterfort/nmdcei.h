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
    subroutine nmdcei(sddisc, nume_inst, newins, nb_inst_ini, nb_inst_ins,&
                      typext, dt0)
        integer :: nb_inst_ins, nume_inst, nb_inst_ini
        character(len=19) :: sddisc
        real(kind=8) :: newins(nb_inst_ins)
        real(kind=8) :: dt0
        character(len=4) :: typext
    end subroutine nmdcei
end interface
