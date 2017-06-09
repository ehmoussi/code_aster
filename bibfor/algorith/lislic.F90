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

subroutine lislic(nomo, prefob, indxch, ligcal)
!
!
    implicit     none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/lisdef.h"
    character(len=8) :: nomo
    character(len=13) :: prefob
    integer :: indxch
    character(len=19) :: ligcal
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE (LISTE_CHARGES)
!
! RETOURNE LE LIGREL SUR LEQUEL ON FAIT LE CALCUL
!
! ----------------------------------------------------------------------
!
!
! IN  MODELE : NOM DU MODELE
! IN  PREFOB : PREFIXE DE L'OBJET DE LA CHARGE
! IN  INDXCH : INDICE DU TYPE DE CHARGE
! OUT LIGCAL : NOM DU LIGREL SUR LEQUEL ON FAIT LE CALCUL
!
!
!
!
    character(len=6) :: typlig
    integer :: ibid(2)
    character(len=19) :: ligrmo
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    call lisdef('LIGC', ' ', indxch, typlig, ibid)
    ligrmo = nomo(1:8)//'.MODELE'
    if (typlig .eq. 'LIGRMO') then
        ligcal = ligrmo
    else if (typlig.eq.'LIGRCH') then
        ligcal = prefob//'.LIGRE'
    else
        ASSERT(.false.)
    endif
!
!
    call jedema()
end subroutine
