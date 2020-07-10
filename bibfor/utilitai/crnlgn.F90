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

subroutine crnlgn(numddl)
    implicit none
#include "asterf_config.h"
#include "asterf.h"
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jeexin.h"
#include "asterfort/jexatr.h"
#include "asterfort/jexnum.h"
#include "asterfort/wkvect.h"
#include "asterfort/asmpi_info.h"
#include "asterc/asmpi_bcast_i.h"
#include "asterc/asmpi_comm.h"
    character(len=14) :: numddl

#ifdef _USE_MPI
#include "mpif.h"
!
    integer :: ili, nunoel, l, idprn1, idprn2, ntot, lonmax, nbno_prno, jdeeq
    integer :: nbddll, iaux, jposdd, jnequ, jnoext, ino, jnugll, iret, nbcmp
    integer :: numero_noeud, numero_cmp, rang, nbproc, jrefn, jown, jprno
    integer :: jnbddl, nec, numglo, dime, jmult, jmult2, nbddl_lag, jmdlag
    integer :: pos, jdelg, jmults, jmult1, nuno, jmlogl
    integer(kind=4) :: un, iaux4
    mpi_int :: mrank, msize, mpicou
    integer, pointer :: v_noext(:) => null()
!
    character(len=4) :: chnbjo
    character(len=8) :: k8bid, noma
    character(len=19) :: nomlig
    character(len=24) :: owner, mult1, mult2, nonulg
!
!----------------------------------------------------------------------
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
#define zzprno(ili,nunoel,l)  zi(idprn1-1+zi(idprn2+ili-1)+ (nunoel-1)* (nec+2)+l-1)
!
    call jemarq()
    call asmpi_comm('GET', mpicou)
!
    call asmpi_info(rank = mrank, size = msize)
    rang = to_aster_int(mrank)
    nbproc = to_aster_int(msize)
!
    call jeveuo(numddl//'.NUME.REFN', 'L', jrefn)
    noma = zk24(jrefn)
!
    call jeveuo(noma//'.DIME', 'L', dime)

!   !!! VERIFIER QU'IL N'Y A PAS DE MACRO-ELTS
!   CALCUL DU NOMBRE D'ENTIERS CODES A PARTIR DE LONMAX
    call jelira(jexnum(numddl//'.NUME.PRNO', 1), 'LONMAX', ntot, k8bid)
    nec = ntot/zi(dime) - 2
!
    call jeveuo(noma//'.NOEX', 'L', vi=v_noext)
!
    call jeveuo(numddl//'.NUME.DEEQ', 'L', jdeeq)
    call jeveuo(numddl//'.NUME.NEQU', 'L', jnequ)
    call jeveuo(numddl//'.NUME.DELG', 'L', jdelg)
    nbddll = zi(jnequ)

!   Creation de la numerotation globale
    call wkvect(numddl//'.NUME.NULG', 'G V I', nbddll, jnugll)
    call wkvect(numddl//'.NUME.PDDL', 'G V I', nbddll, jposdd)
    call wkvect('&&CRNUGL.MULT_DDL', 'V V I', nbddll, jmult)
    call wkvect('&&CRNUGL.MULT_DDL2', 'V V I', nbddll, jmults)
!
! --- Il ne faut pas changer la valeur d'initialisation car on s'en sert pour detecter
!     qui est propriétaire d'un noeud (-1 si pas propriétaire)
    do iaux = 0, nbddll - 1
        zi(jnugll + iaux) = -1
        zi(jposdd + iaux) = -1
    end do
    numglo = 0
    do iaux = 0, nbddll - 1
        numero_noeud = zi(jdeeq + iaux*2)
        numero_cmp = zi(jdeeq + iaux*2 + 1)
        if( numero_noeud.gt.0 .and. numero_cmp.gt.0 ) then
            if (v_noext(numero_noeud) == rang) then
                zi(jnugll + iaux) = numglo
                zi(jposdd + iaux) = rang
                numglo = numglo + 1
            endif
        endif
    end do
!
!   RECHERCHE DES ADRESSES DU .PRNO DE .NUME
    call jeveuo(numddl//'.NUME.PRNO', 'E', idprn1)
    call jeveuo(jexatr(numddl//'.NUME.PRNO', 'LONCUM'), 'L', idprn2)
    call jelira(numddl//'.NUME.PRNO', 'NMAXOC', ntot, k8bid)
!
    nbddl_lag = 0
    do ili = 2, ntot
        call jeexin(jexnum(numddl//'.NUME.PRNO', ili), iret)
        if( iret.ne.0 ) then
            call jelira(jexnum(numddl//'.NUME.PRNO', ili), 'LONMAX', lonmax)
            call jeveuo(jexnum(numddl//'.NUME.PRNO', ili), 'L', jprno)
            nbno_prno = lonmax/(nec+2)
            call jenuno(jexnum(numddl//'.NUME.LILI', ili), nomlig)
            owner = nomlig//'.PNOE'
            mult1 = nomlig//'.MULT'
            mult2 = nomlig//'.MUL2'
            call jeveuo(owner, 'L', jown)
            call jeveuo(mult1, 'L', jmult1)
            call jeveuo(mult2, 'L', jmult2)
            do ino = 1, nbno_prno
                if( zi(jown+ino-1).eq.rang ) then
                    iaux = zzprno(ili, ino, 1)-1
                    nbcmp = zzprno(ili, ino, 2)
                    ASSERT(nbcmp.eq.1)
                    zi(jnugll + iaux) = numglo
                    zi(jposdd + iaux) = rang
                    zi(jmult + iaux) = zi(jmult2+ino-1)
                    zi(jmults + iaux) = zi(jmult1+ino-1)
                    nbddl_lag = nbddl_lag + 1
                    numglo = numglo + 1
                endif
            enddo
        endif
    enddo
!
    call wkvect('&&CRNULG.NBDDLL', 'V V I', nbproc, jnbddl)
    zi(jnbddl + rang) = numglo
!
!   ON CHERCHE LE NOMBRE TOTAL DE DDL AINSI QUE LE DECALAGE
!   DE NUMEROTATION A APPLIQUER POUR CHAQUE PROC
    un = 1
    do iaux = 0, nbproc - 1
        iaux4 = iaux
        call asmpi_bcast_i(zi(jnbddl + iaux), un, iaux4, mpicou)
        if (iaux .ne. 0) then
            zi(jnbddl + iaux) = zi(jnbddl + iaux) + zi(jnbddl + iaux - 1)
        endif
    end do
    zi(jnequ + 1) = zi(jnbddl + nbproc - 1)
    do iaux = nbproc - 1, 1, -1
        zi(jnbddl + iaux) = zi(jnbddl + iaux - 1)
    end do
    zi(jnbddl) = 0
    jmdlag = 0
    if( nbddl_lag.ne.0 ) then
        call wkvect(numddl//'.NUME.MDLA', 'G V I', 3*nbddl_lag, jmdlag)
    endif

    pos = 0
!   Decalage de la numerotation
    do iaux = 0, nbddll - 1
        if ( zi(jdelg + iaux) .ne. 0 .and. zi(jposdd + iaux) .eq. rang ) then
            zi(jmdlag + 3*pos) = iaux+1
            zi(jmdlag + 3*pos + 1) = zi(jmult + iaux)
            zi(jmdlag + 3*pos + 2) = zi(jmults + iaux)
            pos = pos + 1
        endif
        if ( zi(jnugll + iaux) .ne. -1 ) then
            zi(jnugll + iaux) = zi(jnugll + iaux) + zi(jnbddl + rang)
        endif
    end do
    ASSERT(nbddl_lag.eq.pos)
!
! --- Pour debuggage en hpc
    if(ASTER_FALSE) then
        nonulg = noma//'.NULOGL'
        call jeveuo(nonulg, 'L', jmlogl)
        do iaux = 0, nbddll - 1
            nuno = zi(jdeeq + iaux*2)
            if(nuno.ne.0) nuno = zi(jmlogl + nuno - 1) + 1
! numero ddl local, numéro noeud local, numéro noeud global, num composante du noeud,
!            num ddl global, num proc proprio
            write(120+rang, *) iaux, zi(jdeeq + iaux*2), nuno , zi(jdeeq + iaux*2 + 1), &
             zi(jnugll + iaux), zi(jposdd + iaux)
        end do
        flush(120+rang)
    end if
!
    call jedema()
#endif
!
end subroutine
