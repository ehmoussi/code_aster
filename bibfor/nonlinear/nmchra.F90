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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine nmchra(sddyna, l_renumber, optamo, lcamor)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/infdbg.h"
#include "asterfort/ndynlo.h"
#include "asterfort/utmess.h"
!
character(len=19) :: sddyna
aster_logical :: l_renumber
character(len=16) :: optamo
aster_logical :: lcamor
!
! --------------------------------------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (CALCUL)
!
! CHOIX DE REASSEMBLAGE DE LA MATRICE D'AMORTISSEMENT
!
! --------------------------------------------------------------------------------------------------
!
! IN  SDDYNA : SD DYNAMIQUE
! In  l_renumber       : .true. if renumber
! OUT OPTAMO : OPTION POUR L'AMORTISSEMENT
! OUT LCAMOR : .TRUE. SI CALCUL MATRICE D'AMORTISSEMENT
!
! --------------------------------------------------------------------------------------------------
!
    aster_logical :: lktan
    integer :: ifm, niv
!
! --------------------------------------------------------------------------------------------------
!
    call infdbg('MECANONLINE', ifm, niv)
!
! --- INITIALISATIONS
!
    lcamor = .false.
    optamo = 'AMOR_MECA'
!
! --- FONCTIONNALITES ACTIVEES
!
    lktan = ndynlo(sddyna,'RAYLEIGH_KTAN')
!
! --- REACTUALISATION DE LA MATRICE D'AMORTISSEMENT DE RAYLEIGH
!
    if (l_renumber .or. lktan) then
        lcamor = .true.
    endif
!
! - Print
!
    if (niv .ge. 2) then
        if (lcamor) then
            call utmess('I', 'MECANONLINE13_37')
        else
            call utmess('I', 'MECANONLINE13_38')
        endif
    endif
!
end subroutine
