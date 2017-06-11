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

subroutine get_elas_id(j_mater, elas_id, elas_keyword)
!
implicit none
!
#include "asterfort/rccoma.h"
#include "asterfort/utmess.h"
!
!
    integer, intent(in) :: j_mater
    integer, intent(out) :: elas_id
    character(len=*), optional, intent(out) :: elas_keyword
!
! --------------------------------------------------------------------------------------------------
!
! Comportment utility
!
! Get elasticity type
!
! --------------------------------------------------------------------------------------------------
!
! In  j_mater      : coded material address
! Out elas_id      : Type of elasticity
!                 1 - Isotropic
!                 2 - Orthotropic
!                 3 - Transverse isotropic
! Out elas_keyword : keyword factor linked to type of elasticity parameters
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: elas_keyword_in
!
! --------------------------------------------------------------------------------------------------
!
!
! - Keyword for elasticity parameters in material
!
    call rccoma(j_mater, 'ELAS', 1, elas_keyword_in)
!
! - Type of elasticity (Isotropic/Orthotropic/Transverse isotropic)
!
    if (elas_keyword_in.eq.'ELAS'.or.&
        elas_keyword_in.eq.'ELAS_HYPER'.or.&
        elas_keyword_in.eq.'ELAS_MEMBRANE'.or.&
        elas_keyword_in.eq.'ELAS_META'.or.&
        elas_keyword_in.eq.'ELAS_GLRC'.or.&
        elas_keyword_in.eq.'ELAS_DHRC'.or.&
        elas_keyword_in.eq.'ELAS_COQUE') then
        elas_id = 1
    elseif (elas_keyword_in.eq.'ELAS_ORTH') then
        elas_id = 2
    elseif (elas_keyword_in.eq.'ELAS_ISTR') then
        elas_id = 3
    else
        call utmess('F','COMPOR5_15', sk = elas_keyword_in)
    endif
!
    if (present(elas_keyword)) then
        elas_keyword = elas_keyword_in
    endif

end subroutine
