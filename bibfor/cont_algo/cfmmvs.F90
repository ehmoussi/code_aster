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

subroutine cfmmvs(ds_contact, nt_ncomp_poin, v_ncomp_jeux, v_ncomp_loca, v_ncomp_zone)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/r8prem.h"
#include "asterc/r8vide.h"
#include "asterfort/cfmmvd.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mminfr.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Contact), intent(in) :: ds_contact
    integer, intent(in) :: nt_ncomp_poin
    real(kind=8), pointer, intent(in) :: v_ncomp_jeux(:)
    integer, pointer, intent(in) :: v_ncomp_loca(:)
    integer, pointer, intent(in) :: v_ncomp_zone(:)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Post-treatment for no computation methods
!
! All methods - Fill CONT_NOEU datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
! In  nt_ncomp_poin    : number of points in no-computation mode
! In  v_ncomp_jeux     : pointer to save gaps
! In  v_ncomp_loca     : pointer to save index of node
! In  v_ncomp_zone     : pointer to save contact zone index
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: cnsinr
    integer :: i_ncomp_poin, i_zone
    real(kind=8) :: gap, node_status, tole_interp
    integer :: node_slav_nume
    integer :: zresu
    aster_logical :: l_save
    real(kind=8), pointer :: v_cnsinr_cnsv(:) => null()
    aster_logical, pointer :: v_cnsinr_cnsl(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    zresu = cfmmvd('ZRESU')
!
! - Name of post-treatment fields
!
    cnsinr = ds_contact%fields_cont_node
!
! - Access to fields
!
    call jeveuo(cnsinr(1:19)//'.CNSV', 'E', vr = v_cnsinr_cnsv)
    call jeveuo(cnsinr(1:19)//'.CNSL', 'E', vl = v_cnsinr_cnsl)
!
! - Fill
!
    do i_ncomp_poin = 1, nt_ncomp_poin
!
! ----- Parameters for current point
!
        gap            = v_ncomp_jeux(i_ncomp_poin)
        node_slav_nume = v_ncomp_loca(i_ncomp_poin)
        i_zone         = v_ncomp_zone(i_ncomp_poin)
        tole_interp    = mminfr(ds_contact%sdcont_defi, 'TOLE_INTERP', i_zone)
!
! ----- Contact status
!
        node_status = 0.d0
        if (gap .eq. r8vide()) then
            node_status = -1.d0
        else
            if (gap .gt. r8prem()) then
                node_status = 0.d0
            else
                if (abs(gap) .le. tole_interp) then
                    node_status = 0.d0
                else
                    node_status = 3.d0
                endif
            endif
        endif
!
! ----- Save or not ?
!
        l_save = .true.
        if (node_slav_nume .eq. -1) then
            l_save = .false.
        endif
!
! ----- Save in CONT_NOEU datastructure
!
        if (l_save) then
            v_cnsinr_cnsv(zresu*(node_slav_nume-1)+1 ) = node_status
            v_cnsinr_cnsv(zresu*(node_slav_nume-1)+2 ) = gap
            v_cnsinr_cnsl(zresu*(node_slav_nume-1)+1 ) = .true.
            v_cnsinr_cnsl(zresu*(node_slav_nume-1)+2 ) = .true.
        endif
    end do
!
end subroutine
