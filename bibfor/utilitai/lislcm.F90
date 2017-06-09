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

subroutine lislcm(lischa, ichar, motclc)
!
    implicit     none
!
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/lisnnb.h"
!
!
    character(len=19) :: lischa
    integer :: ichar
    integer :: motclc(2)
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE (LISTE_CHARGES)
!
! RETOURNE LE CODE DES MOT-CLEFS DE LA CHARGE
!
! ----------------------------------------------------------------------
!
!
! IN  LISCHA : SD LISTE DES CHARGES
! IN  ICHAR  : INDICE DE LA CHARGE
! OUT MOTCLC : CODE (ENTIER CODE) CONTENANT LES MOTS-CLEFS
!
! ----------------------------------------------------------------------
!
    character(len=24) :: mocfch
    integer :: jmcfc
    integer :: nbchar
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    motclc(1) = 0
    motclc(2) = 0
    call lisnnb(lischa, nbchar)
!
    if (nbchar .ne. 0) then
        mocfch = lischa(1:19)//'.MCFC'
        call jeveuo(mocfch, 'L', jmcfc)
        motclc(1) = zi(jmcfc-1+2*(ichar-1)+1)
        motclc(2) = zi(jmcfc-1+2*(ichar-1)+2)
    endif
!
    call jedema()
end subroutine
