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
interface
    subroutine xneuvi(nb_edgez, nb_edge, nbno, tabdir, scorno,&
                      noeud, crack, tabhyp)
        integer :: nbno
        integer :: nb_edgez
        integer :: nb_edge
        integer :: tabdir(nb_edgez, 2)
        integer :: scorno(2*nb_edgez)
        integer :: noeud(2*nb_edgez)
        character(len=8) :: crack
        aster_logical, intent(in) :: tabhyp(nb_edgez)
    end subroutine xneuvi
end interface
