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
    subroutine lrfmed(resu, i, mfich, nomgd, typcha,&
                      option, param, nochmd, acces, nbordr,&
                      nnu, nis, nto, jnume, jlist,&
                      noma, nbcmpv, ncmpva, ncmpvm, prolz,&
                      iinst, crit, epsi, linoch, acce)
        character(len=8) :: resu
        integer :: i
        integer :: mfich
        character(len=8) :: nomgd
        character(len=8) :: typcha
        character(len=24) :: option
        character(len=8) :: param
        character(len=64) :: nochmd
        character(len=10) :: acces
        integer :: nbordr
        integer :: nnu
        integer :: nis
        integer :: nto
        integer :: jnume
        integer :: jlist
        character(len=8) :: noma
        integer :: nbcmpv
        character(len=24) :: ncmpva
        character(len=24) :: ncmpvm
        character(len=3) :: prolz
        integer :: iinst
        character(len=8) :: crit
        real(kind=8) :: epsi
        character(len=16) :: linoch(100)
        character(len=4) :: acce
    end subroutine lrfmed
end interface
