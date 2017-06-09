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
    subroutine lrceme(chanom, nochmd, typech, nomamd, nomaas,&
                      nommod, nomgd, typent, nbcmpv, ncmpva,&
                      ncmpvm, prolz, iinst, numpt, numord,&
                      inst, crit, prec, nrofic, option,&
                      param, nbpgma, nbpgmm, nbspmm, codret)
        character(len=19) :: chanom
        character(len=*) :: nochmd
        character(len=4) :: typech
        character(len=*) :: nomamd
        character(len=8) :: nomaas
        character(len=8) :: nommod
        character(len=8) :: nomgd
        integer :: typent
        integer :: nbcmpv
        character(len=*) :: ncmpva
        character(len=*) :: ncmpvm
        character(len=3) :: prolz
        integer :: iinst
        integer :: numpt
        integer :: numord
        real(kind=8) :: inst
        character(len=8) :: crit
        real(kind=8) :: prec
        integer :: nrofic
        character(len=24) :: option
        character(len=8) :: param
        integer :: nbpgma(*)
        integer :: nbpgmm(*)
        integer :: nbspmm(*)
        integer :: codret
    end subroutine lrceme
end interface
