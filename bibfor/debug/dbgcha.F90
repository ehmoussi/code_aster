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

subroutine dbgcha(valinc, instap, iterat)
!
    implicit none
#include "asterf_types.h"
#include "asterfort/codent.h"
#include "asterfort/codree.h"
#include "asterfort/irchmd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/nmchex.h"
    real(kind=8) :: instap
    integer :: iterat
    character(len=19) :: valinc(*)
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
!    IMPRESSION D'UN CHAMP POUR DEBUG
!
! ----------------------------------------------------------------------
!
!
! IN  VALINC : VARIABLE CHAPEAU POUR INCREMENTS VARIABLES
! IN  INSTAP : INSTANT CORRESPONDANT AU CHAMP
! IN  ITERAT : ITERATION CORRESPONDANT AU CHAMP
!
    character(len=19) :: depplu
    character(len=8) :: instxt, itetxt
    integer :: codret
    aster_logical :: dbg
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    dbg=.false.
!
    if (dbg) then
        call nmchex(valinc, 'VALINC', 'DEPPLU', depplu)
        call codree(instap, 'G', instxt)
        call codent(iterat, 'G', itetxt)
        call irchmd(80, depplu, 'REEL', 'INST:'//instxt//'ITERAT:'// itetxt, codret)
    endif
!
    call jedema()
end subroutine
