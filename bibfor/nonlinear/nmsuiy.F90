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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmsuiy(ds_print, vale_r, i_dof_monitor)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/nmimcr.h"
!
type(NL_DS_Print), intent(inout) :: ds_print
real(kind=8), intent(in) :: vale_r
integer, intent(inout) :: i_dof_monitor
!
! --------------------------------------------------------------------------------------------------
!
! Non-linear operators - DOF monitor
!
! Write value
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_print         : datastructure for printing parameters
! In  vale_r           : value to print
! IO  i_dof_monitor    : index of current monitoring
!
! --------------------------------------------------------------------------------------------------
!
    character(len=9) :: typcol
    character(len=1) :: indsui
!
! --------------------------------------------------------------------------------------------------
!
    write(indsui,'(I1)') i_dof_monitor
    typcol = 'SUIVDDL'//indsui
    call nmimcr(ds_print, typcol, vale_r, .true._1)
    i_dof_monitor = i_dof_monitor + 1
!
end subroutine
