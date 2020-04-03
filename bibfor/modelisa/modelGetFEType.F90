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
subroutine modelGetFEType(iocc, phenom, modeli_in, idx_modelisa, modeli)
!
implicit none
!
#include "asterc/getexm.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
#include "asterfort/jexnom.h"
#include "asterfort/jenonu.h"
#include "asterfort/getvtx.h"
#include "asterfort/lxlgut.h"
#include "asterfort/deprecated_model.h"
!
integer, intent(in) :: iocc
character(len=16), intent(in) :: phenom, modeli_in
integer, intent(out) :: idx_modelisa
character(len=16), intent(out) :: modeli
!
! --------------------------------------------------------------------------------------------------
!
! AFFE_MODELE
!
! Get type of finite element (PHENOMENE/MODELISATION/FORMULATION)
!
! --------------------------------------------------------------------------------------------------
!
! In  iocc              : factor keyword index for AFFE
! In  phenom            : phenomenon (MECANIQUE/THERMIQUE/ACOUSTIQUE)
! In  modeli_in         : modelisation from MODELISATION keyword
! Out idx_modelisa      : index in catalog for new modelisation
! Out modeli            : new modelisation (with FORMULATION)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=16) :: formul
    character(len=16), parameter :: keywordfact = 'AFFE'
    integer :: nbret
!
! --------------------------------------------------------------------------------------------------
!
    idx_modelisa = 0
    modeli       = modeli_in
!
! - Get formulation
!
    formul = ' '
    if (getexm(keywordfact, 'FORMULATION') .eq. 1) then
        call getvtx(keywordfact, 'FORMULATION', iocc=iocc, scal=formul, nbret = nbret)
        if (nbret .eq. 0) then
            formul = ' '
        else
            ASSERT(nbret .eq. 1)
        endif
    endif
!
! - New modelisation
!
    if (formul .eq. 'LINEAIRE') then
        modeli = modeli_in(1:lxlgut(modeli_in))//'#1'
    elseif (formul .eq. 'QUADRATIQUE') then
        modeli = modeli_in(1:lxlgut(modeli_in))//'#2'
    elseif (formul .ne. ' ') then
        ASSERT(ASTER_FALSE)
    endif
!
! - Check deprecation warning
!
    call deprecated_model(modeli)
!
! - Get FE type
!
    call jenonu(jexnom('&CATA.'//phenom(1:13)//'.MODL', modeli), idx_modelisa)
    if (idx_modelisa .eq. 0) then
        call utmess('F', 'MODELE1_12', sk = formul)
    endif
!
end subroutine
