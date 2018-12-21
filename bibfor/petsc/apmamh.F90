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

subroutine apmamh(kptsc)
!
#include "asterf_types.h"
#include "asterf_petsc.h"
!
!
! person_in_charge: natacha.bereux at edf.fr
use aster_petsc_module
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
    integer :: jnequ, nloc, nglo, jdeeq, prolig, rang, ibid
    integer(kind=4) :: tmp, jterm, un, jcolg4(1), iterm
    integer :: jrefn, jmlogl
    character(len=8) :: noma
    character(len=24) :: nonulg
    mpi_int :: mrank, msize
!
    character(len=19) :: nomat, nosolv
    character(len=16) :: idxi1, idxi2, trans1, trans2
    character(len=14) :: nonu
    character(len=4) :: kbid
!
    logical :: lmnsy, lgive,ldebug
!
    real(kind=8) :: valm, valm2
!
    parameter (idxi1 ='&&APMAMC.IDXI1__')
    parameter (idxi2 ='&&APMAMC.IDXI2__')
    parameter (trans1='&&APMAMC.TRANS1_')
    parameter (trans2='&&APMAMC.TRANS2_')
!
!----------------------------------------------------------------
!     Variables PETSc
    PetscInt :: low, high, neql, neqg, ierr, mm, nn
    Mat :: a
!----------------------------------------------------------------
    call jemarq()
!
!   -- LECTURE DU COMMUN
    nomat = nomat_courant
    nonu = nonu_courant
    nosolv = nosols(kptsc)
    a = ap(kptsc)
    ldebug=.false.
!
    call jeveuo(nonu//'.SMOS.SMDI', 'L', jsmdi)
    call jelira(nonu//'.SMOS.SMDI', 'LONMAX', nsmdi)
    call jeveuo(nonu//'.SMOS.SMHC', 'L', jsmhc)
    call jelira(nonu//'.SMOS.SMHC', 'LONMAX', nsmhc)
    call jeveuo(nonu//'.NUME.NEQU', 'L', jnequ)
    call jeveuo(nonu//'.NUME.NULG', 'L', jnugll)
    call jeveuo(nonu//'.NUME.DEEQ', 'L', jdeeq)
    call jeveuo(nonu//'.NUME.PDDL', 'L', jprddl)
    call asmpi_info(rank = mrank, size = msize)
    rang = to_aster_int(mrank)
    nbproc = to_aster_int(msize)
    nloc = zi(jnequ)
    nglo = zi(jnequ+1)
    neql = nloc
    neqg = nglo
    nz = zi(jsmdi-1+nloc)
!
!   Adresses needed to get the stiffness matrix wrt nodes and dof numbers (see below)
    if (ldebug) then
        call jeveuo(nonu//'.NUME.REFN', 'L', jrefn)
        noma = zk24(jrefn)
        nonulg = noma//'.NULOGL'
        call jeveuo(nonulg, 'L', jmlogl)
    endif
!
    call jelira(nomat//'.VALM', 'NMAXOC', nvalm)
    if (nvalm .eq. 1) then
        lmnsy=.false.
    else if (nvalm.eq.2) then
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
    nuno1 = 0
    if ( zi(jdeeq).gt.0 ) then
        nuno1 = 1
    endif
    if ( nuno1.ne.0 ) then
        procol = zi(jprddl)
        if ( procol .eq. rang ) then
            tmp = zi(jnugll)
            call MatSetValue(a, tmp, tmp, zr(jvalm),&
                            INSERT_VALUES, ierr)
        endif
    else
        tmp = zi(jnugll)
        call MatSetValue(a, tmp, tmp, zr(jvalm),&
                         INSERT_VALUES, ierr)
    endif
!
!   On commence par s'occuper du nombres de NZ par ligne
!   dans le bloc diagonal
!    call MatSetOption(a, MAT_NEW_NONZERO_ALLOCATION_ERR, PETSC_FALSE, ierr)
    un = 1
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
            valm = zr(jvalm + k - 1)
            valm2 = valm
            if( lmnsy ) valm2 = zr(jvalm2 + k - 1)
            nuno1 = 0
            if( zi(jdeeq + (iligl - 1) * 2).gt.0 ) then
                nuno1 = 1
            endif
!           Writings to get the stiffness matrix wrt nodes and dof numbers
            if (ldebug) then
                nuno1 = zi(jmlogl + zi(jdeeq+2*(iligl-1)) - 1) + 1
                nucmp1 = zi(jdeeq +2*(iligl-1) + 1)
                nuno2 = zi(jmlogl + zi(jdeeq+2*(jcoll-1)) - 1) + 1
                nucmp2 = zi(jdeeq +2*(jcoll-1)+1)
                write(11+rang,*) nuno1, nucmp1, nuno2, nucmp2, valm, zi(jdeeq+2*(jcoll-1)), rang
            endif 
            if( nuno1.ne.0.and.nuno2.ne.0 ) then
                if( prolig .eq. rang ) then
                    jterm = jterm + 1
                    zr(jdval2 + jterm - 1) = valm
                    zi4(jdxi2 + jterm - 1) = iligg
                    if( procol .eq. rang ) then
                        if( iligg .ne. jcolg ) then
                            iterm = iterm + 1
                            zr(jdval1 + iterm - 1) = valm2
                            zi4(jdxi1 + iterm - 1) = iligg
                        endif
                    endif
                else if( procol .eq. rang ) then
                    iterm = iterm + 1
                    zr(jdval1 + iterm - 1) = valm2
                    zi4(jdxi1 + iterm - 1) = iligg
                endif
            else
!               Si on est sur un ddl de Lagrange et qu'on possede le ddl d'en face
!               ou que les deux ddl sont de Lagrange, on doit donner le terme
                lgive = (nuno1.eq.0.and.procol.eq.rang).or.&
                        (nuno2.eq.0.and.prolig.eq.rang).or.&
                        (nuno1.eq.0.and.nuno2.eq.0)
                if( lgive ) then
                    jterm = jterm + 1
                    zr(jdval2 + jterm - 1) = valm
                    zi4(jdxi2 + jterm - 1) = iligg
                    if( iligg .ne. jcolg ) then
                        iterm = iterm + 1
                        zr(jdval1 + iterm - 1) = valm2
                        zi4(jdxi1 + iterm - 1) = iligg
                    endif
                endif
            endif
        end do
        jcolg4(1) = jcolg
        mm = to_petsc_int(jterm)
!       Ici zi4(jdxi2) donne le numero de ligne
!       Donc on donne ici le bloc triangulaire superieur
        call MatSetValues(a, jterm, zi4(jdxi2:jdxi2+mm), un, [to_petsc_int(jcolg4)],&
                          zr(jdval2:jdval2+mm), INSERT_VALUES, ierr)
        nn = to_petsc_int(iterm)
!       on donne ici le bloc triangulaire inferieur
        call MatSetValues(a, un, [to_petsc_int(jcolg4)], iterm, zi4(jdxi1:jdxi1+nn),&
                          zr(jdval1:jdval1+nn), INSERT_VALUES, ierr)
        iterm = 0
        jterm = 0
    end do
!
    call jelibe(nonu//'.SMOS.SMDI')
    call jelibe(nonu//'.SMOS.SMHC')
    call jelibe(jexnum(nomat//'.VALM', 1))
    if (lmnsy) call jelibe(jexnum(nomat//'.VALM', 2))
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
