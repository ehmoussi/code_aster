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

subroutine lisltc(lischa, ichar, typech)
!
!
    implicit     none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/lisnnb.h"
    character(len=19) :: lischa
    integer :: ichar
    character(len=8) :: typech
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE (LISTE_CHARGES)
!
! RETOURNE LE TYPE DE LA CHARGE
!
! ----------------------------------------------------------------------
!
!
! IN  LISCHA : SD LISTE DES CHARGES
! IN  ICHAR  : INDICE DE LA CHARGE
! OUT TYPECH : TYPE DE LA CHARGE
!               'REEL'    - CHARGE CONSTANTE REELLE
!               'COMP'    - CHARGE CONSTANTE COMPLEXE
!               'FONC_F0' - CHARGE FONCTION QUELCONQUE
!               'FONC_FT' - CHARGE FONCTION DU TEMPS
!
!
!
!
    character(len=24) :: typcha
    integer :: jtypc
    integer :: nbchar
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    typech = ' '
    call lisnnb(lischa, nbchar)
!
    if (nbchar .ne. 0) then
        typcha = lischa(1:19)//'.TYPC'
        call jeveuo(typcha, 'L', jtypc)
        typech = zk8(jtypc-1+ichar)
    endif
!
    call jedema()
end subroutine
