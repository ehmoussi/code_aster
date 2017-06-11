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
#include "asterfort/thmGetElemModel.h"
#include "asterfort/thmGetGene.h"
#include "asterfort/thmGetParaIntegration.h"
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
    aster_logical :: l_axi, l_steady, l_vf
    integer :: ndim, type_vf
    integer :: mecani(5), press1(7), press2(7), tempe(5)
    character(len=3) :: inte_type
!
! --------------------------------------------------------------------------------------------------
!

!
! - Init THM module
!
    call thmModuleInit()
!
! - Get model of finite element
!
    call thmGetElemModel(l_axi, l_vf, type_vf, l_steady, ndim)
!
! - Get type of integration
!
    call thmGetParaIntegration(l_vf, inte_type)
!
! - Get generalized coordinates
!
    call thmGetGene(l_steady, l_vf, ndim,&
                    mecani, press1, press2, tempe)

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
        call thmCompGravity(inte_type, l_axi , l_vf  , type_vf, ndim,&
                            mecani, press1, press2, tempe)
    endif
!
! =====================================================================
! --- 4. OPTIONS : CHAR_MECA_FR2D2D OU CHAR_MECA_FR3D3D ---------------
! =====================================================================
    if (option .eq. 'CHAR_MECA_FR3D3D' .or. option .eq. 'CHAR_MECA_FR2D2D') then
        call thmCompLoad(option, nomte,&
                         l_axi   , inte_type, l_vf    , type_vf, ndim,&
                         mecani, press1, press2, tempe)
    endif
! ======================================================================
! --- 5. OPTION : FORC_NODA --------------------------------------------
! ======================================================================
    if (option .eq. 'FORC_NODA') then
        call thmCompForcNoda(l_axi   , inte_type, l_vf    , type_vf, l_steady, ndim ,&
                             mecani, press1, press2, tempe)
    endif
! ======================================================================
! --- 6. OPTION : REFE_FORC_NODA ---------------------------------------
! ======================================================================
    if (option .eq. 'REFE_FORC_NODA') then
        call thmCompRefeForcNoda(l_axi   , inte_type, l_vf    , type_vf, l_steady, ndim ,&
                                 mecani, press1, press2, tempe)
    endif
! ======================================================================
! --- 7. OPTION : SIEF_ELNO --------------------------------------------
! ======================================================================
    if (option .eq. 'SIEF_ELNO  ') then
        call thmCompSiefElno(l_vf, inte_type, mecani, press1, press2, tempe)
    endif
! ======================================================================
! --- 8. OPTION : VARI_ELNO --------------------------------------------
! ======================================================================
    if (option .eq. 'VARI_ELNO  ') then
        call thmCompVariElno(l_vf, inte_type)
    endif
! ======================================================================
! --- 9. OPTION : EPSI_ELGA --------------------------------------------
! ======================================================================
    if (option .eq. 'EPSI_ELGA') then
        call thmCompEpsiElga(l_vf, l_axi, inte_type, ndim,&
                             mecani, press1, press2, tempe)
    endif
!
end subroutine
