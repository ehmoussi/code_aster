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
    subroutine dgplas(ea, sya, eb, nub, sytb,&
                      num, nuf, a, b1, b,&
                      syt, syf, dxd, drd, h,&
                      ipente, icisai, emaxm, emaxf, nnap,&
                      rx, ry, np, dxp, pendt,&
                      drp, mp, pendf)
        real(kind=8) :: ea(*)
        real(kind=8) :: sya(*)
        real(kind=8) :: eb
        real(kind=8) :: nub
        real(kind=8) :: sytb
        real(kind=8) :: num
        real(kind=8) :: nuf
        real(kind=8) :: a
        real(kind=8) :: b1
        real(kind=8) :: b
        real(kind=8) :: syt
        real(kind=8) :: syf
        real(kind=8) :: dxd
        real(kind=8) :: drd
        real(kind=8) :: h
        integer :: ipente
        integer :: icisai
        real(kind=8) :: emaxm
        real(kind=8) :: emaxf
        integer :: nnap
        real(kind=8) :: rx(*)
        real(kind=8) :: ry(*)
        real(kind=8) :: np
        real(kind=8) :: dxp
        real(kind=8) :: pendt
        real(kind=8) :: drp
        real(kind=8) :: mp
        real(kind=8) :: pendf
    end subroutine dgplas
end interface
