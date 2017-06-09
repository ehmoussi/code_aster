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

function lisico(genchz, genrec)
!
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/isdeco.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/lisdef.h"
    aster_logical :: lisico
    character(len=*) :: genchz
    integer :: genrec
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE (LISTE_CHARGES)
!
! RETOURNE .TRUE. SI LA CHARGE EST DU GENRE DONNE
!
! ----------------------------------------------------------------------
!
! IN  GENCHA : GENRE DE LA CHARGE (VOIR LISDEF)
! IN  GENREC : CODE POUR LE GENRE DE LA CHARGE
!
! ----------------------------------------------------------------------
!
    integer :: tabcod(30), iposit(2), ibid
    character(len=8) :: k8bid
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    lisico = .false.
    call lisdef('POSG', genchz, ibid, k8bid, iposit)
    call isdeco([genrec], tabcod, 30)
    if (tabcod(iposit(1)) .eq. 1) lisico = .true.
!
    call jedema()
end function
