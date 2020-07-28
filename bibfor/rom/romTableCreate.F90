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
subroutine romTableCreate(resultName, tablName)
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
#include "asterfort/nonlinDSTableIOGetName.h"
#include "asterfort/utmess.h"
!
character(len=8), intent(in) :: resultName
character(len=24), intent(out) :: tablName
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Create table for the reduced coordinates in results datatructure
!
! --------------------------------------------------------------------------------------------------
!
! In  resultName       : name of datastructure for results
! Out tablName         : name of table in results datastructure
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    type(NL_DS_TableIO) :: tableio
    integer, parameter :: nbPara = 5
    character(len=8), parameter :: paraType(nbPara) = (/'R','R','I','I','I'/)
    character(len=24), parameter :: paraName(nbPara) = (/'COOR_REDUIT','INST       ',&
                                                         'NUME_MODE  ','NUME_ORDRE ',&
                                                         'NUME_SNAP  '/)
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_38')
    endif
    tablName = ' '
!
! - Create list of parameters
!
    call nonlinDSTableIOSetPara(tableio_  = tableio,&
                                nbPara_   = nbPara,&
                                paraName_ = paraName,&
                                paraType_ = paraType)
!
! - Set other parameters
!
    tableio%resultName   = resultName
    tableio%tablSymbName = 'COOR_REDUIT'
!
! - Get name of table in results datastructure
!
    call nonlinDSTableIOGetName(tableio)
    tablName = tableio%tablName
!
! - Create table in results datastructure (if necessary)
!
    call nonlinDSTableIOCreate(tableio)
!
! - Clean tableio datastructure
!
    call nonlinDSTableIOClean(tableio)
!
end subroutine
