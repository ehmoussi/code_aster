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
subroutine dbr_para_info_pod(operation, ds_para_pod)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/romSnapInfo.h"
!
character(len=16), intent(in) :: operation
type(ROM_DS_ParaDBR_POD), intent(in) :: ds_para_pod
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_BASE_REDUITE - Initializations
!
! Informations about DEFI_BASE_REDUITE parameters
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_para_pod      : datastructure for parameters (POD)
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv

    character(len=24) :: field_name = ' ', surf_num = ' '
    character(len=8)  :: axe_line = ' '
    real(kind=8) :: tole_svd, tole_incr
    integer :: nb_mode_maxi
    aster_logical :: l_tabl_user
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM7_20')
    endif
!
! - Get parameters in datastructure - General for POD
!
    tole_svd     = ds_para_pod%tole_svd
    tole_incr    = ds_para_pod%tole_incr
    field_name   = ds_para_pod%field_name
    axe_line     = ds_para_pod%axe_line
    surf_num     = ds_para_pod%surf_num
    nb_mode_maxi = ds_para_pod%nb_mode_maxi
    l_tabl_user  = ds_para_pod%l_tabl_user
!
! - Print - General for POD
!
    if (niv .ge. 2) then
        if (nb_mode_maxi .ne. 0) then
            call utmess('I', 'ROM5_17', si = nb_mode_maxi)
        endif
        call utmess('I', 'ROM7_3' , sr = tole_svd)
        if (operation .eq. 'POD_INCR') then
            call utmess('I', 'ROM7_13' , sr = tole_incr)
            if (l_tabl_user) then
                call utmess('I', 'ROM7_26')
            endif
        endif
        call utmess('I', 'ROM7_2' , sk = field_name)
    endif
!
! - Print about snapshots selection
!
    if (niv .ge. 2) then
        call romSnapInfo(ds_para_pod%ds_snap)
    endif
!
end subroutine
