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

subroutine jevecd(nompar, jad, valdef)
use calcul_module, only : ca_option_
implicit none
! person_in_charge: jacques.pellet at edf.fr
!----------------------------------------------------------------
! but : rendre l'adresse du champ local (jad) correspondant
!       au parametre nompar (comme le fait jevech).
!       - si le champ local est completement vide, la routine
!         l'initialise a la valeur par defaut valdef.
!       - si le champ local est partiellement vide, la routine
!         emet une erreur fatale
!----------------------------------------------------------------
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/contex_param.h"
#include "asterfort/tecach.h"
#include "asterfort/utmess.h"

    integer :: itab(8), jad, lonel, k, iret
    character(len=*) :: nompar
    real(kind=8) :: valdef
!----------------------------------------------------------------

    call tecach('OON', nompar, 'L', iret, nval=8,&
                itab=itab)
    ASSERT((iret.eq.0).or.(iret.eq.3))

    jad=itab(1)
    if (iret .eq. 3) then
        ASSERT(itab(5).eq.1)
        lonel=itab(2)*max(1,itab(6))*max(1,itab(7))
        do k = 1,lonel
            if (zl(itab(8)-1+k)) then
                call utmess('E', 'CALCUL_44')
                call contex_param(ca_option_, nompar)
            endif
            zr(jad-1+k)=valdef
        enddo
    endif

end subroutine
