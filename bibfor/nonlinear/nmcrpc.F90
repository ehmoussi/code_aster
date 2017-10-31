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
subroutine nmcrpc(result)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/nonlinDSTableIOSetPara.h"
#include "asterfort/nonlinDSTableIOCreate.h"
#include "asterfort/nonlinDSTableIOClean.h"
!
character(len=8), intent(in) :: result
!
! --------------------------------------------------------------------------------------------------
!
! *_NON_LINE
!
! Create table of parameters
!
! --------------------------------------------------------------------------------------------------
!
! In  result           : name of results datastructure
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_para = 8
    type(NL_DS_TableIO) :: tableio
    character(len=24), parameter :: list_para(nb_para) = (/'NUME_REUSE','INST      ','TRAV_EXT  ',&
                                                           'ENER_CIN  ','ENER_TOT  ','TRAV_AMOR ',&
                                                           'TRAV_LIAI ','DISS_SCH  '/)
    character(len=8),  parameter :: type_para(nb_para) = (/'I','R','R',&
                                                           'R','R','R',&
                                                           'R','R'/)
!
! --------------------------------------------------------------------------------------------------
!

!
! - Create list of parameters
!
    call nonlinDSTableIOSetPara(tableio_   = tableio,&
                                nb_para_   = nb_para,&
                                list_para_ = list_para,&
                                type_para_ = type_para)
!
! - Create table in results datastructure
!
    call nonlinDSTableIOCreate(result, 'PARA_CALC', tableio)
!
! - Clean table in results datastructure
!
    call nonlinDSTableIOClean(tableio)
!
end subroutine
