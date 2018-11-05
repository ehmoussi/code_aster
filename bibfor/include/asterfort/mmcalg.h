! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
#include "asterf_types.h"
!
interface
    subroutine mmcalg(ndim     , l_large_slip,&
                      nnm      , dffm     , ddffm ,&
                      geomam   , ddepmam  ,&
                      tau1     , tau2     , norm  ,&
                      jeu      , djeu     ,&
                      gene11   , gene21   , gene22,&
                      kappa    , h        ,&
                      vech1    , vech2    ,&
                      a        , ha       , hah   ,&
                      mprt11   , mprt12   , mprt21, mprt22,&
                      mprt1n   , mprt2n   , mprnt1, mprnt2,&
                      taujeu1  , taujeu2  ,&
                      dnepmait1, dnepmait2)
        integer, intent(in) :: ndim, nnm
        aster_logical, intent(in) :: l_large_slip
        real(kind=8), intent(in) :: dffm(2, 9), ddffm(3,9)
        real(kind=8), intent(in) :: geomam(9, 3), ddepmam(9, 3)
        real(kind=8), intent(in) :: tau1(3), tau2(3), norm(3)
        real(kind=8), intent(in) :: jeu, djeu(3)
        real(kind=8), intent(out) :: gene11(3, 3), gene21(3, 3), gene22(3, 3)
        real(kind=8), intent(out) :: kappa(2,2), h(2,2)
        real(kind=8), intent(out) :: vech1(3), vech2(3)
        real(kind=8), intent(out) :: a(2,2), ha(2,2), hah(2,2)
        real(kind=8), intent(out) :: mprt11(3, 3), mprt12(3, 3), mprt21(3, 3), mprt22(3, 3)
        real(kind=8), intent(out) :: mprt1n(3, 3), mprt2n(3, 3), mprnt1(3, 3), mprnt2(3, 3)
        real(kind=8), intent(out) :: taujeu1, taujeu2
        real(kind=8), intent(out) :: dnepmait1, dnepmait2
    end subroutine mmcalg
end interface
