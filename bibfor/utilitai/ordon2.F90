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

subroutine ordon2(vale, nb)
! aslint: disable=W1306
    implicit none
#include "asterfort/ordr8.h"
#include "blas/dcopy.h"
    integer :: nb
    real(kind=8) :: vale(*)
! person_in_charge: mathieu.courtois at edf.fr
! ----------------------------------------------------------------------
!     APPELEE PAR ORDONN : ON SAIT DEJA QU'IL FAUT INVERSER L'ORDRE
!     ORDON2 POUR LES FONCTIONS A VALEURS COMPLEXES
! IN/OUT : VALE : ABSCISSES, PARTIE REELLE, PARTIE IMAGINAIRE
!                 SOUS LA FORME X1,Y1,Z1, X2,Y2,Z2, ...
! IN     : NB   : NBRE DE POINTS
! ----------------------------------------------------------------------
    integer :: i, iord(nb)
    real(kind=8) :: xbid(nb), yrbid(nb), yibid(nb)
!     ------------------------------------------------------------------
!
    call dcopy(nb, vale, 1, xbid, 1)
    call dcopy(nb, vale(nb+1), 2, yrbid, 1)
    call dcopy(nb, vale(nb+2), 2, yibid, 1)
    call ordr8(xbid, nb, iord)
    do 101 i = 1, nb
        vale(i)=xbid(iord(i))
        vale(nb+1+2*(i-1))=yrbid(iord(i))
        vale(nb+2+2*(i-1))=yibid(iord(i))
101  end do
!
end subroutine
