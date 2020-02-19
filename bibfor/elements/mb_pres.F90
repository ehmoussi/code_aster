! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
! aslint: disable=W0413
! person_in_charge: mickael.abbas at edf.fr
!
subroutine mb_pres()
!
implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jevecd.h"
#include "asterfort/jevech.h"
#include "asterfort/rccoma.h"
#include "asterfort/tecach.h"
#include "asterfort/fointe.h"
#include "asterfort/utmess.h"
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: MEMBRANE
!
! Options: CHAR_MECA_PRES_*
!
! --------------------------------------------------------------------------------------------------
!
    character(len=32) :: phenom
    character(len=8) :: param
    integer :: k
    integer :: imate, icodre, itab(8), iret, jad, nbv, ier
    real(kind=8) :: pr
!
! --------------------------------------------------------------------------------------------------
!
    call jevech('PMATERC', 'L', imate)
    call rccoma(zi(imate), 'ELAS_MEMBRANE', 0, phenom, icodre)
! - Only small strains work with ELAS_MEMBRANE behavior
    if (icodre .eq. 0) then
        param='PPRESSR'
        call tecach('NNO', param, 'L', iret, nval=8, itab=itab)
        if (iret .eq. 0) then
            jad=itab(1)
            nbv=itab(2)
            ASSERT(itab(5).eq.1 .or. itab(5).eq.4)
            if (itab(5).eq.1) then
                do k=1,nbv
                    if (zr(jad-1+k).ne.0.d0) then
                        call utmess('F', 'CALCUL_48')
                    endif
                enddo
            else
                do k=1,nbv
                    if (zk8(jad-1+k).ne.'&FOZERO') then
                        call fointe(' ', zk8(jad-1+k), 0, ' ', [0.d0], pr, ier)
                        if (ier.eq.0 .and. pr.eq.0.d0) then
                            ! tout va bien ...
                        else
                            call utmess('F', 'CALCUL_48')
                        endif
                    endif
                enddo
            endif
        endif
    endif

end subroutine
