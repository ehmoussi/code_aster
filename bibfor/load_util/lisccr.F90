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

subroutine lisccr(phenom, list_load, nb_loadz, base)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/detrsd.h"
#include "asterfort/wkvect.h"
!
!
    character(len=4), intent(in) :: phenom
    character(len=19), intent(in) :: list_load
    integer, intent(in) :: nb_loadz
    character(len=1), intent(in) :: base
!
! --------------------------------------------------------------------------------------------------
!
! List of loads - Utility
!
! Create datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  phenom         : phenomenon (MECA/THER/ACOU)
! In  list_load      : name of datastructure for list of loads
! In  nb_loadz       : number of loads
! In  base           : JEVEUX base
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_load
    character(len=24) :: lload_name, lload_info, lload_func
    integer, pointer :: v_load_info(:) => null()
    character(len=24), pointer :: v_load_name(:) => null()
    character(len=24), pointer :: v_load_func(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    nb_load = nb_loadz
!
! - Datastructure access
!
    lload_name = list_load(1:19)//'.LCHA'
    lload_info = list_load(1:19)//'.INFC'
    lload_func = list_load(1:19)//'.FCHA'
!
! - No loads datastructure
!
    if (nb_loadz.eq.0) then
        nb_load = 1
    endif
!
    call detrsd('LISTE_CHARGES', list_load)
    if (phenom.eq.'MECA') then
        call wkvect(lload_name, base//' V K24', nb_load    , vk24 = v_load_name)
        call wkvect(lload_info, base//' V IS' , 4*nb_load+7, vi   = v_load_info)
        call wkvect(lload_func, base//' V K24', nb_load    , vk24 = v_load_func)
    elseif (phenom.eq.'THER') then
        call wkvect(lload_name, base//' V K24', nb_load    , vk24 = v_load_name)
        call wkvect(lload_info, base//' V IS' , 2*nb_load+1, vi   = v_load_info)
        call wkvect(lload_func, base//' V K24', nb_load    , vk24 = v_load_func)
    else
        ASSERT(.false.)
    endif
    v_load_info(1) = nb_load
!
! - No loads datastructure
!
    if (nb_loadz.eq.0) then
        nb_load = 0
    endif
!
end subroutine
