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
!
subroutine inithm(imate, yachai, yamec, phi0, em,&
                  cs0, tbiot, temp, epsv, depsv,&
                  epsvm, angmas, mdal, dalal,&
                  alphfi, cbiot, unsks, alpha0)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/thmTherElas.h"
#include "asterfort/assert.h"
#include "asterfort/dilata.h"
#include "asterfort/tebiot.h"
#include "asterfort/unsmfi.h"
#include "asterfort/utmess.h"
#include "asterfort/THM_type.h"
!
aster_logical :: yachai
integer :: imate, yamec, i
real(kind=8), intent(in) :: temp
real(kind=8), intent(out) :: cs0
real(kind=8), intent(out) :: alphfi
real(kind=8) :: phi0, em, tbiot(6), epsvm, epsv, depsv
real(kind=8) :: angmas(3), dalal, mdal(6), young, nu
real(kind=8) :: cbiot, unsks, alpha0, k0
real(kind=8), parameter :: eps = 1.d-21
!
! =====================================================================
! --- SI PRESENCE DE MECANIQUE OU DE CHAINAGE -------------------------
! =====================================================================
    if ((yamec .eq. 1) .or. yachai) then
        if (ds_thm%ds_material%biot%type .eq. BIOT_TYPE_ISOT) then
            young  = ds_thm%ds_material%elas%e
            nu     = ds_thm%ds_material%elas%nu
            alpha0 = ds_thm%ds_material%elas%alpha
            cbiot  = tbiot(1)
            k0     = young / 3.d0 / (1.d0-2.d0*nu)
            unsks  = (1.d0-cbiot) / k0
        endif
! =====================================================================
! --- CALCUL DES GRANDEURS MECANIQUES DANS LE CAS GENERAL -------------
! =====================================================================
        call unsmfi(imate, phi0, temp, tbiot, cs0)
        call dilata(angmas, phi0, tbiot, alphfi)
!
! ----- Compute thermic quantities
!
        call thmTherElas(angmas, mdal, dalal)
!
! =====================================================================
! --- SI ABSENCE DE MECANIQUE -----------------------------------------
! =====================================================================
    else
        if (ds_thm%ds_material%biot%type .eq. BIOT_TYPE_ISOT) then
! =====================================================================
! --- CALCUL CAS ISOTROPE ---------------------------------------------
! =====================================================================
            alphfi = 0.d0
            cs0 = em
            dalal = 0.d0
            alpha0 = 0.0d0
            unsks = em
            do i = 1, 6
                mdal(i) = 0.d0
            end do
            if (em .lt. eps) then
                cbiot = phi0
                ds_thm%ds_material%biot%coef = phi0
                ds_thm%ds_material%biot%l    = phi0
                ds_thm%ds_material%biot%t    = phi0
                ds_thm%ds_material%biot%t    = phi0
                call tebiot(angmas, tbiot)
            endif
        else if (ds_thm%ds_material%biot%type .eq. BIOT_TYPE_ISTR) then
! =====================================================================
! --- CALCUL CAS ISOTROPE TRANSVERSE-----------------------------------
! =====================================================================
            alphfi = 0.0d0
            cs0 = em
            dalal = 0.d0
            do i = 1, 6
                mdal(i) = 0.d0
            end do
            if (em .lt. eps) then
                ds_thm%ds_material%biot%coef = phi0
                ds_thm%ds_material%biot%l    = phi0
                ds_thm%ds_material%biot%t    = phi0
                ds_thm%ds_material%biot%t    = phi0
                call tebiot(angmas, tbiot)
            endif
        else if (ds_thm%ds_material%biot%type .eq. BIOT_TYPE_ORTH) then
! =====================================================================
! --- CALCUL CAS ORTHO 2D-----------------------------------
! =====================================================================
            alphfi = 0.0d0
            cs0 = em
            dalal = 0.d0
            do i = 1, 6
                mdal(i) = 0.d0
            end do
            if (em .lt. eps) then
                ds_thm%ds_material%biot%coef = phi0
                ds_thm%ds_material%biot%l    = phi0
                ds_thm%ds_material%biot%t    = phi0
                ds_thm%ds_material%biot%t    = phi0
                call tebiot(angmas, tbiot)
            endif
        else
            ASSERT(.false.)
        endif
    endif
! =====================================================================
! --- CALCUL EPSV AU TEMPS MOINS --------------------------------------
! =====================================================================
    epsvm = epsv - depsv
! =====================================================================
end subroutine
