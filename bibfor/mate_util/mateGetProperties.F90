! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
!
subroutine mateGetProperties(mate      , i_mate , nomrc      ,&
                             mate_shift, v_mate ,&
                             noobrc    , nb_prop, v_mate_func)
!
implicit none
!
#include "asterf_types.h"
#include "asterc/getmjm.h"
#include "asterfort/assert.h"
#include "asterfort/deprecated_material.h"
#include "asterfort/codent.h"
#include "asterfort/lxlgut.h"
!
character(len=8), intent(in) :: mate
integer, intent(in) :: i_mate
character(len=32), intent(inout) :: nomrc
integer, intent(inout) :: mate_shift
character(len=32), pointer :: v_mate(:)
character(len=19), intent(out) :: noobrc
integer, intent(out) :: nb_prop
aster_logical, pointer :: v_mate_func(:)
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_MATERIAU
!
! Get properties for one material factor keyword
!
! --------------------------------------------------------------------------------------------------
!
! In  mate             : name of output datastructure
! In  i_mate           : index of material factor keyword
! IO  nomrc            : name of material property
! IO  mate_shift       : index to save factor keyword
! Out noobrc           : name of .CPT object
! Out nb_prop          : number of material properties
! In  v_mate_func      : pointer to flags for function
!
! --------------------------------------------------------------------------------------------------
!
    character(len=6) :: nom
    character(len=16) :: k16dummy
    integer :: ind
    aster_logical :: l_func
!
! --------------------------------------------------------------------------------------------------
!
    call deprecated_material(nomrc)
!
! - Is function ?
!
    ind = index(nomrc,'_FO')
    if (ind .gt. 0) then
        nomrc(ind:ind+2) = '   '
        l_func = ASTER_TRUE
    else
        l_func = ASTER_FALSE
    endif
    v_mate_func(i_mate) = l_func
!
! - Save name of keyword (without _FO)
!
    mate_shift = mate_shift + 1
    v_mate(mate_shift) = nomrc
!
! - (re) create name with _FO
!
    call codent(mate_shift, 'D0', nom)
    noobrc = mate//'.CPT.'//nom
    ind    = lxlgut(nomrc)+1
    ASSERT(ind .le. 32)
    if (l_func) then
        nomrc(ind:ind+2) = '_FO'
    endif
!
! - Number of properties
!
    call getmjm(nomrc, 1, 0, k16dummy, k16dummy, nb_prop)
    nb_prop = - nb_prop
    ASSERT(nb_prop .ne. 0)
!
! - Add automatic BETA property for THER_NL or ECRO for DIS_ECRO_TRAC
!
    if (nomrc .eq. 'THER_NL'.or. nomrc .eq. 'DIS_ECRO_TRAC') then
        nb_prop = nb_prop + 1
    endif
!
end subroutine
