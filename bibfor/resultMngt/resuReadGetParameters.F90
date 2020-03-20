! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
subroutine resuReadGetParameters(mesh, model, caraElem, fieldMate)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/getvid.h"
#include "asterfort/jeveuo.h"
!
character(len=8), intent(out) :: mesh, model, caraElem, fieldMate
!
! --------------------------------------------------------------------------------------------------
!
! LIRE_RESU
!
! Read standard parameters
!
! --------------------------------------------------------------------------------------------------
!
! Out mesh             : name of mesh
! Out model            : name of model
! Out caraElem         : name of elementary characteristics
! Out fieldMate        : name of material field
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret, nbOcc
    character(len=19) :: ligrel
    character(len=8), pointer :: lgrf(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    model     = ' '
    mesh      = ' '
    fieldMate = ' '
    caraElem  = ' '
!
! - Get model
!
    call getvid(' ', 'MODELE', scal=model, nbret=nbOcc)
    if (nbOcc .eq. 0) then
        call getvid(' ', 'MODELE', scal=model, nbret=iret)
    endif
!
! - Get mesh
!
    call getvid(' ', 'MAILLAGE', scal=mesh, nbret=nbOcc)
    if (nbOcc .eq. 0) then
        ligrel = model//'.MODELE'
        call jeveuo(ligrel//'.LGRF', 'L', vk8=lgrf)
        mesh = lgrf(1)
    endif
!
! - Get material
!
    call getvid(' ', 'CHAM_MATER', nbval=0, nbret=nbOcc)
    if (nbOcc .ne. 0) then
        call getvid(' ', 'CHAM_MATER', scal=fieldMate, nbret=iret)
    endif
!
! - Get elementary characteristics
!
    call getvid(' ', 'CARA_ELEM', nbval=0, nbret=nbOcc)
    if (nbOcc .ne. 0) then
        call getvid(' ', 'CARA_ELEM', scal=caraElem, nbret=iret)
    endif
!
end subroutine
