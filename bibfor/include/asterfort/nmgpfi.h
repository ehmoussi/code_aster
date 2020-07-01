! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
    subroutine nmgpfi(fami, option, typmod, ndim, nno,&
                      npg, iw, vff, idff, geomInit,&
                      dff, compor, imate, mult_comp, lgpg, carcri,&
                      angmas, instm, instp, dispPrev, dispIncr,&
                      sigmPrev, vim, sigmCurr, vip, fint,&
                      matr, codret)
        integer :: ndim, nno, npg, imate, lgpg, iw, idff
        character(len=8) :: typmod(*)
        character(len=*) :: fami
        character(len=16) :: option, compor(*)
        character(len=16), intent(in) :: mult_comp
        real(kind=8) :: geomInit(*), dff(nno, *), carcri(*), instm, instp
        real(kind=8) :: vff(nno, npg)
        real(kind=8) :: angmas(3)
        real(kind=8) :: dispPrev(*), dispIncr(*), sigmPrev(2*ndim, npg)
        real(kind=8) :: vim(lgpg, npg), sigmCurr(2*ndim, npg), vip(lgpg, npg)
        real(kind=8) :: matr(*), fint(*)
        integer, intent(out) :: codret
    end subroutine nmgpfi
end interface
