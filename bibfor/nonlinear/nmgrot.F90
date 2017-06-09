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

subroutine nmgrot(iran, deldet, theta, chamaj)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/proqua.h"
#include "asterfort/quavro.h"
#include "asterfort/vroqua.h"
    real(kind=8) :: theta(3), deldet(3)
    integer :: iran(3)
    real(kind=8) :: chamaj(*)
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (ALGORITHME - UTILITAIRE - DYNAMIQUE)
!
! MISE A JOUR DES DEPLACEMENTS EN GRANDES ROTATIONS
! POUR POU_D_GD
!
! ----------------------------------------------------------------------
!
!
! IN  POUGD  : VARIABLE CHAPEAU POUR POUTRES EN GRANDES ROTATIONS
! IN  THETA  : VALEUR DE LA ROTATION PRECEDENTE
! IN  IRAN   : NUMEROS ABSOLUS D'EQUATION DES DDL DE ROTATION DANS LES
!                 CHAM_NO
! OUT CHAMAJ : CHAMP MISE A JOUR
!
!
!
!
    integer :: ic
    real(kind=8) :: quapro(4), quarot(4), delqua(4)
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
!
! --- QUATERNION DE LA ROTATION PRECEDENTE
!
    call vroqua(theta, quarot)
!
! --- QUATERNION DE L'INCREMENT DE ROTATION
!
    call vroqua(deldet, delqua)
!
! --- CALCUL DE LA NOUVELLE ROTATION
!
    call proqua(delqua, quarot, quapro)
    call quavro(quapro, theta)
!
! --- MISE A JOUR DE LA ROTATION
!
    do 15 ic = 1, 3
        chamaj(iran(ic)) = theta (ic)
15  end do
!
!
    call jedema()
end subroutine
