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

subroutine char_impo_liai(nomg, type_liai, cmp_nb, cmp_name, cmp_index,  &
                          vale_real, vale_cplx, vale_fonc)
!
    implicit none
!
#include "jeveux.h"
#include "asterc/indik8.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
!
!
    character(len=8), intent(in) :: nomg
    character(len=16), intent(in) :: type_liai
    character(len=8), intent(out) :: cmp_name(6)
    integer, intent(out) :: cmp_index(6)
    integer, intent(out) :: cmp_nb
    real(kind=8), intent(out) :: vale_real
    character(len=8), intent(out) :: vale_fonc
    complex(kind=8), intent(out):: vale_cplx
!
! --------------------------------------------------------------------------------------------------
!
! AFFE_CHAR_MECA
!
! Prepare data for LIAISON in DDL_IMPO
!
! --------------------------------------------------------------------------------------------------
!
! In  nomg      : name of <GRANDEUR>
! In  type_liai : type of liaison (only ENCASTRE)
! Out cmp_nb    : number of components
! Out cmp_name  : components name
! Out cmp_index : components index in <GRANDEUR>
! Out vale_real : value of all components (if real)
! Out vale_cplx : value of all components (if complex)
! Out vale_fonc : value of all components (if function)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: look_name(6)
    integer :: i_exis, i_cmp, jnom
!
    data look_name /'DX','DY','DZ','DRX','DRY','DRZ'/
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initializations
!
    ASSERT(type_liai.eq. 'ENCASTRE')
    vale_real = 0.d0
    vale_cplx = (0.d0,0.d0)
    vale_fonc = '&FOZERO'
    cmp_nb    = 0
!
! - Information about <GRANDEUR>
!
    call jeveuo(jexnom('&CATA.GD.NOMCMP', nomg), 'L', jnom)
!
! - DOF index in catalogue
!
    do i_cmp = 1,6
        i_exis = indik8(zk8(jnom),look_name(i_cmp),1,6)
        if (i_exis.ne.0) then
            cmp_nb = cmp_nb + 1
            cmp_index(cmp_nb) = i_exis
            cmp_name(cmp_nb) = look_name(i_cmp)
        endif
    enddo
!
    call jedema()
end subroutine
