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

subroutine te0119(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/jevech.h"
#include "asterfort/teattr.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
!
    character(len=16) :: option, nomte
! person_in_charge: jacques.pellet at edf.fr
! ======================================================================
!  BUT:  CALCUL DE L'OPTION VERI_CARA_ELEM
! ......................................................................
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
! aslint: disable=W0104
    character(len=8) :: alias8
    character(len=24) :: valk(3)
    integer :: j1, ibid, iadzi, iazk24
    real(kind=8) :: excent
    character(len=3) :: cmod
!     ------------------------------------------------------------------
!
!
!     1. RECUPERATION DU CODE DE LA MODELISATION (CMOD) :
!     ---------------------------------------------------
    call teattr('S', 'ALIAS8', alias8, ibid)
    cmod=alias8(3:5)
!
!
!     2. VERIFICATION QUE L'EXCENTREMENT EST NUL POUR
!        CERTAINES MODELISATIONS: COQUE_3D
!     --------------------------------------------------
    if ( cmod .eq. 'CQ3') then
        call jevech('PCACOQU', 'L', j1)
            excent=zr(j1-1+6)
        if (nint(excent) .ne. 0) then
            call tecael(iadzi, iazk24)
            valk(1)=zk24(iazk24-1+3)(1:8)
            call utmess('F', 'CALCULEL2_31', sk=valk(1))
        endif
    endif
!
!
end subroutine
