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

subroutine rs_get_model(result_, nume, model, codret)
!
implicit none
!
#include "jeveux.h"
#include "asterc/getexm.h"
#include "asterfort/getvid.h"
#include "asterfort/rsadpa.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=*), intent(in) :: result_
    integer, intent(in) :: nume
    character(len=*), intent(out) :: model
    integer, intent(out) :: codret
!
! --------------------------------------------------------------------------------------------------
!
! Results datastructure - Utility
!
! Get model at index stored in results datastructure or from command file
!
! --------------------------------------------------------------------------------------------------
!
! In  result           : name of results datastructure
! In  nume             : index to find in results datastructure
! Out model            : name of model
! Out codret           : return code
!                        -1 - No model found
!                         1 - Model from command file
!                         2 - Model from results datastructure
!                         3 - Model from results datastructure and command file (the same)
!                         4 - Model from command file is different from results datastructure
!                        
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: result, model_resu, model_comm
    integer :: nocc, jv_para
!
! --------------------------------------------------------------------------------------------------
!
    result = result_
    model  = ' '
    nocc   = 0
    codret = -1
!
! - Get from command file
!
    model_comm = ' '
    if (getexm(' ','MODELE') .eq. 1) then
        call getvid(' ', 'MODELE', scal=model_comm, nbret=nocc)
    else
        model_comm = ' '
        nocc       = 0
    endif
!
! - Get from results datastructure
!
    model_resu = ' '
    call rsadpa(result, 'L', 1, 'MODELE', nume,&
                0, sjv=jv_para)
    model_resu = zk8(jv_para)
!
! - Select model
!
    if (model_resu .eq. ' ') then
        if (nocc .eq. 0) then
            model  = ' '
            codret = -1
        else
            model  = model_comm
            codret = 1
        endif
    else
        if (nocc .eq. 0) then
            model  = model_resu
            codret = 2
        else if (model_resu .eq. model_comm) then
            model  = model_comm
            codret = 3
        else
            model  = model_comm
            codret = 4
        endif
    endif
!
end subroutine
