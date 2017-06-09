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

subroutine mm_cycl_stat(ds_measure, ds_contact)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/cfdisi.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmrvai.h"
#include "asterfort/mm_cycl_erase.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Measure), intent(inout) :: ds_measure
    type(NL_DS_Contact), intent(in) :: ds_contact
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve - Cycling
!
! Statistics
!
! --------------------------------------------------------------------------------------------------
!
! IO  ds_measure       : datastructure for measure and statistics management
! In  ds_contact       : datastructure for contact management
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: sdcont_cyceta
    integer, pointer :: p_sdcont_cyceta(:) => null()
    integer :: cycl_index, cycl_stat
    integer :: i_cont_poin, nt_cont_poin
    integer :: cycl_nb(4)
!
! --------------------------------------------------------------------------------------------------
!
    cycl_nb(1:4) = 0
!
! - Get contact parameters
!
    nt_cont_poin = cfdisi(ds_contact%sdcont_defi,'NTPC' )
!
! - Acces to cycling objects
!
    sdcont_cyceta = ds_contact%sdcont_solv(1:14)//'.CYCETA'
    call jeveuo(sdcont_cyceta, 'L', vi = p_sdcont_cyceta)
!
! - Counting cycles
!
    do i_cont_poin = 1, nt_cont_poin
        do cycl_index = 1, 4
            cycl_stat = p_sdcont_cyceta(4*(i_cont_poin-1)+cycl_index)
            if (cycl_stat .ne. 0) then
                cycl_nb(cycl_index) = cycl_nb(cycl_index) + 1
            endif
            if (cycl_stat .lt. 0) then
                call mm_cycl_erase(ds_contact, cycl_index, i_cont_poin)
            endif
        end do
    end do
!
! - Saving for statistics
!
    call nmrvai(ds_measure, 'Cont_Cycl1', input_count = cycl_nb(1))
    call nmrvai(ds_measure, 'Cont_Cycl2', input_count = cycl_nb(2))
    call nmrvai(ds_measure, 'Cont_Cycl3', input_count = cycl_nb(3))
    call nmrvai(ds_measure, 'Cont_Cycl4', input_count = cycl_nb(4))
!
end subroutine
