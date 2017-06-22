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

subroutine calc_meta_field(ligrmo, chmate, tempe, compor, phasin, &
                           meta_out)
!
    implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/calcul.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
!
!
    character(len=19), intent(in) :: meta_out
    character(len=24), intent(in) :: ligrmo
    character(len=19), intent(in) :: compor
    character(len=24), intent(in) :: phasin
    character(len=24), intent(in) :: chmate
    character(len=24), intent(in) :: tempe
!
! --------------------------------------------------------------------------------------------------
!
! CALC_META
!
! Compute initial metallurgical field in meta_out
!
! --------------------------------------------------------------------------------------------------
!
! In  ligrmo   : LIGREL for model
! In  chmate   : field of coded material
! In  tempe    : field of current temperature
! In  compor   : field of behavior
! In  phasin   : field of phase
! In  meta_out : metallurgical field
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nbout, nbin
    parameter    (nbout=1, nbin=4)
    character(len=8)  :: lpaout(nbout), lpain(nbin)
    character(len=19) :: lchin(nbin)
!
    character(len=1) :: base
    character(len=16) :: option
!
! --------------------------------------------------------------------------------------------------
!
    call jemarq()
!
! - Initialization
!
    option = 'META_INIT_ELNO'
    base = 'V'
!
! - Fields in
!
    lpain(1) = 'PMATERC'
    lchin(1) = chmate(1:19)
    lpain(2) = 'PCOMPOR'
    lchin(2) = compor(1:19)
    lpain(3) = 'PTEMPER'
    lchin(3) = tempe(1:19)
    lpain(4) = 'PPHASIN'
    lchin(4) = phasin(1:19)
!
! - Fields out
!
    lpaout(1) = 'PPHASNOU'
!
! - Computation
!
    call calcul('S', option, ligrmo, nbin, lchin,&
                lpain, nbout, meta_out, lpaout, base,&
                'OUI')
!
    call jedema()
end subroutine
