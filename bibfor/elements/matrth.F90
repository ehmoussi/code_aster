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

subroutine matrth(fami, npg, young, nu, alpha,&
                  indith)
!
    implicit none
!
!
#include "jeveux.h"
#include "asterfort/jevech.h"
#include "asterfort/moytem.h"
#include "asterfort/rccoma.h"
#include "asterfort/rcvala.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"
    integer :: iret
!
    real(kind=8) :: valres(26)
    integer :: icodre(26)
    character(len=8) :: nompar
    character(len=16) :: nomres(26)
    character(len=32) :: phenom
    real(kind=8) :: young, nu, alpha
    integer :: npg
    character(len=4) :: fami
!
!
!-----------------------------------------------------------------------
    integer :: indith, jcou, jmate
    real(kind=8) :: temp
!-----------------------------------------------------------------------
    indith=0
    nompar = 'TEMP'
!
    call jevech('PMATERC', 'L', jmate)
!
    call rccoma(zi(jmate), 'ELAS', 1, phenom, icodre(1))
!
    if (phenom .eq. 'ELAS') then
!
        call jevech('PNBSP_I', 'L', jcou)
!
        nomres(1)='E'
        nomres(2)='NU'
        nomres(3)='ALPHA'
!
        call moytem(fami, npg, 3*zi(jcou), '+', temp,&
                    iret)
        call rcvala(zi(jmate), ' ', phenom, 1, nompar,&
                    [temp], 3, nomres, valres, icodre,&
                    1)
        if (icodre(3) .ne. 0) then
            indith = -1
            goto 999
        endif
!
!     MATERIAU ISOTROPE
!
        young = valres(1)
        nu = valres(2)
        alpha = valres(3)
!
    else if (phenom .eq. 'ELAS_ORTH') then
        nomres(1)='ALPHA_L'
        nomres(2)='ALPHA_T'
        call rcvalb(fami, 1, 1, '+', zi(jmate),&
                    ' ', phenom, 0, nompar, [temp],&
                    2, nomres, valres, icodre, 1)
        if (icodre(1) .ne. 0) then
            indith = -1
            goto 999
        else
            if ((valres(1).eq.0.d0) .and. (valres(2).eq.0.d0)) then
                indith = -1
                goto 999
            else
                call utmess('F', 'ELEMENTS2_33')
            endif
        endif
    else
        call utmess('F', 'ELEMENTS_45', sk=phenom)
    endif
!
!
999 continue
end subroutine
