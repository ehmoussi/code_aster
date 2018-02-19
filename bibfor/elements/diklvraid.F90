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

subroutine diklvraid(nomte, klv, raide)
    implicit none
    character(len=16), intent(in)   :: nomte
    real(kind=8), intent(in)        :: raide(6)
    real(kind=8), intent(out)       :: klv(*)

! --------------------------------------------------------------------------------------------------
!
!           ACTUALISATION DE LA MATRICE QUASI-TANGENTE
!
!  LES TERMES DIAGONAUX SONT LES SEULS A ETRE ADAPTES
!
! --------------------------------------------------------------------------------------------------
!
!     nomte : nom de l'element
!     raide : raideur
!     klv   : matrice de raideur
!
! --------------------------------------------------------------------------------------------------
!
    if (nomte .eq. 'MECA_DIS_TR_L') then
        klv(1)  = raide(1)
        klv(3)  = raide(2)
        klv(6)  = raide(3)
        klv(10) = raide(4)
        klv(15) = raide(5)
        klv(21) = raide(6)
        klv(28) = raide(1)
        klv(36) = raide(2)
        klv(45) = raide(3)
        klv(55) = raide(4)
        klv(66) = raide(5)
        klv(78) = raide(6)
        klv(22) = -raide(1)
        klv(30) = -raide(2)
        klv(39) = -raide(3)
        klv(49) = -raide(4)
        klv(60) = -raide(5)
        klv(72) = -raide(6)
    else if (nomte.eq.'MECA_DIS_TR_N') then
        klv(1)  = raide(1)
        klv(3)  = raide(2)
        klv(6)  = raide(3)
        klv(10) = raide(4)
        klv(15) = raide(5)
        klv(21) = raide(6)
    else if (nomte.eq.'MECA_DIS_T_L') then
        klv(1)  = raide(1)
        klv(3)  = raide(2)
        klv(6)  = raide(3)
        klv(10) = raide(1)
        klv(15) = raide(2)
        klv(21) = raide(3)
        klv(7)  = -raide(1)
        klv(12) = -raide(2)
        klv(18) = -raide(3)
    else if (nomte.eq.'MECA_DIS_T_N') then
        klv(1)  = raide(1)
        klv(3)  = raide(2)
        klv(6)  = raide(3)
    else if (nomte.eq.'MECA_2D_DIS_T_L') then
        klv(1)  = raide(1)
        klv(3)  = raide(2)
        klv(6)  = raide(1)
        klv(10) = raide(2)
        klv(4)  = -raide(1)
        klv(8)  = -raide(2)
    else if (nomte.eq.'MECA_2D_DIS_T_N') then
        klv(1)  = raide(1)
        klv(3)  = raide(2)
    else if (nomte.eq.'MECA_2D_DIS_TR_L') then
        klv(1)  = raide(1)
        klv(3)  = raide(2)
        klv(6)  = raide(3)
        klv(10) = raide(1)
        klv(15) = raide(2)
        klv(21) = raide(3)
        klv(7)  = -raide(1)
        klv(12) = -raide(2)
        klv(18) = -raide(3)
    else if (nomte.eq.'MECA_2D_DIS_TR_N') then
        klv(1)  = raide(1)
        klv(3)  = raide(2)
        klv(6)  = raide(3)
    endif
!
end subroutine
