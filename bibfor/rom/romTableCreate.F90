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
subroutine romTableCreate(resultName, tablResu)
!
use Rom_Datastructure_type
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infniv.h"
#include "asterfort/nonlinDSTableIOSetPara.h"
#include "asterfort/nonlinDSTableIOGetName.h"
#include "asterfort/utmess.h"
!
character(len=8), intent(in) :: resultName
type(NL_DS_TableIO), intent(inout) :: tablResu
!
! --------------------------------------------------------------------------------------------------
!
! Model reduction
!
! Create datastructure of table in results datastructure for the reduced coordinates
!
! --------------------------------------------------------------------------------------------------
!
! In  resultName       : name of datastructure for results
! IO  tablResu         : datastructure for table in result datastructure
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer, parameter :: nbPara = 5
    character(len=8), parameter :: paraType(nbPara) = (/'R','R','I','I','I'/)
    character(len=24), parameter :: paraName(nbPara) = (/'COOR_REDUIT','INST       ',&
                                                         'NUME_MODE  ','NUME_ORDRE ',&
                                                         'NUME_SNAP  '/)
    character(len=16), parameter :: tablSymbName = 'COOR_REDUIT'
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM5_38')
    endif
!
! - Create list of parameters
!
    call nonlinDSTableIOSetPara(tableio_  = tablResu,&
                                nbPara_   = nbPara,&
                                paraName_ = paraName,&
                                paraType_ = paraType)
!
! - Set other parameters
!
    tablResu%resultName   = resultName
    tablResu%tablSymbName = tablSymbName
!
! - Get name of table in results datastructure
!
    call nonlinDSTableIOGetName(tablResu)
!
end subroutine
