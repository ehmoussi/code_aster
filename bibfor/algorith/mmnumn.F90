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

subroutine mmnumn(noma, typint, nummae, nnomae, iptm,&
                  numnoe)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
!
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
    character(len=8) :: noma
    integer :: typint
    integer :: nummae, iptm, numnoe, nnomae
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - UTILITAIRE)
!
! NUMERO ABSOLU DU POINT DE CONTACT
!
! ----------------------------------------------------------------------
!
!
! IN  NOMA   : NOM DU MAILLAGE
! IN  TYPINT : TYPE D'INTEGRATION
! IN  NUMMAE : NUMERO ABSOLU DE LA MAILLE ESCLAVE
! IN  NNOMAE : NOMBRE DE NOEUDS DE LA MAILLE ESCLAVE
! IN  IPTM   : NUMERO DU POINT D'INTEGRATION DANS LA MAILLE
! OUT NUMNOE : NUMERO ABSOLU DU POINT DE CONTACT
!                  VAUT -1 SI LE POINT N'EST PAS UN NOEUD
!
!
!
!
!
    integer :: inoe, jconnx
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    numnoe = -1
!
! --- ACCES MAILLAGE
!
    call jeveuo(jexnum(noma//'.CONNEX', nummae), 'L', jconnx)
!
! --- NUMERO ABSOLU DU NOEUD
!
    if (typint .eq. 1) then
        if (iptm .gt. nnomae) then
            numnoe = -1
        else
            inoe = iptm
            numnoe = zi(jconnx+inoe-1)
        endif
    else
        numnoe = -1
    endif
!
    call jedema()
end subroutine
