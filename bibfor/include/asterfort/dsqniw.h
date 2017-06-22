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
    subroutine dsqniw(qsi, eta, caraq4, dci, bcm,&
                      bcb, bca, an, am, wsq,&
                      wmesq)
        real(kind=8) :: qsi
        real(kind=8) :: eta
        real(kind=8) :: caraq4(*)
        real(kind=8) :: dci(2, 2)
        real(kind=8) :: bcm(2, 8)
        real(kind=8) :: bcb(2, 12)
        real(kind=8) :: bca(2, 4)
        real(kind=8) :: an(4, 12)
        real(kind=8) :: am(4, 8)
        real(kind=8) :: wsq(12)
        real(kind=8) :: wmesq(8)
    end subroutine dsqniw
end interface
