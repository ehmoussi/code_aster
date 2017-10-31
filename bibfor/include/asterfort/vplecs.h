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
#include "asterf_types.h"
!
interface
    subroutine vplecs(eigsol,&
                  itemax, maxitr, nbborn, nitv, nborto, nbvec2, nbvect, nbrss, nfreq, nperm,&
                  alpha, omecor, freq1, freq2, precdc, precsh, prorto, prsudg, seuil, tol, toldyn,&
                  tolsor,&
                  appr, arret, method, typevp, matra, matrb, matrc, modrig, optiof, stoper, sturm,&
                  typcal, typeqz, typres, amor, masse, raide, tabmod,&
                  lc, lkr, lns, lpg, lqz)
!                    
    character(len=19) , intent(in)    :: eigsol
!!
    integer           , intent(out)   :: itemax
    integer           , intent(out)   :: maxitr
    integer           , intent(out)   :: nbborn
    integer           , intent(out)   :: nitv
    integer           , intent(out)   :: nborto
    integer           , intent(out)   :: nbvec2
    integer           , intent(out)   :: nbvect
    integer           , intent(out)   :: nbrss
    integer           , intent(out)   :: nfreq
    integer           , intent(out)   :: nperm
!
    real(kind=8)      , intent(out)   :: alpha
    real(kind=8)      , intent(out)   :: omecor
    real(kind=8)      , intent(out)   :: freq1
    real(kind=8)      , intent(out)   :: freq2
    real(kind=8)      , intent(out)   :: precdc
    real(kind=8)      , intent(out)   :: precsh
    real(kind=8)      , intent(out)   :: prorto
    real(kind=8)      , intent(out)   :: prsudg
    real(kind=8)      , intent(out)   :: seuil
    real(kind=8)      , intent(out)   :: tol
    real(kind=8)      , intent(out)   :: toldyn
    real(kind=8)      , intent(out)   :: tolsor
!
    character(len=1)  , intent(out)   :: appr
!
    character(len=8)  , intent(out)   :: arret
    character(len=8)  , intent(out)   :: method
!
    character(len=9)  , intent(out)   :: typevp
!
    character(len=14) , intent(out)   :: matra
    character(len=14) , intent(out)   :: matrb
    character(len=14) , intent(out)   :: matrc
!    
    character(len=16) , intent(out)   :: modrig
    character(len=16) , intent(out)   :: optiof
    character(len=16) , intent(out)   :: stoper
    character(len=16) , intent(out)   :: sturm
    character(len=16) , intent(out)   :: typcal
    character(len=16) , intent(out)   :: typeqz
    character(len=16) , intent(out)   :: typres
!
    character(len=19) , intent(out)   :: amor
    character(len=19) , intent(out)   :: masse
    character(len=19) , intent(out)   :: raide
    character(len=19) , intent(out)   :: tabmod    
!
    aster_logical   , intent(out)   :: lc
    aster_logical   , intent(out)   :: lkr
    aster_logical   , intent(out)   :: lns
    aster_logical   , intent(out)   :: lpg
    aster_logical   , intent(out)   :: lqz
!    
    end subroutine vplecs
end interface
