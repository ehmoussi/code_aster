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

subroutine dtmforeq(sd_dtm_, sd_int_, index, buffdtm, buffint)
    implicit none
!
! person_in_charge: hassan.berro at edf.fr
!
! dtmforeq : Calculate the equilibrium forces for a given step specified by the argument
!           "index".
!
#include "jeveux.h"
#include "asterfort/dtmget.h"
#include "asterfort/intget.h"
#include "asterfort/intbuff.h"
#include "asterfort/intinivec.h"
#include "asterfort/pmavec.h"
#include "asterfort/as_allocate.h"
#include "asterfort/as_deallocate.h"

!
!   -0.1- Input/output arguments
    character(len=*) , intent(in) :: sd_dtm_
    character(len=*) , intent(in) :: sd_int_
    integer          , intent(in) :: index
    integer, pointer :: buffdtm(:)
    integer, pointer              :: buffint(:)
!
!   -0.2- Local variables
    aster_logical    :: mdiag, kdiag, cdiag
    integer          :: nbmode, i, iret
    character(len=8) :: sd_dtm, sd_int
!
    real(kind=8)    , pointer :: depl(:)   => null()
    real(kind=8)    , pointer :: vite(:)   => null()
    real(kind=8)    , pointer :: acce(:)   => null()
    real(kind=8)    , pointer :: fext(:)   => null()
    real(kind=8)    , pointer :: masgen(:)   => null()
    real(kind=8)    , pointer :: riggen(:)   => null()
    real(kind=8)    , pointer :: amogen(:)   => null()
!
!   0 - Initializations
    sd_dtm = sd_dtm_
    sd_int = sd_int_
!
    call dtmget(sd_dtm, _NB_MODES, iscal=nbmode, buffer=buffdtm)

    mdiag = .false.
    call intget(sd_int, MASS_FUL, iocc=1, lonvec=iret, buffer=buffint)
    if (iret.gt.0) then
        call intget(sd_int, MASS_FUL, iocc=1, vr=masgen, buffer=buffint)
    else
        call intget(sd_int, MASS_DIA, iocc=1, vr=masgen, buffer=buffint)
        mdiag = .true.
    end if

    kdiag = .false.
    call intget(sd_int, RIGI_FUL, iocc=1, lonvec=iret, buffer=buffint)
    if (iret.gt.0) then
        call intget(sd_int, RIGI_FUL, iocc=1, vr=riggen, buffer=buffint)
    else
        call intget(sd_int, RIGI_DIA, iocc=1, vr=riggen, buffer=buffint)
        kdiag = .true.
    end if

    cdiag = .false.
    call intget(sd_int, AMOR_FUL, iocc=1, lonvec=iret, buffer=buffint)
    if (iret.gt.0) then
        call intget(sd_int, AMOR_FUL, iocc=1, vr=amogen, buffer=buffint)
    else
        call intget(sd_int, AMOR_DIA, iocc=1, vr=amogen, buffer=buffint)
        cdiag = .true.
    end if

    call intget(sd_int, DEPL, iocc=index, vr=depl, buffer=buffint)
    call intget(sd_int, VITE, iocc=index, vr=vite, buffer=buffint)
    call intget(sd_int, ACCE, iocc=index, vr=acce, buffer=buffint)

    call intget(sd_int, FORCE_EX, iocc=index, lonvec=iret)
    if (iret.eq.0) then
        call intinivec(sd_int, FORCE_EX, nbmode, iocc=index, vr=fext)
    else 
        call intget(sd_int, FORCE_EX, iocc=index, vr=fext, buffer=buffint)
    end if

!   --- M is diagonal
    if (mdiag) then
        if (kdiag) then
            if (cdiag) then
                do i = 1, nbmode
                    fext(i) = masgen(i)*acce(i) + masgen(i)*amogen(i)*vite(i) &
                                                + riggen(i)*depl(i)
                end do
            else
!               --- Calculate C[nxn] * V[n*1]
                call pmavec('ZERO', nbmode, amogen, vite, fext)
                do i = 1, nbmode
                    fext(i) = masgen(i)*acce(i) + fext(i) &
                                                + riggen(i)*depl(i)
                end do
            endif
        else
!           --- Calculate the term M[nxn] * A[nx1] + C[nxn] * V[nx1]
            if (cdiag) then
                do i = 1, nbmode
                    fext(i) = masgen(i)*acce(i) + masgen(i)*amogen(i)*vite(i)
                end do
            else
                do i = 1, nbmode
                    fext(i) = masgen(i)*acce(i)
                end do
                call pmavec('CUMU', nbmode, amogen, vite, fext)
            end if

!           --- Add up the term K[nxn] * X[n*1]
            call pmavec('CUMU', nbmode, riggen, depl, fext)
        end if

!   --- M is not diagonal
    else
!       --- Calculate the term C[nxn] * V[nx1] = Zeta[nxn] * M [nxn] * V [nx1]
        if (cdiag) then
            call pmavec('ZERO', nbmode, masgen, vite, fext)
            do i = 1, nbmode
                fext(i) = amogen(i)*fext(i)
            end do    
        else
            call pmavec('ZERO', nbmode, amogen, vite, fext)
        endif

!       --- Add up the term M[nxn] * A[nx1]
        call pmavec('CUMU', nbmode, masgen, acce, fext)

!       --- Add up the term K[nxn] * X[nx1]
        if (kdiag) then
            do i = 1, nbmode
                fext(i) = fext(i) + riggen(i)*depl(i)
            end do     
        else
            call pmavec('CUMU', nbmode, riggen, depl, fext)
        end if
    endif

end subroutine
