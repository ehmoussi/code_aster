! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
    subroutine dgendo(em, h, ea, sya, fcj, epsi_c,&
                      syt, syc, num, pendt, pendf, pelast, pelasf,&
                      icisai, gt,&
                      gf, gc, ipentetrac, np, dxp,&
                      b, alpha_c)
        real(kind=8) :: em
        real(kind=8) :: h
        real(kind=8) :: ea
        real(kind=8) :: sya
        real(kind=8) :: fcj
        real(kind=8) :: epsi_c
        real(kind=8) :: syt
        real(kind=8) :: syc
        real(kind=8) :: num
        real(kind=8) :: pendt
        real(kind=8) :: pendf
        real(kind=8) :: pelast
        real(kind=8) :: pelasf
        integer :: icisai
        real(kind=8) :: gt
        real(kind=8) :: gf
        real(kind=8) :: gc
        integer :: ipentetrac
        real(kind=8) :: np
        real(kind=8) :: dxp
        real(kind=8) :: b
        real(kind=8) :: alpha_c
    end subroutine dgendo
end interface
