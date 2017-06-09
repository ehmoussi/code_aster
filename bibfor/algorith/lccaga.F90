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

subroutine lccaga(loi, cargau)
    implicit none
!
    character(len=4) :: cargau
    character(len=16) :: loi
!
!     CHOIX DES CARACTERISTIQUES
!     ----------------------------------------------------------------
!
!     IN
!         LOI : NOM DE LA LOI DE COMPORTEMENT
!     OUT
!         CARGAUS : CHAINE DE CARACTERES PRECISANT CERTAINES
!                     CARACTERISTIQUES DE LA RESOLUTION DES SYSTEMES
!                     LINEAIRES (1ER ARGUMENT DE MGAUSS)
!     ----------------------------------------------------------------
!
    if (loi .eq. 'VISCOCHAB') then
!
!       METHODE 'S' : SURE
        cargau = 'NCSP'
!
    else
!
!       METHODE 'W' : RATEAU
        cargau = 'NCWP'
!
    endif
!
end subroutine
