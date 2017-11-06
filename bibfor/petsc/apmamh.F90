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

subroutine apmamh(kptsc)
!
#include "asterf_types.h"
#include "asterf_petsc.h"
!
!
! person_in_charge: natacha.bereux at edf.fr
! aslint:disable=C1308

use petsc_data_module

    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelibe.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/wkvect.h"
#include "asterfort/asmpi_info.h"
    integer :: kptsc
!----------------------------------------------------------------
!
!  REMPLISSAGE DE LA MATRICE PETSC (INSTANCE NUMERO KPTSC)
!
!  En entrée : la matrice ASTER complète
!  En sortie : les valeurs de la matrice PETSc sont remplies à
!              partir des valeurs de la matrice ASTER
!
!  Rq :
!  - la matrice PETSc n'a pas de stockage symétrique: que la matrice
!    ASTER soit symétrique ou non, la matrice PETSc est stockée en entier
!    (termes non-nuls).
!  - dans le mode "matrice complète" (MC) tous les processeurs connaissent
!    toute la matrice ASTER. Chaque processeur initialise sa partie de la
!    matrice PETSc (ie le bloc de lignes A(low:high-1))
!----------------------------------------------------------------
!
#ifdef _HAVE_PETSC
!
!     VARIABLES LOCALES
    integer :: nsmdi, nsmhc, nz, nvalm, nlong
    integer :: jsmdi, jsmhc, jdxi1, jdxi2, jdval1, jdval2, jvalm, jvalm2
    integer :: k, iligl, jcoll, nzdeb, nzfin, nuno1, nucmp1, nuno2, nbproc
    integer :: jcolg, iligg, jnugll, nucmp2, procol, jprddl
    integer :: jnequ, nloc, nglo, jdeeq, jrefn, prolig, rang, ibid, jmlogl
    integer(kind=4) :: tmp, jterm, un, jcolg4(1), iterm
    mpi_int :: mrank, msize
!
    character(len=24) :: nonulg
    character(len=19) :: nomat, nosolv
    character(len=16) :: idxi1, idxi2, trans1, trans2
    character(len=14) :: nonu
    character(len=8) :: noma
    character(len=4) :: kbid
!
    logical :: lmnsy
!
    real(kind=8) :: valm
!
    parameter (idxi1 ='&&APMAMC.IDXI1__')
    parameter (idxi2 ='&&APMAMC.IDXI2__')
    parameter (trans1='&&APMAMC.TRANS1_')
    parameter (trans2='&&APMAMC.TRANS2_')
!
!----------------------------------------------------------------
!     Variables PETSc
    PetscInt :: low, high, neql, neqg, ierr
    Mat :: a
!----------------------------------------------------------------
    call jemarq()
!
!   -- LECTURE DU COMMUN
    nomat = nomat_courant
    nonu = nonu_courant
    nosolv = nosols(kptsc)
    a = ap(kptsc)
!
    call jeveuo(nonu//'.SMOS.SMDI', 'L', jsmdi)
    call jelira(nonu//'.SMOS.SMDI', 'LONMAX', nsmdi)
    call jeveuo(nonu//'.SMOS.SMHC', 'L', jsmhc)
    call jelira(nonu//'.SMOS.SMHC', 'LONMAX', nsmhc)
    call jeveuo(nonu//'.NUME.NEQU', 'L', jnequ)
    call jeveuo(nonu//'.NUME.NULG', 'L', jnugll)
    call jeveuo(nonu//'.NUME.DEEQ', 'L', jdeeq)
    call jeveuo(nonu//'.NUME.REFN', 'L', jrefn)
    call jeveuo(nonu//'.NUME.PDDL', 'L', jprddl)
    call asmpi_info(rank = mrank, size = msize)
    rang = to_aster_int(mrank)
    nbproc = to_aster_int(msize)
    noma = zk24(jrefn)
    nonulg = noma//'.NULOGL'
    call jeveuo(nonulg, 'L', jmlogl)
    nloc = zi(jnequ)
    nglo = zi(jnequ+1)
    neql = nloc
    neqg = nglo
    nz = zi(jsmdi-1+nloc)
!
    call jelira(nomat//'.VALM', 'NMAXOC', nvalm)
    if (nvalm .eq. 1) then
        lmnsy=.false.
    else if (nvalm.eq.2) then
        ASSERT(.false.)
        lmnsy=.true.
    else
        ASSERT(.false.)
    endif
!
    call jeveuo(jexnum(nomat//'.VALM', 1), 'L', jvalm)
    call jelira(jexnum(nomat//'.VALM', 1), 'LONMAX', nlong)
    ASSERT(nlong.eq.nz)
    if (lmnsy) then
        call jeveuo(jexnum(nomat//'.VALM', 2), 'L', jvalm2)
        call jelira(jexnum(nomat//'.VALM', 2), 'LONMAX', nlong)
        ASSERT(nlong.eq.nz)
    endif
!
!     low donne la premiere ligne stockee localement
!     high donne la premiere ligne stockee par le processus (rang+1)
!     ATTENTION ces indices commencent a zero (convention C de PETSc)
    call MatGetOwnershipRange(a, low, high, ierr)
    ASSERT(ierr.eq.0)
!
    call wkvect(idxi1, 'V V S', nloc, jdxi1)
    call wkvect(idxi2, 'V V S', nloc, jdxi2)
    call wkvect(trans1, 'V V R', nloc, jdval1)
    call wkvect(trans2, 'V V R', nloc, jdval2)
!
    iterm = 0
    jterm = 0
!
!   Cas ou on possede le premier bloc de lignes
    if ( zi(jprddl) .eq. rang ) then
! nsellenet
!         iligg = zi(jnugll)
!         jcolg = zi(jnugll)
!         nuno1 = 0
!         if( zi(jdeeq).gt.0 ) nuno1 = zi(jmlogl + zi(jdeeq) - 1) + 1
!         nucmp1 = zi(jdeeq + 1)
!         nuno2 = 0
!         if( zi(jdeeq).gt.0 ) nuno2 = zi(jmlogl + zi(jdeeq) - 1) + 1
!         nucmp2 = zi(jdeeq + 1)
!!         write(12+rang, 1000) nuno2, nucmp2, nuno1, nucmp1, jcolg, iligg, zr(jvalm)
!         write(12+rang, 2000) nuno2, nucmp2, nuno1, nucmp1, zr(jvalm)
        write(12, *) "i,j", zi(jnugll), zi(jnugll)
! nsellenet
        tmp = zi(jnugll)
        call MatSetValue(a, tmp, tmp, zr(jvalm),&
                         INSERT_VALUES, ierr)
    endif
!
!   On commence par s'occuper du nombres de NZ par ligne
!   dans le bloc diagonal
    call MatSetOption(a, MAT_NEW_NONZERO_ALLOCATION_ERR, PETSC_FALSE, ierr)
    un = 1
    do jcoll = 2, nloc
        nzdeb = zi(jsmdi + jcoll - 2) + 1
        nzfin = zi(jsmdi + jcoll - 1)
        procol = zi(jprddl + jcoll - 1)
        jcolg = zi(jnugll + jcoll - 1)
        nuno2 = 0
        if( zi(jdeeq + (jcoll - 1) * 2).gt.0 ) then
            nuno2 = zi(jmlogl + zi(jdeeq + (jcoll - 1) * 2) - 1) + 1
        endif
        do k = nzdeb, nzfin
            iligl = zi4(jsmhc + k - 1)
            prolig = zi(jprddl + iligl - 1)
            iligg = zi(jnugll + iligl - 1)
            valm = zr(jvalm + k - 1)
            nuno1 = 0
            if( zi(jdeeq + (iligl - 1) * 2).gt.0 ) then
                nuno1 = zi(jmlogl + zi(jdeeq + (iligl - 1) * 2) - 1) + 1
            endif
! nsellenet
!         nucmp1 = zi(jdeeq + (iligl - 1) * 2 + 1)
!         nucmp2 = zi(jdeeq + (jcoll - 1) * 2 + 1)
!         if( rang.eq.0.and.nuno1.eq.4.and.nucmp1.eq.1.and.nuno2.eq.0.and.nucmp2.eq.0 ) then
!            write(6,*)'Ici', valm
!         endif
! nsellenet
            if ( prolig .eq. rang ) then
                jterm = jterm + 1
                zr(jdval2 + jterm - 1) = valm
                zi4(jdxi2 + jterm - 1) = iligg
! nsellenet
        write(12, *) "i,j", iligg, jcolg
! nsellenet
                if ( procol .eq. rang ) then
! nsellenet
!!         write(12+rang, 1000) nuno2, nucmp2, nuno1, nucmp1, jcolg, iligg, valm
!         write(12+rang, 2000) nuno2, nucmp2, nuno1, nucmp1, valm
! nsellenet
                    if ( iligg .ne. jcolg ) then
                        iterm = iterm + 1
                        zr(jdval1 + iterm - 1) = valm
                        zi4(jdxi1 + iterm - 1) = iligg
! nsellenet
!!         write(12+rang, 1000) nuno1, nucmp1, nuno2, nucmp2, jcolg, iligg, valm
!         write(12+rang, 2000) nuno1, nucmp1, nuno2, nucmp2, valm
        write(12, *) "i,j", jcolg, iligg
! nsellenet
                    endif
                else
                    if( nuno1.eq.0 .or. nuno2.eq.0 ) then
                        iterm = iterm + 1
                        zr(jdval1 + iterm - 1) = valm
                        zi4(jdxi1 + iterm - 1) = iligg
! nsellenet
        write(12, *) "i,j", jcolg, iligg
! nsellenet
                    endif
! nsellenet
!!         write(12+rang, 1000) nuno2, nucmp2, nuno1, nucmp1, jcolg, iligg, valm
!         write(12+rang, 2000) nuno2, nucmp2, nuno1, nucmp1, valm
!                    if( nuno1.eq.0 .or. nuno2.eq.0 ) then
!         write(12+rang, 2000) nuno1, nucmp1, nuno2, nucmp2, valm
!                    endif
! nsellenet
                endif
            else if ( procol .eq. rang ) then
                    if( nuno1.eq.0 .or. nuno2.eq.0 ) then
                        jterm = jterm + 1
                        zr(jdval2 + jterm - 1) = valm
                        zi4(jdxi2 + jterm - 1) = iligg
! nsellenet
        write(12, *) "i,j", iligg, jcolg
! nsellenet
                    endif
! nsellenet
!!         write(12+rang, 1000) nuno1, nucmp1, nuno2, nucmp2, jcolg, iligg, valm
!         write(12+rang, 2000) nuno1, nucmp1, nuno2, nucmp2, valm
!                    if( nuno1.eq.0 .or. nuno2.eq.0 ) then
!         write(12+rang, 2000) nuno2, nucmp2, nuno1, nucmp1, valm
!                    endif
! nsellenet
                iterm = iterm + 1
                zr(jdval1 + iterm - 1) = valm
                zi4(jdxi1 + iterm - 1) = iligg
! nsellenet
        write(12, *) "i,j", jcolg, iligg
! nsellenet
            else
                if( nuno1.eq.0 .or. nuno2.eq.0 ) then
                    jterm = jterm + 1
                    zr(jdval2 + jterm - 1) = valm
                    zi4(jdxi2 + jterm - 1) = iligg
! nsellenet
        write(12, *) "i,j", iligg, jcolg
! nsellenet
                    if( iligg.ne.jcolg ) then
                        iterm = iterm + 1
                        zr(jdval1 + iterm - 1) = valm
                        zi4(jdxi1 + iterm - 1) = iligg
! nsellenet
        write(12, *) "i,j", jcolg, iligg
! nsellenet
                    endif
                endif
! nsellenet
!            else
!                if( nuno1.eq.0 .or. nuno2.eq.0 ) then
!         write(12+rang, 2000) nuno1, nucmp1, nuno2, nucmp2, valm
!!         write(12+rang, 3000) nuno1, nucmp1, nuno2, nucmp2, valm
!                    if( iligg.ne.jcolg ) then
!         write(12+rang, 2000) nuno2, nucmp2, nuno1, nucmp1, valm
!!         write(12+rang, 3000) nuno2, nucmp2, nuno1, nucmp1, valm
!                    endif
!                endif
! nsellenet
            endif
        end do
        jcolg4(1) = jcolg
        call MatSetValues(a, jterm, zi4(jdxi2), un, jcolg4,&
                          zr(jdval2), INSERT_VALUES, ierr)
        call MatSetValues(a, un, jcolg4, iterm, zi4(jdxi1),&
                          zr(jdval1), INSERT_VALUES, ierr)
        iterm = 0
        jterm = 0
    end do
!
    call jelibe(nonu//'.SMOS.SMDI')
    call jelibe(nonu//'.SMOS.SMHC')
    call jelibe(jexnum(nomat//'.VALM', 1))
    if (lmnsy) call jelibe(jexnum(nomat//'.VALM', 2))
!    1000 format(i6,' ',i6,' ',i6,' ',i6,' ',i6,' ',i6,' ',1pe20.13)
!    2000 format(i6,' ',i6,' ',i6,' ',i6,' ',1pe20.13)
!    3000 format('ici',i6,' ',i6,' ',i6,' ',i6,' ',1pe20.13)
!
!     ON N'OUBLIE PAS DE DETRUIRE LES TABLEAUX
!     APRES AVOIR ALLOUE CORRECTEMENT
    call jedetr(idxi1)
    call jedetr(idxi2)
    call jedetr(trans1)
    call jedetr(trans2)
!
    call jedema()
!
#endif
!
end subroutine
