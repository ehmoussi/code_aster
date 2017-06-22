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

subroutine megeom(modelz, chgeoz)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
!
!
    character(len=*), intent(in) :: modelz
    character(len=*), intent(inout) :: chgeoz
!
! --------------------------------------------------------------------------------------------------
!
! Prepare geometry field
!
! --------------------------------------------------------------------------------------------------
!
! In  model  : name of model
! IO  chgeom : name geometry field
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: chgeom
    character(len=8) :: model
    character(len=8), pointer :: p_model_lgrf(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    model = modelz
!
    ASSERT(model.ne.' ')
    call jeveuo(model//'.MODELE    .LGRF', 'L', vk8 = p_model_lgrf)
    chgeom = p_model_lgrf(1)//'.COORDO'
!
    chgeoz = chgeom
end subroutine
