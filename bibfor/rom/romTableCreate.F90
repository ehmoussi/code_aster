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
subroutine romTableCreate(result, tabl_name)
!
use Rom_Datastructure_type
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infniv.h"
#include "asterfort/nonlinDSTableIOSetPara.h"
#include "asterfort/nonlinDSTableIOCreate.h"
#include "asterfort/nonlinDSTableIOClean.h"
#include "asterfort/utmess.h"
!
character(len=8), intent(in) :: result
character(len=19), intent(out) :: tabl_name
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Create table for the reduced coordinates in results datatructure
!
! --------------------------------------------------------------------------------------------------
!
! In  result           : name of datastructure for results
! Out tabl_name        : name of table in results datastructure
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    type(NL_DS_TableIO) :: tableio
    integer, parameter :: nb_para = 5
    character(len=8), parameter :: type_para(nb_para) = (/'R','R','I','I','I'/)
    character(len=24), parameter :: list_para(nb_para) = (/'COOR_REDUIT','INST       ',&
                                                           'NUME_MODE  ','NUME_ORDRE ',&
                                                           'NUME_SNAP  '/)
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_38')
    endif
    tabl_name = ' '
!
! - Create list of parameters
!
    call nonlinDSTableIOSetPara(tableio_   = tableio,&
                                nb_para_   = nb_para,&
                                list_para_ = list_para,&
                                type_para_ = type_para)
!
! - Create table in results datastructure (if necessary)
!
    call nonlinDSTableIOCreate(result, 'COOR_REDUIT', tableio)
!
! - Save name of table
!
    tabl_name = tableio%table_name
!
! - Clean tableio datastructure
!
    call nonlinDSTableIOClean(tableio)
!
end subroutine
