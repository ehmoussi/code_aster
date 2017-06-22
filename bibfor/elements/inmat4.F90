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

subroutine inmat4(elrefa, nno, nnos, npg, nofpg,&
                  mgano)
    implicit none
#include "asterfort/assert.h"
#include "asterfort/inmat5.h"
#include "asterfort/inmat6.h"
    character(len=8) :: elrefa, nofpg
    integer :: nno, nnos, npg
    real(kind=8) :: mgano(*)
! person_in_charge: jacques.pellet at edf.fr
! ======================================================================
! BUT : CALCULER LA MATRICE DE PASSAGE GAUSS -> NOEUDS
!       POUR UNE FAMILLE D'UN ELREFA
! ======================================================================
!
    integer :: nbpgmx, nbnomx
    parameter (nbpgmx=1000,nbnomx=27)
    integer :: kpg, kno, knos, k
    real(kind=8) :: mganos(nbpgmx, nbnomx), mgano2(nbpgmx, nbnomx)
!
!     NBPGMX, NBNOMX SE REFERER A ELRACA
!
! DEB ------------------------------------------------------------------
!
!
    ASSERT(npg.le.nbpgmx)
    ASSERT(nno.le.nbnomx)
    ASSERT(nnos.le.nbnomx)
!
!
!     -- MISES A ZERO :
!     ----------------------------------------------------------
    do 30,kpg = 1,npg
    do 10,kno = 1,nno
    mgano2(kpg,kno) = 0.d0
10  continue
    do 20,knos = 1,nnos
    mganos(kpg,knos) = 0.d0
20  continue
    30 end do
    do 40,k = 1,2 + npg*nno
    mgano(k) = 0.d0
    40 end do
!
!
!     -- ON TRAITE LE CAS GENERIQUE NPG=1  (INCLUT NOFPG='FPG1')
!     ----------------------------------------------------------
    if (npg .eq. 1) then
        do 50,kno = 1,nno
        mgano2(1,kno) = 1.d0
50      continue
        goto 80
    endif
!
!
!     -- ON TRAITE LE CAS GENERIQUE NOFPG='NOEU'
!     -------------------------------------------------
    if (nofpg .eq. 'NOEU') then
        ASSERT(nno.eq.npg)
        do 60,k = 1,nno
        mgano2(k,k) = 1.d0
60      continue
        goto 80
    endif
!
!
!     -- ON TRAITE LE CAS GENERIQUE NOFPG='NOEU_S'
!     -------------------------------------------------
    if (nofpg .eq. 'NOEU_S') then
        ASSERT(nnos.eq.npg)
        do 70,k = 1,nnos
        mganos(k,k) = 1.d0
70      continue
        call inmat5(elrefa, nno, nnos, npg, mganos,&
                    mgano2)
        goto 80
    endif
!
!
!     -- AUTRES CAS : GAUSS -> SOMMETS -> NOEUDS
!     -------------------------------------------
    call inmat6(elrefa, nofpg, mganos)
    call inmat5(elrefa, nno, nnos, npg, mganos,&
                mgano2)
    goto 80
!
!
80  continue
    mgano(1) = nno
    mgano(2) = npg
    do 100,kpg = 1,npg
    do 90,kno = 1,nno
    mgano(2+ (kno-1)*npg+kpg) = mgano2(kpg,kno)
90  continue
    100 end do
    goto 110
!
110  continue
!
end subroutine
