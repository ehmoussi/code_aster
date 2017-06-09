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

function dinins(sddisc, nume_inst)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utdidt.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer :: dinins
    integer, intent(in) :: nume_inst
    character(len=19), intent(in) :: sddisc
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (UTILITAIRE - DISCRETISATION)
!
! ACCES AU NIVEAU DE SUBDIVISION D'UN INSTANT
!
! --------------------------------------------------------------------------------------------------
!
! In  sddisc           : datastructure for time discretization
! IN  nume_inst        : NUMERO DE L'INSTANT
! OUT DININS           : NIVEAU DE SUBDIVISION DE L'INSTANT (1=PAS REDECOUPE)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=24) :: sddisc_dini
    integer, pointer :: v_sddisc_dini(:) => null()
    character(len=16) :: metlis
!
! --------------------------------------------------------------------------------------------------
!
!
! --- LA NOTION DE SOUS-NIVEAU N'EXISTE PAS EN GESTION AUTO
!
    call utdidt('L', sddisc, 'LIST', 'METHODE',&
                valk_ = metlis)
    if (metlis .eq. 'AUTO') then
        dinins = 1
        goto 999
    endif
!
! --- ACCES SD LISTE D'INSTANTS
!
    sddisc_dini = sddisc(1:19)//'.DINI'
    call jeveuo(sddisc_dini, 'L', vi = v_sddisc_dini)
    ASSERT(nume_inst.ge.1)
    dinins = v_sddisc_dini(nume_inst)
!
999 continue
end function
