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

subroutine dfc_chck(sdcont, mesh, model_ndim)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/cfnodb.h"
#include "asterfort/cfbord.h"
#include "asterfort/chckco.h"
#include "asterfort/cfdisi.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=8), intent(in) :: sdcont
    character(len=8), intent(in) :: mesh
    integer, intent(in) :: model_ndim
!
! --------------------------------------------------------------------------------------------------
!
! DEFI_CONTACT
!
! Some checks
!
! --------------------------------------------------------------------------------------------------
!
! In  sdcont           : name of contact concept (DEFI_CONTACT)
! In  mesh             : name of mesh
! In  model_ndim       : dimension of model
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iform
!
! - Check common nodes
!
    call cfnodb(sdcont)
    
    iform = cfdisi(sdcont(1:8)//'.CONTACT','FORMULATION')
    if (iform .ne. 5) then  
!
! - Check dimension of elements versus model dimension
!
        call cfbord(sdcont, mesh)
!
! - Check normals/tangents
!
        call chckco(sdcont, mesh, model_ndim)
    endif
!
end subroutine
