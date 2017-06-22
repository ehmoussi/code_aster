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

subroutine decod1(rec, irec, ifield, valatt, trouve)
    implicit none
#include "asterf_types.h"
#include "asterfort/lxliis.h"
#include "asterfort/trfmot.h"
    character(len=*) :: rec(20)
    integer :: irec, ifield, valatt
    aster_logical :: trouve
!
!    VERIFICATION : L'ENTETE DU DATASET LU EST-IL CELUI RECHERCHE ?
!                   COMPARAISON ENTETE / SD FORMAT_IDEAS
!
! IN  : REC    : K80  : TABLEAU DE CARACTERES CONTENANT L'ENTETE DU
!                       DATASET
! IN  : IREC   : I    : NUMERO DE L'ENREGISTREMENT A TRAITER
! IN  : IFIELD : I    : NUMERO DU CHAMP A TRAITER
! IN  : VALATT : I    : VALEUR ATTENDUE
! OUT : TROUVE : L    : .TRUE.  ON A TROUVE LA VALEUR ATTENDUE
!                       .FALSE. ON N A PAS TROUVE LA VALEUR ATTENDUE
!
!----------------------------------------------------------------------
!
    integer :: ilu, ier
    character(len=80) :: field
!
!- RECHERCHE DU CHAMP A TRAITER
!
    call trfmot(rec(irec), field, ifield)
!
!- DECODAGE D'UN ENTIER
!
    call lxliis(field, ilu, ier)
!
!- LA VALEUR TROUVEE N'EST PAS UN ENTIER
!
    if (ier .eq. 1) trouve = .false.
!
!- LA VALEUR TROUVEE (ENTIERE) EST-ELLE CELLE ATTENDUE?
!
    if (ilu .eq. valatt) then
        trouve = .true.
    else
        trouve = .false.
    endif
!
end subroutine
