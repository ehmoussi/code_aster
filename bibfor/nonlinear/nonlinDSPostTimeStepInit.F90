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
subroutine nonlinDSPostTimeStepInit(result         , ds_algopara, ds_constitutive,&
                                    ds_posttimestep)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8vide.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/utmess.h"
#include "asterfort/nonlinDSTableIOSetPara.h"
#include "asterfort/nonlinDSTableIOCreate.h"
!
character(len=8), intent(in) :: result
type(NL_DS_AlgoPara), intent(in) :: ds_algopara
type(NL_DS_Constitutive), intent(in) :: ds_constitutive
type(NL_DS_PostTimeStep), intent(inout) :: ds_posttimestep
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Post-treatment management
!
! Initializations for post-treatment at each time step
!
! --------------------------------------------------------------------------------------------------
!
! In  result           : name of results datastructure
! In  ds_algopara      : datastructure for algorithm parameters
! In  ds_constitutive  : datastructure for constitutive laws management
! IO  ds_posttimestep  : datastructure for post-treatment at each time step
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    aster_logical :: l_hpp
    integer, parameter :: nb_para = 10
    character(len=24), parameter :: list_para(nb_para) = (/&
        'INST           ','NUME_INST      ',&
        'NB_MODE        ','NUME_MODE      ','TYPE_MODE      ',&
        'FREQ           ','CHAR_CRIT      ','CHAR_STAB      ',&
        'NOM_OBJET      ','NOM_SD         '/)
    character(len=8),  parameter :: type_para(nb_para) = (/&
        'R  '            ,'I  '            ,&
        'I  '            ,'I  '            ,'K16'            ,&
        'R  '            ,'R  '            ,'R  '            ,&
        'K16'            ,'K24'            /)
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'MECANONLINE13_4')
    endif
!
! - Parameters for CRIT_STAB
!
    if (ds_posttimestep%l_crit_stab) then
        ds_posttimestep%crit_stab%type_matr_rigi = ds_algopara%matrix_pred
    endif
!
! - Select small strain hypothese
!
    l_hpp = ASTER_TRUE
    if (ds_constitutive%l_matr_geom) then
        l_hpp = ASTER_FALSE
    endif
    if (ds_posttimestep%l_crit_stab) then
        if (.not. ds_posttimestep%stab_para%l_geom_matr) then
            l_hpp = ASTER_FALSE
            call utmess('I', 'MECANONLINE4_3')
        endif
    endif
    ds_posttimestep%l_hpp = l_hpp
!
! - Create list of parameters for output table
!
    call nonlinDSTableIOSetPara(tableio_   = ds_posttimestep%table_io,&
                                nb_para_   = nb_para,&
                                list_para_ = list_para,&
                                type_para_ = type_para)
!
! - Create table in results datastructure
!
    call nonlinDSTableIOCreate(result, 'ANALYSE_MODALE', ds_posttimestep%table_io)    
!
end subroutine
