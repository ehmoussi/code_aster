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

subroutine mnluil(x, omega, alpha, eta, h,&
                  hf, nt, sort)
    implicit none
!
! ======================================================================!
#include "jeveux.h"
#include "asterc/r8depi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jedetr.h"
#include "asterfort/mnlfft.h"
#include "asterfort/wkvect.h"
! ----------------------------------------------------------------------
! --- DECLARATION DES ARGUMENTS DE LA ROUTINE
! ----------------------------------------------------------------------
    integer :: h, hf, nt
    real(kind=8) :: x(2*h+1), omega, alpha, eta, sort(2*hf+1)
! ----------------------------------------------------------------------
! --- DECLARATION DES VARIABLES LOCALES
! ----------------------------------------------------------------------
    real(kind=8) :: depi, xt
    integer :: it, iif
    integer :: k, j
!
    call jemarq()
!
    call wkvect('&&mnluil.t', 'V V R', nt, it)
    call wkvect('&&mnluil.f', 'V V R', nt, iif)
    depi=r8depi()
    zr(it)=0.d0
    do 10 k = 2, nt
        zr(it-1+k)=zr(it-1+k-1)+(depi/omega)/nt
10  continue
!
    do 20 k = 1, nt
        xt=x(1)
        do 21 j = 1, h
            xt=xt+x(1+j)*dcos(dble(j)*omega*zr(it-1+k))
            xt=xt+x(1+h+j)*dsin(dble(j)*omega*zr(it-1+k))
21      continue
        zr(iif-1+k)=((xt-1.d0)+sqrt((xt-1.d0)**2+4.d0*eta/alpha))/(2.d0/alpha)
20  continue
!
    call mnlfft(1, sort(1), zr(iif), hf, nt,1)
!
    call jedetr('&&mnluil.t')
    call jedetr('&&mnluil.f')
!
!
    call jedema()
end subroutine
