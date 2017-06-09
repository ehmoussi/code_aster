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

subroutine inmat6(elrefa, fapg, mganos)
! person_in_charge: jacques.pellet at edf.fr
!----------------------------------------------------------------------
! BUT : CALCUL DE LA MATRICE MGANOS : GAUSS -> SOMMETS
!----------------------------------------------------------------------
    implicit none
!
#include "asterfort/assert.h"
#include "asterfort/elraca.h"
#include "asterfort/elraga.h"
#include "asterfort/elrfvf.h"
#include "asterfort/mgauss.h"
#include "asterfort/r8inir.h"
    integer :: nbpgmx, nbnomx, nbfamx
    parameter (nbpgmx=1000, nbnomx=27, nbfamx=20)
    integer :: ndim, nno, nnos, nbfpg, nbpg(nbfamx)
    integer :: i, kp, kdim, ln, j, lm, npg, iret
    real(kind=8) :: xno(3*nbnomx), vol, ff(nbnomx), m(nbpgmx*nbnomx)
    real(kind=8) :: p(nbpgmx*nbnomx), mganos(nbpgmx, nbnomx)
    real(kind=8) :: xpg(3*nbpgmx), poipg(nbpgmx), xg(3), det
    character(len=8) :: nofpg(nbfamx), elrefa, elref2, fapg
!
!     NBPGMX, NBNOMX, NBFAMX SE REFERER A ELRACA
!
! DEB ------------------------------------------------------------------
!
    call elraca(elrefa, ndim, nno, nnos, nbfpg,&
                nofpg, nbpg, xno, vol)
    call elraga(elrefa, fapg, ndim, npg, xpg,&
                poipg)
!
    ASSERT(nno.le.nbnomx)
    ASSERT(npg.le.nbpgmx)
!
!     CAS DU SHB8 ET DU SHB6 NON INVERSIBLE
    if (fapg .eq. 'SHB5' .or. fapg .eq. 'SHB6') then
        call r8inir(nbnomx*nbnomx, 0.d0, mganos, 1)
        do 10 i = 1, nnos/2
            mganos(1,i) = 1.d0
10      continue
        do 20 i = nnos/2+1, nnos
            mganos(5,i) = 1.d0
20      continue
        elref2 = elrefa
        goto 100
    endif
!
!     CAS DU QU4/FIS2 NON INVERSIBLE
    if (elrefa .eq. 'QU4' .and. fapg .eq. 'FIS2') then
        call r8inir(nbnomx*nbnomx, 0.d0, mganos, 1)
        mganos(1,1) = 1.d0
        mganos(1,4) = 1.d0
        mganos(2,2) = 1.d0
        mganos(2,3) = 1.d0
        goto 100
    endif
!
!
    if ((elrefa.eq.'H20') .or. (elrefa.eq.'H27')) then
        elref2 = 'HE8'
    else if ((elrefa.eq.'P15').or.(elrefa.eq.'P18')) then
        elref2 = 'PE6'
    else if ((elrefa.eq.'S15')) then
        elref2 = 'SH6'
    else if (elrefa.eq.'P13') then
        elref2 = 'PY5'
    else if (elrefa.eq.'T10') then
        elref2 = 'TE4'
    else if ((elrefa.eq.'TR6') .or. (elrefa.eq.'TR7')) then
        elref2 = 'TR3'
    else if ((elrefa.eq.'QU8') .or. (elrefa.eq.'QU9')) then
        elref2 = 'QU4'
    else if ((elrefa.eq.'SE3') .or. (elrefa.eq.'SE4')) then
        elref2 = 'SE2'
    else
        elref2 = elrefa
    endif
!
!
!     CALCUL DES MATRICES M ET P :
!     ----------------------------
    do 30 i = 1, nnos*nnos
        m(i) = 0.d0
30  end do
!
    do 70 kp = 1, npg
        do 40,kdim = 1,ndim
        xg(kdim) = xpg(ndim* (kp-1)+kdim)
40      continue
        call elrfvf(elref2, xg, nbnomx, ff, nno)
        ln = (kp-1)*nnos
        do 60 i = 1, nnos
            p(ln+i) = ff(i)
            do 50 j = 1, nnos
                lm = nnos* (i-1) + j
                m(lm) = m(lm) + ff(i)*ff(j)
50          continue
60      continue
70  end do
!
!     CALCUL DE LA MATRICE M-1*P :
!     ----------------------------
    call mgauss('NFVP', m, p, nnos, nnos,&
                npg, det, iret)
!
    do 90 i = 1, nnos
        do 80 kp = 1, npg
            mganos(kp,i) = p((kp-1)*nnos+i)
80      continue
90  end do
!
100  continue
!
end subroutine
