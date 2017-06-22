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

subroutine reerel(elrefp, nnop, ndim, tabar, xe,&
                  xg)
! aslint: disable=W1306
    implicit none
!
#include "asterfort/elrfvf.h"
#include "asterfort/vecini.h"
    integer :: ndim, nnop
    real(kind=8) :: xe(ndim), xg(ndim), tabar(*)
    character(len=8) :: elrefp
!
!
!                      TROUVER LES COORDONNEES REELLES D'UN POINT
!                      A PARTIR DE SES COORDONNEES DE REFERENCE
!
!     ENTREE
!       NDIM    : DIMENSION TOPOLOGIQUE DU MAILLAGE
!       IGEOM   : COORDONNEES DES NOEUDS DE L'ELEMENT
!       ELP     : TYPE DE L'ELEMENT
!       XE      : COORDONNES DE REFERENCE DU POINT
!
!     SORTIE
!       XG       : COORDONNES REELLES DU POINT
!......................................................................
!
    real(kind=8) :: ff(nnop)
    integer :: i, j, nbnomx, nno
    parameter   (nbnomx = 27)
!
!......................................................................
!
    call vecini(ndim, 0.d0, xg)
!
! --- VALEURS DES FONCTIONS DE FORME EN XE: FF
!
    if (elrefp(1:2) .eq. 'SE') then
        call elrfvf(elrefp, xe(1), nbnomx, ff, nno)
    else
        call elrfvf(elrefp, xe, nbnomx, ff, nno)
    endif
!
! --- COORDONNES DU POINT DANS L'ELEMENT REEL
!
    do j = 1, ndim
        do i = 1, nnop
            xg(j) = xg(j) + tabar(ndim*(i-1)+j)*ff(i)
        end do
    end do
!
end subroutine
