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

subroutine codere(cod, npg, codret)
    implicit none
    integer :: npg, cod(npg), codret
!     ------------------------------------------------------------------
!     SYNTHESE DES CODES RETOURS : EN ENTREE, ON A UN TABLEAU
!     DE DIM. NPG CONTENANT LES CODES RETOURS DE TOUS LES PTS DE
!     GAUSS. EN SORTIE, ON A UN SEUL CODE RETOUR RESUME
!     ------------------------------------------------------------------
!     IN  COD     : TABLEAU CONTENANT LES CODES RETOURS DE TOUS
!                   LES PTS DE GAUSS
!     IN  NPG     : NBRE DE PTS DE GAUSS DE L'ELELEMT TRAITE
!     OUT CODRET  : CODE RETOUR RESUME
!         CODRET=1 : ECHEC INTEGRATION LOI DE COMPORTEMENT
!         CODRET=3 : C_PLAN DEBORST SIGZZ NON NUL
!     ------------------------------------------------------------------
    integer :: i
!
    codret=0
    do 10 i = 1, npg
        if (cod(i) .eq. 1) then
            codret=1
            goto 9999
        else if (cod(i).ne.0) then
            codret=cod(i)
        endif
10  end do
!
!
9999  continue
end subroutine
