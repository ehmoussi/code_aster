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

subroutine xmilfi(elp, n, ndime, nno, ptint, ndim,&
                  jtabco, jtabls, ipp, ip, milfi)
    implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/reerel.h"
#include "asterfort/vecini.h"
#include "asterfort/xnewto.h"
    integer :: ndim, ndime, nno, jtabco, jtabls, ipp, ip, n(3)
    character(len=8) :: elp
    real(kind=8) :: milfi(ndim), ptint(*)
!
!                      TROUVER LES COORDONNES DU PT MILIEU ENTRE LES
!                      DEUX POINTS D'INTERSECTION
!
!     ENTREE
!       NDIM    : DIMENSION TOPOLOGIQUE DU MAILLAGE
!       PTINT  : COORDONNÉES DES POINTS D'INTERSECTION
!       JTABCO  : ADRESSE DES COORDONNEES DES NOEUDS DE L'ELEMENT
!       JTABLS  : ADRESSE DES LSN DES NOEUDS DE L'ELEMENT
!       IPP     : NUMERO NOEUD PREMIER POINT INTER
!       IP      : NUMERO NOEUD DEUXIEME POINT INTER
!       N       : LES INDICES DES NOEUX D'UNE FACE DANS L'ELEMENT PARENT
!     SORTIE
!       MILFI   : COORDONNES DU PT MILIEU ENTRE IPP ET IP
!     ----------------------------------------------------------------
!
    real(kind=8) :: ksi(ndim)
    real(kind=8) :: epsmax
    integer :: itemax
    character(len=6) :: name
!
! --------------------------------------------------------------------
!
!
    itemax=500
    epsmax=1.d-9
    name='XMILFI'
!
!     CALCUL DES COORDONNEES DE REFERENCE
!     DU POINT PAR UN ALGO DE NEWTON
!!!!!ATTENTION INITIALISATION DU NEWTON:
    call vecini(ndim, 0.d0, ksi)
    call xnewto(elp, name, n,&
                ndime, ptint, ndim, zr(jtabco), zr(jtabls),&
                ipp, ip, itemax,&
                epsmax, ksi)
!
    ASSERT(ksi(1).ge.-1.d0 .and. ksi(1).le.1.d0)
    ASSERT(ksi(2).ge.-1.d0 .and. ksi(2).le.1.d0)
!
! --- COORDONNES DU POINT DANS L'ELEMENT REEL
    call reerel(elp, nno, ndim, zr(jtabco), ksi,&
                milfi)
!
end subroutine
