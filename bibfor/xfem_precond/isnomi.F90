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

function isnomi(elrefa, ino)
!
!-----------------------------------------------------------------------
! BUT : VERIFIER S IL S AGIT D UN NOEUD MILIEU
!-----------------------------------------------------------------------
!
! ARGUMENTS :
!------------
!   - LSN
!-----------------------------------------------------------------------
    implicit none
!-----------------------------------------------------------------------
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/assert.h"
!-----------------------------------------------------------------------
    character(len=8) :: elrefa
    aster_logical :: isnomi
    integer :: ino
!-----------------------------------------------------------------------
    integer :: nnos
!-----------------------------------------------------------------------
!
    isnomi=.false.
!
    if (elrefa.eq.'HE8'.or.elrefa.eq.'H20'.or.elrefa.eq.'H27') then
      nnos=8
      goto 100
    else if (elrefa.eq.'TE4'.or.elrefa.eq.'T10') then
      nnos=4
      goto 100
    else if (elrefa.eq.'PE6'.or.elrefa.eq.'P15'.or.elrefa.eq.'P18'&
             .or. elrefa.eq.'SH6'.or.elrefa.eq.'S15') then
      nnos=6
      goto 100
    else if (elrefa.eq.'PY5'.or.elrefa.eq.'P13') then
      nnos=5
      goto 100
    else if (elrefa.eq.'TR3'.or.elrefa.eq.'TR6'.or.elrefa.eq.'TR7') then
      nnos=3
      goto 100
    else if (elrefa.eq.'QU4'.or.elrefa.eq.'QU8'.or.elrefa.eq.'QU9') then
      nnos=4
      goto 100
    else if (elrefa.eq.'SE2'.or.elrefa.eq.'SE3'.or.elrefa.eq.'SE4') then
      nnos=2
      goto 100
    else if (elrefa.eq.'PO1') then
      nnos=1
      goto 100
    else
      ASSERT(.false.)
    endif
!
100 continue
!
    if (ino.gt.nnos) isnomi=.true.
!
end function
