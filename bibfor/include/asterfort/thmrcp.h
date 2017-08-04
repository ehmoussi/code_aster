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
interface 
    subroutine thmrcp(etape, imate, thmc, hydr,&
                      ther, t, p1, p1m, p2,&
                      phi, pvp, rgaz, rhod,&
                      cpd, satm, satur, dsatur,&
                      permli, dperml, permgz,&
                      dperms, dpermp, fick, dfickt, dfickg,&
                      lambp, dlambp, rhol, unsurk, alpha,&
                      cpl, lambs, dlambs, viscl, dviscl,&
                      mamolg, cpg, tlambt, tdlamt, viscg,&
                      dviscg, mamolv, cpvg, viscvg, dvisvg,&
                      fickad, dfadt, cpad, kh, pad,&
                      em, tlamct, retcom,&
                      angmas, ndim)
        integer :: ndim
        character(len=8) :: etape
        integer :: imate
        character(len=16) :: thmc
        character(len=16) :: hydr
        character(len=16) :: ther
        real(kind=8) :: t0
        real(kind=8) :: p10
        real(kind=8) :: p20
        real(kind=8) :: phi0
        real(kind=8) :: pvp0
        real(kind=8) :: t
        real(kind=8) :: p1
        real(kind=8) :: p1m
        real(kind=8) :: p2
        real(kind=8) :: phi
        real(kind=8) :: pvp
        real(kind=8) :: rgaz
        real(kind=8) :: rhod
        real(kind=8) :: cpd
        real(kind=8) :: satm
        real(kind=8) :: satur
        real(kind=8) :: dsatur
        real(kind=8) :: permli
        real(kind=8) :: dperml
        real(kind=8) :: permgz
        real(kind=8) :: dperms
        real(kind=8) :: dpermp
        real(kind=8) :: fick
        real(kind=8) :: dfickt
        real(kind=8) :: dfickg
        real(kind=8) :: lambp
        real(kind=8) :: dlambp
        real(kind=8) :: rhol
        real(kind=8) :: unsurk
        real(kind=8) :: alpha
        real(kind=8) :: cpl
        real(kind=8) :: lambs
        real(kind=8) :: dlambs
        real(kind=8) :: viscl
        real(kind=8) :: dviscl
        real(kind=8) :: mamolg
        real(kind=8) :: cpg
        real(kind=8) :: tlambt(ndim, ndim)
        real(kind=8) :: tdlamt(ndim, ndim)
        real(kind=8) :: viscg
        real(kind=8) :: dviscg
        real(kind=8) :: mamolv
        real(kind=8) :: cpvg
        real(kind=8) :: viscvg
        real(kind=8) :: dvisvg
        real(kind=8) :: fickad
        real(kind=8) :: dfadt
        real(kind=8) :: cpad
        real(kind=8) :: kh
        real(kind=8) :: pad
        real(kind=8) :: em
        real(kind=8) :: tlamct(ndim, ndim)
        integer :: retcom
        real(kind=8) :: angmas(3)
    end subroutine thmrcp
end interface 
