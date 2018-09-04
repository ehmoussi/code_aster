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
!
subroutine mfrontExternalStateVariable(carcri, rela_comp, fami, kpg, ksp, &
                                         irets, ireth, &
                                         sechm, sechp, hydrm, hydrp, &
                                         predef, dpred)
!
use calcul_module, only : ca_vext_eltsize1_, ca_vext_hygrm_, ca_vext_hygrp_
!
implicit none
!
#include "asterfort/Behaviour_type.h"
#include "asterfort/r8inir.h"
#include "asterc/r8nnem.h"
#include "asterc/mfront_get_external_state_variable.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/rcvarc.h"
!
real(kind=8), intent(in) :: carcri(*)
character(len=16), intent(in) :: rela_comp
character(len=*), intent(in) :: fami
integer, intent(in) :: kpg, ksp
integer, intent(in)      :: irets, ireth
real(kind=8), intent(in) :: sechm, sechp, hydrm, hydrp
real(kind=8), intent(out) :: predef(*), dpred(*)
!
! --------------------------------------------------------------------------------------------------
!
! Behaviour (MFront)
!
! Prepare predef and dpred variables
!
! --------------------------------------------------------------------------------------------------
!
! In  carcri           : parameters for comportment
! In  rela_comp        : name of comportment definition
! In  fami             : Gauss family for integration point rule
! In  kpg              : current point gauss
! In  ksp              : current "sous-point" gauss
! In  irets            : error code for 'SECH'
! In  ireth            : error code for 'HYDR'
! In  sechm            : 'SECH' at the beginning of current step time
! In  sechp            : 'SECH' at the end of current step time
! In  hydrm            : 'HYDR' at the beginning of current step time
! In  hydrp            : 'HYDR' at the end of current step time
! Out predef           : external state variables at beginning of current step time
! Out dpred            : increment of external state variables during current step time
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: nb_varc_maxi = 8
    integer            :: i_varc, iret, iret2, nb_varc
    real(kind=8)       :: vrcm, vrcp
    character(len=8)   :: list_varc(nb_varc_maxi)
!
! --------------------------------------------------------------------------------------------------
!
    call r8inir(nb_varc_maxi, 0.d0, predef, 1)
    call r8inir(nb_varc_maxi, 0.d0, dpred, 1)
!
! Get the ExternalStateVariables declared in the mfront law
    call mfront_get_external_state_variable(int(carcri(14)), int(carcri(15)),&
                                            list_varc      , nb_varc)
!
    ASSERT(nb_varc .le. nb_varc_maxi)
!
    do i_varc = 1, nb_varc
        if (list_varc(i_varc) .eq. 'SECH' ) then
            if (irets .eq. 0) then
                predef(i_varc) = sechm
                dpred(i_varc)  = sechp-sechm
            else 
                call utmess('F', 'COMPOR4_23', sk = list_varc(i_varc))
            endif
        else
            if (list_varc(i_varc) .eq. 'HYDR' ) then
                if (ireth .eq. 0) then
                    predef(i_varc) = hydrm
                    dpred(i_varc)  = hydrp-hydrm
                else 
                    if (rela_comp.ne.'BETON_BURGER') then
                        call utmess('F', 'COMPOR4_23', sk = list_varc(i_varc))
                    endif
                endif
            else 
                call rcvarc(' ', list_varc(i_varc), '-', fami, kpg, ksp, vrcm, iret)
                if (iret .eq. 0) then
                    call rcvarc('F', list_varc(i_varc), '+', fami, kpg, ksp, vrcp, iret2)
                    predef(i_varc) = vrcm
                    dpred(i_varc)  = vrcp-vrcm
                else
                    if (list_varc(i_varc) .eq. 'ELTSIZE1') then
                        predef(i_varc) = ca_vext_eltsize1_
                    endif
                    if (list_varc(i_varc) .eq. 'HYGR') then
                        predef(i_varc) = ca_vext_hygrm_
                        dpred(i_varc)  = ca_vext_hygrp_-ca_vext_hygrm_
                    endif
                    if ((list_varc(i_varc) .ne. 'HYGR') .and. &
                    (list_varc(i_varc) .ne. 'ELTSIZE1')) then
                        if (rela_comp .ne. 'BETON_BURGER') then
                            call utmess('F', 'COMPOR4_23', sk = list_varc(i_varc))
                        endif
                    endif
                endif
            endif
        endif
    enddo

end subroutine
