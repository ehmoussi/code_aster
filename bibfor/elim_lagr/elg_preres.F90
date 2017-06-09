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

subroutine elg_preres(solve1, base, iret, matpre, matas1,&
                      npvneg, istop)
!
use elim_lagr_data_module
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/elg_calc_matk_red.h"
#include "asterfort/gcncon.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/prere1.h"
!-----------------------------------------------------------------------
! But : faire "preres" si ELIM_MAGR='OUI'
!-----------------------------------------------------------------------
!
    character(len=19) :: matas1, solve1
    character(len=*) :: base, matpre
    integer :: istop, iret
    character(len=19) :: matas2, solve2
    integer ::   npvneg
    character(len=24), pointer :: slvk(:) => null()
    character(len=24), pointer :: refa(:) => null()
!
!
    call jemarq()
!
!
!   -- ON CREE LA MATRICE (REDUITE) MATAS2
    call gcncon('_', matas2)
    call elg_gest_data('NOTE', matas1, matas2, ' ')
    call elg_calc_matk_red(matas1, solve1, matas2, 'V')
!
!   -- ON DUPLIQUE SOLVE1 EN CHANGEANT ELIM_LAGR: OUI -> NON
    call gcncon('_', solve2)
    call copisd('SOLVEUR', 'V', solve1, solve2)
    call jeveuo(solve2//'.SLVK', 'L', vk24=slvk)
    slvk(13)='NON'
    call jeveuo(matas2//'.REFA', 'E', vk24=refa)
    refa(7)=solve2
!
!   --  ON APPELLE PRERE1 AVEC MATAS2 ET SOLVE2 :
    call prere1(' ', base, iret, matpre, matas2,&
                npvneg, istop)
!
!
    call jedema()
end
