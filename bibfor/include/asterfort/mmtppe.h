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
    subroutine mmtppe(typmae,typmam,ndim  ,nne   ,nnm   , &
                      nnl   ,nbdm  ,iresog,laxis ,&
                      xpc        , ypc      , xpr     , ypr     ,&
                      tau1  ,tau2  ,&
                      jeusup,ffe   ,ffm   ,dffm  ,ddffm,ffl   , &
                      jacobi,jeu   ,djeut ,dlagrc, &
                      dlagrf,norm  ,mprojn, &
                     mprojt, mprt1n, mprt2n, mprnt1, mprnt2,&
                     kappa ,h     , hah, vech1 ,vech2 , &
              mprt11,mprt12, mprt21, &
              mprt22,taujeu1, taujeu2, &
                  dnepmait1,dnepmait2, l_previous,l_large_slip)
              
        character(len=8) :: typmae
        character(len=8) :: typmam
        integer :: ndim
        integer :: nne
        integer :: nnm
        integer :: nnl
        integer :: nbdm
        aster_logical, intent(in) :: l_large_slip
        integer :: iresog
        aster_logical :: laxis
        aster_logical :: l_previous
        real(kind=8), intent(in) :: xpc, ypc, xpr, ypr
        real(kind=8) :: jeusup
        real(kind=8) :: ffe(9)
        real(kind=8) :: ffm(9)
        real(kind=8) :: dffm(2, 9)
        real(kind=8) :: ddffm(3, 9)
        real(kind=8) :: ffl(9)
        real(kind=8) :: jacobi
        real(kind=8) :: jeu
        real(kind=8) :: djeut(3)
        real(kind=8) :: dlagrc
        real(kind=8) :: dlagrf(2)
        real(kind=8) :: norm(3)
        real(kind=8), intent(in) :: tau1(3), tau2(3)
        real(kind=8) :: dnepmait1 ,dnepmait2 ,taujeu1,taujeu2

        real(kind=8) :: mprojn(3, 3)
        real(kind=8) :: mprojt(3, 3)
        real(kind=8), intent(out) :: mprt11(3, 3), mprt12(3, 3), mprt21(3, 3), mprt22(3, 3)
        real(kind=8), intent(out) :: mprt1n(3, 3), mprt2n(3, 3), mprnt1(3, 3), mprnt2(3, 3)
    
    real(kind=8) :: kappa(2,2)
    real(kind=8) :: h(2,2), hah(2,2)
    
    real(kind=8) :: vech1(3)
    real(kind=8) :: vech2(3)

    end subroutine mmtppe
end interface
