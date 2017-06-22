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
    subroutine dikfin(nbt, dnsdu, dnsdt, dmsdt, dnsdu2,&
                      dnsdt2, dmsdt2, ky, kz, krx,&
                      krz, klv, klv2)
        integer :: nbt
        real(kind=8) :: dnsdu
        real(kind=8) :: dnsdt
        real(kind=8) :: dmsdt
        real(kind=8) :: dnsdu2
        real(kind=8) :: dnsdt2
        real(kind=8) :: dmsdt2
        real(kind=8) :: ky
        real(kind=8) :: kz
        real(kind=8) :: krx
        real(kind=8) :: krz
        real(kind=8) :: klv(nbt)
        real(kind=8) :: klv2(nbt)
    end subroutine dikfin
end interface
