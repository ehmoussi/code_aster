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

subroutine nmgpin(ndim, nno, axi, vu)
!
    implicit none
#include "asterf_types.h"
!
    aster_logical :: axi
    integer :: ndim, nno, vu(3, 27)
! ----------------------------------------------------------------------
!        INITIALISATION POUR LES ELEMENTS EN GRANDES DEFORMATIONS
! ----------------------------------------------------------------------
! IN  NDIM  DIMENSION DE L'ESPACE
! IN  NNO   NOMBRE DE NOEUDS
! IN  AXI   INDICATEUR DE MODELISATION AXISYMETRIQUE
! OUT VU    RENVOIE L'INDICE DU DDL CORRESPONDANT A (I,N)
! ----------------------------------------------------------------------
    integer :: n, i
! ----------------------------------------------------------------------
!
    do 10 n = 1, nno
        do 20 i = 1, ndim
            vu(i,n) = i + ndim*(n-1)
 20     continue
 10 end do
!
    if (axi) then
        do 30 n = 1, nno
            vu(3,n) = vu(1,n)
 30     continue
    endif
!
end subroutine
