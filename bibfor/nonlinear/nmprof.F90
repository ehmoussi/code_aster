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

subroutine nmprof(model        , result, list_load, nume_ddl,&
                  sd_iden_relaz)
!
implicit none
!
#include "asterfort/gnomsd.h"
#include "asterfort/numero.h"
#include "asterfort/rsnume.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=24), intent(in) :: model
    character(len=24), intent(out) :: nume_ddl
    character(len=8), intent(in) :: result
    character(len=19), intent(in) :: list_load
    character(len=*), optional, intent(in) :: sd_iden_relaz
!
! --------------------------------------------------------------------------------------------------
!
! Non-linear algorithm - Initializations
!
! Create numbering
!
! --------------------------------------------------------------------------------------------------
!
! Out nume_ddl       : name of numbering object (NUME_DDL)
! In  result         : name of result datastructure (EVOL_NOLI)
! In  model          : name of model datastructure
! In  list_load      : list of loads
! In  sd_iden_rela   : name of object for identity relations between dof
!
! --------------------------------------------------------------------------------------------------
!
    character(len=14) :: nuposs
    character(len=24) :: noojb, sd_iden_rela
!
! --------------------------------------------------------------------------------------------------
!
    sd_iden_rela = ' '
    if (present(sd_iden_relaz)) then
        sd_iden_rela = sd_iden_relaz
    endif
!
! - Generate name of numbering object (nume_ddl)
!
    nume_ddl = '12345678.NUMED'
    noojb    = '12345678.00000.NUME.PRNO'
    call gnomsd(' ', noojb, 10, 14)
    nume_ddl = noojb(1:14)
    call rsnume(result, 'DEPL', nuposs)
!
! - Create numbering
!
    call numero(nume_ddl, 'VG',&
                old_nume_ddlz = nuposs,&
                modelz = model , list_loadz = list_load,&
                sd_iden_relaz = sd_iden_rela)
!
end subroutine
