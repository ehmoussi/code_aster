! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine vtcreb_wrap(field_nodez, base, type_scalz, nume_ddlz)
!
implicit none
!
#include "asterfort/vtcreb.h"
!
!
    character(len=*), intent(in) :: field_nodez
    character(len=1), intent(in) :: base
    character(len=*), intent(in) :: type_scalz
    character(len=*), intent(in) :: nume_ddlz
!
! --------------------------------------------------------------------------------------------------
!
! Field utility
!
! Create NODE field
!
! --------------------------------------------------------------------------------------------------
!
! In  field_node    : name of field
! In  base          : JEVEUX base to create field
! In  type_scal     : type of GRANDEUR (real or complex)
! With numbering:
!   In  nume_ddl    : name of numbering
!
!   Out nb_equa_out : number of equations
! --------------------------------------------------------------------------------------------------
!
    call vtcreb(field_nodez, base, type_scalz, nume_ddlz)
!
end subroutine
