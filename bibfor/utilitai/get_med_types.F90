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

! person_in_charge: mathieu.courtois at edf.fr
subroutine get_med_types(mesh, vect_types)

    implicit none

#include "asterfort/assert.h"
#include "asterfort/gcncon.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/lrmtyp.h"
#include "asterfort/wkvect.h"


    character(len=8), intent(in) :: mesh
    character(len=24), intent(out) :: vect_types

! ------------------------------------------------------------------------------
!
! Return the list of the Med type for each cell
!
! In  mesh         : name of mesh
! Out vect_types   : vector of Med type (size: number of cells)
!
! ------------------------------------------------------------------------------

    integer :: typgeo(MT_NTYMAX)
    ! integer :: nnotyp(MT_NTYMAX), typgeo(MT_NTYMAX), nuanom(MT_NTYMAX, MT_NNOMAX)
    ! integer :: renumd(MT_NTYMAX), modnum(MT_NTYMAX), numnoa(MT_NTYMAX, MT_NNOMAX)
    ! integer :: nbtyp
    integer :: i, nbcell
    integer, pointer :: dime(:) => null()
    integer, pointer :: typmast(:) => null(), typmmed(:) => null()
    character(len=8) :: tmpname

!   get conversion arrays code_aster <---> med
    call lrmtyp(typgeo=typgeo)

    call jeveuo(mesh//'.DIME', 'L', vi=dime)
    nbcell = dime(3)

    call gcncon('_', tmpname)
    call wkvect(tmpname, 'V V I', nbcell, vi=typmmed)
    call jeveuo(mesh//'.TYPMAIL', 'L', vi=typmast)
    do i=1, nbcell
        typmmed(i) = typgeo(typmast(i))
    end do

end subroutine
