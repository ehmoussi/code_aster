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
subroutine cpysol(nomat, numddl, rsolu, debglo, vecpet, nbval)
    implicit none
#include "asterf_config.h"
#include "asterf.h"
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jeexin.h"
#include "asterfort/jenuno.h"
#include "asterfort/jexatr.h"
#include "asterfort/jexnum.h"
#include "asterfort/mrconl.h"
#include "asterc/loisem.h"
#include "asterfort/wkvect.h"
#include "asterc/asmpi_comm.h"
#include "asterfort/asmpi_comm_vect.h"
#include "asterfort/asmpi_info.h"
#include "asterc/asmpi_recv_r.h"
#include "asterc/asmpi_send_r.h"
    integer(kind=4) :: debglo, nbval
    real(kind=8) :: rsolu(*), vecpet(*)
    character(len=14) :: numddl
    character(len=19) :: nomat
#ifdef _USE_MPI
#include "mpif.h"
!
    integer :: rang, nbproc, jnbjoi, nbjoin, numpro, jjointr, jjointe,lmat
    integer :: lgenvo, lgrecep, jvaleue, jvaleur, iaux, jaux, jnulg
    integer :: jprddl, jnequ, nloc, nlili, ili, iret, jjoin, ijoin
    integer :: numglo, jdeeq, jrefn, jmlogl, nuno1, nucmp1, numloc
    integer :: iret1, iret2, jjoine, nbnoee, idprn1, idprn2, nec, dime
    integer :: nunoel, l, jjoinr, jnujoi1, jnujoi2, nbnoer, nddll, ntot
    integer :: numnoe
    logical :: ldebug
!
    integer(kind=4) :: n4r, n4e, iaux4, num4, numpr4
    mpi_int :: mrank, msize, iermpi, mpicou
    mpi_int :: lr8, lint, lint4, nbv4, nbpro4, nudes4, numes4
!
    character(len=4) :: chnbjo
    character(len=8) :: k8bid, noma
    character(len=19) :: nomlig
    character(len=24) :: nonbjo, nojoinr, nojoine, nonulg, join
!----------------------------------------------------------------------
    integer :: zzprno
!
!---- FONCTION D ACCES AUX ELEMENTS DES CHAMPS PRNO DES S.D. LIGREL
!     REPERTORIEES DANS LE CHAMP LILI DE NUME_DDL ET A LEURS ADRESSES
!     ZZPRNO(ILI,NUNOEL,1) = NUMERO DE L'EQUATION ASSOCIEES AU 1ER DDL
!                            DU NOEUD NUNOEL DANS LA NUMEROTATION LOCALE
!                            AU LIGREL ILI DE .LILI
!     ZZPRNO(ILI,NUNOEL,2) = NOMBRE DE DDL PORTES PAR LE NOEUD NUNOEL
!     ZZPRNO(ILI,NUNOEL,2+1) = 1ER CODE
!     ZZPRNO(ILI,NUNOEL,2+NEC) = NEC IEME CODE
!
    zzprno(ili,nunoel,l) = zi(idprn1-1+zi(idprn2+ili-1)+ (nunoel-1)* (nec+2)+l-1)
!
    call jemarq()
    ldebug=.false.
!
    call asmpi_comm('GET', mpicou)
    if (loisem() .eq. 8) then
        lint=MPI_INTEGER8
    else
        lint=MPI_INTEGER
    endif
    lint4=MPI_INTEGER4
    lr8 = MPI_DOUBLE_PRECISION
!
    call asmpi_info(rank = mrank, size = msize)
    rang = to_aster_int(mrank)
    nbproc = to_aster_int(msize)
!
    nonbjo = numddl//'.NUME.NBJO'
    call jeveuo(nonbjo, 'L', jnbjoi)
    nbjoin = zi(jnbjoi)
!
    call jeveuo(numddl//'.NUME.NULG', 'L', jnulg)
    call jeveuo(numddl//'.NUME.PDDL', 'L', jprddl)
    call jeveuo(numddl//'.NUME.NEQU', 'L', jnequ)
    nloc = zi(jnequ)
!
    do iaux = 0, nloc
        if (zi(jprddl + iaux) .eq. rang) then
            numglo = zi(jnulg + iaux)
            rsolu(iaux + 1) = vecpet(numglo - debglo + 1)
        endif
    enddo
!
    do iaux = 0, nbjoin - 1
        numpro = zi(jnbjoi + iaux + 1)
        if (numpro .ne. -1) then
            call codent(iaux, 'G', chnbjo)
!
            nojoinr = numddl//'.NUMER'//chnbjo(1:3)
            call jeveuo(nojoinr, 'L', jjointr)
            call jelira(nojoinr, 'LONMAX', lgrecep, k8bid)
            nojoine = numddl//'.NUMEE'//chnbjo(1:3)
            call jeveuo(nojoine, 'L', jjointe)
            call jelira(nojoine, 'LONMAX', lgenvo, k8bid)
            ASSERT(lgenvo .gt. 0 .and. lgrecep .gt. 0)
!
            call wkvect('&&CPYSOL.TMP1E', 'V V R', lgenvo, jvaleue)
            call wkvect('&&CPYSOL.TMP1R', 'V V R', lgrecep, jvaleur)
            do jaux = 0, lgenvo - 1
                numloc = zi(jjointe + jaux)
                ASSERT(zi(jprddl + numloc - 1) .eq. rang)
                zr(jvaleue + jaux) = rsolu(numloc)
            enddo
!
            n4e = lgenvo
            n4r = lgrecep
            num4 = iaux
            numpr4 = numpro
            if (rang .lt. numpro) then
                call asmpi_send_r(zr(jvaleue), n4e, numpr4, num4,&
                                  mpicou)
                call asmpi_recv_r(zr(jvaleur), n4r, numpr4, num4,&
                                  mpicou)
            else if (rang.gt.numpro) then
                call asmpi_recv_r(zr(jvaleur), n4r, numpr4, num4,&
                                  mpicou)
                call asmpi_send_r(zr(jvaleue), n4e, numpr4, num4,&
                                  mpicou)
            else
                ASSERT(.false.)
            endif
            do jaux = 0, lgrecep - 1
                numloc = zi(jjointr + jaux)
                ASSERT(zi(jprddl + numloc - 1) .eq. numpro)
                rsolu(numloc) = zr(jvaleur + jaux)
            enddo
            call jedetr('&&CPYSOL.TMP1E')
            call jedetr('&&CPYSOL.TMP1R')
        endif
    enddo

!   RECHERCHE DES ADRESSES DU .PRNO DE .NUME
    call jeveuo(numddl//'.NUME.PRNO', 'E', idprn1)
    call jeveuo(jexatr(numddl//'.NUME.PRNO', 'LONCUM'), 'L', idprn2)
    call jelira(jexnum(numddl//'.NUME.PRNO', 1), 'LONMAX', ntot, k8bid)

!   RECUPERATION DU NOM DU MAILLAGE DANS LE BUT D'OBTENIR LE JOINT
    call jeveuo(numddl//'.NUME.REFN', 'L', jrefn)
    noma = zk24(jrefn)

    call jeveuo(noma//'.DIME', 'L', dime)

!   !!! VERIFIER QU'IL N'Y A PAS DE MACRO-ELTS
!   CALCUL DU NOMBRE D'ENTIERS CODES A PARTIR DE LONMAX
    nec = ntot/zi(dime) - 2
    call jelira(numddl//'.NUME.PRNO', 'NMAXOC', nlili, k8bid)
    do ili = 2, nlili
        call jeexin(jexnum(numddl//'.NUME.PRNO', ili), iret)
        if( iret.ne.0 ) then
            call jenuno(jexnum(numddl//'.NUME.LILI', ili), nomlig)
            join = nomlig//".NBJO"
            call jeexin(join, iret)
            if( iret.eq.0 ) cycle
            call jeveuo(join, 'L', jjoin)
            call jelira(join, 'LONMAX', nbjoin)
            do ijoin = 1, nbjoin
                numpro = zi(jjoin+ijoin-1)
                if( numpro.ne.-1 ) then
                    numpr4 = numpro
                    num4 = ijoin
                    call codent(numpro, 'G', chnbjo)
                    nojoine = nomlig//'.E'//chnbjo
                    nojoinr = nomlig//'.R'//chnbjo

                    call jeexin(nojoine, iret1)
                    if( iret1.ne.0 ) then
                        call jeveuo(nojoine, 'L', jjoine)
                        call jelira(nojoine, 'LONMAX', nbnoee, k8bid)
                        call wkvect('&&CRNUGL.NUM_DDL_GLOB_E', 'V V R', nbnoee, jnujoi1)
                        do jaux = 1, nbnoee
                            numnoe = -zi(jjoine+jaux-1)
                            nddll = zzprno(ili, numnoe, 1)
                            zr(jnujoi1+jaux-1) = rsolu(nddll)
                        enddo
                        n4e = nbnoee
                    endif

                    call jeexin(nojoinr, iret2)
                    if( iret2.ne.0 ) then
                        call jeveuo(nojoinr, 'L', jjoinr)
                        call jelira(nojoinr, 'LONMAX', nbnoer, k8bid)
                        call wkvect('&&CRNUGL.NUM_DDL_GLOB_R', 'V V R', nbnoer, jnujoi2)
                    endif

                    if (rang .lt. numpro) then
                        if( iret1.ne.0 ) then
                            call asmpi_send_r(zr(jnujoi1), n4e, numpr4, num4, mpicou)
                        endif
                        if( iret2.ne.0 ) then
                            call asmpi_recv_r(zr(jnujoi2), n4r, numpr4, num4, mpicou)
                        endif
                    else if (rang.gt.numpro) then
                        if( iret2.ne.0 ) then
                            call asmpi_recv_r(zr(jnujoi2), n4r, numpr4, num4, mpicou)
                        endif
                        if( iret1.ne.0 ) then
                            call asmpi_send_r(zr(jnujoi1), n4e, numpr4, num4, mpicou)
                        endif
                    endif

                    if( iret2.ne.0 ) then
                        do jaux = 1, nbnoer
                            numnoe = -zi(jjoinr+jaux-1)
                            nddll = zzprno(ili, numnoe, 1)
                            rsolu(nddll) = zr(jnujoi2+jaux-1)
                        enddo
                    endif
                    call jedetr('&&CRNUGL.NUM_DDL_GLOB_E')
                    call jedetr('&&CRNUGL.NUM_DDL_GLOB_R')
                endif
            enddo
        endif
    enddo
!
! -- REMISE A L'ECHELLE DES LAGRANGES DANS LA SOLUTION
    call jeveuo(nomat//'.&INT', 'L', lmat)
    call mrconl('MULT', lmat, 0, 'R', rsolu, 1)
    if(ldebug) then
        call jeveuo(numddl//'.NUME.DEEQ', 'L', jdeeq)
        call jeveuo(numddl//'.NUME.REFN', 'L', jrefn)
        noma = zk24(jrefn)
        nonulg = noma//'.NULOGL'
        call jeveuo(nonulg, 'L', jmlogl)
        do iaux = 1, nloc
            if ( zi(jprddl + iaux - 1) .eq. rang ) then
                nuno1 = zi(jdeeq + (iaux - 1) * 2)
                if( nuno1.ne.0 ) nuno1 = zi(jmlogl + nuno1 - 1)+1
                nucmp1 = zi(jdeeq + (iaux - 1) * 2 + 1)
                write(30+rang,*) nuno1,nucmp1,rsolu(iaux)
            endif
        enddo
        flush(30+rang)
    endif

    call jedema()
#endif
!
end subroutine
