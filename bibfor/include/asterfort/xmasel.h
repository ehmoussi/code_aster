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
    subroutine xmasel(nnop, nfh, nfe, ddlc, igeom,&
                      imate, pintt, cnset, heavt, lonch,&
                      basloc, lsn, lst, matuu, heavn, jpmilt,&
                      jstno, nnops, ddlm)
        integer :: nnop
        integer :: nfh
        integer :: nfe
        integer :: ddlc
        integer :: igeom
        integer :: imate
        integer :: jpmilt
        integer :: jstno
        integer :: ddlm
        integer :: nnops
        real(kind=8) :: pintt(33)
        integer :: cnset(128)
        integer :: heavt(36)
        integer :: lonch(10)
        real(kind=8) :: basloc(*)
        real(kind=8) :: lsn(nnop)
        real(kind=8) :: lst(nnop)
        real(kind=8) :: matuu(*)
        integer :: heavn(27,5)
    end subroutine xmasel
end interface
