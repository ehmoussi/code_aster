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

subroutine nmetnc(field_name_algo, field_algo)
!
implicit none
!
#include "asterfort/assert.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=*), intent(in) :: field_name_algo
    character(len=*), intent(out) :: field_algo
!
! --------------------------------------------------------------------------------------------------
!
! *_NON_LINE - Input/output datastructure
!
! Get name of datastructure for field - This utiliy is required for "hat" variables
!
! --------------------------------------------------------------------------------------------------
!
! In  field_name_algo : name of field in algorithme
! Out field_algo      : name of datastructure for field
!
! --------------------------------------------------------------------------------------------------
!
    character(len=6) :: hat_type, hat_vari
!
! --------------------------------------------------------------------------------------------------
!
    field_algo = ' '
!
    if (field_name_algo(1:3) .eq. '#H#') then
        hat_type = field_name_algo(4:9)
        hat_vari = field_name_algo(11:16)
        if (hat_type .eq. 'VALINC') then
            if (hat_vari .eq. 'TEMP') then
                field_algo = '&&NXLECTVAR_____'
            else
                field_algo = '&&NMCH1P.'//hat_vari
            endif
        else if (hat_type.eq.'VEASSE') then
            field_algo = '&&NMCH5P.'//hat_vari
        else
            ASSERT(.false.)
        endif
    else
        field_algo = field_name_algo
    endif
!
end subroutine
