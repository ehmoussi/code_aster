! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nunuco(nume_ddl, sdnuco)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/select_dof.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!
character(len=24), intent(in) :: nume_ddl, sdnuco
!
! --------------------------------------------------------------------------------------------------
!
! Non-linear algorithm - Initializations
!
! Get position of contact dof
!
! --------------------------------------------------------------------------------------------------
!
! In  nume_ddl : name of numbering (NUME_DDL)
! In  sdnuco   : name of datastructure to save position of contact dof
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nbEqua, nbCmp
    character(len=8), pointer :: listCmp(:) => null()
    integer, pointer :: listEqua(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
!
! - Create list of components
!
    nbCmp = 3
    AS_ALLOCATE(vk8 = listCmp, size = nbCmp)
    listCmp(1) = 'LAGS_C'
    listCmp(2) = 'LAGS_F1'
    listCmp(3) = 'LAGS_F2'
!
! - Create list of equations
!
    call dismoi('NB_EQUA', nume_ddl, 'NUME_DDL', repi = nbEqua)
    call wkvect(sdnuco, 'V V I', nbEqua, vi = listEqua)
!
! - Find components in list of equations
!
    call select_dof(listEqua, &
                    numeDofZ_      = nume_ddl,&
                    nbCmpToSelect_ = nbCmp  , listCmpToSelect_ = listCmp)
!
    AS_DEALLOCATE(vk8=listCmp)
!
end subroutine
