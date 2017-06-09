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
    subroutine premld(n1, diag, col, xadj1, adjnc1,&
                      nnz, deb, voisin, suiv, ladjn,&
                      nrl)
        integer :: n1
        integer :: diag(0:*)
        integer :: col(*)
        integer :: xadj1(n1+1)
        integer :: adjnc1(*)
        integer :: nnz(1:n1)
        integer :: deb(1:n1)
        integer :: voisin(*)
        integer :: suiv(*)
        integer :: ladjn
        integer :: nrl
    end subroutine premld
end interface
