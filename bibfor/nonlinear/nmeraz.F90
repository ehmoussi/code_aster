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

subroutine nmeraz(sderro, typevt)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit     none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=24) :: sderro
    character(len=4) :: typevt
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (SD ERREUR)
!
! REMISE A ZERO DES EVENEMENTS
!
! ----------------------------------------------------------------------
!
!
! IN  SDERRO : SD GESTION DES ERREURS
! IN  TYPEVT : TYPE DE L'EVENEMENT
!              'TOUS' - TOUS LES EVENEMENTS
!              'EVEN' - EVENEMENT SIMPLE
!
! ----------------------------------------------------------------------
!
    integer :: ieven, zeven
    integer :: iret
    character(len=24) :: errinf
    integer :: jeinfo
    character(len=24) :: erraac, erreni
    integer :: jeeact, jeeniv
    character(len=16) :: teven
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- ACCES SD
!
    errinf = sderro(1:19)//'.INFO'
    call jeexin(errinf, iret)
    if (iret .eq. 0) goto 99
    call jeveuo(errinf, 'L', jeinfo)
    zeven = zi(jeinfo-1+1)
    erraac = sderro(1:19)//'.EACT'
    erreni = sderro(1:19)//'.ENIV'
    call jeveuo(erraac, 'E', jeeact)
    call jeveuo(erreni, 'L', jeeniv)
!
! --- EVENEMENTS DESACTIVES
!
    do 15 ieven = 1, zeven
        teven = zk16(jeeniv-1+ieven)(1:9)
        if (typevt .eq. 'TOUS') then
            zi(jeeact-1+ieven) = 0
        else if (typevt.eq.'EVEN') then
            if (teven .eq. 'EVEN') zi(jeeact-1+ieven) = 0
        else
            ASSERT(.false.)
        endif
15  end do
!
99  continue
!
    call jedema()
end subroutine
