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

subroutine rcevo1(nommat, fatizh, sm, para, symax)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/r8vide.h"
#include "asterfort/rccome.h"
#include "asterfort/rcvale.h"
#include "asterfort/utmess.h"
    real(kind=8) :: sm, para(*), symax
    aster_logical :: fatizh
    character(len=8) :: nommat
!     OPERATEUR POST_RCCM, TYPE_RESU_MECA='EVOLUTION'
!     LECTURE DU MOT CLE SIMPLE "MATER"
!
!     ------------------------------------------------------------------
!
    integer :: nbpar
    real(kind=8) :: valres(3), erefe(1), e(1), rbid, tsm(1)
    integer :: icodre(3)
    character(len=8) :: nompar, nomval(3)
! DEB ------------------------------------------------------------------
!
    rbid = 0.d0
    nbpar = 0
    nompar = ' '
    nomval(1) = 'SM'
    call rcvale(nommat, 'RCCM', nbpar, nompar, [rbid],&
                1, nomval, tsm, icodre, 2)
    sm=tsm(1)
!
    para(1) = r8vide()
    para(2) = r8vide()
    para(3) = r8vide()
    if (fatizh) then
        call rccome(nommat, 'FATIGUE', icodre(1))
        if (icodre(1) .eq. 1) then
            call utmess('F', 'POSTRCCM_7', sk='FATIGUE')
        endif
        call rccome(nommat, 'ELAS', icodre(1))
        if (icodre(1) .eq. 1) then
            call utmess('F', 'POSTRCCM_7', sk='ELAS')
        endif
!
        nomval(1) = 'M_KE'
        nomval(2) = 'N_KE'
        call rcvale(nommat, 'RCCM', nbpar, nompar, [rbid],&
                    2, nomval, valres, icodre, 2)
        para(1) = valres(1)
        para(2) = valres(2)
!
        nomval(1) = 'E_REFE'
        call rcvale(nommat, 'FATIGUE', nbpar, nompar, [rbid],&
                    1, nomval, erefe(1), icodre, 2)
!
        nomval(1) = 'E'
        call rcvale(nommat, 'ELAS', nbpar, nompar, [rbid],&
                    1, nomval, e(1), icodre, 2)
        para(3) = erefe(1) / e(1)
    endif
!
    if (symax .eq. r8vide()) then
        nomval(1) = 'SY_02'
        call rcvale(nommat, 'RCCM', nbpar, nompar, [rbid],&
                    1, nomval, valres, icodre, 0)
        if (icodre(1) .eq. 0) symax = valres(1)
    endif
!
end subroutine
