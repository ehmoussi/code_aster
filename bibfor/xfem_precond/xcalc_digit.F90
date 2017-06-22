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

function xcalc_digit(id)
!
!-----------------------------------------------------------------------
! BUT : CALCULER LA TAILLE DU P-UPLET DE DEPART <=> NFISS VU PAR L ELEMENT
!-----------------------------------------------------------------------
!
! ARGUMENTS :
!------------
!   - ID     : INDICE DU DOMAINE
!
!-----------------------------------------------------------------------
    implicit none
!-----------------------------------------------------------------------
#include "jeveux.h"
#include "asterfort/assert.h"
!-----------------------------------------------------------------------
    integer :: xcalc_digit, id
!-----------------------------------------------------------------------
    integer :: base_codage
    parameter (base_codage=4)
!-----------------------------------------------------------------------
!
    if ( id .le. 1) then
      xcalc_digit=1
    else
      xcalc_digit=int(log(real(id,8))/log(real(base_codage,8)))+1
    endif
!
end function
