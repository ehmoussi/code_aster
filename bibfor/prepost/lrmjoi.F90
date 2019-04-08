subroutine lrmjoi(fid, nomam2, nbnoeu, nomnoe)
! ======================================================================
! COPYRIGHT (C) 1991 - 2019  EDF R&D                  WWW.CODE-ASTER.ORG
! THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
! IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
! THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
! (AT YOUR OPTION) ANY LATER VERSION.
!
! THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
! WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
! MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
! GENERAL PUBLIC LICENSE FOR MORE DETAILS.
!
! YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
! ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
!    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
! ======================================================================
! person_in_charge: nicolas.sellenet at edf.fr
!-----------------------------------------------------------------------
!     LECTURE DU MAILLAGE -  FORMAT MED
!-----------------------------------------------------------------------
    implicit none
#include "asterf.h"
#include "asterf_types.h"
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/as_mmhgnr.h"
#include "asterfort/as_msdnjn.h"
#include "asterfort/as_msdjni.h"
#include "asterfort/as_msdszi.h"
#include "asterfort/as_msdcrr.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/codent.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/jexnom.h"
#include "asterfort/mdexma.h"
#include "asterfort/wkvect.h"
#include "asterfort/asmpi_info.h"
!
    med_idt :: fid
    integer :: nbnoeu
!
    character(len=24) :: nomnoe
    character(len=*) :: nomam2
!
    character(len=4) :: chrang, chnbjo
    character(len=24) :: nonulg, nojoin
    character(len=64) :: nomjoi, nommad
    character(len=200) :: descri
    integer rang, nbproc, nbjoin, jnojoe, jnojor, domdis, nstep, ncorre
    integer icor, entlcl, geolcl, entdst, geodst, ncorr2, jjoint, jdojoi
    integer jnlogl, codret, iaux
    integer :: ednoeu
    parameter (ednoeu=3)
    integer :: typnoe
    parameter (typnoe=0)
    mpi_int :: mrank, msize
!
    call jemarq()
!
    call asmpi_info(rank = mrank, size = msize)
    rang = to_aster_int(mrank)
    nbproc = to_aster_int(msize)
    if ( nbproc.gt.1 ) then
!
        nonulg = nomnoe(1:8)//'.NULOGL'
        call wkvect(nonulg, 'G V I', nbnoeu, jnlogl)
        call as_mmhgnr(fid, nomam2, ednoeu, typnoe, zi(jnlogl),&
                       nbnoeu, codret)
        call codent(rang, 'G', chrang)
        call as_msdnjn(fid, nomam2, nbjoin, codret)
!         call wkvect(nomnoe(1:8)//'.NO_JO_ENV', 'G V K24', &
!                     nbproc, jnojoe)
!         call wkvect(nomnoe(1:8)//'.NO_JO_REC', 'G V K24', &
!                     nbproc, jnojor)
        call wkvect(nomnoe(1:8)//'.DOMJOINTS', 'G V I', &
                    nbjoin, jdojoi)
        do iaux = 1, nbjoin
            call as_msdjni(fid, nomam2, iaux, nomjoi, descri, domdis, &
                        nommad, nstep, ncorre, codret)
            do icor = 1, ncorre
                call as_msdszi(fid, nomam2, nomjoi, -1, -1, icor, entlcl, &
                            geolcl, entdst, geodst, ncorr2, codret)
                if ( entlcl.eq.ednoeu.and.geolcl.eq.typnoe ) then
                    call codent(domdis, 'G', chnbjo)
                    if ( nomjoi(1:4).eq.chrang ) then
                        nojoin = nomnoe(1:8)//'.R'//chnbjo
                    else
                        nojoin = nomnoe(1:8)//'.E'//chnbjo
                    endif
                    call wkvect(nojoin, 'G V I', 2*ncorr2, jjoint)
                    call as_msdcrr(fid, nomam2, nomjoi, -1, -1, entlcl, &
                                geolcl, entdst, geodst, 2*ncorr2, &
                                zi(jjoint), codret)
!                     if ( nomjoi(1:4).eq.chrang ) then
!                         ASSERT(zk24(jnojor + domdis).eq.' ')
!                         zk24(jnojor + domdis) = nojoin
!                     else
!                         ASSERT(zk24(jnojoe + domdis).eq.' ')
!                         zk24(jnojoe + domdis) = nojoin
!                     endif
                    ASSERT(domdis.le.nbproc)
                    zi(jdojoi + iaux - 1) = domdis
                endif
            enddo
        enddo
    endif
!
    call jedema()
!
end subroutine
