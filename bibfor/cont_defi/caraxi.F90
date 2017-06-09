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

subroutine caraxi(sdcont, model, mesh, model_ndim)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/jeveuo.h"
#include "asterfort/cfdisl.h"
#include "asterfort/cfdisi.h"
#include "asterfort/mmmaxi.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: sdcont
    character(len=8), intent(in) :: model
    character(len=8), intent(in) :: mesh
    integer, intent(in) :: model_ndim
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Check if elements of contact zones are axisymmetric
!
! --------------------------------------------------------------------------------------------------
!
! In  sdcont           : name of contact concept (DEFI_CONTACT)
! In  model            : name of model
! In  mesh             : name of mesh
! In  model_ndim       : dimension of model
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_verif_all, l_elem_axis
    integer :: nb_cont_elem
    character(len=24) :: sdcont_defi
    character(len=24) :: sdcont_paraci
    integer, pointer :: v_sdcont_paraci(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    sdcont_defi = sdcont(1:8)//'.CONTACT'
!
! - Datastructure for contact definition
!
    sdcont_paraci = sdcont_defi(1:16)//'.PARACI'
    call jeveuo(sdcont_paraci, 'E', vi=v_sdcont_paraci)
!
! - Parameters
!
    l_verif_all  = cfdisl(sdcont_defi,'ALL_VERIF')
    nb_cont_elem = cfdisi(sdcont_defi,'NMACO')
!
! - Only if not verification on all zones !
!
    if (.not.l_verif_all) then
        l_elem_axis = .false.
        if (model_ndim .eq. 2) then
            l_elem_axis = mmmaxi(sdcont_defi, model, mesh)
        endif
        if (l_elem_axis) then
            v_sdcont_paraci(16) = 1
        else
            v_sdcont_paraci(16) = 0
        endif
    endif
end subroutine
