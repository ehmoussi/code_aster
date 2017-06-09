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
    subroutine uteref(chanom, typech, tyelas, nomte, nomfpg,&
                      nnos, nno, nbpg, ndim, refcoo,&
                      gscoo, wg, nochmd, codret)
        character(len=19) :: chanom
        character(len=8) :: typech
        integer :: tyelas
        character(len=16) :: nomte
        character(len=16) :: nomfpg
        integer :: nnos
        integer :: nno
        integer :: nbpg
        integer :: ndim
        real(kind=8) :: refcoo(*)
        real(kind=8) :: gscoo(*)
        real(kind=8) :: wg(*)
        character(len=64) :: nochmd
        integer :: codret
    end subroutine uteref
end interface
