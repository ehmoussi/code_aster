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
subroutine get_med_connectivity(mesh, med_connect)

    implicit none

#include "asterfort/gnomsd_xx.h"
#include "asterfort/jecrec.h"
#include "asterfort/jedema.h"
#include "asterfort/jeecra.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/lrmtyp.h"
#include "asterfort/wkvect.h"

    character(len=8), intent(in) :: mesh
    character(len=24), intent(inout) :: med_connect

! ------------------------------------------------------------------------------
!
! Return the connectivity of 'mesh' using Med conventions
!
! In  mesh          : name of mesh
! InOut med_connect : collection identical to 'mesh.CONNECT' but with the
!                     Med conventions
!    If it is empty as input (" "), a default temporary name is used.
!
! ------------------------------------------------------------------------------

    integer :: modnum(MT_NTYMAX)
    integer :: nuanom(MT_NTYMAX, MT_NNOMAX)
    character(len=24) :: connex
    integer :: i, j, ityp
    integer :: nbcell, nbnode, size
    integer, pointer :: dime(:) => null()
    integer, pointer :: p_elt(:) => null(), m_elt(:) => null()
    integer, pointer :: typmast(:) => null()

    call jemarq()

    if (med_connect .eq. ' ') then
        call gnomsd_xx(med_connect)
    endif

!   get conversion arrays code_aster <---> med
    call lrmtyp(modnum=modnum, nuanom=nuanom)

    connex = mesh//'.CONNEX'
    call jelira(connex, 'LONT', size)
    call jeveuo(mesh//'.DIME', 'L', vi=dime)
    call jeveuo(mesh//'.TYPMAIL', 'L', vi=typmast)
    nbcell = dime(3)

    call jecrec(med_connect, 'V V I', 'NU', 'CONTIG', 'VARIABLE', nbcell)
    call jeecra(med_connect, 'LONT', ival=size)

    do i=1, nbcell
        ityp = typmast(i)
        call jelira(jexnum(connex, i), 'LONMAX', ival=nbnode)
        call jeveuo(jexnum(connex, i), 'L', vi=p_elt)
        call jeecra(jexnum(med_connect, i), 'LONMAX', ival=nbnode)
        call jeveuo(jexnum(med_connect, i), 'E', vi=m_elt)
        if (modnum(ityp) .eq. 0) then
            do j=1, nbnode
                m_elt(j) = p_elt(j)
            end do
        else
            do j=1, nbnode
                m_elt(j) = p_elt(nuanom(ityp, j))
            end do
        endif
    end do

    call jedema()

end subroutine
