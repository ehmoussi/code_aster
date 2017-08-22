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
! aslint: disable=W1504
!
#include "asterf_types.h"
!
interface 
    subroutine assesu(nno, nnos, nface, geom, crit,&
                      deplm, deplp, congem, congep, vintm,&
                      vintp, defgem, defgep, dsde, matuu,&
                      vectu, rinstm, rinstp, option, j_mater,&
                      mecani, press1, press2, tempe, dimdef,&
                      dimcon, dimuel, nbvari, ndim, compor,&
                      typmod, typvf, axi, perman)
        integer, parameter :: maxfa=6
        integer :: ndim
        integer :: nbvari
        integer :: dimuel
        integer :: dimcon
        integer :: dimdef
        integer :: nno
        integer :: nnos
        integer :: nface
        real(kind=8) :: geom(ndim, nno)
        real(kind=8) :: crit(*)
        real(kind=8) :: deplm(dimuel)
        real(kind=8) :: deplp(dimuel)
        real(kind=8) :: congem(dimcon, maxfa+1)
        real(kind=8) :: congep(dimcon, maxfa+1)
        real(kind=8) :: vintm(nbvari, maxfa+1)
        real(kind=8) :: vintp(nbvari, maxfa+1)
        real(kind=8) :: defgem(dimdef)
        real(kind=8) :: defgep(dimdef)
        real(kind=8) :: dsde(dimcon, dimdef)
        real(kind=8) :: matuu(dimuel*dimuel)
        real(kind=8) :: vectu(dimuel)
        real(kind=8) :: rinstm
        real(kind=8) :: rinstp
        character(len=16) :: option
        integer :: j_mater
        integer :: mecani(5)
        integer :: press1(7)
        integer :: press2(7)
        integer :: tempe(5)
        character(len=16) :: compor(*)
        character(len=8) :: typmod(2)
        integer :: typvf
        aster_logical :: axi
        aster_logical :: perman
    end subroutine assesu
end interface 
