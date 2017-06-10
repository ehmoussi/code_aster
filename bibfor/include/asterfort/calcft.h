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
    subroutine calcft(option, thmc, imate, ndim, dimdef,&
                      dimcon, yamec, yap1, yap2, addete,&
                      addeme, addep1, addep2, adcote, congep,&
                      dsde, t, grat, phi, pvp,&
                      rgaz, tbiot, sat, dsatp1, lambp,&
                      dlambp, lambs, dlambs, tlambt, tdlamt,&
                      mamolv, tlamct, rho11, h11, h12,&
                      angmas, anisof, phenom)
        integer :: dimcon
        integer :: dimdef
        integer :: ndim
        character(len=16) :: option
        character(len=16) :: thmc
        integer :: imate
        integer :: yamec
        integer :: yap1
        integer :: yap2
        integer :: addete
        integer :: addeme
        integer :: addep1
        integer :: addep2
        integer :: adcote
        real(kind=8) :: congep(1:dimcon)
        real(kind=8) :: dsde(1:dimcon, 1:dimdef)
        real(kind=8) :: t
        real(kind=8) :: grat(3)
        real(kind=8) :: phi
        real(kind=8) :: pvp
        real(kind=8) :: rgaz
        real(kind=8) :: tbiot(6)
        real(kind=8) :: sat
        real(kind=8) :: dsatp1
        real(kind=8) :: lambp
        real(kind=8) :: dlambp
        real(kind=8) :: lambs
        real(kind=8) :: dlambs
        real(kind=8) :: tlambt(ndim, ndim)
        real(kind=8) :: tdlamt(ndim, ndim)
        real(kind=8) :: mamolv
        real(kind=8) :: tlamct(ndim, ndim)
        real(kind=8) :: rho11
        real(kind=8) :: h11
        real(kind=8) :: h12
        real(kind=8) :: angmas(3)
        integer, intent(in) :: anisof
        character(len=16) :: phenom
    end subroutine calcft
end interface 
