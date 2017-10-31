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
    subroutine vpcres(eigsol, typres, raide, masse, amor, optiof, method, modrig, arret, tabmod,&
                  stoper, sturm, typcal, appr, typeqz, nfreq, nbvect, nbvec2, nbrss, nbborn,&
                  nborto, nitv, itemax, nperm, maxitr, vectf, precsh, omecor, precdc, seuil,&
                  prorto, prsudg, tol, toldyn, tolsor, alpha)
        character(len=19) , intent(in) :: eigsol
        character(len=16) , intent(in) :: typres
        character(len=19) , intent(in) :: raide
        character(len=19) , intent(in) :: masse
        character(len=19) , intent(in) :: amor
        character(len=16) , intent(in) :: optiof
        character(len=8)  , intent(in) :: method
        character(len=16) , intent(in) :: modrig
        character(len=8)  , intent(in) :: arret
        character(len=19) , intent(in) :: tabmod
        character(len=16) , intent(in) :: stoper
        character(len=16) , intent(in) :: sturm
        character(len=16) , intent(in) :: typcal
        character(len=1)  , intent(in) :: appr
        character(len=16) , intent(in) :: typeqz
        integer           , intent(in) :: nfreq
        integer           , intent(in) :: nbvect
        integer           , intent(in) :: nbvec2
        integer           , intent(in) :: nbrss
        integer           , intent(in) :: nbborn
        integer           , intent(in) :: nborto
        integer           , intent(in) :: nitv
        integer           , intent(in) :: itemax
        integer           , intent(in) :: nperm
        integer           , intent(in) :: maxitr
        real(kind=8)      , intent(in) :: vectf(2)
        real(kind=8)      , intent(in) :: precsh
        real(kind=8)      , intent(in) :: omecor
        real(kind=8)      , intent(in) :: precdc
        real(kind=8)      , intent(in) :: seuil
        real(kind=8)      , intent(in) :: prorto
        real(kind=8)      , intent(in) :: prsudg
        real(kind=8)      , intent(in) :: tol
        real(kind=8)      , intent(in) :: toldyn
        real(kind=8)      , intent(in) :: tolsor
        real(kind=8)      , intent(in) :: alpha
    end subroutine vpcres
end interface
