subroutine lrmnin(nommai, nbmail, nbnoeu, connex, grpnoe,&
                  nbgrno)
! ======================================================================
! COPYRIGHT (C) 1991 - 2017  EDF R&D                  WWW.CODE-ASTER.ORG
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
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/codent.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/jexnom.h"
#include "asterfort/wkvect.h"
#include "asterfort/asmpi_info.h"
!
    integer :: nbmail, nbnoeu, nbgrno
!
    character(len=24) :: nommai, connex, grpnoe, kbid
    character(len=64) :: nofimd
!
    integer :: jmaext, nmgr, kno, ino, jnoext, rang, nbproc
    mpi_int :: mrank, msize
!
    character(len=4) :: chnbjo
    character(len=8) :: nom_grp_mailles
!
    logical :: ismaex
!
    call jemarq()
!
    call asmpi_info(rank = mrank, size = msize)
    rang = to_aster_int(mrank)
    nbproc = to_aster_int(msize)
    if ( nbproc.gt.1 ) then
!
        call codent(rang, 'G', chnbjo)
        nom_grp_mailles = 'EXT_'//chnbjo
!
        call wkvect(nommai(1:8)//'.NOEX', 'G V L', nbnoeu, jnoext)
        call jelira(jexnom(grpnoe, nom_grp_mailles), 'LONMAX', nmgr, kbid)
        kno = 0
        call jeveuo(jexnom(grpnoe, nom_grp_mailles), 'L', kno)
        ASSERT(kno.ne.0)
!
        do ino = 1, nmgr
            zl(jnoext + zi(kno + ino - 1) - 1) = .true.
        end do
    endif
!
    call jedema()
!
end subroutine
