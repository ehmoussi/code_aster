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
!
#include "asterf_types.h"
!
interface
    subroutine getExternalBehaviourPntr(comp_exte,&
                                        cptr_fct_ldc ,&
                                        cptr_nbvarext, cptr_namevarext,&
                                        cptr_nbprop  , cptr_nameprop)
        use Behaviour_type
        type(Behaviour_External), intent(in) :: comp_exte
        integer, intent(out) :: cptr_fct_ldc
        integer, intent(out) :: cptr_nbvarext
        integer, intent(out) :: cptr_namevarext
        integer, intent(out) :: cptr_nbprop
        integer, intent(out) :: cptr_nameprop
    end subroutine getExternalBehaviourPntr
end interface
