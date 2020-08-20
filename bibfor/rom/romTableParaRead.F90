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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine romTableParaRead(tablReduCoor)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infniv.h"
#include "asterfort/getvid.h"
#include "asterfort/utmess.h"
!
type(ROM_DS_TablReduCoor), intent(inout) :: tablReduCoor
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Read parameters of table for the reduced coordinates in command file
!
! --------------------------------------------------------------------------------------------------
!
! IO  tablReduCoor     : datastructure for table for the reduced coordinates in result
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nocc
    aster_logical :: lTablFromUser
    character(len=8) :: tablUserName
!
! --------------------------------------------------------------------------------------------------
!
    lTablFromUser = ASTER_FALSE
    tablUserName  = ' '
    call getvid(' ', 'TABL_COOR_REDUIT', scal = tablUserName, nbret = nocc)
    lTablFromUser = nocc .gt. 0
    tablReduCoor%lTablFromUser = lTablFromUser
    tablReduCoor%tablUserName  = tablUserName
!
end subroutine
