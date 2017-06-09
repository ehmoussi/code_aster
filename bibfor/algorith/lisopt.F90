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

subroutine lisopt(prefob, nomo, typech, indxch, option,&
                  parain, paraou, carte, ligcal)
!
!
    implicit     none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/lisdef.h"
#include "asterfort/lislic.h"
    integer :: indxch
    character(len=8) :: nomo
    character(len=16) :: option
    character(len=19) :: carte, ligcal
    character(len=8) :: parain, paraou
    character(len=8) :: typech
    character(len=13) :: prefob
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE (LISTE_CHARGES)
!
! CREATION OBJETS CONTENANT LA LISTE DES CHARGES POUR LE GENRE DONNE
!
! ----------------------------------------------------------------------
!
!
! IN  NOMO   : NOM DU MODELE
! IN  PREFOB : PREFIXE DE L'OBJET DE LA CHARGE
! IN  TYPECH : TYPE DE LA CHARGE
! IN  INDXCH : INDICE DU TYPE DE CHARGE
! OUT OPTION : NOM DE L'OPTION DE CALCUL
! OUT CARTE  : NOM DE LA CARTE
! OUT PARAIN : NOM DU PARAMETRE D'ENTREE
! OUT PARAOU : NOM DU PARAMETRE DE SORTIE
! OUT LIGCAL : NOM DU LIGREL SUR LEQUEL ON FAIT LE CALCUL
!
    character(len=24) :: nomobj
    integer :: itypob(2), ibid(2)
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    option = ' '
    parain = ' '
    paraou = ' '
    carte = ' '
    ligcal = ' '
!
! --- OPTION DE CALCUL
!
    call lisdef('OPTI', typech, indxch, option, ibid)
!
! --- NOM DE LA CARTE
!
    call lisdef('OBJE', prefob, indxch, nomobj, itypob)
!
! --- ON ATTEND UNE CARTE !
!
    if (itypob(1) .eq. 1) then
        carte = nomobj(1:19)
    else
        ASSERT(.false.)
    endif
!
! --- NOM DU PARAMETRE D'ENTREE
!
    call lisdef('PARA', typech, indxch, parain, ibid)
    if (typech .eq. 'COMP') then
        paraou = 'PVECTUC'
    else
        paraou = 'PVECTUR'
    endif
!
! --- LIGREL DE CALCUL
!
    call lislic(nomo, prefob, indxch, ligcal)
!
    call jedema()
end subroutine
