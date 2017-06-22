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

subroutine rsliso(fami, kpg, ksp, poum, imat,&
                  p, rp, drdp)
    implicit none
!       LOI ECROUISSAGE ISOTROPE R(P,T) ENTREE POINT PAR POINT
!       ET  DERIVEE LOI ECROUISSAGE ISOTROPE R(P,T)/ P
!       IN  P      :  DEFORMATION CUMULEE
!           IMAT   :  ADRESSE DU MATERIAU CODE
!       OUT RP     :  R (P,TEMP)
!       OUT DRDP   :  DRDP ( P,TEMP) = INTERPOLATION LINEAIRE SUR P,TEMP
!       ----------------------------------------------------------------
#include "asterfort/rcfonc.h"
#include "asterfort/rctrac.h"
#include "asterfort/rctype.h"
#include "asterfort/rcvarc.h"
#include "asterfort/utmess.h"
    real(kind=8) :: temp, p, rp, e, drdp, airerp, para_vale
    integer :: imat, jprol, jvale, nbvale, kpg, ksp, iret
    character(len=*) :: fami
    character(len=1) :: poum
    character(len=8) :: para_type
!       ----------------------------------------------------------------
! --  TEMPERATURE
    call rcvarc(' ', 'TEMP', poum, fami, kpg, ksp, temp, iret)
    call rctype(imat, 1, 'TEMP', [temp], para_vale, para_type)
    if ((para_type.eq.'TEMP') .and. (iret.eq.1)) then
        call utmess('F', 'COMPOR5_5', sk = para_type)
    endif
    call rctrac(imat, 1, 'SIGM', para_vale, jprol,&
                jvale, nbvale, e)
    call rcfonc('V', 1, jprol, jvale, nbvale,&
                p = p, rp = rp, rprim = drdp, airerp = airerp)
end subroutine
