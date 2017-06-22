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

subroutine rccomp(chmat, mesh)
!
implicit none
!
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/assert.h"
#include "asterfort/comp_comp_read.h"
#include "asterfort/comp_comp_save.h"
#include "asterfort/comp_init.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"
!
    character(len=8), intent(in) :: chmat
    character(len=8), intent(in) :: mesh
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (AFFE_MATERIAU)
!
! Prepare COMPOR <CARTE>
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh        : name of mesh
! In  chmat       : name material field
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_cmp, nocc
    character(len=16) :: keywordfact
    character(len=19) :: compor
    character(len=16), pointer :: v_info_valk(:) => null()
    integer, pointer :: v_info_vali(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    keywordfact = 'AFFE_COMPOR'
    compor      = chmat//'.COMPOR'
    call getfac(keywordfact, nocc)
    if (nocc .ne. 0) then
!
! ----- Create comportment informations objects
!
        AS_ALLOCATE(vk16 = v_info_valk, size = 16*nocc)
        AS_ALLOCATE(vi   = v_info_vali, size = 4*nocc)
!
! ----- Create COMPOR <CARTE>
!
        call comp_init(mesh, compor, 'G', nb_cmp)
!
! ----- Read informations from command file
!
        call comp_comp_read(v_info_valk, v_info_vali)
!
! ----- Save informations in COMPOR <CARTE>
!
        call comp_comp_save(mesh, compor, nb_cmp, v_info_valk, v_info_vali)
!
! ----- Clean it
!
        AS_DEALLOCATE(vk16 = v_info_valk)
        AS_DEALLOCATE(vi   = v_info_vali)
    endif
!
end subroutine
