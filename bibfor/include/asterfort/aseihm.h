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
    subroutine aseihm(option, axi, ndim, nno1, nno2,&
                      npi, npg, dimuel, dimdef, dimcon,&
                      nbvari, imate, iu, ip, ipf,&
                      iq, mecani, press1, press2, tempe,&
                      vff1, vff2, dffr2, instam, instap,&
                      deplm, deplp, sigm, sigp, varim,&
                      varip, nomail, wref, geom, ang,&
                      compor, perman, crit, vectu, matuu,&
                      retcom)
        integer :: nbvari
        integer :: dimcon
        integer :: dimdef
        integer :: dimuel
        integer :: npi
        integer :: nno2
        integer :: nno1
        integer :: ndim
        character(len=16) :: option
        aster_logical :: axi
        integer :: npg
        integer :: imate
        integer :: iu(3, 18)
        integer :: ip(2, 9)
        integer :: ipf(2, 2, 9)
        integer :: iq(2, 2, 9)
        integer :: mecani(8)
        integer :: press1(9)
        integer :: press2(9)
        integer :: tempe(5)
        real(kind=8) :: vff1(nno1, npi)
        real(kind=8) :: vff2(nno2, npi)
        real(kind=8) :: dffr2(ndim-1, nno2, npi)
        real(kind=8) :: instam
        real(kind=8) :: instap
        real(kind=8) :: deplm(dimuel)
        real(kind=8) :: deplp(dimuel)
        real(kind=8) :: sigm(dimcon, npi)
        real(kind=8) :: sigp(dimcon, npi)
        real(kind=8) :: varim(nbvari, npi)
        real(kind=8) :: varip(nbvari, npi)
        character(len=8) :: nomail
        real(kind=8) :: wref(npi)
        real(kind=8) :: geom(ndim, nno2)
        real(kind=8) :: ang(24)
        character(len=16) :: compor(*)
        aster_logical :: perman
        real(kind=8) :: crit(*)
        real(kind=8) :: vectu(dimuel)
        real(kind=8) :: matuu(dimuel*dimuel)
        integer :: retcom
    end subroutine aseihm
end interface
