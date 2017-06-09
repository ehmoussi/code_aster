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

function lisnbg(lischa, genchz)
!
!
    implicit none
    integer :: lisnbg
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/lisico.h"
#include "asterfort/lislco.h"
#include "asterfort/lisnnb.h"
    character(len=19) :: lischa
    character(len=*) :: genchz
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE (LISTE_CHARGES)
!
! RETOURNE LE NOMBRE DE CHARGES DE TYPE GENCHA
!
! ----------------------------------------------------------------------
!
!
! IN  LISCHA : SD LISTE DES CHARGES
! IN  GENCHA : GENRE DE LA CHARGE (VOIR LISDEF)
!
! ----------------------------------------------------------------------
!
    integer :: ichar, nbchar
    integer :: genrec
    aster_logical :: lok
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    lisnbg = 0
!
! --- NOMBRE DE CHARGES
!
    call lisnnb(lischa, nbchar)
    if (nbchar .eq. 0) goto 999
!
! --- BOUCLE SUR LES CHARGES
!
    do 10 ichar = 1, nbchar
        call lislco(lischa, ichar, genrec)
        lok = lisico(genchz,genrec)
        if (lok) lisnbg = lisnbg + 1
 10 continue
!
999 continue
!
    call jedema()
end function
