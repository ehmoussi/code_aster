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

subroutine meta_kit_nvar(rela_meta, nb_vari_meta)
!
implicit none
!
#include "asterc/lccree.h"
#include "asterc/lcinfo.h"
#include "asterc/lcdiscard.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=16), intent(in) :: rela_meta
    integer, intent(out) :: nb_vari_meta
!
! --------------------------------------------------------------------------------------------------
!
! META_*
!
! Number of internal variables
!
! --------------------------------------------------------------------------------------------------
!
! In  rela_meta        : relations for META
! Out nb_vari_meta     : number of internal variables for META
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: rela_meta_py
    integer :: idummy
!
! --------------------------------------------------------------------------------------------------
!
    nb_vari_meta = 0
    call lccree(1, rela_meta, rela_meta_py)
    call lcinfo(rela_meta_py, idummy, nb_vari_meta, idummy)
    call lcdiscard(rela_meta_py)
!
end subroutine
