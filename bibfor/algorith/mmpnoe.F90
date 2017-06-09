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

subroutine mmpnoe(defico, posmae, alias, typint, iptm,&
                  posnoe)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/cfconn.h"
#include "asterfort/cfnben.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    character(len=8) :: alias
    character(len=24) :: defico
    integer :: iptm
    integer :: posmae, posnoe
    integer :: typint
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
!
! DONNE LE NUMERO DU NOEUD DANS SD CONTACT SI INTEGRATION AUX NOEUDS
!
! ----------------------------------------------------------------------
!
!
! IN  TYPINT : TYPE D'INTEGRATION
! IN  IPTM   : NUMERO DU POINT D'INTEGRATION DANS LA MAILLE
! IN  ALIAS  : NOM D'ALIAS DE L'ELEMENT
! IN  POSMAE : POSITION DE LA MAILLE ESCLAVE DANS LES SD CONTACT
! IN  DEFICO : SD POUR LA DEFINITION DE CONTACT
! IN  TYPINT : TYPE D'INTEGRATION
! OUT POSNOE : POSITION DU NOEUD ESCLAVE SI INTEG. AUX NOEUDS
!
!
!
!
    integer :: nbnoe, jdecne, inoe
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    posnoe = 0
!
! --- NOEUD ESCLAVE SI INTEGRATION AUX NOEUDS
!
    if (typint .eq. 1) then
        inoe = iptm
!       GLUTE POUR QUAD8 POUR LEQUEL NBNOE=8<NBPC=9
        if (alias .eq. 'QU8') then
            posnoe = -1
        else
            call cfnben(defico, posmae, 'CONNEX', nbnoe, jdecne)
            if (inoe .le. nbnoe) then
                call cfconn(defico, jdecne, inoe, posnoe)
            else
                ASSERT(.false.)
            endif
        endif
    else
        posnoe = 0
    endif
!
    call jedema()
!
end subroutine
