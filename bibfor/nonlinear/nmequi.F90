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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmequi(l_disp     , l_pilo, l_macr, cnresu,&
                  cnfint     , cnfext, cndiri, cnsstr,&
                  ds_contact_,&
                  cnbudi_    , cndfdo_,&
                  cndipi_    , eta_)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/infdbg.h"
#include "asterfort/nmdebg.h"
#include "asterfort/nonlinDSVectCombCompute.h"
#include "asterfort/nonlinDSVectCombAddAny.h"
#include "asterfort/nonlinDSVectCombInit.h"
!
aster_logical, intent(in) :: l_disp, l_pilo, l_macr
character(len=19), intent(in) :: cnresu
character(len=19), intent(in) :: cnfint, cnfext, cndiri, cnsstr
type(NL_DS_Contact), optional, intent(in) :: ds_contact_
character(len=19), optional, intent(in) :: cnbudi_, cndfdo_, cndipi_
real(kind=8), optional, intent(in) :: eta_
!
! --------------------------------------------------------------------------------------------------
!
! MECA_NON_LINE - Algorithm
!
! Compute lack of balance forces
!
! --------------------------------------------------------------------------------------------------
!
! In  cnfext           : nodal field for external force
! In  cnfint           : nodal field for internal force
! In  cndiri           : nodal field for support reaction
! In  cnsstr           : nodal field for sub-structuring force
! In  ds_contact       : datastructure for contact management
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ifm, niv
    type(NL_DS_VectComb) :: ds_vectcomb
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECA_NON_LINE', ifm, niv)
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE> Compute lack of balance forces'
    endif
!
! - Initializations
!
    call nonlinDSVectCombInit(ds_vectcomb)
!
! - Add vect_asse
!
    call nonlinDSVectCombAddAny(cnfint, +1.d0, ds_vectcomb)
    call nonlinDSVectCombAddAny(cndiri, +1.d0, ds_vectcomb)
    call nonlinDSVectCombAddAny(cnfext, -1.d0, ds_vectcomb)
    if (present(ds_contact_)) then
        if (ds_contact_%l_cnctdf) then
            call nonlinDSVectCombAddAny(ds_contact_%cnctdf, +1.d0, ds_vectcomb)
        endif
!        if (ds_contact_%l_cneltc) then
!            call nonlinDSVectCombAddAny(ds_contact_%cneltc, +1.d0, ds_vectcomb)
!        endif
!        if (ds_contact_%l_cneltf) then
!            call nonlinDSVectCombAddAny(ds_contact_%cneltf, +1.d0, ds_vectcomb)
!        endif
    endif
    if (l_disp) then
        call nonlinDSVectCombAddAny(cnbudi_, +1.d0, ds_vectcomb)
        call nonlinDSVectCombAddAny(cndfdo_, -1.d0, ds_vectcomb)
    endif
    if (l_pilo) then
        call nonlinDSVectCombAddAny(cndipi_, -eta_, ds_vectcomb)
    endif
    if (l_macr) then
        call nonlinDSVectCombAddAny(cnsstr, +1.d0, ds_vectcomb)
    endif

!
! - Combination
!
    call nonlinDSVectCombCompute(ds_vectcomb, cnresu)
!
! - Debug
!
    if (niv .eq. 2) then
        call nmdebg('VECT', cnresu, ifm)
    endif
!
end subroutine
