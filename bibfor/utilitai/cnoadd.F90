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
subroutine cnoadd(chno, chnop)
    implicit none
    character(len=*), intent(in) :: chno, chnop
!----------------------------------------------------------------
! BUT :
! pour un cham_no (chno) provenant d'un assemblage,
! on met à zéro les entrées dont on n'est pas strictement propriétaires
!----------------------------------------------------------------
#ifdef _USE_MPI

#include "asterf_config.h"
#include "asterf.h"
#include "asterf_types.h"
#include "mpif.h"
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jemarq.h"
#include "asterfort/jedema.h"
#include "asterfort/copisd.h"
#include "asterfort/codent.h"
#include "asterfort/jelira.h"
#include "asterfort/gettco.h"
#include "asterfort/assert.h"
#include "asterfort/asmpi_comm_vect.h"
#include "asterfort/asmpi_info.h"

    integer :: rang, nbproc
    integer :: iaux, jvale, jprddl, nbeq
    mpi_int :: mrank, msize
    character(len=8)  :: k8bid
    character(len=14) :: numddl
    character(len=16) :: typsd='****'
    character(len=19) :: cn19, pfchno, nommai, cn19p
!----------------------------------------------------------------
    call jemarq()

!   copie du champ en entrée
!   ------------------------
    cn19=chno
    cn19p=chnop
    call copisd('CHAMP','V',cn19,cn19p)

!   si le maillage support n'est pas distribué, on sort
!   ---------------------------------------------------
    call dismoi('PROF_CHNO',cn19,'CHAM_NO', repk=pfchno)
    ASSERT(pfchno(15:19).eq.'.NUME')
    numddl=pfchno(1:14)
    call dismoi('NOM_MAILLA', numddl, 'NUME_DDL', repk=nommai)
    call gettco(nommai(1:8), typsd)
    if( typsd .eq. 'MAILLAGE_P' ) then

        call jeveuo(numddl//'.NUME.PDDL', 'L', jprddl)
        call jelira(numddl//'.NUME.PDDL', 'LONMAX', nbeq, k8bid)

        call asmpi_info(rank = mrank, size = msize)
        rang = to_aster_int(mrank)
        nbproc = to_aster_int(msize)
        call jeveuo(cn19p//'.VALE','E',jvale)

        do iaux=1, nbeq
            if( zi(jprddl+iaux-1).ne.rang ) then
                zr(jvale-1+iaux) = 0.d0
            endif
        enddo

    endif

    call jedema()
#endif

    end
