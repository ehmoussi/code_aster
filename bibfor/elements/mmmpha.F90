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

subroutine mmmpha(loptf, lcont, ladhe, ndexfr, lpenac,&
                  lpenaf, phasep)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
    aster_logical :: lpenaf, lpenac
    aster_logical :: loptf, lcont, ladhe
    integer :: ndexfr
    character(len=9) :: phasep
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - CALCUL)
!
! PREPARATION DES CALCULS - PHASE DE CALCUL
!
! ----------------------------------------------------------------------
!
!
! IN  LOPTF  : .TRUE. SI OPTION DE FROTTEMENT
! IN  LCONT  : .TRUE. SI CONTACT (SU=1)
! IN  LADHE  : .TRUE. SI ADHERENCE
! IN  LPENAC : .TRUE. SI CONTACT PENALISE
! IN  LPENAF : .TRUE. SI FROTTEMENT PENALISE
! IN  NDEXFR : ENTIER CODE POUR EXCLUSION DIRECTION DE FROTTEMENT
! OUT PHASEP : 'SANS' - PAS DE CONTACT
!              'CONT' - CONTACT
!              'ADHE' - CONTACT ADHERENT
!              'GLIS' - CONTACT GLISSANT
!              'SANS_PENA' - PENALISATION - PAS DE CONTACT
!              'CONT_PENA' - PENALISATION - CONTACT
!              'ADHE_PENA' - PENALISATION - CONTACT ADHERENT
!              'GLIS_PENA' - PENALISATION - CONTACT GLISSANT
!
! ----------------------------------------------------------------------
!
    character(len=4) :: phase
!
! ----------------------------------------------------------------------
!
    phase = ' '
    phasep = ' '
!
! --- PHASE PRINCIPALE
!
    if (loptf) then
        if (lcont) then
            if (ladhe) then
                phase = 'ADHE'
            else
                phase = 'GLIS'
            endif
        else
            phase = 'SANS'
        endif
    else
        ndexfr = 0
        if (lcont) then
            phase = 'CONT'
        else
            phase = 'SANS'
        endif
    endif
!
! --- PRISE EN COMPTE DE LA PENALISATION
!
    if (phase .eq. 'SANS') then
        if (lpenac .or. lpenaf) then
            phasep = phase(1:4)//'_PENA'
        else
            phasep = phase(1:4)
        endif
    else if (phase.eq.'CONT') then
        if (lpenac) then
            phasep = phase(1:4)//'_PENA'
        else
            phasep = phase(1:4)
        endif
    else if ((phase.eq.'ADHE').or.(phase.eq.'GLIS')) then
        if (lpenaf) then
            phasep = phase(1:4)//'_PENA'
        else
            phasep = phase(1:4)
        endif
    else
        ASSERT(.false.)
    endif
!
end subroutine
