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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine getBehaviourAlgo(plane_stress, rela_comp   ,&
                            rela_code_py, meca_code_py,&
                            keywf       , i_comp      ,&
                            algo_inte   , algo_inte_r)
!
use NonLin_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
#include "asterc/lcalgo.h"
#include "asterc/lctest.h"
#include "asterfort/assert.h"
#include "asterfort/getvtx.h"
#include "asterfort/utlcal.h"
#include "asterfort/utmess.h"
!
aster_logical, intent(in) :: plane_stress
character(len=16), intent(in) :: rela_comp
character(len=16), intent(in) :: rela_code_py
character(len=16), intent(in) :: meca_code_py
character(len=16), intent(in) :: keywf
integer, intent(in) :: i_comp
character(len=16), intent(out) :: algo_inte
real(kind=8), intent(out) :: algo_inte_r
!
! --------------------------------------------------------------------------------------------------
!
! Preparation of comportment (mechanics)
!
! Get algorithm for integration of behaviour
!
! --------------------------------------------------------------------------------------------------
!
! In  mesh             : name of mesh
! In  model            : name of model
! In  rela_comp        : RELATION comportment
! In  rela_code_py     : coded comportment for RELATION (coding in Python)
! In  meca_code_py     : coded comportment for mechanical part (coding in Python)
! In  keywf            : factor keyword to read (COMPORTEMENT)
! In  i_comp           : factor keyword index
! Out algo_inte        : algorithm for integration of behaviour
! Out algo_inte_r      : identifier for algorithm for integration of behaviour
!
! --------------------------------------------------------------------------------------------------
!
    integer :: iret
    character(len=16) :: texte(3)=(/ ' ',' ',' '/)
!
! --------------------------------------------------------------------------------------------------
!
    algo_inte   = ' '
    algo_inte_r = 0.d0
!
! - Get ALGO_INTE
!
    call getvtx(keywf, 'ALGO_INTE', iocc = i_comp, scal = algo_inte, nbret = iret)
    if (iret .eq. 0) then
        call lcalgo(rela_code_py, algo_inte)
    else  
        call lctest(meca_code_py, 'ALGO_INTE', algo_inte, iret)
        if (iret .eq. 0) then
            texte(1) = algo_inte
            texte(2) = 'ALGO_INTE'
            texte(3) = rela_comp
            call utmess('F', 'COMPOR1_45', nk = 3, valk = texte)
        endif
    endif
!
! - Get ALGO_INTE - Plane stress
!
    if (plane_stress) then
        if (rela_comp .eq. 'VMIS_ECMI_LINE' .or. rela_comp .eq. 'VMIS_ECMI_TRAC' .or.&
            rela_comp .eq. 'VMIS_ISOT_LINE' .or. rela_comp .eq. 'VMIS_ISOT_TRAC') then
            algo_inte = 'SECANTE'
        endif
    endif
!
! - Convert name of algorithm to identifier
!
    call utlcal('NOM_VALE', algo_inte, algo_inte_r)
!
end subroutine
