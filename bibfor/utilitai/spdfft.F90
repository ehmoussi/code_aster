! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine spdfft(lvar, nbva, nsens, ltra, nbpts1, nbpts, nout, nbpts2,&
                  sym)
    implicit none
#include "jeveux.h"
#include "asterfort/fft.h"
#include "asterfort/vecinc.h"
#include "asterfort/vecini.h"
#include "blas/zcopy.h"
!
!     REALISATION N.GREFFET
!     CALCUL DE LA FFT OU DE LA FFT-1 (E. BOYERE 09/06/00)
!     ----------------------------------------------------------------
! parametres
    integer :: lvar, nbva, nsens, ltra, nbpts1, nbpts, nout, nbpts2
    character(len=16) :: sym
!
! variables locales
    complex(kind=8) :: dcmplx, czero, caux
    real(kind=8) :: pas, pasfrq, raux, rzero
    integer :: lfon, i, ii, valmax, lres1
!     ----------------------------------------------------------------
!
    czero=dcmplx(0.D0,0.D0)
    rzero=0.D0
    lfon = lvar + nbva
!     --- TRANSFORMATION PAR FOURIER
    if (nsens .eq. 1) then
!     --- SENS DIRECT
!
!INIT
        call vecinc(nbpts,czero,zc(ltra),1)
        call vecinc(2*nbpts2,czero,zc(nout),1)
!
        do 199 i = 1, nbpts1
            zc(ltra+i-1) = dcmplx(zr(lfon+i-1),0.d0)
199      continue
        if (nbpts .gt. nbva) then
          call vecinc(nbpts-nbva,czero,zc(ltra+nbva),1)
        endif
        call fft(zc(ltra), nbpts, 1)
        pas = zr(lvar+1)-zr(lvar)
        lres1 = nout + nbpts2
        pasfrq = 1.d0/((dble(nbpts))*pas)
        caux=dcmplx(pasfrq,0.d0)
        do 198 i = 1, nbpts2
          zc(nout+i-1) = (i-1)*caux
198     continue
        call zcopy(nbpts2,zc(ltra),1,zc(lres1),1)
!
    else if (nsens.eq.-1) then
!     --- SENS INVERSE
!
!INIT
        call vecinc(nbpts2+1,czero,zc(ltra),1)
        call vecini(2*nbpts2,rzero,zr(nout))
!
        valmax = (nbpts2/2)
        if (nbva .lt. (nbpts2/2)) then
          valmax = nbva
        endif
        do 201 i = 1, valmax
            ii = (2*i)-1
            zc(ltra+i-1) = dcmplx(zr(lfon+ii-1),zr(lfon+ii))
            zc(ltra+nbpts2-i+1) = dcmplx(zr(lfon+ii-1),-zr(lfon+ii))
201      continue
        zc(ltra+nbpts+1)=dcmplx(((4.d0*zr(lfon+ii-1)-zr(lfon+ii-3)&
        )/3.d0),0.d0)
        if ((nbpts.gt.nbva) .and. (sym.eq.'NON')) then
          do i = 1, (nbpts-nbva)
            zc(ltra+nbva+i-1) = dcmplx(0.d0,0.d0)
            zc(ltra+nbpts2-nbva-i+1) = dcmplx(0.d0,0.d0)
          enddo
        endif
        zc(ltra+nbpts+1)=dcmplx(((4.d0*dble(zc(ltra+nbpts)) -dble(zc(&
        ltra+nbpts-1)) )/3.d0),0.d0)
        call fft(zc(ltra), nbpts2, -1)
        pas = zr(lvar+1)-zr(lvar)
        lres1 = nout + nbpts2
        raux=1.d0/(dble(nbpts2)*pas)
        do 202 i = 1, nbpts2
          zr(nout+i-1) = raux*(i-1)
202     continue
! PAS2 = (1.D0/ZR(LVAR+NBVA-1))*(DBLE(NBVA)/DBLE(NBPTS2))
        do 203 i = 1, nbpts2
            zr(lres1+i-1) = dble(zc(ltra+i-1))
203      continue
!
    endif
!
end subroutine
