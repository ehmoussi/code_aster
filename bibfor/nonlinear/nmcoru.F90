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

subroutine nmcoru(vresi, vresid, convok)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
    real(kind=8) :: vresi, vresid
    aster_logical :: convok
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - CONVERGENCE)
!
! VERIFICATION DES CRITERES D'ARRET SUR RESIDU - OPTION PIC
!
! ----------------------------------------------------------------------
!
!
! IN  VRESI  : NORME MAXI DU RESIDU A EVALUER
! IN  VRESID : DONNEE UTILISATEUR POUR CONVERGENCE
! OUT CONVOK . .TRUE. SI CRITERE RESPECTE
!
! ----------------------------------------------------------------------
!
    convok = .true.
    if ((vresi.gt.vresid) .or. (vresi.lt.0.d0)) then
        convok = .false.
    endif
end subroutine
