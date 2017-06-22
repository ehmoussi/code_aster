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

subroutine sdchgd(fieldz, type_scalz)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/jeexin.h"
#include "asterfort/jenonu.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
!
!
    character(len=*), intent(in) :: fieldz
    character(len=*), intent(in) :: type_scalz
!
! --------------------------------------------------------------------------------------------------
!
! Field utility
!
! Change type of GRANDEUR in a field
!
! --------------------------------------------------------------------------------------------------
!
! In  field     : name of field
! In  type_scal : new type of GRANDEUR (R, C or F)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: field
    character(len=8) :: gd_name_old, gd_name_new
    integer :: i_exi, i_gd_old, i_gd_new
    integer, pointer :: p_desc(:) => null()
    character(len=3) :: type_scal
!
! --------------------------------------------------------------------------------------------------
!
    field     = fieldz
    type_scal = type_scalz
!
! - Field type
!
    call jeexin(field//'.DESC', i_exi)
    if (i_exi .gt. 0) then
        call jeveuo(field//'.DESC', 'E', vi = p_desc)  
    else
        call jeveuo(field//'.CELD', 'E', vi = p_desc)
    endif
!
! - Old GRANDEUR
!
    i_gd_old = p_desc(1)
    call jenuno(jexnum('&CATA.GD.NOMGD', i_gd_old), gd_name_old)
!
! - New GRANDEUR
!
    gd_name_new = gd_name_old(1:5)//type_scal
    call jenonu(jexnom('&CATA.GD.NOMGD', gd_name_new), i_gd_new)
    ASSERT(i_gd_new.ne.0)
    p_desc(1) = i_gd_new

end subroutine
