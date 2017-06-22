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

subroutine inteuler(sd_dtm_, sd_int_, buffdtm, buffint)
    implicit none
!
! person_in_charge: hassan.berro at edf.fr
!
! inteuler : Integrate from t_i to t_i+1 the differential equations of motion
!            using EULER integration method.
! 
#include "jeveux.h"
#include "asterfort/dtmacce.h"
#include "asterfort/intget.h"
#include "asterfort/intsav.h"
!
!   -0.1- Input/output arguments
    character(len=*) , intent(in) :: sd_dtm_
    character(len=*) , intent(in) :: sd_int_
    integer, pointer              :: buffdtm(:)
    integer, pointer              :: buffint(:)
!
!   -0.2- Local variables
    integer           :: i, nbequ, ind1
    real(kind=8)      :: t1, dt
    character(len=8)  :: sd_dtm, sd_int

    real(kind=8) , pointer :: depl1(:)    => null()
    real(kind=8) , pointer :: vite1(:)    => null()
    real(kind=8) , pointer :: acce1(:)    => null()

!   0 - Initializations
    sd_dtm = sd_dtm_
    sd_int = sd_int_

!   1 - Retrieval of the system's state at instant t_i (index=1)
    call intget(sd_int, TIME , iocc=1, rscal=t1  , buffer=buffint)
    call intget(sd_int, INDEX, iocc=1, iscal=ind1, buffer=buffint)
    call intget(sd_int, STEP , iocc=1, rscal=dt  , buffer=buffint)

    call intget(sd_int, DEPL, iocc=1, vr=depl1, lonvec=nbequ, buffer=buffint)
    call intget(sd_int, VITE, iocc=1, vr=vite1, buffer=buffint)
    call intget(sd_int, ACCE, iocc=1, vr=acce1, buffer=buffint)

!    write(*,*) "EULER T1, D1, V1, A1: ", t1, depl1, vite1, acce1

!   2 - Calculation of the system's state at instant t_(i+1) (saved under index=1)
    do i = 1, nbequ
        vite1(i) = vite1(i) + ( dt * acce1(i) )
        depl1(i) = depl1(i) + ( dt * vite1(i) )
    enddo


!   3 - Calculation of the acceleration from DE of motion at instant t_(i+1)
    call intsav(sd_int, TIME , 1, iocc=1, rscal=t1+dt, buffer=buffint)
    call intsav(sd_int, STEP , 1, iocc=1, rscal=dt, buffer=buffint)
    call intsav(sd_int, INDEX, 1, iocc=1, iscal=ind1+1, buffer=buffint)
    call dtmacce(sd_dtm, sd_int, 1, buffdtm, buffint)

!    write(*,*) "EULER T2, D2, V2, A2: ", t1+dt, depl1, vite1, acce1

!   4 - Set the archiving index to 1
    call intsav(sd_int, IND_ARCH, 1, iscal=1, buffer=buffint)

end subroutine
