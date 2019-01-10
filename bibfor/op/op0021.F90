! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

subroutine op0021()
    implicit none
! ----------------------------------------------------------------------
!     BUT:
!       IMPRESSION DES CARTES DE DONNEES DE CHAM_MATER, CARA_ELEM, CHARGE ...
!       PROCEDURE IMPR_CONCEPT
!
#include "asterfort/getvis.h"
#include "asterfort/getvtx.h"
#include "asterfort/infmaj.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"  
#include "asterfort/ulaffe.h"
#include "asterfort/ulexis.h"
#include "asterfort/ultype.h"
#include "asterfort/ulopen.h"
#include "asterfort/utmess.h"
#include "asterfort/w039ca.h"


    integer :: ifc, ifi  
    integer :: n11 
    integer :: nforma 
!
    character(len=1) :: typf
    character(len=8) :: form 

    character(len=16) :: fich

! ----------------------------------------------------------------------
!
    call jemarq()
    call infmaj()
!           
!     ---------------------------------------------
!     --- FORMAT, FICHIER ET UNITE D'IMPRESSION ---
!     ---------------------------------------------
!
!     --- FORMAT ---
    call getvtx(' ', 'FORMAT', scal=form, nbret=nforma)

!     --- FICHIER ---
    ifi = 0
    fich = 'F_'//form
    call getvis(' ', 'UNITE', scal=ifi, nbret=n11)
    ifc = ifi
    if (.not. ulexis( ifi )) then
        if (form .eq.'MED')then
            call ulaffe(ifi, ' ', fich, 'NEW', 'O')
        else
            call ulopen(ifi, ' ', fich, 'NEW', 'O')
        endif
    elseif (form .eq.'MED') then
        call ultype(ifi, typf)
        if (typf .ne. 'B' .and. typf .ne. 'L') then
        call utmess('A','PREPOST3_7')
        endif
    endif


!     -- IMPRESSION DES CARTES DE DONNEES DE CHAM_MATER,  ... :   
    call w039ca(ifi, form)
!
    call jedema()
end subroutine
