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

subroutine nmcrot(result, sd_obsv)
!
implicit none
!
#include "asterfort/exisd.h"
#include "asterfort/jeexin.h"
#include "asterfort/ltcrsd.h"
#include "asterfort/ltnotb.h"
#include "asterfort/tbajpa.h"
#include "asterfort/tbcrsd.h"
#include "asterfort/wkvect.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: result
    character(len=19), intent(in) :: sd_obsv
!
! --------------------------------------------------------------------------------------------------
!
! Non-linear operators - Observation
!
! Create table
!
! --------------------------------------------------------------------------------------------------
!
! In  result           : name of results datastructure
! In  sd_obsv          : datastructure for observation parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_para = 16
    character(len=8) :: para_type(nb_para)
    character(len=16) :: para_name(nb_para)
!
    character(len=24) :: obsv_tabl
    character(len=24), pointer :: v_obsv_tabl(:) => null()
    integer :: iret
    character(len=19) :: tabl_name
!
! --------------------------------------------------------------------------------------------------
!
    data para_name /'NOM_OBSERVATION','TYPE_OBJET'  ,&
                    'NUME_REUSE'     ,'NUME_OBSE'   ,'INST'   ,&
                    'NOM_CHAM'       ,'EVAL_CHAM'   ,'NOM_CMP', 'NOM_VARI',&
                    'EVAL_CMP'       ,'NOEUD'       ,'MAILLE' ,&
                    'EVAL_ELGA'      ,'POINT'       ,'SOUS_POINT',&
                    'VALE'           /
    data para_type /'K16','K16',&
                    'I'  ,'I'  ,'R'  ,&
                    'K16','K8' ,'K8' ,'K16',&
                    'K8' ,'K8' ,'K8' ,&
                    'K8' ,'I'  ,'I'  ,&
                    'R' /
!
! --------------------------------------------------------------------------------------------------
!
!
! - Create vector for table name
!
    obsv_tabl = sd_obsv(1:14)//'     .TABL'
    call wkvect(obsv_tabl, 'V V K24', 1, vk24 = v_obsv_tabl)
!
! - Create list of tables in results datastructure
!
    call jeexin(result//'           .LTNT', iret)
    if (iret .eq. 0) then
        call ltcrsd(result, 'G')
    endif
!
! - Get name of observation table
!
    tabl_name = ' '
    call ltnotb(result, 'OBSERVATION', tabl_name)
!
! - Create observation table
!
    call exisd('TABLE', tabl_name, iret)
    if (iret .eq. 0) then
        call tbcrsd(tabl_name, 'G')
        call tbajpa(tabl_name, nb_para, para_name, para_type)
    endif
!
! - Save name of table
!
    v_obsv_tabl(1) = tabl_name
!
end subroutine
