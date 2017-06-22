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

subroutine charac(load, vale_type)
!
implicit none
!
#include "asterfort/adalig.h"
#include "asterfort/caddli.h"
#include "asterfort/cagene.h"
#include "asterfort/cagrou.h"
#include "asterfort/cbimpe.h"
#include "asterfort/cbvite.h"
#include "asterfort/cormgi.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeexin.h"
#include "asterfort/jeveuo.h"
#include "asterfort/initel.h"
#include "asterfort/utmess.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    character(len=4), intent(in) :: vale_type
    character(len=8), intent(in) :: load
!
! --------------------------------------------------------------------------------------------------
!
! Loads affectation
!
! Treatment of loads for AFFE_CHAR_ACOU_*
!
! --------------------------------------------------------------------------------------------------
!
!
! In  vale_type : affected value type (real, complex or function)
! In  load      : name of load
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nb_dim, iret
    character(len=4) :: vale_type_acou
    character(len=8) :: mesh, model
    character(len=16) :: keywordfact, command
    character(len=19) :: ligrch, ligrmo
    character(len=8), pointer :: p_ligrch_lgrf(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
!
! - Mesh, Ligrel for model, dimension of model
!
    command = 'AFFE_CHAR_ACOU'
    call cagene(load, command, ligrmo, mesh, nb_dim)
    model = ligrmo(1:8)
    if (nb_dim .gt. 3) then
        call utmess('A', 'CHARGES2_4')
    endif
!
! - VITE_FACE
!
    call cbvite(load, mesh, ligrmo, vale_type)
!
! - IMPE_FACE
!
    call cbimpe(load, mesh, ligrmo, vale_type)
!
! - PRES_IMPO
!
    keywordfact    = 'PRES_IMPO'
    vale_type_acou = 'COMP'
    call caddli(keywordfact, load, mesh, ligrmo, vale_type_acou)
!
! - LIAISON_UNIF
!
    call cagrou(load, mesh, vale_type, 'ACOU')
!
! - Update loads <LIGREL>
!
    ligrch = load//'.CHAC.LIGRE'
    call jeexin(ligrch//'.LGRF', iret)
    if (iret .ne. 0) then
        call adalig(ligrch)
        call cormgi('G', ligrch)
        call jeecra(ligrch//'.LGRF', 'DOCU', cval = 'ACOU')
        call initel(ligrch)
        call jeveuo(ligrch//'.LGRF', 'E', vk8 = p_ligrch_lgrf)
        p_ligrch_lgrf(2) = model
    endif
!
end subroutine
