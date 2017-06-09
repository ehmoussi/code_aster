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

subroutine nmvcex(index, varcz, chamz)
!
    implicit none
!
#include "asterfort/exisd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
!
!
    character(len=4), intent(in) :: index
    character(len=*), intent(in) :: varcz
    character(len=*), intent(out) :: chamz
!
! --------------------------------------------------------------------------------------------------
!
! Command variables utility
!
! Extract command variable
!
! --------------------------------------------------------------------------------------------------
!
! IN   INDEX   K4  INDEX DE LA VARIABLE DE COMMANDE
! IN   COM     K14 SD VARI_COM
! OUT  CHAMP   K19 SD CHAMP_GD  DE LA VARIABLE DE COMMANDE EXTRAITE
!                  ' ' SI INEXISTANT
!
! --------------------------------------------------------------------------------------------------
!
    character(len=14) :: varc
    character(len=19) :: champ
    integer :: iret
!
! --------------------------------------------------------------------------------------------------
!
    varc  = varcz
    champ = varc//'.'// index
    call exisd('CHAMP_GD', champ, iret)
    if (iret .eq. 0) then
        champ = ' '
    endif
    chamz = champ
end subroutine
