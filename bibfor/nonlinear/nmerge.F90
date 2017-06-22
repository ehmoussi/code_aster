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

subroutine nmerge(sderro, nomevt, lactiv)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=24) :: sderro
    character(len=9) :: nomevt
    aster_logical :: lactiv
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (SD ERREUR)
!
! DIT SI UN EVENEMENT EST DECLENCHE
!
! ----------------------------------------------------------------------
!
!
! IN  SDERRO : SD GESTION DES ERREURS
! IN  NOMEVT : NOM DE L'EVENEMENT (VOIR LA LISTE DANS NMCRER)
! OUT LACTIV : .TRUE. SI EVENEMENT ACTIVE
!
!
!
!
    integer :: zeven
    integer :: ieven, icode
    character(len=24) :: errinf
    integer :: jeinf
    character(len=24) :: erreno, erraac
    integer :: jeenom, jeeact
    character(len=16) :: neven
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    lactiv = .false.
!
! --- ACCES SD
!
    errinf = sderro(1:19)//'.INFO'
    call jeveuo(errinf, 'L', jeinf)
    zeven = zi(jeinf-1+1)
!
    erreno = sderro(1:19)//'.ENOM'
    erraac = sderro(1:19)//'.EACT'
    call jeveuo(erreno, 'L', jeenom)
    call jeveuo(erraac, 'L', jeeact)
!
    do 15 ieven = 1, zeven
        neven = zk16(jeenom-1+ieven)
        if (neven .eq. nomevt) then
            icode = zi(jeeact-1+ieven)
            if (icode .eq. 1) lactiv = .true.
        endif
 15 end do
!
    call jedema()
end subroutine
