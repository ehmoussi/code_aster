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

subroutine mnlaft(x, y, h, nt, pq)
    implicit none
!
!
! ----------------------------------------------------------------------
!
!     MODE_NON_LINE ALTERNATING FOURIER TRANSFORM
!     -    -   -    -           -       -
! ----------------------------------------------------------------------
!
! EFFECTUE LE PRODUIT DE DEUX SIGNAUX FREQUENTIELS X ET Y PAR LA METHODE
! AFT  : IFFT -> FFT -> IFFT
! LES COEFFICIENTS SONT RANGES AINSI : Z = [Z0 ZC1...ZCH ZS1...ZSH]
! ----------------------------------------------------------------------
! IN  X  : R8(N*(2*H+1)) : VECTEUR A MULTIPLIER
! IN  Y  : R8(N*(2*H+1)) : VECTEUR A MULTIPLIER
! IN  H  : I             : NOMBRE D'HARMONIQUES
! IN  NT : I             : DISCRETISATION DU TEMPS (POUR LA FFT)
!                          ATTENTION ! NT DOIT ETRE UNE PUISSANCE DE 2.
!                          EN GENERAL ON PREND :
!                          NT = 2**(1 + LOG10(4H+1)/LOG10(2))
! OUT PQ : R8(N*(2*H+1)) : VECTEUR RESULTAT DE LA MULTIPLICATION
! ----------------------------------------------------------------------
!
! --- DECLARATION PARAMETRES D'APPELS
!
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/fft.h"
#include "asterfort/wkvect.h"
    integer :: h, nt
    real(kind=8) :: x(2*h+1), y(2*h+1), pq(2*h+1)
!
    integer :: ixf, iyf, ixyf
    integer :: k
!
    call jemarq()
!
    call wkvect('&&mnlaft.xf', 'V V C', nt, ixf)
    call wkvect('&&mnlaft.yf', 'V V C', nt, iyf)
    call wkvect('&&mnlaft.xft', 'V V C', nt, ixyf)
!
    zc(ixf)=dcmplx(nt*x(1),0.d0)
    zc(iyf)=dcmplx(nt*y(1),0.d0)
    do 20 k = 1, h
        zc(ixf-1+k+1)=dcmplx(nt/2.d0*x(k+1), nt/2.d0*x(h+k+1))
        zc(ixf-1+nt-k+1)=dcmplx(nt/2.d0*x(k+1),-nt/2.d0*x(h+k+1))
!
        zc(iyf-1+k+1)=dcmplx(nt/2.d0*y(k+1),nt/2.d0*y(h+k+1))
        zc(iyf-1+nt-k+1)=dcmplx(nt/2.d0*y(k+1),-nt/2.d0*y(h+k+1))
20  continue
!
    call fft(zc(ixf), nt, -1)
    call fft(zc(iyf), nt, -1)
!
    do 30 k = 1, nt
        zc(ixyf-1+k)=dcmplx(dble(zc(ixf-1+k))*dble(zc(iyf-1+k)),0.d0)
30  continue
!
    call fft(zc(ixyf), nt, 1)
!
    pq(1)=dble(zc(ixyf))/nt
    do 40 k = 1, h
        pq(k+1)=2.d0*dble(zc(ixyf-1+k+1))/nt
        pq(h+k+1)=2.d0*aimag(zc(ixyf-1+k+1))/nt
40  continue
!
    call jedetr('&&mnlaft.xf')
    call jedetr('&&mnlaft.yf')
    call jedetr('&&mnlaft.xft')
!
    call jedema()
end subroutine
