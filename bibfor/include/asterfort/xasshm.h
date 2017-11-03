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
    subroutine xasshm(nno, npg, npi, ipoids, ivf,&
                      idfde, igeom, geom, carcri, deplm,&
                      deplp, contm, contp, varim,&
                      varip, defgem, defgep, drds,&
                      drdsr, dsde, b, dfdi, dfdi2,&
                      r, sigbar, c, ck, cs,&
                      matuu, vectu, rinstm, rinstp, option,&
                      j_mater, mecani, press1, press2, tempe,&
                      dimdef, dimcon, dimuel, nbvari, nddls,&
                      nddlm, nmec, np1, ndim,&
                      compor, axi, modint, codret,&
                      nnop, nnops, nnopm, enrmec,&
                      dimenr, heavt, lonch, cnset, jpintt,&
                      jpmilt, jheavn, angmas,dimmat, enrhyd,&
                      nfiss, nfh, jfisno, work1, work2)
        integer :: dimmat
        integer :: dimenr
        integer :: nnops
        integer :: nnop
        integer :: ndim
        integer :: dimuel
        integer :: dimcon
        integer :: dimdef
        integer :: nno
        integer :: npg
        integer :: npi
        integer :: ipoids
        integer :: ivf
        integer :: idfde
        integer :: igeom
        real(kind=8) :: geom(ndim, nnop)
        real(kind=8) :: carcri(*)
        real(kind=8) :: deplm(dimuel)
        real(kind=8) :: deplp(dimuel)
        real(kind=8) :: contm(*)
        real(kind=8) :: contp(*)
        real(kind=8) :: varim(*)
        real(kind=8) :: varip(*)
        real(kind=8) :: defgem(dimdef)
        real(kind=8) :: defgep(dimdef)
        real(kind=8) :: drds(dimenr, dimcon)
        real(kind=8) :: drdsr(dimenr, dimcon)
        real(kind=8) :: dsde(dimcon, dimenr)
        real(kind=8) :: b(dimenr, dimuel)
        real(kind=8) :: dfdi(nnop, ndim)
        real(kind=8) :: dfdi2(nnops, ndim)
        real(kind=8) :: r(dimenr)
        real(kind=8) :: sigbar(dimenr)
        real(kind=8) :: c(dimenr)
        real(kind=8) :: ck(dimenr)
        real(kind=8) :: cs(dimenr)
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
        integer :: nbvari
        integer :: nddls
        integer :: nddlm
        integer :: nmec
        integer :: np1
        character(len=16) :: compor(*)
        aster_logical :: axi
        character(len=3) :: modint
        integer :: codret
        integer :: nnopm
        integer :: enrmec(3)
        integer :: heavt(*)
        integer :: lonch(10)
        integer :: cnset(*)
        integer :: jpintt
        integer :: jpmilt
        integer :: jheavn
        real(kind=8) :: angmas(3)
        integer :: enrhyd(3)
        integer :: nfiss
        integer :: nfh
        integer :: jfisno
        real(kind=8) :: work1(dimcon, dimuel)
        real(kind=8) :: work2(dimenr, dimuel)
    end subroutine xasshm
end interface
