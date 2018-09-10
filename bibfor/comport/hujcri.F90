! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine hujcri(mater, sig, vin, seuili)
    implicit none
!       HUJEUX:  SEUIL DU MECANISME ISOTROPE   FI = ABS( I1 ) + R4*D*PC
!       ---------------------------------------------------------------
!       IN  MATER  : COEFFICIENTS MATERIAU
!           SIG    :  CONTRAINTE
!           VIN    :  VARIABLES INTERNES = (R4,R1,R2,R3,EPSVP...)
!       OUT SEUILI :  SEUIL DU MECANISME MONOTONE DE CONSOLIDATION
!       ---------------------------------------------------------------
#include "asterc/r8maem.h"
#include "asterfort/utmess.h"
    integer :: ndt, ndi, i
    real(kind=8) :: mater(22, 2), r4, i1, sig(6), vin(*)
    real(kind=8) :: d, pco, beta, seuili, pc, epsvpm
    real(kind=8) :: d13, zero, aexp, exptol
!
    common /tdim/   ndt , ndi
!
    data      d13, zero  /0.333333333334d0, 0.d0/
!
    d = mater(3,2)
    pco = mater(7,2)
    beta = mater(2,2)
    r4 = vin(4)
    epsvpm = vin(23)
!
    exptol = log(r8maem())
!
    exptol = min(exptol, 40.d0)
    aexp = -beta*epsvpm
    if (aexp .ge. exptol) then
        call utmess('F', 'COMPOR1_7')
    endif
!
    pc = pco*exp(-beta*epsvpm)
!
    i1 = zero
    do i = 1, ndi
        i1 = i1 + d13*sig(i)
    enddo
!
    seuili = - abs(i1)/(d*pc) - r4
!
end subroutine
