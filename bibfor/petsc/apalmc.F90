! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine apalmc(kptsc)
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
#include "asterc/asmpi_comm.h"
#include "asterfort/apbloc.h"
#include "asterfort/asmpi_info.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/wkvect.h"
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
    integer :: rang, nbproc
    integer :: nsmdi, nsmhc, nz, bs, nblloc2
    integer :: jidxd, jidxo
    integer :: i, k, ilig, jcol1,jcol2,nbo, nbd, nzdeb, nzfin, nbterm
    PetscInt :: mm 
    mpi_int :: mpicou
    integer, pointer :: smdi(:) => null()
    integer(kind=4), pointer :: smhc(:) => null()
!
    character(len=19) :: nomat, nosolv
    character(len=16) :: idxo, idxd
    character(len=14) :: nonu
!
    parameter   (idxo  ='&&APALMC.IDXO___')
    parameter   (idxd  ='&&APALMC.IDXD___')
!
!----------------------------------------------------------------
!     Variables PETSc
    PetscInt :: low2, high2, low1, high1, unused_nz
    PetscErrorCode ::  ierr
    integer :: neq
    Vec :: vtmp
    Mat :: a
    mpi_int :: mrank, msize
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
    call jeveuo(nonu//'.SMOS.SMDI', 'L', vi=smdi)
    call jelira(nonu//'.SMOS.SMDI', 'LONMAX', nsmdi)
    call jeveuo(nonu//'.SMOS.SMHC', 'L', vi4=smhc)
    call jelira(nonu//'.SMOS.SMHC', 'LONMAX', nsmhc)
    neq = nsmdi
    nz = smdi(neq)
!
    call apbloc(kptsc)
    bs=tblocs(kptsc)

    ASSERT(bs.ge.1)
    ASSERT(mod(neq,bs).eq.0)

!
!     -- RECUPERE LE RANG DU PROCESSUS ET LE NB DE PROCS
    call asmpi_info(rank=mrank, size=msize)
    rang = to_aster_int(mrank)
    nbproc = to_aster_int(msize)
!
!     low2  DONNE LA PREMIERE LIGNE STOCKEE LOCALEMENT
!     high2 DONNE LA PREMIERE LIGNE STOCKEE PAR LE PROCESSUS DE (RANG+1)
!     *ATTENTION* CES INDICES COMMENCENT A ZERO (CONVENTION C DE PETSc)
!
!     ON EST OBLIGE DE PASSER PAR UN VECTEUR TEMPORAIRE CONSTRUIT
!     PAR MORCEAUX POUR OBTENIR LE BON DECOUPAGE PAR BLOC
    call VecCreate(mpicou, vtmp, ierr)
    ASSERT(ierr.eq.0)
    call VecSetBlockSize(vtmp, to_petsc_int(bs), ierr)
    ASSERT(ierr.eq.0)
    call VecSetSizes(vtmp, PETSC_DECIDE, to_petsc_int(neq), ierr)
    ASSERT(ierr.eq.0)
    call VecSetType(vtmp, VECMPI, ierr)
    ASSERT(ierr.eq.0)
!
    call VecGetOwnershipRange(vtmp, low2, high2, ierr)
    ASSERT(ierr.eq.0)
    call VecDestroy(vtmp, ierr)
    ASSERT(ierr.eq.0)

!   -- NB DE LIGNES QUE L'ON STOCKE LOCALEMENT
    nblloc2 = high2 - low2

!   -- CES DEUX VECTEURS SONT LES D_NNZ ET O_NNZ A PASSER A PETSc
    call wkvect(idxo, 'V V S', nblloc2, jidxo)
    call wkvect(idxd, 'V V S', nblloc2, jidxd)



!   -- On commence par s'occuper du nombre de nz par ligne dans le bloc diagonal
!      Indices C : jcol2
!      Indices F : jcol1, ilig
!   -----------------------------------------------------------------------------
    do jcol2 = low2, high2-1
       jcol1=jcol2+1
       nbo = 0
       nbd = 0
       if (jcol1.eq.1) then
           nzdeb = 1
       else
           ASSERT(jcol1.ge.2)
           nzdeb = smdi(jcol1-1) + 1
       endif
       nzfin = smdi(jcol1)
       do k = nzdeb, nzfin
           ilig = smhc(k)
           if (ilig .lt. (low2+1)) then
               nbo = nbo + 1
           else
               nbd = nbd + 1
               zi4(jidxd-1+(ilig-low2)) = zi4(jidxd-1+(ilig-low2)) + 1
           endif
       end do
       zi4(jidxd-1+(jcol2+1-low2)) = zi4(jidxd-1+(jcol2+1-low2)) + nbd - 1
       zi4(jidxo-1+(jcol2+1-low2)) = zi4(jidxo-1+(jcol2+1-low2)) + nbo
    end do
!   -- Ensuite on complete le tableau du bloc hors diagonal
!      Indices C : jcol2
!      Indices F : jcol1, ilig
!   ---------------------------------------------------------
    do jcol2 = high2, neq-1
        jcol1= jcol2+1
        ASSERT(jcol1.ge.2)
        nzdeb = smdi(jcol1-1) + 1
        nzfin = smdi(jcol1)
        do k = nzdeb, nzfin
            ilig = smhc(k)
            if (ilig .lt. (low2+1)) then
                continue
            else if (ilig.le.high2) then
                zi4(jidxo-1+(ilig-low2)) = zi4(jidxo-1+(ilig-low2)) + 1
            else
                exit
            endif
        end do
    end do
!
    call MatCreate(mpicou, a, ierr)
    ASSERT(ierr.eq.0)
    call MatSetSizes(a, to_petsc_int(nblloc2), to_petsc_int(nblloc2), &
                     to_petsc_int(neq), to_petsc_int(neq),&
                     ierr)
    ASSERT(ierr.eq.0)
!
    call MatSetBlockSize(a, to_petsc_int(bs), ierr)
    ASSERT(ierr.eq.0)

    if (nbproc .eq. 1) then
        call MatSetType(a, MATSEQAIJ, ierr)
        ASSERT(ierr.eq.0)
        mm = to_petsc_int(nblloc2)
        unused_nz = -1
        call MatSeqAIJSetPreallocation(a, unused_nz, zi4(jidxd-1+1:jidxd-1+mm), ierr)
        ASSERT(ierr.eq.0)
    else
        call MatSetType(a, MATMPIAIJ, ierr)
        ASSERT(ierr.eq.0)
        mm = to_petsc_int(nblloc2)
        unused_nz = -1
        call MatMPIAIJSetPreallocation(a, unused_nz, zi4(jidxd-1+1:jidxd-1+mm),&
                                       unused_nz, zi4(jidxo-1+1:jidxd-1+mm), ierr)
        ASSERT(ierr.eq.0)
    endif
!
    ap(kptsc)=a


!   -- menage :
!   -----------
    call jedetr(idxo)
    call jedetr(idxd)
    call jedema()
!
#else
    integer :: idummy
    idummy = kptsc
#endif
!
end subroutine
