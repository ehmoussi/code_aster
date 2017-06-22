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

subroutine numer3(modelz, list_loadz, nume_ddlz, sd_iden_relaz)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/detrsd.h"
#include "asterfort/idenob.h"
#include "asterfort/infbav.h"
#include "asterfort/infmue.h"
#include "asterfort/numero.h"
!
!
    character(len=*), intent(in) :: modelz
    character(len=*), intent(inout) :: nume_ddlz
    character(len=*), intent(in) :: list_loadz
    character(len=*), intent(in) :: sd_iden_relaz
!
! --------------------------------------------------------------------------------------------------
!
! Factor
!
! (Re)-Numbering - Used for variable element topology (contact)
!
! --------------------------------------------------------------------------------------------------
!
! IO  nume_ddl       : name of numbering object (NUME_DDL)
! In  model          : name of model datastructure
! In  list_load      : list of loads
! In  sd_iden_rela   : name of object for identity relations between dof
!
! --------------------------------------------------------------------------------------------------
!
    character(len=14) :: nume_ddl_old, nume_ddl_save
!
! --------------------------------------------------------------------------------------------------
!
    call infmue()
    nume_ddl_old  = nume_ddlz
    nume_ddl_save = '&&NUMER3.NUAV'
    call copisd('NUME_DDL', 'V', nume_ddlz, nume_ddl_save)
    call detrsd('NUME_DDL', nume_ddlz)
!
! - Numbering
!
    call numero(nume_ddlz, 'VG',&
                modelz = modelz , list_loadz = list_loadz,&
                sd_iden_relaz = sd_iden_relaz)
!
! - Same equations ! The re-numbering works only with MUMPS/MULT_FRONT/PETSc, not with LDLT
!
    ASSERT(idenob(nume_ddl_old//'.NUME.DEEQ',nume_ddl_save//'.NUME.DEEQ'))
!
    call detrsd('NUME_DDL', nume_ddl_save)
    call infbav()
!
end subroutine
