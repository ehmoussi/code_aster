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
subroutine dbr_chck_pod(operation, ds_para_pod, l_reuse)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/rs_paraonce.h"
!
character(len=16), intent(in) :: operation
type(ROM_DS_ParaDBR_POD), intent(in) :: ds_para_pod
aster_logical, intent(in) :: l_reuse
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Some checks - For POD methods
!
! --------------------------------------------------------------------------------------------------
!
! In  operation        : type of method
! In  ds_para_pod      : datastructure for parameters (POD)
! In  l_reuse          : .true. if reuse
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer, parameter :: nb_para = 4
    character(len=16), parameter :: list_para(nb_para) = (/&
        'MODELE  ',&
        'CHAMPMAT',&
        'CARAELEM',&
        'EXCIT   '/)
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I','ROM5_19')
    endif
!
! - General checks
!
    if (l_reuse .and. operation.eq.'POD') then
        call utmess('F','ROM2_13', sk = operation)
    endif
!
! - Check results datastructures: parameters required
!
    call rs_paraonce(ds_para_pod%result_in, nb_para, list_para)
!
! - Check results datastructures: type of field
!
    
!
end subroutine
