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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine romSolveDSInit(type_syst, ds_solve)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
!
character(len=3), intent(in) :: type_syst
type(ROM_DS_Solve), intent(out) :: ds_solve
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction - Initializations
!
! Initialisation of datastructure to solve systems
!
! --------------------------------------------------------------------------------------------------
!
! In  type_syst        : type of system
! Out ds_solve         : datastructure to solve systems
!
! --------------------------------------------------------------------------------------------------
!
    ds_solve%syst_matr       = '&&'//type_syst//'.MATR'
    ds_solve%syst_2mbr       = '&&'//type_syst//'.SECMBR'
    ds_solve%syst_solu       = '&&'//type_syst//'.SOLUTI'
    ds_solve%vect_zero       = '&&'//type_syst//'.VEZERO'
    ds_solve%syst_size       = 0
    ds_solve%syst_matr_type  = ' '
    ds_solve%syst_2mbr_type  = ' '
    ds_solve%syst_type       = ' '
!
end subroutine
