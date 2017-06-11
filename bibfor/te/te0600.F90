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
! person_in_charge: sylvie.granet at edf.fr
!
subroutine te0600(option, nomte)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/thmCompEpsiElga.h"
#include "asterfort/thmCompSiefElno.h"
#include "asterfort/thmCompVariElno.h"
#include "asterfort/thmCompRefeForcNoda.h"
#include "asterfort/thmCompForcNoda.h"
#include "asterfort/thmCompLoad.h"
#include "asterfort/thmCompGravity.h"
#include "asterfort/thmCompNonLin.h"
!
    character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: THM
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    call thmModuleInit()
! =====================================================================
! --- 2. OPTIONS : RIGI_MECA_TANG , FULL_MECA , RAPH_MECA -------------
! =====================================================================
    if ((option(1:9).eq.'RIGI_MECA' ) .or. (option(1:9).eq.'RAPH_MECA' ) .or.&
        (option(1:9).eq.'FULL_MECA' )) then
        call thmCompNonLin(option)
    endif
! =====================================================================
! --- 3. OPTION : CHAR_MECA_PESA_R ------------------------------------
! =====================================================================
    if (option .eq. 'CHAR_MECA_PESA_R') then
        call thmCompGravity()
    endif
! =====================================================================
! --- 4. OPTIONS : CHAR_MECA_FR2D2D OU CHAR_MECA_FR3D3D ---------------
! =====================================================================
    if (option .eq. 'CHAR_MECA_FR3D3D' .or. option .eq. 'CHAR_MECA_FR2D2D') then
        call thmCompLoad(option, nomte)
    endif
! ======================================================================
! --- 5. OPTION : FORC_NODA --------------------------------------------
! ======================================================================
    if (option .eq. 'FORC_NODA') then
        call thmCompForcNoda()
    endif
! ======================================================================
! --- 6. OPTION : REFE_FORC_NODA ---------------------------------------
! ======================================================================
    if (option .eq. 'REFE_FORC_NODA') then
        call thmCompRefeForcNoda()
    endif
! ======================================================================
! --- 7. OPTION : SIEF_ELNO --------------------------------------------
! ======================================================================
    if (option .eq. 'SIEF_ELNO') then
        call thmCompSiefElno()
    endif
! ======================================================================
! --- 8. OPTION : VARI_ELNO --------------------------------------------
! ======================================================================
    if (option .eq. 'VARI_ELNO') then
        call thmCompVariElno()
    endif
! ======================================================================
! --- 9. OPTION : EPSI_ELGA --------------------------------------------
! ======================================================================
    if (option .eq. 'EPSI_ELGA') then
        call thmCompEpsiElga()
    endif
!
end subroutine
