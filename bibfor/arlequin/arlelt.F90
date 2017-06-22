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

function arlelt(nomte, mod, cin)
!
!
!
!
!
    implicit none
#include "asterf_types.h"
    aster_logical :: arlelt
    character(len=16) :: nomte
    character(len=16) :: mod
    character(len=16) :: cin
!
! ----------------------------------------------------------------------
!
! ROUTINE ARLEQUIN
!
! RETOURNE .TRUE. SI LE TYPE D'ELEMENT EST RECONNU COMME ETANT VALIDE
! POUR ARLEQUIN ET DONNE LE TYPE DE MODELISATION ET DE CINEMATIQUE
!
! ----------------------------------------------------------------------
!
!
! NB: EXCLU LES BORDS/ARETES
!
! IN  NOMTE  : NOM DU TE
! OUT MOD    : TYPE DE MODELISATION
!              'DPLAN'  ELEMENT DE DEFORMATIONS PLANES
!              'CPLAN'  ELEMENT DE CONTRAINTES PLANES
!              'AXIS'   ELEMENT AXISYMETRIQUE
!              '3D'     ELEMENT 3D POUR SOLIDE
!                       DKT/DST/COQUE_3D/Q4G POUR COQUE
! OUT CIN    : TYPE DE CINEMATIQUE
!              'SOLIDE'
!              'POUTRE'
!
! ----------------------------------------------------------------------
    arlelt = .false.
!
    if (nomte(1:5) == 'MECA_') then
        mod = '3D'
        if ((nomte(6:10) == 'PENTA') .or. (nomte(6:9) == 'HEXA') .or.&
            (nomte(6:10) == 'TETRA')) then
            cin = 'SOLIDE'
            arlelt = .true.
        else if (nomte(6:8) == 'POU') then
            cin = 'POUTRE'
            arlelt = .true.
        else
            arlelt = .false.
        endif
    else
        arlelt = .false.
    endif
!
end function
