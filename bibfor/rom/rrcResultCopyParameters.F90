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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine rrcResultCopyParameters(cmdPara)
!
use Rom_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/rsadpa.h"
#include "asterfort/rslesd.h"
#include "asterfort/rssepa.h"
!
type(ROM_DS_ParaRRC), intent(in) :: cmdPara
!
! --------------------------------------------------------------------------------------------------
!
! REST_REDUIT_COMPLET - Compute
!
! Copy parameters from ROM results datastructure to DOM results datastructure
!
! --------------------------------------------------------------------------------------------------
!
! In  cmdPara          : datastructure for parameters
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    integer :: nbStore, iStore, numeStore
    character(len=8) :: resultRomName, resultDomName, modelDom
    character(len=19) :: listLoad
    character(len=24) :: materi, caraElem
    integer :: jvPara
    real(kind=8) :: time
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, niv)
    if (niv .ge. 2) then
        call utmess('I', 'ROM16_5')
    endif
!
! - Get parameters
!
    nbStore       = cmdPara%resultDom%nbStore
    resultDomName = cmdPara%resultDom%resultName
    resultRomName = cmdPara%resultRom%resultName
    modelDom      = cmdPara%modelDom
!
! - Copy
!
    do iStore = 1, nbStore - 1
        numeStore = iStore
! ----- Get parameters
        call rslesd(resultRomName , numeStore-1,&
                    materi_   = materi    ,&
                    cara_elem_ = caraElem ,&
                    list_load_ = listLoad )
        call rsadpa(resultRomName, 'L', 1, 'INST', numeStore, 0, sjv=jvPara)
        time = zr(jvPara)
! ----- Save parameters
        call rssepa(resultDomName, numeStore, modelDom, materi, caraElem, listLoad)
        call rsadpa(resultDomName, 'E', 1, 'INST', numeStore, 0, sjv=jvPara)
        zr(jvPara) = time
    end do
!
end subroutine
