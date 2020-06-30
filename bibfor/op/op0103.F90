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

subroutine op0103()
    implicit none
! person_in_charge: jacques.pellet at edf.fr
!------------------------------------------------------------------
!                   MODI_MODELE
!------------------------------------------------------------------
#include "jeveux.h"
#include "asterfort/ajlipa.h"
#include "asterfort/getvid.h"
#include "asterfort/getvtx.h"
#include "asterfort/getvis.h"
#include "asterfort/gcncon.h"
#include "asterfort/fetskp.h"
#include "asterfort/fetcrf.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/assert.h"
#include "asterfort/asmpi_info.h"
    character(len=8) :: model, sd_partit1
    character(len=24) :: kdis
    integer :: ib,nbproc,n1
    mpi_int :: mrank, msize
!------------------------------------------------------------------
!
    call jemarq()
!
!   -- modification de la partition  :
!   ---------------------------------------------------
    call getvid(' ', 'MODELE', scal=model, nbret=ib)
    ASSERT(ib.eq.1)
    call asmpi_info(rank=mrank, size=msize)
    nbproc = to_aster_int(msize)
    call getvtx('DISTRIBUTION', 'METHODE', iocc=1, scal=kdis, nbret=n1)
    ASSERT(n1.eq.1)
    if (nbproc.eq.1) kdis='CENTRALISE'

!   -- pour MODI_MODELE : 'SOUS_DOMAINE' == 'GROUP_ELEM'
    if (kdis.eq.'SOUS_DOMAINE') kdis='GROUP_ELEM'

    sd_partit1=' '

    call ajlipa(model, 'G', kdis, sd_partit1)
!
    call jedema()
end subroutine
