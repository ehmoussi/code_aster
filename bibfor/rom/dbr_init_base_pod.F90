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
subroutine dbr_init_base_pod(base, ds_para_pod, l_reuse, ds_empi)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/rscrsd.h"
#include "asterfort/dbr_rnum.h"
#include "asterfort/romBaseGetInfo.h"
#include "asterfort/romTableCreate.h"
#include "asterfort/romBaseGetInfoFromResult.h"
!
character(len=8), intent(in) :: base
type(ROM_DS_ParaDBR_POD), intent(in) :: ds_para_pod
aster_logical, intent(in) :: l_reuse
type(ROM_DS_Empi), intent(inout) :: ds_empi
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Prepare datastructure for empiric modes - For POD methods
!
! --------------------------------------------------------------------------------------------------
!
! In  base             : name of empiric base
! In  ds_para_pod      : datastructure for parameters (POD)
! In  l_reuse          : .true. if reuse
! IO  ds_empi          : datastructure for empiric modes
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nb_mode_crea = 0, nb_mode_maxi = 0
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM2_12')
    endif
!
! - Get informations from parameters
!
    nb_mode_maxi = ds_para_pod%nb_mode_maxi
!
! - Create empiric base
!
    if (.not.l_reuse) then
        if (nb_mode_maxi .eq. 0) then
            nb_mode_crea = 10
        else
            nb_mode_crea = nb_mode_maxi
        endif
        if (niv .ge. 2) then
            call utmess('I', 'ROM7_11', si = nb_mode_crea)
        endif
        call rscrsd('G', base, 'MODE_EMPI', nb_mode_crea)
    endif
!
! - Create table for the reduced coordinates in results datastructure
!
    call romTableCreate(base, ds_empi%tabl_coor)
!
! - Get informations about empiric modes base
!
    if (l_reuse) then
        call romBaseGetInfo(base, ds_empi)
    else
        call romBaseGetInfoFromResult(ds_para_pod%ds_result_in, base, ds_empi)
        ds_empi%base_type = ds_para_pod%base_type
        ds_empi%axe_line  = ds_para_pod%axe_line
        ds_empi%surf_num  = ds_para_pod%surf_num
        ds_empi%nb_mode   = 0
        ds_empi%nb_snap   = 0
    endif
!
! - Create numbering of nodes for the lineic model
!
    if (ds_empi%base_type .eq. 'LINEIQUE') then
        if (niv .ge. 2) then
            call utmess('I', 'ROM2_40')
        endif
        call dbr_rnum(ds_empi)
    endif
!
end subroutine
