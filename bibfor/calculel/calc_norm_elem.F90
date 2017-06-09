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

subroutine calc_norm_elem(normz   , ligrel, chcoef, chgaus, chcalc, &
                          field_in, field_resu)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/calcul.h"
!
!
    character(len=*) , intent(in) :: normz
    character(len=19), intent(in) :: ligrel
    character(len=19), intent(in) :: chcoef
    character(len=19), intent(in) :: chgaus
    character(len=19), intent(in) :: chcalc
    character(len=19), intent(in) :: field_in
    character(len=19), intent(in) :: field_resu
!
! --------------------------------------------------------------------------------------------------
!
! Compute Norm * Norm or Norm by element (integration on finite element)
!
! --------------------------------------------------------------------------------------------------
!
! In  norm       : type of norm
! In  ligrel     : list of elements where norm computing
! In  chcoef     : name of <CARTE> contains coefficient for each component
! In  chgaus     : name of <CARTE> with informations on Gauss points
! In  chcalc     : name of <CARTE> for type of calc_elem (NORM or SQUA)
! In  field_in   : name of input field FROM which compute norm
! In  field_resu : name of output field IN which compute norm
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: lpain(4), lpaout(1)
    character(len=16) :: option, norm
    character(len=19) :: lchin(4), lchout(3)
    integer :: nbchin
!
! --------------------------------------------------------------------------------------------------
!
    norm = normz
    if (norm.eq.'L2') then
        option = 'NORME_L2'
    elseif (norm.eq.'FROBENIUS') then
        option = 'NORME_FROB'
    else
        ASSERT(.false.)
    endif
!
! - Compute norm * norm
!
    lpain(1)  = 'PCOORPG'
    lchin(1)  = chgaus
    lpain(2)  = 'PCHAMPG'
    lchin(2)  = field_in
    lpain(3)  = 'PCOEFR'
    lchin(3)  = chcoef
    lpain(4)  = 'PCALCI'
    lchin(4)  = chcalc
    lpaout(1) = 'PNORME'
    lchout(1) = field_resu
    nbchin    = 4
!
    call calcul('S', option, ligrel, nbchin, lchin,&
                lpain, 1, lchout, lpaout, 'V',&
                'OUI')
!
end subroutine
