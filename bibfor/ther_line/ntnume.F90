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

subroutine ntnume(model, list_load, result, nume_dof)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/gnomsd.h"
#include "asterfort/numero.h"
#include "asterfort/rsnume.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=24), intent(in) :: model
    character(len=19), intent(in) :: list_load
    character(len=8), intent(in) :: result
    character(len=24), intent(out) :: nume_dof
!
! --------------------------------------------------------------------------------------------------
!
! Thermics - Initializations
!
! Create numbering
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! In  list_load        : name of datastructure for list of loads
! In  result           : name of result datastructure (EVOL_THER)
! Out nume_dof         : name of numbering object (NUME_DDL)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=14) :: nuposs
    character(len=24) :: noojb
!
! --------------------------------------------------------------------------------------------------
!
    nume_dof = '12345678.NUMED'
    noojb    = '12345678.00000.NUME.PRNO'
    call gnomsd(' ', noojb, 10, 14)
    nume_dof = noojb(1:14)
    call rsnume(result, 'TEMP', nuposs)
    call numero(nume_dof, 'VG',&
                old_nume_ddlz = nuposs,&
                modelz = model , list_loadz = list_load)
!
end subroutine
