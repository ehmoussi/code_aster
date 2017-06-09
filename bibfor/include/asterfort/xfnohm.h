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
    subroutine xfnohm(fnoevo, deltat, nno,&
                      npg, ipoids, ivf, idfde,&
                      geom, congem, b, dfdi, dfdi2,&
                      r, vectu, imate, mecani, press1,&
                      dimcon, nddls, nddlm, dimuel, nmec,&
                      np1, ndim, axi, dimenr, nnop,&
                      nnops, nnopm, igeom, jpintt, jpmilt,&
                      jheavn, lonch, cnset, heavt, enrmec, enrhyd,&
                      nfiss, nfh, jfisno)
        integer :: nnops
        integer :: nnop
        integer :: dimenr
        integer :: ndim
        integer :: dimuel
        aster_logical :: fnoevo
        real(kind=8) :: deltat
        integer :: nno
        integer :: npg
        integer :: ipoids
        integer :: ivf
        integer :: idfde
        real(kind=8) :: geom(ndim, nnop)
        real(kind=8) :: congem(*)
        real(kind=8) :: b(dimenr, dimuel)
        real(kind=8) :: dfdi(nnop, ndim)
        real(kind=8) :: dfdi2(nnops, ndim)
        real(kind=8) :: r(1:dimenr)
        real(kind=8) :: vectu(dimuel)
        integer :: imate
        integer :: mecani(5)
        integer :: press1(7)
        integer :: dimcon
        integer :: nddls
        integer :: nddlm
        integer :: nmec
        integer :: np1
        integer :: jheavn
        aster_logical :: axi
        integer :: nnopm
        integer :: igeom
        integer :: jpintt
        integer :: jpmilt
        integer :: lonch(10)
        integer :: cnset(*)
        integer :: heavt(*)
        integer :: enrmec(3)
        integer :: enrhyd(3)
        integer :: nfiss
        integer :: nfh
        integer :: jfisno
    end subroutine xfnohm
end interface 
