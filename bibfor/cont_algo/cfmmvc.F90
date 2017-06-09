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

subroutine cfmmvc(ds_contact   , v_ncomp_jeux, v_ncomp_loca, v_ncomp_enti, v_ncomp_zone,&
                  nt_ncomp_poin)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/as_allocate.h"
#include "asterfort/cfdisi.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    type(NL_DS_Contact), intent(in) :: ds_contact
    real(kind=8), pointer, intent(out) :: v_ncomp_jeux(:)
    integer, pointer, intent(out) :: v_ncomp_loca(:)
    character(len=16), pointer, intent(out) :: v_ncomp_enti(:)
    integer, pointer, intent(out) :: v_ncomp_zone(:)
    integer, intent(out) :: nt_ncomp_poin
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Post-treatment for no computation methods
!
! Prepare datastructures
!
! --------------------------------------------------------------------------------------------------
!
! In  ds_contact       : datastructure for contact management
! Out v_ncomp_jeux     : pointer to save gaps
! Out v_ncomp_loca     : pointer to save index of node
! Out v_ncomp_enti     : pointer to save name of entities
! Out v_ncomp_zone     : pointer to save contact zone index
! Out nt_ncomp_poin    : number of points in no-computation mode
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nt_poin, nt_cont_poin
!
! --------------------------------------------------------------------------------------------------
!
    nt_poin      = cfdisi(ds_contact%sdcont_defi,'NTPT' )
    nt_cont_poin = cfdisi(ds_contact%sdcont_defi,'NTPC' )
    nt_ncomp_poin = nt_poin-nt_cont_poin
    ASSERT(nt_ncomp_poin.ge.1)
!
    AS_ALLOCATE(vr   = v_ncomp_jeux, size = nt_ncomp_poin)
    AS_ALLOCATE(vi   = v_ncomp_loca, size = nt_ncomp_poin)
    AS_ALLOCATE(vk16 = v_ncomp_enti, size = nt_ncomp_poin*2)
    AS_ALLOCATE(vi   = v_ncomp_zone, size = nt_ncomp_poin)
!
end subroutine
