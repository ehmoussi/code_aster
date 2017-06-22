! --------------------------------------------------------------------
! Copyright (C) 2007 NECS - BRUNO ZUBER   WWW.NECS.FR
! Copyright (C) 2007 - 2017 - EDF R&D - www.code-aster.org
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

subroutine nmfifn(nno, nddl, npg, wref, vff,&
                  dfde, geom, sigma, fint)
!
!
    implicit none
#include "asterfort/nmfici.h"
#include "asterfort/r8inir.h"
#include "blas/ddot.h"
    integer :: nno, nddl, npg
    real(kind=8) :: wref(npg), vff(nno, npg), dfde(2, nno, npg)
    real(kind=8) :: geom(nddl), fint(nddl), sigma(3, npg)
!-----------------------------------------------------------------------
!  FORCES NODALES POUR LES JOINTS 3D (TE0207)
!-----------------------------------------------------------------------
! IN  NNO    NOMBRE DE NOEUDS DE LA FACE (*2 POUR TOUT L'ELEMENT)
! IN  NDDL   NOMBRE DE DEGRES DE LIBERTE EN DEPL TOTAL (3 PAR NOEUDS)
! IN  NPG    NOMBRE DE POINTS DE GAUSS
! IN  WREF   POIDS DE REFERENCE DES POINTS DE GAUSS
! IN  VFF    VALEUR DES FONCTIONS DE FORME (DE LA FACE)
! IN  DFDE   DERIVEE DES FONCTIONS DE FORME (DE LA FACE)
! IN  GEOM   COORDONNEES DES NOEUDS
! IN  SIGMA  CONTRAINTES LOCALES AUX POINTS DE GAUSS (SIGN, SITX, SITY)
! OUT FINT   FORCES NODALES
!-----------------------------------------------------------------------
    integer :: ni, kpg
    real(kind=8) :: b(3, 60), poids
!-----------------------------------------------------------------------
!
!
    call r8inir(nddl, 0.d0, fint, 1)
!
!
    do 10 kpg = 1, npg
!
        call nmfici(nno, nddl, wref(kpg), vff(1, kpg), dfde(1, 1, kpg),&
                    geom, poids, b)
!
        do 20 ni = 1, nddl
!
            fint(ni) = fint(ni) + poids*ddot(3,b(1,ni),1,sigma(1,kpg), 1)
!
20      continue
!
10  end do
!
end subroutine
