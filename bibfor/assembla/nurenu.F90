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

subroutine nurenu(nu, base)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/asmpi_comm_jev.h"
#include "asterfort/asmpi_comm_point.h"
#include "asterfort/asmpi_info.h"
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
    character(len=14) :: nu
    character(len=2) :: base
! person_in_charge: nicolas.sellenet at edf.fr
! ----------------------------------------------------------------------
!  NUME_DDL - RENUMEROTATION POUR MATR_DISTR AVEC PETSC
!  --         ----
! ----------------------------------------------------------------------
!
!   LE BUT DE CETTE ROUTINE EST DE CREER L'OBJET .NUML.NLGP QUI
!    FOURNIT UNE NUMEROTATION GLOBALE CONTIGUE DU PDV PETSC
!
! IN  :
!   NU      K14  NOM DU NUME_DDL
!   BASE    K2   BASE(1:1) : BASE POUR CREER LE NUME_DDL
!                    (SAUF LE PROF_CHNO)
!                BASE(2:2) : BASE POUR CREER LE PROF_CHNO
!
    integer :: rang, nbproc,   neql, iddl, nbrddl, jnbddl
    integer :: iproc, nbddpr,  neqg, jnulg, decals, decald, iaux
    integer ::  njoint, numpro, nbddlj, jjoint,  numddl
    integer :: num
!
    character(len=4) :: chnbjo
    character(len=24) ::  nonbdd, nojoin
    integer, pointer :: tmp(:) => null()
    integer, pointer :: pddl(:) => null()
    integer, pointer :: nequg(:) => null()
    integer, pointer :: nequl(:) => null()
    integer, pointer :: join(:) => null()
    mpi_int :: mrank, msize
    parameter    (nonbdd='&&NUPODD.NBDDL')
!
    call jemarq()
!
    call asmpi_info(rank=mrank, size=msize)
    rang = to_aster_int(mrank)
    nbproc = to_aster_int(msize)
!
    call jeveuo(nu//'.NUML.PDDL', 'L', vi=pddl)
    call jeveuo(nu//'.NUML.NEQU', 'L', vi=nequl)
    call jeveuo(nu//'.NUME.NEQU', 'L', vi=nequg)
    neql=nequl(1)
    neqg=nequg(1)
!
    nbrddl=0
    do 10 iddl = 0, neql-1
        if (pddl(iddl+1) .eq. rang) nbrddl=nbrddl+1
10  end do
!
    call wkvect(nonbdd, 'V V I', nbproc, jnbddl)
    zi(jnbddl+rang)=nbrddl
    call asmpi_comm_jev('MPI_SUM', nonbdd)
    nbddpr=zi(jnbddl)
    do 20 iproc = 1, nbproc-1
        zi(jnbddl+iproc)=zi(jnbddl+iproc)+nbddpr
        nbddpr=zi(jnbddl+iproc)
20  end do
    ASSERT(neqg.eq.nbddpr)
!
    call wkvect(nu//'.NUML.NLGP', base(1:1)//' V I', neql, jnulg)
    decals=0
    if (rang .ne. 0) decals=zi(jnbddl+rang-1)
    call jedetr(nonbdd)
!
    decald=1
    do 30 iddl = 0, neql-1
        if (pddl(iddl+1) .eq. rang) then
            zi(jnulg+iddl)=decals+decald
            decald=decald+1
        endif
30  end do
!
    call jeveuo(nu//'.NUML.JOIN', 'L', vi=join)
    call jelira(nu//'.NUML.JOIN', 'LONMAX', njoint)
!
    do iaux=0,njoint-1
        numpro=join(iaux+1)
        if (numpro .eq. -1) cycle
!
        num=iaux+1
        call codent(num, 'G', chnbjo)
        nojoin=nu//'.NUML.'//chnbjo
        call jeveuo(nojoin, 'L', jjoint)
        call jelira(nojoin, 'LONMAX', nbddlj)
        AS_ALLOCATE(vi=tmp, size=nbddlj)
        if (rang .lt. numpro) then
!           !!! VERIFIER QU'ON EST OK SUR LES NUM GLOBAUX
            do 50, iddl=0,nbddlj-1
                numddl=zi(jjoint+iddl)
                tmp(iddl+1)=zi(jnulg+numddl-1)
50          continue
            call asmpi_comm_point('MPI_SEND', 'I', numpro, iaux, nbval=nbddlj,&
                                  vi=tmp)
        else if (rang.gt.numpro) then
!           !!! VERIFIER QU'ON EST OK SUR LES NUM GLOBAUX
            call asmpi_comm_point('MPI_RECV', 'I', numpro, iaux, nbval=nbddlj,&
                                  vi=tmp)
            do 60, iddl=0,nbddlj-1
                numddl=zi(jjoint+iddl)
                zi(jnulg+numddl-1)=tmp(iddl+1)
60          continue
        else
            ASSERT(.false.)
        endif
        AS_DEALLOCATE(vi=tmp)
    end do
!
    call jedema()
!
end subroutine
