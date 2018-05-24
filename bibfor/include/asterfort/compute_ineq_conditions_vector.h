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
!
interface
    subroutine compute_ineq_conditions_vector(jsecmb, nbliai, neq   ,&
                                            japptr, japddl, japcoe,&
                                            jjeux , jtacf , jmu   ,&
                                            njeux , ztacf , iliac )
        integer :: jsecmb
        real(kind=8) :: jeuini, coefpn, lambdc
        integer :: iliai, iliac
        integer :: jmu
        integer :: japcoe, japddl, japptr
        integer :: jtacf
        integer :: jjeux, njeux
        integer :: ztacf
        integer :: nbliai, neq
        integer :: nbddl, jdecal
    end subroutine compute_ineq_conditions_vector
end interface
