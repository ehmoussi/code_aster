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
    subroutine thmMecaSpecial(option , meca     , thmc  ,&
                              yate   , yap1     , yap2  ,&
                              p1     , dp1      , p2    , dp2   , satur, tbiot,&
                              j_mater, ndim     , typmod, carcri, &
                              addeme , adcome   , addep1, addep2,&
                              dimdef , dimcon   ,&
                              defgem , deps     ,&
                              congem , vintm    ,&
                              congep , vintp    ,&
                              dsde   , ther_meca, retcom)
        character(len=16), intent(in) :: option, meca, thmc
        integer, intent(in) :: yate, yap1, yap2
        integer, intent(in) :: j_mater
        real(kind=8), intent(in) :: p1, dp1, p2, dp2, satur, tbiot(6)
        character(len=8), intent(in) :: typmod(2)
        real(kind=8), intent(in) :: carcri(*)
        integer, intent(in) :: ndim, dimdef, dimcon, addeme, adcome, addep1, addep2
        real(kind=8), intent(in) :: vintm(*)
        real(kind=8), intent(in) :: defgem(dimdef), deps(6), congem(dimcon)
        real(kind=8), intent(inout) :: congep(dimcon)
        real(kind=8), intent(inout) :: vintp(*)
        real(kind=8), intent(inout) :: dsde(dimcon, dimdef)
        real(kind=8), intent(out) :: ther_meca(6)
        integer, intent(out) :: retcom
    end subroutine thmMecaSpecial
end interface
