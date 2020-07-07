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
! person_in_charge: nicolas.pignet at edf.fr
!
subroutine cgVerification(cgField, cgTheta)
!
use calcG_type
!
    implicit none
!
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/exixfe.h"
#include "asterc/getfac.h"
!
    type(CalcG_field), intent(in) :: cgField
    type(CalcG_theta), intent(in) :: cgTheta
!
! --------------------------------------------------------------------------------------------------
!
!     CALC_G --- Utilities
!
!     Verification of inputs
!
! --------------------------------------------------------------------------------------------------
!
!
    character(len=8) :: model, mesh
    aster_logical :: lmodemeca, ldynatrans, lXfemModel
    integer :: nexci, ixfem, netatinit
!
    call jemarq()
!
    if(cgField%level_info>1) then
        call utmess('I', 'RUPTURE3_1')
    end if
!
    call dismoi('MODELE', cgField%result_in, 'RESULTAT', repk=model)
    call dismoi('NOM_MAILLA',model,'MODELE', repk=mesh)
    ASSERT(cgTheta%mesh .eq. mesh)
!
    lmodemeca = cgField%isModeMeca()
    ldynatrans= cgField%isDynaTrans()
!
! --- Compatibility between Model and Crack
!
    lXfemModel = ASTER_FALSE
    call exixfe(model, ixfem)
    if(ixfem==1) then
        lXfemModel = ASTER_TRUE
    end if
!
    if(cgTheta%lxfem .and. lXfemModel) then
        if(cgTheta%lxfem .neqv. lXfemModel) then
            call utmess('F', 'RUPTURE3_8')
        end if
    end if
!
! --- EXCIT is allowed only for MODE_MECA and DYNA_TRANS
!
    call getfac('EXCIT', nexci)
    if(lmodemeca .or. ldynatrans) then
        if (nexci == 0) then
            call utmess('F', 'RUPTURE3_6')
        endif
    else
        if (nexci == 1) then
            call utmess('F', 'RUPTURE3_7')
        endif
    end if
!
! --- If Xfem -> COHESIF is forbidden
!
    if(cgTheta%lxfem) then
        if(cgField%ndim .eq. 2 .and. cgTheta%XfemDisc_type.eq.'COHESIF') then
            call utmess('F', 'RUPTURE2_5')
        end if
    endif
!
! --- Verification option (not allowed for the moment)
!
    ASSERT(.not.cgTheta%lxfem)
    ASSERT(.not.cgField%isModeMeca())
    ASSERT(.not.cgField%isDynaTrans())
    ASSERT(nexci==0)
    call getfac('ETAT_INIT', netatinit)
    ASSERT(netatinit==0)
!
    call jedema()
!
end subroutine
