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
!
! person_in_charge: nicolas.sellenet at edf.fr
!
subroutine lrmjoi(fid, nommail, nomam2, nbnoeu, nomnoe)
!
    implicit none
#include "asterf.h"
#include "asterf_types.h"
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/as_mmhgnr.h"
#include "asterfort/as_msdcrr.h"
#include "asterfort/as_msdjni.h"
#include "asterfort/as_msdnjn.h"
#include "asterfort/as_msdszi.h"
#include "asterfort/asmpi_info.h"
#include "asterfort/codent.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/jexnom.h"
#include "asterfort/mdexma.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
    med_idt, intent(in) :: fid
    integer, intent(in) :: nbnoeu
    character(len=24), intent(in) :: nomnoe
    character(len=*), intent(in) :: nomam2, nommail
!
! ---------------------------------------------------------------------------------------------
!
! LECTURE DU FORMAT MED : Lecture des joints pour le ParallelMesh
!
! ---------------------------------------------------------------------------------------------
!
    character(len=4) :: chrang, chnbjo
    character(len=24) :: nonulg, nojoin
    character(len=64) :: nomjoi, nommad
    character(len=200) :: descri
    integer rang, nbproc, nbjoin, domdis, nstep, ncorre
    integer icor, entlcl, geolcl, entdst, geodst, ncorr2, jjoint, jdojoi
    integer jnlogl, codret, i_join, ino, numno, deca
    integer, parameter :: ednoeu=3, typnoe=0
    mpi_int :: mrank, msize
    integer, pointer :: v_noext(:) => null()
!
    call jemarq()
!
    call asmpi_info(rank = mrank, size = msize)
    rang = to_aster_int(mrank)
    nbproc = to_aster_int(msize)
!
! --- Uniquement pour les ParallelMesh
!
    if ( nbproc.gt.1 ) then
!
! --- Récupération de la numérotation globale des noeuds
!
        nonulg = nomnoe(1:8)//'.NULOGL'
        call wkvect(nonulg, 'G V I', nbnoeu, jnlogl)
        call as_mmhgnr(fid, nomam2, ednoeu, typnoe, zi(jnlogl),&
                       nbnoeu, codret)
        call codent(rang, 'G', chrang)
        call as_msdnjn(fid, nomam2, nbjoin, codret)
!
! --- Par défaut, tout les noeuds d'un domaine appartient au moins à ce domaine
!
        call wkvect(nommail(1:8)//'.NOEX', 'G V I', nbnoeu, vi=v_noext)
        v_noext(1:nbnoeu) = rang
!
        if(nbjoin > 0) then
            call wkvect(nomnoe(1:8)//'.DOMJOINTS', 'G V I', &
                        nbjoin, jdojoi)
!
! --- Boucle sur les joints entre les sous-domaines
!
            do i_join = 1, nbjoin
                call as_msdjni(fid, nomam2, i_join, nomjoi, descri, domdis, &
                            nommad, nstep, ncorre, codret)
                ASSERT(domdis.le.nbproc)
!
                do icor = 1, ncorre
                    call as_msdszi(fid, nomam2, nomjoi, -1, -1, icor, entlcl, &
                                geolcl, entdst, geodst, ncorr2, codret)
!
                    if ( entlcl.eq.ednoeu.and.geolcl.eq.typnoe ) then
                        call codent(domdis, 'G', chnbjo)
                        if ( nomjoi(1:4).eq.chrang ) then
                            nojoin = nomnoe(1:8)//'.R'//chnbjo
                        else
                            nojoin = nomnoe(1:8)//'.E'//chnbjo
                        endif
!
! --- Récupération de la table de correspondance pour les noeuds partagés par 2 sous-domaines
!
                        call wkvect(nojoin, 'G V I', 2*ncorr2, jjoint)
                        call as_msdcrr(fid, nomam2, nomjoi, -1, -1, entlcl, &
                                    geolcl, entdst, geodst, 2*ncorr2, &
                                    zi(jjoint), codret)
!
! --- On récupère le numéro du sous-domaine pour les noeuds partagés
!
                        if(nomjoi(1:4).eq.chrang) then
                            deca = 1
                            do ino = 1, ncorr2
                                numno = zi(jjoint-1 + deca)
                                v_noext(numno) = domdis
                                deca = deca +2
                            end do
                        end if
!
                        zi(jdojoi + i_join - 1) = domdis
                    endif
                enddo
            enddo
        else
            call utmess('A', 'MAILLAGE1_5', sk=nomam2)
        end if
    endif
!
    call jedema()
!
end subroutine
