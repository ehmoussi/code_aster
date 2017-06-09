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

subroutine hujksi(carac, mater, r, ksi, iret)
    implicit none
!     LOI HUJEUX : CALCUL DU COEFFICIENT DE MOBILISATION
!     OU DE SA DERIVEE
! ============================================================
!   IN
!    CARAC (K6) : 'KSI'  CALCUL DE KSI(R) =
!                        [ (R - RHYS) / (RMOB - RHYS) ] **XM
!             'DKSIDR'   CALCUL DE LA DERIVEE DE KSI
!    MATER  :  COEFFICIENTS MATERIAU
!    R      :  ECROUISSAGE COURANT (MECANISME DEVIATOIRE)
!   OUT
!    KSI (R)    :  VALEUR DE KSI OU DKSIDR
!     --------------------------------------------------------
!
#include "asterf_types.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
    integer :: ifm, niv, iret
    real(kind=8) :: mater(22, 2), r, ksi, rhys, rmob, xm, xm1
    real(kind=8) :: zero, un
    character(len=6) :: carac
    character(len=16) :: nomail
    aster_logical :: debug
    parameter   (zero = 0.d0)
    parameter   (un = 1.d0)
!
    common /meshuj/ debug
!
    call infniv(ifm, niv)
!
    rhys = mater(15,2)
    rmob = mater(16,2)
    xm = mater(17,2)
!
    if (carac(1:3) .eq. 'KSI') then
!
        if (r .gt. zero .and. r .le. rhys) then
            ksi = zero
        else if (r.gt.rhys .and. r.le.rmob) then
            ksi = (r - rhys)**xm /(rmob - rhys)**xm
        else if (r.gt.rmob) then
            ksi = un
        else
!          IRET = 1
            ksi=zero
            if (debug) then
!            CALL TECAEL(IADZI,IAZK24)
!            NOMAIL = ZK24(IAZK24-1+3) (1:8)
                nomail='#A FAIRE#'
                write(ifm,'(A)')&
     &      'HUJKSI :: ECROUISSAGE NEGATIF DANS LA MAILLE ',nomail
            endif
        endif
!
    else if (carac(1:6).eq.'DKSIDR') then
!
        if (r .gt. zero .and. r .le. rhys) then
            ksi = zero
        else if (r.gt.rhys .and. r.le.rmob) then
            xm1 = xm-un
            ksi = xm*(r - rhys)**xm1 /(rmob - rhys)**xm
        else if (r.gt.rmob) then
            ksi = zero
        else
!          IRET = 1
            ksi=zero
            if (debug) then
!            CALL TECAEL(IADZI,IAZK24)
!            NOMAIL = ZK24(IAZK24-1+3) (1:8)
                nomail='#A FAIRE#'
                write(ifm,'(A)')&
     &      'HUJKSI :: ECROUISSAGE NEGATIF DANS LA MAILLE ',nomail
            endif
        endif
!
    else
        call utmess('F', 'COMPOR1_10')
    endif
!
end subroutine
