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
! aslint: disable=W1504
!
interface
    subroutine pminit(imate, nbvari, ndim, typmod, table,&
                      nbpar, iforta, nompar, typpar, ang,&
                      pgl, irota, epsm, sigm, vim,&
                      vip, vr, defimp, coef, indimp,&
                      fonimp, cimpo, kel, sddisc, ds_conv, ds_algopara,&
                      pred, matrel, imptgt, option, nomvi,&
                      nbvita, sderro)
        use NonLin_Datastructure_type
        integer :: nbvari
        integer :: imate
        integer :: ndim
        character(len=8) :: typmod(2)
        character(len=8) :: table
        integer :: nbpar
        integer :: iforta
        character(len=16) :: nompar(*)
        character(len=8) :: typpar(*)
        real(kind=8) :: ang(7)
        real(kind=8) :: pgl(3, 3)
        integer :: irota
        real(kind=8) :: epsm(9)
        real(kind=8) :: sigm(6)
        real(kind=8) :: vim(nbvari)
        real(kind=8) :: vip(nbvari)
        real(kind=8) :: vr(*)
        integer :: defimp
        real(kind=8) :: coef
        integer :: indimp(9)
        character(len=8) :: fonimp(9)
        real(kind=8) :: cimpo(6, 12)
        real(kind=8) :: kel(6, 6)
        character(len=19) :: sddisc
        type(NL_DS_Conv), intent(inout) :: ds_conv
        type(NL_DS_AlgoPara), intent(inout) :: ds_algopara
        integer :: pred
        integer :: matrel
        integer :: imptgt
        character(len=16) :: option
        character(len=8) :: nomvi(*)
        integer :: nbvita
        character(len=24) :: sderro
    end subroutine pminit
end interface
