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
subroutine nonlinDSInOutInit(phenom, ds_inout)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/nonlinDSTableIOCreate.h"
#include "asterfort/nonlinDSTableIOSetPara.h"
!
character(len=4), intent(in) :: phenom
type(NL_DS_InOut), intent(inout) :: ds_inout
!
! --------------------------------------------------------------------------------------------------
!
! *_NON_LINE - Input/output management
!
! Initializations for input/output management
!
! --------------------------------------------------------------------------------------------------
!
! In  phenom           : phenomenon (MECA/THER/THNL)
! Out ds_inout         : datastructure for input/output management
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_para = 2
    character(len=24), parameter :: list_para(nb_para) = (/'NUME_REUSE','INST      '/)
    character(len=8),  parameter :: type_para(nb_para) = (/'I','R'/)
!
! --------------------------------------------------------------------------------------------------
!
    if (phenom.eq.'MECA') then
! ----- Create list of parameters
        call nonlinDSTableIOSetPara(tableio_   = ds_inout%table_io,&
                                    nb_para_   = nb_para,&
                                    list_para_ = list_para,&
                                    type_para_ = type_para)
! ----- Create table in results datastructure
        call nonlinDSTableIOCreate(ds_inout%result, 'PARA_CALC', ds_inout%table_io)
    else
        ASSERT(ASTER_FALSE)
    endif
!
end subroutine
