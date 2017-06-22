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

subroutine rs_gettime(result_, nume, inst)
!
implicit none
!
#include "jeveux.h"
#include "asterc/r8vide.h"
#include "asterfort/rsadpa.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=*), intent(in) :: result_
    integer, intent(in) :: nume
    real(kind=8), intent(out) :: inst
!
! --------------------------------------------------------------------------------------------------
!
! Results datastructure - Utility
!
! Get time at index stored in results datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  result           : name of results datastructure
! In  nume             : index to find in results datastructure
! Out inst             : time found in results datastructure
!                        
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: result
    integer :: j_inst
!
! --------------------------------------------------------------------------------------------------
!
    result    = result_
    inst      = r8vide()
    call rsadpa(result, 'L', 1, 'INST', nume,&
                0, sjv=j_inst)
    inst      = zr(j_inst)

end subroutine
