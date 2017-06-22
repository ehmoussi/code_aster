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

subroutine dierre(sddisc, sdcrit, iterat)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmlere.h"
    integer :: iterat
    character(len=19) :: sddisc, sdcrit
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (UTILITAIRE)
!
! ENREGISTRE LES RESIDUS
!
! ----------------------------------------------------------------------
!
!
! IN  SDDISC : SD DISCRETISATION
! IN  SDCRIT : SD CRITERE
! IN  ITERAT : NUMERO ITERATION NEWTON
!
!
!
!
!
    character(len=24) :: critcr
    integer :: jcrr
    real(kind=8) :: vrela(1), vmaxi(1), vchar(1)
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- ENREGISTRE LES RESIDUS A CETTE ITERATION
!
    critcr = sdcrit(1:19)//'.CRTR'
    call jeveuo(critcr, 'L', jcrr)
    vrela(1) = zr(jcrr+3-1)
    vmaxi(1) = zr(jcrr+4-1)
    vchar(1) = zr(jcrr+6-1)
    call nmlere(sddisc, 'E', 'VRELA', iterat, vrela(1))
    call nmlere(sddisc, 'E', 'VMAXI', iterat, vmaxi(1))
    call nmlere(sddisc, 'E', 'VCHAR', iterat, vchar(1))
!
    call jedema()
end subroutine
