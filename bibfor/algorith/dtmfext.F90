! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine dtmfext(sd_dtm_, time, fext, buffdtm)
    implicit none
!
! person_in_charge: hassan.berro at edf.fr
!
! dtmfext : Calculate the external forces at instant "time"
!
#include "jeveux.h"
#include "asterfort/dtmget.h"
#include "asterfort/mdfext.h"
#include "asterfort/r8inir.h"


!
!   -0.1- Input/output arguments
    character(len=*)      , intent(in)  :: sd_dtm_
    real(kind=8)          , intent(out) :: time
    real(kind=8), pointer :: fext(:)
    integer     , pointer  :: buffdtm(:)

!
!   -0.2- Local variables
    integer          :: nbmode, ntotex
    real(kind=8)     :: r8b
    character(len=8) :: sd_dtm
!
    integer         , pointer :: idescf(:)  => null()
    integer         , pointer :: liad(:)    => null()
    integer         , pointer :: inumor(:)  => null()
    real(kind=8)    , pointer :: coefm(:)   => null()
    character(len=8), pointer :: nomfon(:)  => null()
!
!   0 - Initializations
    sd_dtm = sd_dtm_
!
    call dtmget(sd_dtm, _NB_MODES, iscal=nbmode, buffer=buffdtm)
    call dtmget(sd_dtm, _NB_EXC_T, iscal=ntotex, buffer=buffdtm)

    call r8inir(nbmode, 0.d0, fext, 1)
!
    if (ntotex .ne. 0) then
        call dtmget(sd_dtm, _DESC_FRC,vi=idescf, buffer=buffdtm)
        call dtmget(sd_dtm, _FUNC_NAM,vk8=nomfon, buffer=buffdtm)
        call dtmget(sd_dtm, _COEF_MLT,vr=coefm, buffer=buffdtm)
        call dtmget(sd_dtm, _ADRES_VC,vi=liad, buffer=buffdtm)
        call dtmget(sd_dtm, _N_ORD_VC,vi=inumor, buffer=buffdtm)
        call mdfext(time, r8b, nbmode, ntotex, idescf,&
                    nomfon, coefm, liad, inumor, 1,&
                    fext)
    end if

end subroutine
