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

!
#include "asterf_types.h"
!
interface
    subroutine mngliss(tau1  ,tau2  ,djeut,kappa ,taujeu1, taujeu2, &
                  dnepmait1,dnepmait2, ndim )

        integer :: ndim
        integer :: nnm
        integer :: iresog,granglis
    real(kind=8) :: ddgeo1(3),ddgeo2(3),ddgeo3(3),detkap,ddepmait1(3),ddepmait2(3)
    real(kind=8) :: dnepmait1,dnepmait2,taujeu1,taujeu2
    
        real(kind=8) :: geomam(9, 3),depmam(9, 3)

        real(kind=8) :: ddffm(3, 9),dffm(2, 9)

        real(kind=8) :: jeu , djeu(3)
        real(kind=8) :: djeut(3)

        real(kind=8) :: norm(3)
        real(kind=8) :: tau1(3)
        real(kind=8) :: tau2(3)
    
        real(kind=8) :: mprojn(3, 3)
        real(kind=8) :: mprojt(3, 3)
    
        real(kind=8) :: mprt1n(3, 3)
        real(kind=8) :: mprt2n(3, 3)
        real(kind=8) :: mprt11(3, 3)
        real(kind=8) :: mprt21(3, 3)
        real(kind=8) :: mprt22(3, 3)
        
        real(kind=8) :: gene11(3, 3)
        real(kind=8) :: gene21(3, 3)
        real(kind=8) :: gene22(3, 3)
    
        real(kind=8) :: kappa(2,2)
        real(kind=8) :: h(2,2)    
        real(kind=8) :: a(2,2)        
        real(kind=8) :: ha(2,2)    
        real(kind=8) :: hah(2,2)
    
    real(kind=8) :: vech1(3)
    real(kind=8) :: vech2(3)
    
    end subroutine mngliss
end interface
