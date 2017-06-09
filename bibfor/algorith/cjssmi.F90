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

subroutine cjssmi(mater, sig, vin, seuili)
    implicit none
!       CJS        :  SEUIL DU MECANISME ISOTROPE   FI = - I1/3 + Q
!
!       ----------------------------------------------------------------
!       IN  SIG    :  CONTRAINTE
!       IN  VIN    :  VARIABLES INTERNES = ( Q, R, X, ETAT)
!       OUT SEUILI :  SEUIL  ELASTICITE DU MECANISME ISOTROPE
!       ----------------------------------------------------------------
    integer :: ndt, ndi, i
    real(kind=8) :: mater(14, 2), qiso, i1, sig(6), vin(*), seuili, trois
!
    common /tdim/   ndt , ndi
!
    data       trois  /3.d0/
!
!       ----------------------------------------------------------------
!
!
    qiso = vin(1)
    i1=0.d0
    do 10 i = 1, ndi
        i1 = i1 + sig(i)
10  continue
!
    seuili = - (i1+mater(13,2))/trois + qiso
!
end subroutine
