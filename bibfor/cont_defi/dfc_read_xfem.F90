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

subroutine dfc_read_xfem(sdcont      , keywf, mesh, model, model_ndim,&
                         nb_cont_zone)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/cfdisl.h"
#include "asterfort/limacx.h"
#include "asterfort/xmacon.h"
#include "asterfort/xconta.h"
#include "asterfort/xfem_rel_lin.h"
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
    character(len=8), intent(in) :: sdcont
    character(len=8), intent(in) :: mesh
    character(len=8), intent(in) :: model
    character(len=16), intent(in) :: keywf
    integer, intent(in) :: model_ndim
    integer, intent(in) :: nb_cont_zone
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! XFEM method - Read contact data
!
! --------------------------------------------------------------------------------------------------
!
! In  sdcont           : name of contact concept (DEFI_CONTACT)
! In  keywf            : factor keyword to read
! In  mesh             : name of mesh
! In  model            : name of model
! In  model_ndim       : dimension of model
! In  nb_cont_zone     : number of zones of contact
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: l_cont_xfem_gg
    character(len=24) :: sdcont_defi
!
! --------------------------------------------------------------------------------------------------
!
    sdcont_defi    = sdcont(1:8)//'.CONTACT'
    l_cont_xfem_gg = cfdisl(sdcont_defi,'CONT_XFEM_GG')
!
! - Read cracks
!
    call limacx(sdcont, keywf, model_ndim, nb_cont_zone)
!
! - Create/modify contact datastructure
!
    if (l_cont_xfem_gg) then
        call xmacon(sdcont, mesh, model)
    endif
!
! - Prepare informations for linear relations for LBB condition
!
    call xconta(sdcont, mesh, model, model_ndim)
!
! - Set linear relations between contact unknonws for LBB condition
!
    call xfem_rel_lin(sdcont, mesh, model, model_ndim)
!
end subroutine
