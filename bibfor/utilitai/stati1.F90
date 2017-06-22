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

subroutine stati1(nval, serie, moyenn, ectype)
    implicit none
#include "asterfort/assert.h"
    integer :: nval
    real(kind=8) :: serie(nval), moyenn, ectype
! person_in_charge: jacques.pellet at edf.fr
! ----------------------------------------------------------------------
!  CALCULE LA MOYENNE ET L'ECART-TYPE D'UNE SERIE DE VALEURS REELLES
!  IN : NVAL  : NB DE VALEURS DE LA SERIE
!  IN : SERIE : LISTE DES VALEURS LA SERIE
!  OUT: MOYENN : VALEUR DE LA MOYENNE
!  OUT: ECTYPE : VALEUR DE L'ECART-TYPE
! ----------------------------------------------------------------------
!
    integer :: k
!----------------------------------------------------------------------
    ASSERT(nval.ge.1)
!
!
!     -- MOYENNE :
    moyenn=0.d0
    do 1, k=1,nval
    moyenn=moyenn+serie(k)
    1 end do
    moyenn=moyenn/nval
!
!
!     -- ECART-TYPE :
    ectype=0.d0
    do 2, k=1,nval
    ectype=ectype+(serie(k)-moyenn)**2
    2 end do
    ectype=sqrt(ectype/nval)
!
end subroutine
