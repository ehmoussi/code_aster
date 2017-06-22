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

subroutine mm_cycl_erase(ds_contact, cycl_type, point_curr)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/cfdisi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
    type(NL_DS_Contact), intent(in) :: ds_contact
    integer, intent(in) :: cycl_type
    integer, intent(in) :: point_curr
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve - Cycling
!
! Erase cycling informations
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
! In  cycl_type        : type of cycling to erase
!                     0 - for erasing for all cycles
! In  point_curr       : contact point to erasing
!                     0 - when erasing all cycles
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: sdcont_cyclis
    integer, pointer :: p_sdcont_cyclis(:) => null()
    character(len=24) :: sdcont_cycnbr
    integer, pointer :: p_sdcont_cycnbr(:) => null()
    character(len=24) :: sdcont_cyceta
    integer, pointer :: p_sdcont_cyceta(:) => null()
    integer :: nt_cont_poin, i_cont_poin
    integer :: cycl_index
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Name of cycling objects
!
    sdcont_cyclis = ds_contact%sdcont_solv(1:14)//'.CYCLIS'
    sdcont_cycnbr = ds_contact%sdcont_solv(1:14)//'.CYCNBR'
    sdcont_cyceta = ds_contact%sdcont_solv(1:14)//'.CYCETA'
!
! - Access to cycling objects
!
    call jeveuo(sdcont_cyclis, 'E', vi = p_sdcont_cyclis)
    call jeveuo(sdcont_cycnbr, 'E', vi = p_sdcont_cycnbr)
    call jeveuo(sdcont_cyceta, 'E', vi = p_sdcont_cyceta)
!
! - Get contact parameters
!
    nt_cont_poin = cfdisi(ds_contact%sdcont_defi,'NTPC' )
!
! - Erasing cycling information
!
    if (cycl_type .eq. 0) then
        ASSERT(point_curr.eq.0)
        do cycl_index = 1, 4
            do i_cont_poin = 1, nt_cont_poin
                p_sdcont_cyclis(4*(i_cont_poin-1)+cycl_index) = 0
                p_sdcont_cycnbr(4*(i_cont_poin-1)+cycl_index) = 0
                p_sdcont_cyceta(4*(i_cont_poin-1)+cycl_index) = -1
            enddo
        end do
    else if (cycl_type.gt.0) then
        ASSERT(point_curr.le.nt_cont_poin)
        ASSERT(point_curr.ge.1)
        ASSERT(cycl_type.ge.1)
        ASSERT(cycl_type.le.4)
        cycl_index = cycl_type
        i_cont_poin = point_curr
        p_sdcont_cyclis(4*(i_cont_poin-1)+cycl_index) = 0
        p_sdcont_cycnbr(4*(i_cont_poin-1)+cycl_index) = 0
        p_sdcont_cyceta(4*(i_cont_poin-1)+cycl_index) = -1
    else
        ASSERT(.false.)
    endif
!
    call jedema()
end subroutine
