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

subroutine diraidklv(nomte, raide, klv)
    implicit none
    character(len=16), intent(in) :: nomte
    real(kind=8), intent(in)      :: klv(*)
    real(kind=8), intent(out)     :: raide(6)
!
! --------------------------------------------------------------------------------------------------
!
!           TERMES DIAGONAUX DE LA MATRICE DE RAIDEUR
!
! --------------------------------------------------------------------------------------------------
!
!     nomte     : nom de l'élément
!     klv       : matrice de raideur
!     raide     : terme diagonal
!
! --------------------------------------------------------------------------------------------------
!
    raide(:) = 0.0d0
    if (nomte .eq. 'MECA_DIS_TR_L') then
        raide(1) = klv(1)
        raide(2) = klv(3)
        raide(3) = klv(6)
        raide(4) = klv(10)
        raide(5) = klv(15)
        raide(6) = klv(21)
    else if (nomte.eq.'MECA_DIS_TR_N') then
        raide(1) = klv(1)
        raide(2) = klv(3)
        raide(3) = klv(6)
        raide(4) = klv(10)
        raide(5) = klv(15)
        raide(6) = klv(21)
    else if (nomte.eq.'MECA_DIS_T_L') then
        raide(1) = klv(1)
        raide(2) = klv(3)
        raide(3) = klv(6)
    else if (nomte.eq.'MECA_DIS_T_N') then
        raide(1) = klv(1)
        raide(2) = klv(3)
        raide(3) = klv(6)
    else if (nomte.eq.'MECA_2D_DIS_T_L') then
        raide(1) = klv(1)
        raide(2) = klv(3)
    else if (nomte.eq.'MECA_2D_DIS_T_N') then
        raide(1) = klv(1)
        raide(2) = klv(3)
    else if (nomte.eq.'MECA_2D_DIS_TR_L') then
        raide(1) = klv(1)
        raide(2) = klv(3)
        raide(3) = klv(6)
    else if (nomte.eq.'MECA_2D_DIS_TR_N') then
        raide(1) = klv(1)
        raide(2) = klv(3)
        raide(3) = klv(6)
    endif
!
end subroutine
