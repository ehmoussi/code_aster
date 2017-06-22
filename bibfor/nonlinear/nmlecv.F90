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

subroutine nmlecv(sderro, nombcl, lconv)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/nmleeb.h"
    character(len=24) :: sderro
    character(len=4) :: nombcl
    aster_logical :: lconv
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME)
!
! BOUCLE CONVERGEE OU PAS ?
!
! ----------------------------------------------------------------------
!
!
! IN  SDERRO : SD GESTION DES ERREURS
! IN  NOMBCL : NOM DE LA BOUCLE
!               'RESI' - RESIDUS D'EQUILIBRE
!               'NEWT' - BOUCLE DE NEWTON
!               'FIXE' - BOUCLE DE POINT FIXE
!               'INST' - BOUCLE SUR LES PAS DE TEMPS
! OUT LCONV  : .TRUE. SI LA BOUCLE EST DANS L'ETAT CONVERGE
!
!
!
!
    character(len=4) :: etabcl
!
! ----------------------------------------------------------------------
!
    lconv = .false.
    call nmleeb(sderro, nombcl, etabcl)
    lconv = (etabcl.eq.'CONV')
!
end subroutine
