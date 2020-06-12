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
subroutine lrmjoi_wrap(nomu, nofimd)
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
    med_idt :: fid, ifimed
    integer :: nbnoeu, ndim, codret, vali(3)
    integer, parameter :: edlect=0
!
    aster_logical :: existm
!
    call jemarq()
!
    call sdmail(nomu, nommai, nomnoe, cooval, coodsc,&
                cooref, grpnoe, gpptnn, grpmai, gpptnm,&
                connex, titre, typmai, adapma)
!
    call jelira(cooval, 'LONMAX', nbnoeu)
    nbnoeu = nbnoeu/3
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
    call lrmjoi(fid, nommai, nomamd, nbnoeu, nomnoe)
!
    call jedema()
!
end subroutine
