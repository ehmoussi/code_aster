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
    subroutine xddlim(modele, motcle, nomn, ino, valimr,&
                      valimc, valimf, fonree, icompt, lisrel,&
                      ndim, direct, jnoxfv, ch1, ch2,&
                      ch3, cnxinv, mesh, hea_no)
        character(len=8) :: modele
        character(len=8) :: motcle
        character(len=8) :: nomn
        integer :: ino
        real(kind=8) :: valimr
        complex(kind=8) :: valimc
        character(len=8) :: valimf
        character(len=4) :: fonree
        integer :: icompt
        character(len=19) :: lisrel
        integer :: ndim
        real(kind=8) :: direct(3)
        integer :: jnoxfv
        character(len=19) :: ch1
        character(len=19) :: ch2
        character(len=19) :: ch3
        character(len=19) :: hea_no
        character(len=19) :: cnxinv
        character(len=8), intent(in) :: mesh
    end subroutine xddlim
end interface
