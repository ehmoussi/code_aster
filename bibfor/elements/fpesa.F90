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

subroutine fpesa(nomte, xi, nb1, vecl)
    implicit none
#include "jeveux.h"
#include "asterfort/dxroep.h"
#include "asterfort/forpes.h"
#include "asterfort/jevech.h"
#include "asterfort/jevete.h"
#include "asterfort/r8inir.h"
#include "asterfort/vectci.h"
#include "asterfort/vexpan.h"
    character(len=16) :: nomte
!
!
    integer :: nb1, npgsn
    real(kind=8) :: rho, epais, pesan, rnormc
    real(kind=8) :: xi(3, *), vpesan(3), vecl(51), vecl1(42)
!     REAL*8 VECTC(3),VECPTX(3,3)
!
!-----------------------------------------------------------------------
    integer :: i, intsn, jpesa, lzi, lzr
!-----------------------------------------------------------------------
    call jevech('PPESANR', 'L', jpesa)
    pesan = zr(jpesa)
    do 5 i = 1, 3
        vpesan(i) = pesan*zr(jpesa+i)
 5  end do
!
    call jevete('&INEL.'//nomte(1:8)//'.DESI', ' ', lzi)
    nb1 = zi(lzi-1+1)
    npgsn = zi(lzi-1+4)
!
    call jevete('&INEL.'//nomte(1:8)//'.DESR', ' ', lzr)
!
    call dxroep(rho, epais)
!
    call r8inir(42, 0.d0, vecl1, 1)
!
    do 40 intsn = 1, npgsn
        call vectci(intsn, nb1, xi, zr(lzr), rnormc)
        call forpes(intsn, nb1, zr(lzr), rho, epais,&
                    vpesan, rnormc, vecl1)
40  end do
!
    call vexpan(nb1, vecl1, vecl)
    do 60 i = 1, 3
        vecl(6*nb1+i) = 0.d0
60  end do
!
end subroutine
