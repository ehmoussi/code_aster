! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
interface
    subroutine mmCompMatrFric(phase      , l_large_slip,&
                              l_pena_fric,&
                              i_reso_geom, i_reso_fric ,&
                              nbdm       , nbcps       , ndexfr,&
                              ndim       , nne         , nnm   , nnl   ,&
                              wpg        , jacobi      , coefac, coefaf,&
                              jeu        , dlagrc      ,&
                              ffe        , ffm         , ffl   , dffm  , ddffm,&
                              tau1       , tau2        , mprojt,&
                              rese       , nrese       , lambda, coefff,&
                              mprt1n     , mprt2n      , mprnt1, mprnt2,&
                              mprt11     , mprt12      , mprt21, mprt22,&
                              kappa      , vech1       , vech2 ,&
                              h          , &
                              dlagrf     , djeut ,&
                              matr_fric)
        character(len=4), intent(in) :: phase
        aster_logical, intent(in) :: l_large_slip, l_pena_fric
        integer, intent(in) :: i_reso_geom, i_reso_fric
        integer, intent(in) :: nbdm, nbcps, ndexfr
        integer, intent(in) :: ndim, nne, nnm, nnl
        real(kind=8), intent(in) :: wpg, jacobi, coefac, coefaf
        real(kind=8), intent(in) :: ffe(9), ffm(9), ffl(9), dffm(2,9), ddffm(3,9)
        real(kind=8), intent(in) :: tau1(3), tau2(3), mprojt(3, 3)
        real(kind=8), intent(in) :: rese(3), nrese, lambda, coefff
        real(kind=8), intent(in) :: jeu, dlagrc
        real(kind=8), intent(in) :: mprt1n(3,3), mprt2n(3,3), mprnt1(3,3), mprnt2(3,3)
        real(kind=8), intent(in) :: mprt11(3,3), mprt12(3,3), mprt21(3,3), mprt22(3,3)
        real(kind=8), intent(in) :: kappa(2,2), vech1(3), vech2(3), h(2,2)
        real(kind=8), intent(in) :: dlagrf(2), djeut(3)
        real(kind=8), intent(inout) :: matr_fric(81, 81)
    end subroutine mmCompMatrFric
end interface
