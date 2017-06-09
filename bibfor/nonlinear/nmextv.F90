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

subroutine nmextv(nb_cmp_vale, func_name, v_cmp_name, v_cmp_vale, nb_vale,&
                  vale_resu)
!
implicit none
!
#include "asterfort/fointe.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer, intent(in) :: nb_cmp_vale
    character(len=8), intent(in) :: func_name
    character(len=8), intent(in) :: v_cmp_name(*)
    real(kind=8), intent(in) :: v_cmp_vale(*)
    real(kind=8), intent(out) :: vale_resu(*)
    integer, intent(out) :: nb_vale
!
! --------------------------------------------------------------------------------------------------
!
! *_NON_LINE - Field extraction datastructure
!
! Extract component value or apply function between several components
!
! --------------------------------------------------------------------------------------------------
!
! In  nb_cmp_vale      : number of components to evaluate
! In  func_name        : name of function to evaluate (' ' if not function)
! In  v_cmp_name       : list of name of components
! In  v_cmp_vale       : list of value of components
! Out vale_resu        : list of result values
! Out nb_vale          : number of result values (one if function)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_cmp_vale, icode
    real(kind=8) :: valr
!
! --------------------------------------------------------------------------------------------------
!
    nb_vale = 0
!
    if (func_name .eq. ' ') then
        do i_cmp_vale = 1, nb_cmp_vale
            vale_resu(i_cmp_vale) = v_cmp_vale(i_cmp_vale)
        end do
        nb_vale = nb_cmp_vale
    else
        call fointe('FM', func_name, nb_cmp_vale, v_cmp_name, v_cmp_vale,&
                    valr, icode)
        vale_resu(1) = valr
        nb_vale = 1
    endif
!
end subroutine
