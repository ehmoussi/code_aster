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

subroutine cfcorn(newgeo, numno, coorno)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit     none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=19) :: newgeo
    integer :: numno
    real(kind=8) :: coorno(3)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODES DISCRETES - UTILITAIRE)
!
! COORDONNEES D'UN NOEUD
!
! ----------------------------------------------------------------------
!
!
! IN  NEWGEO : GEOMETRIE ACTUALISEE
! IN  NUMNO  : NUMERO ABSOLU DU NOEUD DANS LE MAILLAGE
! OUT COORNO : COORDONNEES DU NOEUD
!
!
!
!
    real(kind=8), pointer :: vale(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    coorno(1) = 0.d0
    coorno(2) = 0.d0
    coorno(3) = 0.d0
!
! --- COORDONNEES DU NOEUD
!
    call jeveuo(newgeo(1:19)//'.VALE', 'L', vr=vale)
    coorno(1) = vale(1+3*(numno -1))
    coorno(2) = vale(1+3*(numno -1)+1)
    coorno(3) = vale(1+3*(numno -1)+2)
!
    call jedema()
!
end subroutine
