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

subroutine asmpi_comm_jev(optmpi, nomjev)
!-----------------------------------------------------------------------
!    - FONCTION REALISEE : SUR-COUCHE MPI
!
!      FAIRE UN ECHANGE BCAST/REDUCE/ALL_REDUCE SUR UN OBJET JEVEUX
!
! ARGUMENTS D'APPELS
! IN OPTMPI :
!      /'MPI_SUM' == 'ALLREDUCE + SUM'
!      /'MPI_MAX' == 'ALLREDUCE + MAX'
!      /'MPI_MIN' == 'ALLREDUCE + MIN'
!      /'REDUCE'  == 'REDUCE + SUM' : TOUS -> 0
!      /'BCAST'   == 'BCAST'        : 0    -> TOUS
!
! IN NOMJEV : K24 : NOM JEVEUX DU VECTEUR A COMMUNIQUER
!----------------------------------------------------------------------
! person_in_charge: jacques.pellet at edf.fr
!
!
    implicit none
#include "asterf_types.h"
#include "asterf.h"
#include "jeveux.h"
#include "asterc/asmpi_comm.h"
#include "asterc/loisem.h"
#include "asterfort/asmpi_comm_vect.h"
#include "asterfort/asmpi_info.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelibe.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
#include "asterfort/uttcpu.h"
#include "asterfort/wkvect.h"
#include "asterfort/jxveri.h"
!
! DECLARATION PARAMETRES D'APPELS
    character(len=*) :: optmpi
    character(len=24) :: nomjev
!
#ifdef _USE_MPI
#include "mpif.h"
#include "asterf_mpi.h"
!
! DECLARATION VARIABLES LOCALES
    integer :: jnomjv, iexi, bcrank, ibid
    integer :: iobj, nbobj, nlong
    mpi_int :: nbpro4, mpicou, nbv
    mpi_int, parameter :: pr0=0
    character(len=1) :: typsca, xous
    character(len=8) :: kbid, stock
    aster_logical :: unseul
!
! ---------------------------------------------------------------------
    call jemarq()
!
!
!   -- s'il n'y a qu'un seul proc, il n'y a rien a faire :
!   ------------------------------------------------------
    call asmpi_comm('GET', mpicou)
    call asmpi_info(mpicou, size=nbpro4)
    if (nbpro4 .eq. 1) goto 999
!
!
    call jelira(nomjev, 'XOUS', ibid, xous)
    ASSERT(xous.eq.'S'.or. xous.eq.'X')
    call jelira(nomjev, 'TYPE', ibid, typsca)
!
    if (xous .eq. 'X') then
        call jelira(nomjev, 'NMAXOC', nbobj, kbid)
        call jelira(nomjev, 'STOCKAGE', cval=stock)
        unseul=.false.
        if (stock .eq. 'CONTIG') then
            nbobj=1
            unseul=.true.
        endif
    else
        nbobj=1
        unseul=.true.
    endif
!
!
    bcrank=0
!
    do 10 iobj = 1, nbobj
        if (unseul) then
            ASSERT (nbobj.eq.1)
            call jeveuo(nomjev, 'E', jnomjv)
            if (xous .eq. 'X') then
                call jelira(nomjev, 'LONT', nlong, kbid)
            else
                call jelira(nomjev, 'LONMAX', nlong, kbid)
            endif
        else
            call jeexin(jexnum(nomjev, iobj), iexi)
            if (iexi .eq. 0) goto 10
            call jeveuo(jexnum(nomjev, iobj), 'E', jnomjv)
            call jelira(jexnum(nomjev, iobj), 'LONMAX', nlong, kbid)
        endif
!
        nbv = to_mpi_int(nlong)
!
        if (typsca .eq. 'R') then
            call asmpi_comm_vect(optmpi, typsca, nlong, bcrank, vr=zr(jnomjv))
        else if (typsca.eq.'C') then
            call asmpi_comm_vect(optmpi, typsca, nlong, bcrank, vc=zc(jnomjv))
        else if (typsca.eq.'I') then
            call asmpi_comm_vect(optmpi, typsca, nlong, bcrank, vi=zi(jnomjv))
        else if (typsca.eq.'S') then
            call asmpi_comm_vect(optmpi, typsca, nlong, bcrank, vi4=zi4(jnomjv))
        else
            ASSERT(.false.)
        endif
!
        if (xous .eq. 'X' .and. stock .ne. 'CONTIG') call jelibe(jexnum(nomjev, iobj))
 10 continue
!
!
999 continue
    call jedema()
#else
    character(len=1) :: kdummy
    kdummy = optmpi(1:1)
    kdummy = nomjev(1:1)
#endif
end subroutine
