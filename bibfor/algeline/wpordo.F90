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

subroutine wpordo(type, shift, vpr, vpi, x,&
                  m, neq)
    implicit none
#include "asterfort/utmess.h"
    integer :: type, neq, m
    real(kind=8) :: vpr(*), vpi(*)
    complex(kind=8) :: x(neq, m), shift
!     TRI DES VALEURS (ET DES VECTEURS) PROPRES
!     DEUX TYPE DE TRI :
!          - TRI DANS LE SPECTRE : SUIVANT ABS(SHIFT - VPQ)
!          - TRI DE PRESNTATION  : SUIVANT IM(VPQ) - IM(SHIFT)
!     ------------------------------------------------------------------
! IN  TYPE   : IS : TYPE DU TRI PAR ORDRE CROISSANT SUR LES VALEURS.
!                   * SI TYPE = 0  TRI DE PRESENTATION
!                   * SI TYPE = 1  TRI DANS LE SPECTRE
! IN  M      : IS : NOMBRE DE VALEUR PROPRE
! IN  SHIFT  : C8 : DECALAGE SPECTRAL
! VAR VPR    : R8 : TABLEAU DES PARTIES IMAGINAIRES DES VALEURS PROPRES
! VAR VPI    : R8 : TABLEAU DES PARTIES REELLES     DES VALEURS PROPRES
! VAR X      : C8 : MATRICE DES VECTEURS PROPRES
! IN  NEQ    : IS : NOMBRE D'EQUATIONS
!                 SI NEQ < NBPRO ALORS ON NE TRIE PAS DE VECTEURS
!     ------------------------------------------------------------------
    integer :: i, j, k
    real(kind=8) :: p, om
    complex(kind=8) :: c
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    om = dimag(shift)
    if (type .eq. 0) then
        do 100, i = 1, m, 1
        k = i
        p = vpi(i) - om
        do 110, j = i+1, m
        if ((vpi(j)-om) .lt. p) then
            p = vpi(j) - om
            k = j
        endif
110      continue
        if (k .ne. i) then
            p = vpi(i)
            vpi(i) = vpi(k)
            vpi(k) = p
            p = vpr(i)
            vpr(i) = vpr(k)
            vpr(k) = p
            do 120, j = 1, neq, 1
            c = x(j,i)
            x(j,i) = x(j,k)
            x(j,k) = c
120          continue
        endif
100      continue
    else if (type .eq. 1) then
        do 200, i = 1, m, 1
        k = i
        p = abs(dcmplx(vpr(i),vpi(i)) - shift)
        do 210, j = i+1, m
        if ((abs(dcmplx(vpr(j),vpi(j))-shift)) .lt. p) then
            p = abs(dcmplx(vpr(j),vpi(j)) - shift)
            k = j
        endif
210      continue
        if (k .ne. i) then
            p = vpi(i)
            vpi(i) = vpi(k)
            vpi(k) = p
            p = vpr(i)
            vpr(i) = vpr(k)
            vpr(k) = p
            do 220, j = 1, neq, 1
            c = x(j,i)
            x(j,i) = x(j,k)
            x(j,k) = c
220          continue
        endif
200      continue
    else
        call utmess('F', 'ALGELINE3_97')
    endif
end subroutine
