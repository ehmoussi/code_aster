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

subroutine mmnbnz(mesh, sdcont_defi, i_zone, nb_cont_poin)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/cfdisi.h"
#include "asterfort/cfnumm.h"
#include "asterfort/mminfi.h"
#include "asterfort/mmelin.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: mesh
    character(len=24), intent(in) :: sdcont_defi
    integer, intent(in) :: i_zone
    integer, intent(out) :: nb_cont_poin
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Utility
!
! Continue/Discrete - Count contact point by zonee
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  sdcont_defi      : name of contact definition datastructure (from DEFI_CONTACT)
! In  i_zone           : index of contact zone
! Out nb_cont_poin     : number of contact points
!
! --------------------------------------------------------------------------------------------------
!
    integer :: cont_form, elem_slav_indx, elem_slav_nume, type_inte, nb_poin_elem
    integer :: i_elem_slav, nb_elem_slav, jdecme
!
! --------------------------------------------------------------------------------------------------
!
    nb_cont_poin = 0
    cont_form    = cfdisi(sdcont_defi, 'FORMULATION')
!
! - Count
!
    if (cont_form .eq. 1) then
        nb_cont_poin = mminfi(sdcont_defi, 'NBNOE' , i_zone)
    else if (cont_form.eq.2 .or. cont_form.eq.5) then
        nb_elem_slav = mminfi(sdcont_defi, 'NBMAE', i_zone)
        jdecme       = mminfi(sdcont_defi, 'JDECME', i_zone)
        type_inte    = mminfi(sdcont_defi, 'INTEGRATION', i_zone)
        do i_elem_slav = 1, nb_elem_slav
            elem_slav_indx = i_elem_slav + jdecme
            call cfnumm(sdcont_defi, elem_slav_indx, elem_slav_nume)
            call mmelin(mesh, elem_slav_nume, type_inte, nb_poin_elem)
            nb_cont_poin = nb_cont_poin + nb_poin_elem
        end do
    else
        ASSERT(.false.)
    endif
!
end subroutine
