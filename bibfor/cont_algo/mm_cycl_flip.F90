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

subroutine mm_cycl_flip(ds_contact, cycl_flip)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/cfdisi.h"
#include "asterfort/jeveuo.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Contact), intent(in) :: ds_contact
    aster_logical, intent(out) :: cycl_flip
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve - Cycling
!
! Is flip-flop cycling ?
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
! Out cycl_flip        : .true. if flip-flop cycling activated
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: sdcont_cyceta
    integer, pointer :: p_sdcont_cyceta(:) => null()
    integer :: cycl_index, cycl_stat
    integer :: nb_cont_poin, i_cont_poin
!
! --------------------------------------------------------------------------------------------------
!
    cycl_flip = .false.
    cycl_index = 4
!
! - Cycling objects
!
    sdcont_cyceta = ds_contact%sdcont_solv(1:14)//'.CYCETA'
    call jeveuo(sdcont_cyceta, 'L', vi = p_sdcont_cyceta)
!
! - Flip-flop dectected ?
!
    nb_cont_poin = cfdisi(ds_contact%sdcont_defi,'NTPC' )
    do i_cont_poin = 1, nb_cont_poin
        cycl_stat = p_sdcont_cyceta(4*(i_cont_poin-1)+cycl_index)
        if (cycl_stat .eq. -10) cycl_flip = .true.
    end do
!
end subroutine
