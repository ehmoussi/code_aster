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

subroutine juvinn(ojb)
    implicit none
#include "jeveux.h"
#include "asterc/r8nnem.h"
#include "asterc/r8vide.h"
#include "asterfort/assert.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=*) :: ojb
!     BUT : REMPLACER DANS L'OBJET JEVEUX DE NOM OJB (DE TYPE 'R')
!           LES VALEURS R8VIDE() PAR R8NNEM()
!     ------------------------------------------------------------------
! IN  OJB  : K24 : NOM DE L'OBJET A MODIFIER
!     ------------------------------------------------------------------
!
!
    character(len=8) :: type
    integer :: n1, k, jojb
    real(kind=8) :: rvid, rnan
!     ------------------------------------------------------------------
!
    call jemarq()
    call jelira(ojb, 'TYPE  ', cval=type)
    ASSERT(type.eq.'R')
!
    call jeveuo(ojb, 'L', jojb)
    call jelira(ojb, 'LONMAX', n1)
!
    rvid=r8vide()
    rnan=r8nnem()
    do 1, k=1,n1
    if (.not.isnan(zr(jojb-1+k))) then
        if (zr(jojb-1+k) .eq. rvid) zr(jojb-1+k)=rnan
    endif
    1 end do
!
    call jedema()
end subroutine
