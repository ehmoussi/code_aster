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

subroutine prccm3(nommat, para, sm, sn, sp,&
                  ke, salt, nadm)
    implicit none
#include "asterf_types.h"
#include "asterc/r8maem.h"
#include "asterfort/limend.h"
#include "asterfort/rcvale.h"
#include "asterfort/utmess.h"
    real(kind=8) :: para(*), sm, sn, sp, ke, salt, nadm
    character(len=*) :: nommat
!
!     OPERATEUR POST_RCCM: CALCUL DU KE, SALT, NADM
!
!     ------------------------------------------------------------------
    real(kind=8) :: un, xm, xn, sns3, troism, tnadm(1)
    character(len=8) :: kbid
    real(kind=8) :: valr(2)
    integer :: icodre(1)
    aster_logical :: endur
!     ------------------------------------------------------------------
!
    un = 1.0d0
    troism = 3.0d0 * sm
!
! --- CALCUL DU COEFFICIENT DE CONCENTRATION ELASTO-PLASTIQUE KE :
!     ----------------------------------------------------------
!
! --- SI SN < 3*SM  KE = 1 :
!     --------------------
    if (sn .lt. troism) then
        ke = un
!
! --  SI 3*SM < SN < 3*M*SM
! --- KE = 1 +((1-N)/(N*(M-1)))*((SN/(3*SM))-1) :
!             ------------------------------------- ---
    else if (sn .lt. 3.d0*para(1)*sm) then
        xm = para(1)
        xn = para(2)
        sns3 = sn / 3.d0
        ke = un+((un-xn)/(xn*(xm-un)))*((sns3/sm)-un)
!
! --- SI 3*M*SM < SN   KE = 1/N :
!     -------------------------
    else
        ke = un / para(2)
    endif
!
!
! --- CALCUL DE LA CONTRAINTE EQUIVALENTE ALTERNEE SALT
! --- PAR DEFINITION SALT = 0.5*EC/E*KE*SP(TEMP1,TEMP2) :
!     -------------------------------------------------
    salt = 0.5d0 * para(3) * ke * sp
!
!
! --- CALCUL DU NOMBRE DE CYCLES ADMISSIBLE NADM EN UTILISANT
! --- LA COURBE DE WOHLER AUX EXTREMITES DU CHEMIN :
!     --------------------------------------------
    call limend(nommat, salt, 'WOHLER', kbid, endur)
    if (endur) then
        nadm=r8maem()
    else
        call rcvale(nommat, 'FATIGUE', 1, 'SIGM    ', [salt],&
                    1, 'WOHLER  ', tnadm(1), icodre(1), 2)
        nadm=tnadm(1)           
        if (nadm .lt. 0) then
            valr (1) = salt
            valr (2) = nadm
            call utmess('A', 'POSTRELE_61', nr=2, valr=valr)
        endif
    endif
!
end subroutine
