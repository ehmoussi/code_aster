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
    subroutine lrcame(nrofic, nochmd, nomamd, nomaas, ligrel,&
                      option, param, typech, typen, npgma,&
                      npgmm, nspmm, nbcmpv, ncmpva, ncmpvm,&
                      iinst, numpt, numord, inst, crit,&
                      prec, nomgd, ncmprf, jnocmp, chames,&
                      codret)
        integer :: nrofic
        character(len=*) :: nochmd
        character(len=*) :: nomamd
        character(len=8) :: nomaas
        character(len=19) :: ligrel
        character(len=24) :: option
        character(len=8) :: param
        character(len=*) :: typech
        integer :: typen
        integer :: npgma(*)
        integer :: npgmm(*)
        integer :: nspmm(*)
        integer :: nbcmpv
        character(len=*) :: ncmpva
        character(len=*) :: ncmpvm
        integer :: iinst
        integer :: numpt
        integer :: numord
        real(kind=8) :: inst
        character(len=8) :: crit
        real(kind=8) :: prec
        character(len=8) :: nomgd
        integer :: ncmprf
        integer :: jnocmp
        character(len=19) :: chames
        integer :: codret
    end subroutine lrcame
end interface
