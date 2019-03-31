subroutine lrmjoi_wrap(nomu, nofimd)
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
    use as_med_module, only: as_med_open
    implicit none
#include "asterf.h"
#include "asterf_types.h"
#include "jeveux.h"
!
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/codent.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"
#include "asterfort/jexnom.h"
#include "asterfort/lrmjoi.h"
#include "asterfort/lrmnin.h"
#include "asterfort/mdexpm.h"
#include "asterfort/sdmail.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
!
    character(len=8) :: nomu
    character(len=*) :: nofimd
    character(len=64) :: nomamd
!
    character(len=24) :: cooval, coodsc, cooref, grpnoe, grpmai, connex
    character(len=24) :: titre, nommai, nomnoe, typmai, adapma, gpptnn, gpptnm
    character(len=64) :: valk(2)
!
    integer :: nbmail, nbnoeu, nbgrno, fid, ifimed, ndim, codret, vali(3)
    integer :: iaux
    integer :: edlect
    parameter (edlect=0)
!
    aster_logical :: existm
!
    call jemarq()
!
    call sdmail(nomu, nommai, nomnoe, cooval, coodsc,&
                cooref, grpnoe, gpptnn, grpmai, gpptnm,&
                connex, titre, typmai, adapma)
!
    call jelira(typmai, 'LONMAX', nbmail)
    call jelira(cooval, 'LONMAX', nbnoeu)
    nbnoeu = nbnoeu/3
    call jelira(gpptnn, 'NOMMAX', nbgrno)
!
    call lrmnin(nommai, nbmail, nbnoeu, connex, grpnoe,&
                nbgrno)
!
    ifimed = 0
    nomamd = ' '
    call mdexpm(nofimd, ifimed, nomamd, existm, ndim,&
                codret)
    if (.not.existm) then
        call utmess('F', 'MED_50', sk=nofimd)
    endif
!
    call as_med_open(fid, nofimd, edlect, codret)
    if (codret .ne. 0) then
        valk(1) = nofimd
        valk(2) = nomamd
        vali(1) = codret
        call utmess('A', 'MODELISA9_51', nk=2, valk=valk, si=vali(1))
        call utmess('F', 'PREPOST_69')
    endif
!
    call lrmjoi(fid, nomamd, nbnoeu, nomnoe)
!
    call jedema()
!
end subroutine
