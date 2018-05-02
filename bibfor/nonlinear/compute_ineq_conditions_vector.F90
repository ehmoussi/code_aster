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

subroutine compute_ineq_conditions_vector(jsecmb, nbliai, neq   ,&
                                          japptr, japddl, japcoe,&
                                          jjeux , jtacf , jmu   ,&
                                          njeux , ztacf , iliac )
!
!
    implicit     none
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterfort/calatm.h"
    integer :: jsecmb
!
! ----------------------------------------------------------------------
!
    real(kind=8) :: jeuini, coefpn, lambdc
    integer :: iliai, iliac
    integer :: jmu
    integer :: japcoe, japddl, japptr
    integer :: jtacf
    integer :: jjeux, njeux
    integer :: ztacf
    integer :: nbliai, neq
    integer :: nbddl, jdecal
!
! --- INITIALISATION DES MU
!
    do iliai = 1, nbliai
        zr(jmu +iliai-1) = 0.d0
        zr(jmu+3*nbliai+iliai-1) = 0.d0
    end do
!
! --- CALCUL DES FORCES DE CONTACT
!
    iliac = 1
    do iliai = 1, nbliai
        jeuini = zr(jjeux+njeux*(iliai-1)+1-1)
        coefpn = zr(jtacf+ztacf*(iliai-1)+1)
        if (jeuini .lt. r8prem()) then
            jdecal = zi(japptr+iliai-1)
            nbddl = zi(japptr+iliai) - zi(japptr+iliai-1)
            lambdc = -jeuini*coefpn
            zr(jmu+iliac-1) = lambdc
            call calatm(neq, nbddl, lambdc, zr(japcoe+jdecal), zi(japddl+ jdecal),&
                        zr(jsecmb))
            iliac = iliac + 1
        endif
    end do
!
end subroutine
