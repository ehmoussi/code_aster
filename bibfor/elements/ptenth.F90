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

subroutine ptenth(ul, xl, f, n, mat,  enerth)
!
!
! --------------------------------------------------------------------------------------------------
!
!     CALCUL DE L'ENERGIE DE DEFORMATION THERMIQUE POUR LES
!          ELEMENTS POUTRE (POU_D_T, POU_D_E)
!
! --------------------------------------------------------------------------------------------------
!
! IN  UL     :  DEPLACEMENTS DES NOEUDS DE LA POUTRE
! IN  XL     :  LONGUEUR DE LA POUTRE
! IN  F      :  DILATATION DU MATERIAU
! IN  N      :  DIMENSION DE LA MATRICE MAT
! IN  MAT    :  MATRICE DE RAIDEUR
! IN  ITYPE  :  TYPE DE LA SECTION
! OUT ENERTH :  ENERGIE DE DEFORMATION THERMIQUE
!
! --------------------------------------------------------------------------------------------------
!
    implicit  none
!
    integer ::  n
    real(kind=8) :: ul(12), f, mat(n,n), enerth
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ii, jj
    real(kind=8) :: ugt(12), flt(12), xl, flm(12)
!
! --------------------------------------------------------------------------------------------------
!
    enerth = 0.d0
    ugt(:) = 0.d0
    flt(:) = 0.d0
    flm(:) = 0.d0
!
    if (f .ne. 0.d0) then
        ugt(1) = -f*xl
        ugt(7) = -ugt(1)
!       calcul des forces induites par les déformations thermiques
        do ii = 1, 6
            do jj = 1, 6
                flt(ii)   = flt(ii)   - mat(ii,jj)    *ugt(jj)
                flt(ii+6) = flt(ii+6) - mat(ii+6,jj+6)*ugt(jj+6)
                flm(ii)   = flm(ii)   - mat(ii,jj)    *ul(jj)
                flm(ii+6) = flm(ii+6) - mat(ii+6,jj+6)*ul(jj+6)
            enddo
        enddo
!       energie de deformation induite par les deformations thermiques
        do  ii = 1, 12
            enerth = enerth + (0.5d0*ugt(ii)*flt(ii)-ugt(ii)*flm(ii))
        enddo
    endif
!
end subroutine
