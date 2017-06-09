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

subroutine tranma(geomi, d, bidim)
    implicit none
!
!     BUT : TRANSLATION D'UN MAILLAGE
!
!     IN :
!            GEOMI  : CHAM_NO(GEOM_R) : CHAMP DE GEOMETRIE A TRANSLATER
!            DIR    : VECTEUR DE TRANSLATION
!     OUT:
!            GEOMI  : CHAM_NO(GEOM_R) : CHAMP DE GEOMETRIE ACTUALISE
!
!
! ----------------------------------------------------------------------
!
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    integer :: n1, i, iadcoo
    aster_logical :: bidim
    character(len=19) :: geomi
    character(len=24) :: coorjv
    real(kind=8) :: d(3)
!
    call jemarq()
    coorjv=geomi(1:19)//'.VALE'
    call jeveuo(coorjv, 'E', iadcoo)
    call jelira(coorjv, 'LONMAX', n1)
    n1=n1/3
    iadcoo=iadcoo-1
    if (bidim) then
        do 10 i = 1, n1
            zr(iadcoo+3*(i-1)+1)=zr(iadcoo+3*(i-1)+1)+d(1)
            zr(iadcoo+3*(i-1)+2)=zr(iadcoo+3*(i-1)+2)+d(2)
 10     continue
    else
        do 20 i = 1, n1
            zr(iadcoo+3*(i-1)+1)=zr(iadcoo+3*(i-1)+1)+d(1)
            zr(iadcoo+3*(i-1)+2)=zr(iadcoo+3*(i-1)+2)+d(2)
            zr(iadcoo+3*(i-1)+3)=zr(iadcoo+3*(i-1)+3)+d(3)
 20     continue
    endif
    call jedema()
end subroutine
