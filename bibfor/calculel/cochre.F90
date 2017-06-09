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

subroutine cochre(kchar, nbchar, nbchre, iocc)
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
    integer :: nbchar, nbchre, iocc
    character(len=*) :: kchar(*)
!     ROUTINE QUI VERIFIE SUR UNE LISTE DE CHARGE LA PRESENCE D'UNE
!     SEULE CHARGE REPARTIE ET FOURNIT LE NUMERO D'OCCURENCE QUI
!     CORRESPOND A CETTE CHARGE
!
!     IN  : KCHAR   : LISTE DES CHARGES ET DES INFOS SUR LES CHARGES
!     IN  : NBCHAR   : NOMBRE DE CHARGE
!     OUT : NBCHRE   : NOMBRE DE CHARGES REPARTIES
!     OUT : IOCC     : NUMERO D'OCCURENCE DU MOT-CLE FACTEUR EXCIT
!                      CORRESPONDANT A LA CHARGE REPARTIE
! ----------------------------------------------------------------------
!
    character(len=19) :: chrrep, chpesa
! DEB-------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: i, iret1, iret2
!-----------------------------------------------------------------------
    call jemarq()
    nbchre = 0
    iocc = 0
!
    do 10 i = 1, nbchar
        chrrep = kchar(i)(1:8)//'.CHME.F1D1D'
        chpesa = kchar(i)(1:8)//'.CHME.PESAN'
!
        call jeexin(chrrep//'.DESC', iret1)
        call jeexin(chpesa//'.DESC', iret2)
!
        if (iret1 .ne. 0) then
            nbchre = nbchre + 1
            iocc = i
        else if (iret2 .ne. 0) then
            nbchre = nbchre + 1
            iocc = i
        endif
10  end do
!
    call jedema()
end subroutine
