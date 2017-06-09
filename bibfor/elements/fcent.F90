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

subroutine fcent(nomte, xi, nb1, vecl)
    implicit none
#include "jeveux.h"
#include "asterfort/dxroep.h"
#include "asterfort/forcen.h"
#include "asterfort/jevech.h"
#include "asterfort/jevete.h"
#include "asterfort/r8inir.h"
#include "asterfort/vectci.h"
#include "asterfort/vexpan.h"
    character(len=16) :: nomte
!
!
    integer :: nb1
    real(kind=8) :: rho, epais
    real(kind=8) :: xi(3, *), vomega(3), vecl(51), vecl1(42)
    real(kind=8) :: xa(3)
!
!-----------------------------------------------------------------------
    integer :: i, intsn, irota, lzi, lzr, npgsn
    real(kind=8) :: rnormc
!-----------------------------------------------------------------------
    call jevech('PROTATR', 'L', irota)
    vomega(1)=zr(irota)*zr(irota+1)
    vomega(2)=zr(irota)*zr(irota+2)
    vomega(3)=zr(irota)*zr(irota+3)
!
    xa(1)=zr(irota+4)
    xa(2)=zr(irota+5)
    xa(3)=zr(irota+6)
!
    call jevete('&INEL.'//nomte(1:8)//'.DESI', ' ', lzi)
    nb1  =zi(lzi-1+1)
    npgsn=zi(lzi-1+4)
!
    call jevete('&INEL.'//nomte(1:8)//'.DESR', ' ', lzr)
!
    call dxroep(rho, epais)
!
    call r8inir(42, 0.d0, vecl1, 1)
!
    do 40 intsn = 1, npgsn
        call vectci(intsn, nb1, xi, zr(lzr), rnormc)
        call forcen(rnormc, intsn, nb1, xi, zr(lzr),&
                    rho, epais, vomega, vecl1, xa)
40  end do
!
    call vexpan(nb1, vecl1, vecl)
    do 60 i = 1, 3
        vecl(6*nb1+i)=0.d0
60  end do
!
end subroutine
