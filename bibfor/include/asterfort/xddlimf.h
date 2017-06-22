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
interface
    subroutine xddlimf(modele, ino, cnxinv, jnoxfv, motcle,&
                       ch2, ndim, lsn, lst, valimr, valimf, valimc,&
                       fonree, lisrel, nomn, direct, class, mesh,&
                       hea_no)
        character(len=8) :: modele
        integer :: ino
        character(len=19) :: cnxinv
        integer :: jnoxfv
        character(len=8) :: motcle
        character(len=19) :: ch2
        integer :: ndim
        real(kind=8) :: lsn(4)
        real(kind=8) :: lst(4)
        real(kind=8) :: valimr
        character(len=8) :: valimf
        complex(kind=8) :: valimc
        character(len=4) :: fonree
        character(len=19) :: lisrel
        character(len=8), intent(in) :: mesh
        character(len=8) :: nomn
        real(kind=8) :: direct(3)
        aster_logical :: class
        character(len=19) :: hea_no
    end subroutine xddlimf
end interface
