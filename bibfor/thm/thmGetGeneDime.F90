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

subroutine thmGetGeneDime(ndim  ,&
                          mecani, press1, press2, tempe,&
                          dimdep, dimdef, dimcon)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
    integer, intent(in) :: ndim
    integer, intent(in) :: mecani(5), press1(7), press2(7), tempe(5)
    integer, intent(out) :: dimdep, dimdef, dimcon
!
! --------------------------------------------------------------------------------------------------
!
! THM - Parameters
!
! Get dimensions of generalized vectors
!
! --------------------------------------------------------------------------------------------------
!
! In  mecani       : parameters for mechanic
! In  press1       : parameters for hydraulic (first pressure)
! In  press1       : parameters for hydraulic (second pressure)
! In  tempe        : parameters for thermic
! In  ndim         : dimension of element (2 ou 3)
! Out dimdep       : dimension of generalized displacement vector
! Out dimdef       : dimension of generalized strains vector
! Out dimcon       : dimension of generalized stresses vector
!
! --------------------------------------------------------------------------------------------------
!
    dimdep = ndim*mecani(1) + press1(1) + press2(1) + tempe(1)
    dimdef = mecani(4) + press1(6) + press2(6) + tempe(4)
    dimcon = mecani(5) + press1(2)*press1(7) + press2(2)*press2(7) + tempe(5)
!
end subroutine
