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

subroutine hujrmo(mater, sig, vin, riso)
    implicit none
!   CALCUL DE LA VALEUR DE RISO = PISO/(D*PCO*EXP(-BETA*EPSVP))
!   IN  MATER  :  COEFFICIENTS MATERIAU A T+DT
!       VIN    :  VARIABLES INTERNES  A T
!       SIG    :  CONTRAINTE A T+DT
!
!   OUT RISO   : FACTEUR DE MOBILISATION ACTUEL DU MECANISME ISOTROPE
!   ------------------------------------------------------------------
    integer :: ndt, ndi, i
    real(kind=8) :: mater(22, 2), riso, i1, sig(6), vin(*)
    real(kind=8) :: d, pco, beta, pc, epsvpm
    real(kind=8) :: d13, zero, aexp, exptol
!
    common /tdim/   ndt , ndi
!
    data      d13, zero  /0.333333333334d0, 0.d0/
!
    d = mater(3,2)
    pco = mater(7,2)
    beta = mater(2,2)
    epsvpm = vin(23)
!
    exptol = log(1.d+20)
    exptol = min(exptol, 40.d0)
    aexp = -beta*epsvpm
!
    if (aexp .ge. exptol) write(6,'(A)') 'HUJRMO :: PB!!'
!
    pc = pco*exp(-beta*epsvpm)
!
    i1 = zero
    do 10 i = 1, ndi
        i1 = i1 + d13*sig(i)
10  continue
!
    riso = abs(i1)/abs(d*pc)
!
end subroutine
