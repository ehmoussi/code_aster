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

subroutine fopro1(vec, i, prolgd, interp)
    implicit none
    integer :: i
    character(len=*) :: vec(*), prolgd, interp
!     RECUPERE LES PROLONGEMENTS ET TYPE D'INTERPOLATION DANS
!     LE VECTEUR DESCRIPTEUR D'UN OBJET DE TYPE FONCTION
!     ------------------------------------------------------------------
! IN  VEC   : VECTEUR DESCRIPTEUR
! IN  I     : NUMERO DE LA FONCTION DANS LE CAS D'UNE NAPPE (0 SINON)
! OUT PROLGD: PROLONGEMENTS A GAUCHE ET A DROITE DE LA FONCTION I
! OUT INTERP: TYPE D'INTERPOLATION DE LA FONCTION I
!     ------------------------------------------------------------------
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    if (i .eq. 0) then
        interp = vec(2)
        prolgd = vec(5)
    else
        interp = vec(7+(2*i-1))
        prolgd = vec(7+(2*i ))
    endif
end subroutine
