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

subroutine fun1(area, a1, a2, n)
    implicit none
    integer :: n
    real(kind=8) :: area, a1, a2
!         CALCUL DE L'AIRE OU DE LA CONSTANTE DE TORSION EQUIVALENTE
!    D'UNE POUTRE DROITE A SECTION VARIABLE SOUS L'HYPOTHESE DE VARIA-
!    TION LINEAIRE DES COORDONNEES
!     ------------------------------------------------------------------
!                        LISTE DES ARGUMENTS
!    TYPE  !   NOM  !  TABLEAU  !             SIGNIFICATION
!    -------------------------------------------------------------------
! IN  R8   ! A1     !     -     ! VALEUR INITIALE
! IN  R8   ! A2     !     -     ! VALEUR FINALE
! IN  IS   ! N      !     -     ! ORDRE DU POLYNOME
! OUT  R8  ! AREA   !     -     ! VALEUR EQUIVALENTE
!     ------------------------------------------------------------------
!
    real(kind=8) :: xm, xm1, xm2
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    if (a1 .eq. a2) then
        area = a1
    else
        if (n .lt. 2) then
            area = (a2-a1) / (log(a2)-log(a1))
        else if (n .eq.2) then
!           VARIATION HOMOTHETIQUE.
            area = sqrt (a1*a2)
        else if (n .eq.3) then
            xm = 2.d0/3.d0
            xm1 = a1 ** xm
            xm2 = a2 ** xm
            area = 2 * (xm1*a2 - a1*xm2 ) / (xm2-xm1)
        else
            xm = 1.d0 / n
            area = (n-1)*((a2**xm)-a1**xm)
            xm = xm-1.d0
            area=area / ((a1**xm)-a2**xm)
        endif
    endif
end subroutine
