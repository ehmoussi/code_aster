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

! This file is part of code_aster.
!
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------

subroutine apalmh(kptsc)
!
#include "asterf_types.h"
#include "asterf_petsc.h"
!
!
! person_in_charge: natacha.bereux at edf.fr
! aslint:disable=C1308
use aster_petsc_module
use petsc_data_module
    implicit none

#include "jeveux.h"
#include "asterc/loisem.h"
#include "asterfort/apbloc.h"
#include "asterfort/assert.h"
#include "asterc/asmpi_comm.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"
#include "asterfort/asmpi_info.h"
    integer :: kptsc
!----------------------------------------------------------------
!
!  CREATION DE LA MATRICE PETSC (INSTANCE NUMERO KPTSC)
!  PREALLOCATION DANS LE CAS GENERAL
!
!----------------------------------------------------------------
!
#ifdef _HAVE_PETSC
!
!     VARIABLES LOCALES
    integer :: nsmdi, nsmhc, ndprop, nz, bs, numpro, iaux, jjoint
    integer :: jsmdi, jsmhc, jidxd, procol, prolig, lgenvo, jvaleu
    integer :: i, k, nzdeb, nzfin, jidxo, jaux, jdelg, jmdla
    integer :: jnequ, iligl, jcoll, iligg, jcolg, numloc, numglo
    integer :: rang, nbproc, jprddl, jnugll, nloc, nglo, jidxdc
    integer :: nuno1, nuno2, num_ddl_max, imult, ipos, ibid
    integer :: num_ddl_min, jslvi, tbloc, iret, nblag, jdeeq
    integer :: imults
!
    integer(kind=4) :: mpicou
    mpi_int :: mrank, msize
!
    character(len=19) :: nomat, nosolv
    character(len=16) :: idxo, idxd
    character(len=14) :: nonu
    character(len=4) :: kbid, chnbjo
    character(len=8) :: k8bid
!
    parameter   (idxo  ='&&APALMC.IDXO___')
    parameter   (idxd  ='&&APALMC.IDXD___')
!
!----------------------------------------------------------------
!     Variables PETSc
    PetscInt :: low, high, neql, neqg, ierr, unused_nz
    PetscScalar :: xx(1)
    PetscOffset :: xidx
    Mat :: a
!----------------------------------------------------------------
    call jemarq()
!
!   -- COMMUNICATEUR MPI DE TRAVAIL
    call asmpi_comm('GET', mpicou)
!
!     -- LECTURE DU COMMUN
    nomat = nomat_courant
    nonu = nonu_courant
    nosolv = nosols(kptsc)
!
    call jeveuo(nonu//'.SMOS.SMDI', 'L', jsmdi)
    call jelira(nonu//'.SMOS.SMDI', 'LONMAX', nsmdi)
    call jeveuo(nonu//'.SMOS.SMHC', 'L', jsmhc)
    call jelira(nonu//'.SMOS.SMHC', 'LONMAX', nsmhc)
    nz = zi(jsmdi-1+nsmdi)
!
    call apbloc(kptsc)
    bs=tblocs(kptsc)

    ASSERT(bs.ge.1)

    call jeveuo(nonu//'.NUME.NEQU', 'L', jnequ)
    call jeveuo(nonu//'.NUME.NULG', 'L', jnugll)
    call jeveuo(nonu//'.NUME.PDDL', 'L', jprddl)
    call jeveuo(nonu//'.NUME.DELG', 'L', jdelg)
    call jeveuo(nonu//'.NUME.DEEQ', 'L', jdeeq)
    nloc = zi(jnequ)
    nglo = zi(jnequ+1)
    neqg = nglo
    neql = nloc

!
!     -- RECUPERE LE RANG DU PROCESSUS ET LE NB DE PROCS
    call asmpi_info(rank=mrank, size=msize)
    rang = to_aster_int(mrank)
    nbproc = to_aster_int(msize)
!
    ndprop = 0
!
    num_ddl_max = 0
    num_ddl_min = 999999999
    do jcoll = 1, nloc
        procol = zi(jprddl - 1 + jcoll)
        if (procol .eq. rang) then
            ndprop = ndprop + 1
            num_ddl_max = max(num_ddl_max, zi(jnugll + jcoll -1))
            num_ddl_min = min(num_ddl_min, zi(jnugll + jcoll -1))
        endif
    end do

    call MatCreate(mpicou, a, ierr)
    ASSERT(ierr.eq.0)
    call MatSetSizes(a, to_petsc_int(ndprop), to_petsc_int(ndprop), &
                     to_petsc_int(neqg), to_petsc_int(neqg),&
                     ierr)
    ASSERT(ierr.eq.0)
!
#ifndef ASTER_PETSC_VERSION_LEQ_32
!   AVEC PETSc >= 3.3
!   IL FAUT APPELER MATSETBLOCKSIZE *AVANT* MAT*SETPREALLOCATION
    call MatSetBlockSize(a, to_petsc_int(bs), ierr)
    ASSERT(ierr.eq.0)
#endif

    call MatSetType(a, MATMPIAIJ, ierr)
    ASSERT(ierr.eq.0)
    low=num_ddl_min
    high=num_ddl_max+1
!
    call wkvect(idxd, 'V V S', ndprop, jidxd)
    call wkvect(idxo, 'V V S', ndprop, jidxo)

    jcolg = zi(jnugll)
    if (zi(jprddl) .eq. rang) then
        zi4(jidxd + jcolg - low) = zi4(jidxd + jcolg - low) + 1
    endif
!
!   On commence par s'occuper du nombre de NZ par ligne
!   dans le bloc diagonal
    do jcoll = 2, nloc
        nzdeb = zi(jsmdi + jcoll - 2) + 1
        nzfin = zi(jsmdi + jcoll - 1)
        procol = zi(jprddl + jcoll - 1)
        jcolg = zi(jnugll + jcoll - 1)
        nuno2 = 0
        if( zi(jdeeq + (jcoll - 1) * 2).gt.0 ) then
            nuno2 = 1
        endif
        do k = nzdeb, nzfin
            iligl = zi4(jsmhc + k - 1)
            prolig = zi(jprddl + iligl - 1)
            iligg = zi(jnugll + iligl - 1)
            nuno1 = 0
            if( zi(jdeeq + (iligl - 1) * 2).gt.0 ) then
                nuno1 = 1
            endif
            if (procol .eq. rang .and. prolig .eq. rang) then
                zi4(jidxd + iligg - low) = zi4(jidxd + iligg - low) + 1
                if (iligg .ne. jcolg) then
                    zi4(jidxd + jcolg - low) = zi4(jidxd + jcolg - low) + 1
                endif
            else if (procol .ne. rang .and. prolig .eq. rang) then
                zi4(jidxo + iligg - low) = zi4(jidxo + iligg - low) + 1
            else if (procol .eq. rang .and. prolig .ne. rang) then
                zi4(jidxo + jcolg - low) = zi4(jidxo + jcolg - low) + 1
            endif
        end do
    end do
!
    call jeexin(nonu//'.NUME.MDLA', iret)
    jmdla = 0
    nblag = 0
    if( iret.ne.0 ) then
        call jeveuo(nonu//'.NUME.MDLA', 'L', jmdla)
        call jelira(nonu//'.NUME.MDLA', 'LONMAX', nblag)
        nblag = nblag/3
        do ipos = 0, nblag-1
            jcoll = zi(jmdla + ipos*3)
            imult = zi(jmdla + ipos*3 + 1)
            imults = zi(jmdla + ipos*3 + 2)-imult
            jcolg = zi(jnugll + jcoll - 1)
!           Le but ici est de rajouter juste le bon nombre de termes
!           On utilise le nombre de fois qu'apparaissent les noeuds de Lagrange
!           dans des mailles tardives (sur tous les procs et sur les autres procs
!           que le proc courant)
!           On suppose qu'un ddl de Lagrange sera connecte aux autres ddl de la
!           même maniere que sur le proc qui les possede
!           C'est pour cette raison qu'on utilise zi4(jidxd + jcolg - low)
!           divise par le nombre de fois qu'apparait un noeud de Lagrange sur le
!           proc courant
            ibid = (zi4(jidxd + jcolg - low)/imults)*(imult)
            zi4(jidxo + jcolg - low) = zi4(jidxo + jcolg - low) + ibid
        enddo
    endif

    unused_nz = -1
    call MatMPIAIJSetPreallocation(a, unused_nz, zi4(jidxd),&
                                   unused_nz, zi4(jidxo), ierr)
    ASSERT(ierr.eq.0)
!
#ifdef ASTER_PETSC_VERSION_LEQ_32
!      LE BS DOIT ABSOLUMENT ETRE DEFINI ICI
    call MatSetBlockSize(a, to_petsc_int(bs), ierr)
    ASSERT(ierr.eq.0)
!   RQ : A PARTIR DE LA VERSION V 3.3 IL DOIT PRECEDER LA PREALLOCATION
#endif
!
    ap(kptsc)=a


    1000 format(i6,' ',i6,' ',i6,' ',i6,' ',i6,' ',i6,' ',1pe20.13)
!
    call jedetr(idxd)
    call jedetr(idxo)
!
    call jedema()
!
#else
    integer :: idummy
    idummy = kptsc
#endif
!
end subroutine
