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

subroutine op0105()
    implicit none
!
!     OPERATEUR: ASSE_MAILLAGE
!
!-----------------------------------------------------------------------
!
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/asmaco.h"
#include "asterfort/asmael.h"
#include "asterfort/asmasu.h"
#include "asterfort/cargeo.h"
#include "asterfort/getvid.h"
#include "asterfort/getvtx.h"
#include "asterfort/infmaj.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    character(len=8) :: mag, dm(2)
    character(len=16) :: kbi1, kbi2
    character(len=8) :: oper
    integer :: n1,   ibid
    integer, pointer :: dim1(:) => null()
    integer, pointer :: dim2(:) => null()
!     ------------------------------------------------------------------
!
    call jemarq()
    call infmaj()
!
    call getvtx(' ', 'OPERATION', scal=oper, nbret=n1)
!
    call getres(mag, kbi1, kbi2)
    call getvid(' ', 'MAILLAGE_1', scal=dm(1), nbret=n1)
    call getvid(' ', 'MAILLAGE_2', scal=dm(2), nbret=n1)
!
!     --OBJET .TITR:
!     ---------------
    call wkvect(mag//'           .TITR', 'G V K80', 2, ibid)
    zk80(ibid)=' MAILLAGE OBTENU PAR CONCATENATION DES MAILLAGES : '
    zk80(ibid+1)='  '//dm(1)//' ET '//dm(2)
!
!
!     -- TRAITEMENT DU TYPE D OPERATION :
!     -----------------------------------
    if (oper(1:8) .eq. 'SOUS_STR') then
        call asmael(dm(1), dm(2), mag)
    else
!
        call jeveuo(dm(1)//'.DIME', 'L', vi=dim1)
        call jeveuo(dm(2)//'.DIME', 'L', vi=dim2)
        if ((dim1(4).ne.0) .or. (dim2(4).ne.0)) then
            call utmess('F', 'SOUSTRUC_16')
        endif
        if (oper(1:7) .eq. 'COLLAGE') then
            call asmaco(dm(1), dm(2), mag)
        else if (oper(1:7).eq.'SUPERPO') then
            call asmasu(dm(1), dm(2), mag)
        endif
    endif
!
!
!     --ON CALCULE LES CARACTERISTIQUES DU MAILLAGE:
!     ----------------------------------------------
!
    call cargeo(mag)
!
    call jedema()
end subroutine
