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

subroutine nmchra(sddyna, l_renumber, optamo, lcamor)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/infdbg.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/ndynlo.h"
    character(len=19) :: sddyna
    aster_logical :: l_renumber
    character(len=16) :: optamo
    aster_logical :: lcamor
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (CALCUL)
!
! CHOIX DE REASSEMBLAGE DE LA MATRICE D'AMORTISSEMENT
!
! ----------------------------------------------------------------------
!
!
! IN  SDDYNA : SD DYNAMIQUE
! In  l_renumber       : .true. if renumber
! OUT OPTAMO : OPTION POUR L'AMORTISSEMENT
! OUT LCAMOR : .TRUE. SI CALCUL MATRICE D'AMORTISSEMENT
!
!
!
!
    aster_logical :: lktan
    integer :: ifm, niv
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('MECA_NON_LINE', ifm, niv)
!
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        write (ifm,*) '<MECANONLINE><CALC> CHOIX D''ASSEMBLAGE DE '//&
        'MATRICE AMORTISSEMENT'
    endif
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
! --- AFFICHAGE
!
    if (niv .ge. 2) then
        if (lcamor) then
            write (ifm,*) '<MECANONLINE><CALC> ON ASSEMBLE LA MATRICE' //&
     &                  ' D''AMORTISSEMENT'
        else
            write (ifm,*) '<MECANONLINE><CALC> ON N''ASSEMBLE PAS '//&
            'LA MATRICE D''AMORTISSEMENT'
        endif
    endif
!
    call jedema()
!
end subroutine
