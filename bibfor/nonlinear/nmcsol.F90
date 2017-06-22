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

subroutine nmcsol(lischa, sddyna, lviss)
!
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/ndynkk.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    aster_logical :: lviss
    character(len=19) :: lischa, sddyna
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (INITIALISATION)
!
! DETERMINE LA PRESENCE DE CHARGES FORCE_SOL
!
! ----------------------------------------------------------------------
!
!
! IN  LISCHA : SD LISTE DES CHARGES
! IN  SDDYNA : SD DYNAMIQUE
! OUT LVISS  : .TRUE SI PRESENCE D'UNE CHARGE FORCE_SOL
!
! ----------------------------------------------------------------------
!
    character(len=8) :: cnfsol
    character(len=24) :: charge, infcha
    integer :: jalich, jinfch
    integer :: nchar, ichar, nfsol
    character(len=24) :: nchsol
    integer :: jchsol
    character(len=15) :: sdexso
    character(len=19) :: sdexsz
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    lviss = .false.
    nfsol = 0
    cnfsol = ' '
    call ndynkk(sddyna, 'SDEXSO', sdexsz)
    sdexso = sdexsz(1:15)
!
! --- ACCES SD LISTE_CHARGES
!
    charge = lischa(1:19)//'.LCHA'
    infcha = lischa(1:19)//'.INFC'
    call jeveuo(charge, 'E', jalich)
    call jeveuo(infcha, 'E', jinfch)
    nchar = zi(jinfch)
!
! --- DETECTION CHARGE
!
    do 30 ichar = 1, nchar
        if (zi(jinfch+nchar+ichar) .eq. 20) then
            nfsol = nfsol + 1
            cnfsol = zk24(jalich+ichar-1)(1:8)
        endif
 30 end do
!
! --- ACTIVATION CHARGE
!
    if (nfsol .eq. 0) then
        lviss = .false.
    else if (nfsol.eq.1) then
        lviss = .true.
    else
        call utmess('F', 'DYNAMIQUE_9')
    endif
!
! --- NOM DE _LA_CHARGE
!
    if (lviss) then
        nchsol = sdexso(1:15)//'.CHAR'
        call wkvect(nchsol, 'V V K8', 1, jchsol)
        zk8(jchsol) = cnfsol
    endif
!
    call jedema()
!
end subroutine
