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

subroutine mfront_get_function(rela_comp, name)
    implicit none
    character(len=*), intent(in) :: rela_comp
    character(len=*), intent(out) :: name
!
! Retourne le nom de la fonction associée à la loi de comportement `rela_comp`
! dans la bibliothèque MFront officielle
!        in  rela_comp: nom de la relation de comportement
!       out  name: nom de la fonction à appeler
!
#include "asterc/lccree.h"
#include "asterc/lcsymb.h"
#include "asterc/lcdiscard.h"
!
    character(len=16) :: rela_comp_py
    character(len=128) :: symbol
!
    name = ' '
    call lccree(1, rela_comp, rela_comp_py)
    call lcsymb(rela_comp_py, symbol)
    call lcdiscard(rela_comp_py)
!
    name = symbol
!
end
