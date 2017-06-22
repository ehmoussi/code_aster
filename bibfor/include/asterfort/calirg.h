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

!
!
#include "asterf_types.h"
!
interface
    subroutine calirg(mesh, nbno, list_node, tran,  cent, &
                      l_angl_naut, angl_naut, geom_defo, l_rota, matr_rota)
        character(len=8), intent(in) :: mesh
        integer, intent(in) :: nbno
        character(len=24), intent(in) :: list_node
        aster_logical, intent(in) :: l_angl_naut
        real(kind=8), intent(in) :: angl_naut(3)
        real(kind=8), intent(in) :: cent(3)
        real(kind=8), intent(in) :: tran(3)
        character(len=*) :: geom_defo
        aster_logical, intent(out) :: l_rota
        real(kind=8), intent(out) :: matr_rota(3, 3)
    end subroutine calirg
end interface
