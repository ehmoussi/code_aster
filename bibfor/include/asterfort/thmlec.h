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
    subroutine thmlec(j_mater, thmc, hydr, ther,&
                      t, p1, p2, phi, endo,&
                      pvp, pad, rgaz, tbiot, satur,&
                      dsatur, gravity, tperm, permli, dperml,&
                      permgz, dperms, dpermp, fick, dfickt,&
                      dfickg, lambp, dlambp, unsurk, alpha,&
                      lambs, dlambs, viscl, dviscl, mamolg,&
                      tlambt, tdlamt, viscg, dviscg, mamolv,&
                      fickad, dfadt, tlamct, instap,&
                      angl_naut, ndim)
        integer, intent(in) :: ndim
        real(kind=8), intent(in) :: angl_naut(3)
        integer, intent(in) :: j_mater
        real(kind=8), intent(in) :: phi, endo
        real(kind=8), intent(out) :: tperm(ndim, ndim)
        character(len=16) :: thmc
        character(len=16) :: hydr
        character(len=16) :: ther
        real(kind=8) :: t
        real(kind=8) :: p1
        real(kind=8) :: p2
        real(kind=8) :: pvp
        real(kind=8) :: pad
        real(kind=8) :: rgaz
        real(kind=8) :: tbiot(6)
        real(kind=8) :: satur
        real(kind=8) :: dsatur
        real(kind=8), intent(out) :: gravity(3)
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
        real(kind=8) :: unsurk
        real(kind=8) :: alpha
        real(kind=8) :: lambs
        real(kind=8) :: dlambs
        real(kind=8) :: viscl
        real(kind=8) :: dviscl
        real(kind=8) :: mamolg
        real(kind=8) :: tlambt(ndim, ndim)
        real(kind=8) :: tdlamt(ndim, ndim)
        real(kind=8) :: viscg
        real(kind=8) :: dviscg
        real(kind=8) :: mamolv
        real(kind=8) :: fickad
        real(kind=8) :: dfadt
        real(kind=8) :: tlamct(ndim, ndim)
        real(kind=8) :: instap
    end subroutine thmlec
end interface 
