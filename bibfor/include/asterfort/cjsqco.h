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
    subroutine cjsqco(gamma, sig, x, pref, epssig,&
                      i1, s, sii, siirel, cos3ts,&
                      hts, dets, q, qii, qiirel,&
                      cos3tq, htq, detq)
        real(kind=8) :: gamma
        real(kind=8) :: sig(6)
        real(kind=8) :: x(6)
        real(kind=8) :: pref
        real(kind=8) :: epssig
        real(kind=8) :: i1
        real(kind=8) :: s(6)
        real(kind=8) :: sii
        real(kind=8) :: siirel
        real(kind=8) :: cos3ts
        real(kind=8) :: hts
        real(kind=8) :: dets
        real(kind=8) :: q(6)
        real(kind=8) :: qii
        real(kind=8) :: qiirel
        real(kind=8) :: cos3tq
        real(kind=8) :: htq
        real(kind=8) :: detq
    end subroutine cjsqco
end interface
