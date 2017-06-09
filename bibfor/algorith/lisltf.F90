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

subroutine lisltf(lischa, ichar, typfct)
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
    character(len=16) :: typfct
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE (LISTE_CHARGES)
!
! RETOURNE LE TYPE DE LA FONCTION MULTIPLICATRICE
!
! ----------------------------------------------------------------------
!
!
! IN  LISCHA : SD LISTE DES CHARGES
! IN  ICHAR  : INDICE DE LA CHARGE
! OUT TYPFCT : TYPE DE LA FONCTION MULTIPLICATRICE
!              'FONCT_REEL' FONCTION MULTIPLICATRICE REELLE
!              'FONCT_COMP' FONCTION MULTIPLICATRICE COMPLEXE
!              'CONST_REEL' FONCTION MULTIPLICATRICE CONSTANTE REELLE
!              'CONST_COMP' FONCTION MULTIPLICATRICE CONSTANTE COMPLEXE
!
!
!
!
    character(len=24) :: typfon
    integer :: jtfon
    integer :: nbchar
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    typfct = ' '
    call lisnnb(lischa, nbchar)
!
    if (nbchar .ne. 0) then
        typfon = lischa(1:19)//'.TFON'
        call jeveuo(typfon, 'L', jtfon)
        typfct = zk16(jtfon-1+ichar)
    endif
!
    call jedema()
end subroutine
