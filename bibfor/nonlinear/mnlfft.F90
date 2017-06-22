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

subroutine mnlfft(n, x, y, h, nt,ind)
    implicit none
!
!
!     MODE_NON_LINE ALTERNATING FOURIER TRANSFORM
!     -    -   -    -           -       -
! ----------------------------------------------------------------------
!
! EFFECTUE LE PRODUIT DE DEUX SIGNAUX FREQUENTIELS X ET Y PAR LA METHODE
! AFT  : IFFT -> FFT -> IFFT
! LES COEFFICIENTS SONT RANGES AINSI : Z = [Z0 ZC1...ZCH ZS1...ZSH]
! X ET Y PEUVENT CONTENIR N VECTEURS, PAR EX : X = [Z1 Z2 ...ZN]
! ----------------------------------------------------------------------
! IN  N   : I             : NOMBRE DE DDL
! IN  X   : R8(N*(2*H+1)) : LES COEFF DE FOURIER
! OUT Y   : R8(N*NT)      : TRANSFORMEE DE FOURIER INVERSE
! IN  H   : I             : NOMBRE D'HARMONIQUES
! IN  NT  : I             : DISCRETISATION DU TEMPS (POUR LA FFT)
!                           ATTENTION ! NT DOIT ETRE UNE PUISSANCE DE 2.
!                           EN GENERAL ON PREND :
!                           NT = 2**(1 + LOG10(2H+1)/LOG10(2))
! IN  IND : I             : 0 ---> IFFT
!                           1 ---> FFT
!
! ----------------------------------------------------------------------
!
! --- DECLARATION PARAMETRES D'APPELS
!
#include "jeveux.h"
#include "blas/zdscal.h"
#include "asterfort/fft.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jedetr.h"
#include "asterfort/wkvect.h"
    integer :: n, h, nt, ind
    real(kind=8) :: x(n*(2*h+1)), y(n*nt)
!
    integer :: k, iadd, j
    integer :: ixf, iyf, ixft
!
    call jemarq()
!
! --- INITIALISATION DES VECTEURS DE TRAVAIL ET DE L'IMAGINAIRE PUR I
!
    call wkvect('&&mnlfft.xf', 'V V C', n*nt, ixf)
    call wkvect('&&mnlfft.yf', 'V V C', nt, iyf)
    call wkvect('&&mnlfft.xft', 'V V C', nt, ixft)
    if (ind .eq. 0) then
! ---   REECRITURE COMPATIBLE AVEC LA DFT
! ---   APPLICATION DE L'IFFT
        do 10 k = 1, n
            call zdscal(nt, 0.d0, zc(ixft), 1)
!
            zc(ixft)=nt*x(k)
            do 30 j = 1, h
                zc(ixft-1+j+1)=dcmplx((nt/2.d0)*x(j*n+k),(nt/2.d0)*x(n*(h+j)+k))
                zc(ixft-1+nt-j+1)=dcmplx((nt/2.d0)*x(j*n+k),-(nt/2.d0)*x(n*(h+j)+k))
30          continue
!
            call fft(zc(ixft), nt, -1)
            do 11 j = 1, nt
                iadd = (j-1)*n+k
                y(iadd) = dble(zc(ixft-1+j))
11          continue
10      continue
!
    else if (ind.eq.1) then
! ---   APPLICATION DE LA FFT
        do 50 k = 1, n
            do 51 j = 1, nt
                zc(iyf-1+j)=dcmplx(y((j-1)*n+k),0.d0)
51          continue
!
            call fft(zc(iyf), nt, 1)
!
            x(k)=dble(zc(iyf))/nt
            do 52 j = 1, h
                x(j*n+k)=2.d0*dble(zc(iyf-1+j+1))/nt
                x((h+j)*n+k)=2.d0*aimag(zc(iyf-1+j+1))/nt
52          continue
50      continue
    endif
!
    call jedetr('&&mnlfft.xf')
    call jedetr('&&mnlfft.yf')
    call jedetr('&&mnlfft.xft')
!
    call jedema()
end subroutine
