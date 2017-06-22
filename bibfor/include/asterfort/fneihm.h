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
#include "asterf_types.h"
!
interface
    subroutine fneihm(fnoevo, deltat, perman, nno1, nno2,&
                      npi, npg, wref, iu, ip,&
                      ipf, iq, vff1, vff2, dffr2,&
                      geom, ang, congem, r, vectu,&
                      mecani, press1, press2, tempe, dimdef,&
                      dimcon, dimuel, ndim, axi)
        integer :: ndim
        integer :: dimuel
        integer :: dimcon
        integer :: dimdef
        integer :: npg
        integer :: npi
        integer :: nno2
        integer :: nno1
        aster_logical :: fnoevo
        real(kind=8) :: deltat
        aster_logical :: perman
        real(kind=8) :: wref(npg)
        integer :: iu(3, 18)
        integer :: ip(2, 9)
        integer :: ipf(2, 2, 9)
        integer :: iq(2, 2, 9)
        real(kind=8) :: vff1(nno1, npi)
        real(kind=8) :: vff2(nno2, npi)
        real(kind=8) :: dffr2(ndim-1, nno2, npi)
        real(kind=8) :: geom(ndim, nno2)
        real(kind=8) :: ang(24)
        real(kind=8) :: congem(dimcon, npi)
        real(kind=8) :: r(dimdef)
        real(kind=8) :: vectu(dimuel)
        integer :: mecani(8)
        integer :: press1(9)
        integer :: press2(9)
        integer :: tempe(5)
        aster_logical :: axi
    end subroutine fneihm
end interface
