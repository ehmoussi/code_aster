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
    subroutine calcft(option, angl_naut,&
                      ndim  , dimdef   , dimcon,&
                      adcote, &
                      addeme, addete   , addep1, addep2,&
                      temp  , grad_temp,&
                      tbiot ,&
                      phi   , rho11    , satur_, dsatur_,&
                      pvp   , h11      , h12   ,&
                      lambs , dlambs   , lambp , dlambp,&
                      tlambt, tlamct   , tdlamt,&
                      congep, dsde)
        character(len=16), intent(in) :: option
        real(kind=8), intent(in) :: angl_naut(3)
        integer, intent(in) :: ndim, dimdef, dimcon
        integer, intent(in) :: adcote
        integer, intent(in) :: addeme, addete, addep1, addep2
        real(kind=8), intent(in) :: temp, grad_temp(3)
        real(kind=8), intent(in) :: tbiot(6)
        real(kind=8), intent(in) :: phi, rho11, satur_, dsatur_
        real(kind=8), intent(in) :: pvp, h11, h12
        real(kind=8), intent(in) :: lambs, dlambs
        real(kind=8), intent(in) :: lambp, dlambp
        real(kind=8), intent(in) :: tlambt(ndim, ndim)
        real(kind=8), intent(in) :: tlamct(ndim, ndim)
        real(kind=8), intent(in) :: tdlamt(ndim, ndim)
        real(kind=8), intent(inout) :: congep(1:dimcon), dsde(1:dimcon, 1:dimdef)
    end subroutine calcft
end interface 
