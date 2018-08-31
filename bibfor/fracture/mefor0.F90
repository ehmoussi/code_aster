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

subroutine mefor0(nomo, chfor0, fonc)
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/mecact.h"
    character(len=8) :: nomo
    character(len=*) :: chfor0
!
    aster_logical :: fonc
!
! - CETTE ROUTINE GENERE UN CHAMP DE FORCE NUL (CARTE CONSTANTE)
!       FONC = .TRUE.  FORCE FONCTION
!       FONC = .FALSE. FORCE REELLE
!
!
    real(kind=8) :: rcmp(3)
!
    character(len=8) :: licmp(3), nomf(3), zero
    character(len=19) :: ligrmo
!-----------------------------------------------------------------------
    chfor0 = '&&MEFOR0.FORCE_NULLE'
    zero = '&FOZERO'
    ligrmo = nomo//'.MODELE    '
    licmp(1) = 'FX'
    licmp(2) = 'FY'
    licmp(3) = 'FZ'
    rcmp(1) = 0.d0
    rcmp(2) = 0.d0
    rcmp(3) = 0.d0
    if (fonc) then
        nomf(1) = zero
        nomf(2) = zero
        nomf(3) = zero
        call mecact('V', chfor0, 'MODELE', ligrmo, 'FORC_F',&
                    ncmp=3, lnomcmp=licmp, vk=nomf)
    else
        call mecact('V', chfor0, 'MODELE', ligrmo, 'FORC_R',&
                    ncmp=3, lnomcmp=licmp, vr=rcmp)
    endif
!
end subroutine
