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
subroutine misazl(ds_contact, sdnume, vector)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/jeveuo.h"
#include "asterfort/jelira.h"
!
type(NL_DS_Contact), intent(in) :: ds_contact
character(len=19), intent(in) :: sdnume
character(len=19), intent(in) :: vector
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve
!
! Continue method - Set Lagrangians to zero in unknowns vector
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
! In  sdnume           : datastructure for dof positions
! In  vector           : name of vector to modify
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_equa, nb_equa, nt_patch
    character(len=24) :: sdnuco
    integer, pointer :: p_nuco(:) => null()
    real(kind=8), pointer :: p_vale(:) => null()
    character(len=24) :: sdcont_lagc
    real(kind=8), pointer :: v_sdcont_lagc(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    call jeveuo(vector//'.VALE', 'E', vr = p_vale)
    call jelira(vector//'.VALE', 'LONMAX', nb_equa)
    sdnuco = sdnume(1:19)//'.NUCO'
    call jeveuo(sdnuco, 'L', vi = p_nuco)
    do i_equa = 1, nb_equa
        if (p_nuco(i_equa) .eq. 1) then
            p_vale(i_equa) = 0.d0
        endif
    end do
!
! - If LAC method is used
!
    if (ds_contact%l_form_lac) then
        nt_patch    = ds_contact%nt_patch
        sdcont_lagc = ds_contact%sdcont_solv(1:14)//'.LAGC'
        call jeveuo(sdcont_lagc, 'E', vr = v_sdcont_lagc)
        v_sdcont_lagc(1:nt_patch) = 0.d0
    endif
!
end subroutine
