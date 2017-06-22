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

subroutine tsingu(nelem, nbr, re, taille, he)
!
    implicit none
    integer :: nelem, nbr(nelem)
    real(kind=8) :: re(nelem), taille(nelem)
!
!     BUT:
!         CALCUL LA NOUVELLE TAILLE
!         OPTION : 'SING_ELEM'
!
!
!     ARGUMENTS:
!     ----------
!
!      ENTREE :
!-------------
! IN   NELEM         : NOMBRE D ELEMENTS FINIS
! IN   NBR(NELEM)    : NOMBRE DE COMPOSANTES A STOCKER PAR EF
!      3 SI EF SURFACIQUES EN 2D OU VOLUMIQUES EN 3D
!      0 SINON
! IN   RE(NELEM)     : RAPPORT ENTRE ANCIENNE ET NOUVELLE TAILLE
! IN   TAILLE(NELEM) : ANCIENNE TAILLE
!
!      SORTIE :
!-------------
! OUT  HE(NELEM)     : NOUVELLE TAILLE
!
! ......................................................................
!
    integer :: inel
    real(kind=8) :: he(nelem)
!
    do 10 inel = 1, nelem
        if (nbr(inel) .eq. 3) then
            he(inel)=re(inel)*taille(inel)
        endif
10  end do
!
end subroutine
