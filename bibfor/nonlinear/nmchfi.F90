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
subroutine nmchfi(ds_algopara, list_func_acti, sddyna   , ds_contact,&
                  sddisc     , nume_inst     , iter_newt,&
                  lcfint     , lcdiri        , lcbudi   , lcrigi    ,&
                  option)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/isfonc.h"
#include "asterfort/ndynlo.h"
#include "asterfort/nmchrm.h"
!
type(NL_DS_AlgoPara), intent(in) :: ds_algopara
integer, intent(in) :: list_func_acti(*)
character(len=19), intent(in) :: sddisc, sddyna
type(NL_DS_Contact), intent(in) :: ds_contact
integer, intent(in) :: nume_inst, iter_newt
aster_logical, intent(out) :: lcfint, lcrigi, lcdiri, lcbudi
character(len=16), intent(out) :: option
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Get option for update internal forces
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_algopara      : datastructure for algorithm parameters
! In  list_func_acti   : list of active functionnalities
! In  sddisc           : datastructure for discretization
! In  sddyna           : name of dynamic parameters datastructure
! In  nume_inst        : index of current time step
! In  iter_newt        : index of current Newton iteration
! In  ds_contact       : datastructure for contact management
! Out lcfint           : flag to compute internal forces (CNFINT)
! Out lcrigi           : flag to compute rigidity matrix
! Out lcdiri           : flag to compute Dirichlet boundary conditions - BT.LAMBDA (CNDIRI)
! Out lcbudi           : flag to compute Dirichlet boundary conditions - B.U (CNBUDI)
! Out option           : name of non-linear option
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_matr_asse
    character(len=16) :: type_matr_corr, type_matr_pred
    aster_logical :: l_unil, l_cont_disc, l_line_search
!
! --------------------------------------------------------------------------------------------------
!
    l_unil        = isfonc(list_func_acti,'LIAISON_UNILATER')
    l_cont_disc   = isfonc(list_func_acti,'CONT_DISCRET')
    l_line_search = isfonc(list_func_acti,'RECH_LINE')
!
! - Option for matrix
!
    call nmchrm('FORCES_INT',&
                ds_algopara   , list_func_acti, sddisc     , sddyna,&
                nume_inst     , iter_newt     , ds_contact ,&
                type_matr_pred, type_matr_corr, l_matr_asse)
    if (l_matr_asse) then
        if (type_matr_corr .eq. 'TANGENTE') then
            option = 'FULL_MECA'
        else
            option = 'FULL_MECA_ELAS'
        endif
    else
        option = 'RAPH_MECA'
    endif
!
! - Update rigidity matrix ?
!
    if (option .ne. 'RAPH_MECA') then
        lcrigi = ASTER_TRUE
    else
        lcrigi = ASTER_FALSE
    endif
!
! - Update internal forces ?
!
    if (.not.l_line_search .or. iter_newt .eq. 0) then
        lcfint = ASTER_TRUE
    else
        if (option .eq. 'FULL_MECA') then
            lcfint = ASTER_TRUE
        else
            lcfint = ASTER_FALSE
        endif
    endif
    if (l_cont_disc .or. l_unil) then
        lcfint = ASTER_TRUE
    endif
!
    lcdiri = lcfint
    lcbudi = lcfint
!
end subroutine
