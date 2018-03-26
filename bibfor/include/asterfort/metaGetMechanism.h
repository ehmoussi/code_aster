! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
#include "asterf_types.h"
!
interface
    subroutine metaGetMechanism(rela_comp,&
                                l_plas, l_visc,&
                                l_hard_isotline, l_hard_isotnlin,&
                                l_hard_kine, l_hard_line, l_anneal,&
                                l_plas_tran)
        character(len=16), intent(in) :: rela_comp
        aster_logical, optional, intent(out) :: l_plas
        aster_logical, optional, intent(out) :: l_visc
        aster_logical, optional, intent(out) :: l_hard_isotline, l_hard_isotnlin
        aster_logical, optional, intent(out) :: l_hard_kine
        aster_logical, optional, intent(out) :: l_hard_line
        aster_logical, optional, intent(out) :: l_anneal
        aster_logical, optional, intent(out) :: l_plas_tran
    end subroutine metaGetMechanism
end interface
