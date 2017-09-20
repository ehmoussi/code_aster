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
subroutine inithm(angl_naut, tbiot , phi0 ,&
                  epsv     , depsv ,&
                  epsvm    , cs0   , mdal , dalal,&
                  alpha0   , alphfi, cbiot, unsks)
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
real(kind=8), intent(in) :: angl_naut(3)
real(kind=8), intent(in) :: tbiot(6)
real(kind=8), intent(in) :: phi0
real(kind=8), intent(in) :: epsv, depsv
real(kind=8), intent(out) :: epsvm
real(kind=8), intent(out) :: cs0
real(kind=8), intent(out) :: dalal, mdal(6)
real(kind=8), intent(out) :: alphfi, alpha0
real(kind=8), intent(out) :: cbiot, unsks
!
! --------------------------------------------------------------------------------------------------
!
! THM
!
! Prepare initial parameters for coupling law
!
! --------------------------------------------------------------------------------------------------
!
! In  angl_naut        : nautical angles
!                        (1) Alpha - clockwise around Z0
!                        (2) Beta  - counterclockwise around Y1
!                        (1) Gamma - clockwise around X
! In  tbiot            : Biot tensor
! In  phi0             : initial porosity
! In  epsv             : current volumic strain
! In  depsv            : increment of volumic strain
! Out epsvm            : previous volumic strain
! Out cs0              : initial Biot modulus of solid matrix
! Out alphfi           : initial differential thermal expansion ratio
! Out alpha0           : initial thermal expansion
! Out unsks            : inverse of bulk modulus (solid matrix)
! Out cbiot            : Biot coefficient for isotropic case
! Out mdal             : product [Elas] {alpha}
! Out dalal            : product <alpha> [Elas] {alpha}
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: young, nu, k0, emmag
    real(kind=8), parameter :: eps = 1.d-21
!
! --------------------------------------------------------------------------------------------------
!
    cbiot   = 0.d0
    alphfi  = 0.d0
    cs0     = 0.d0
    dalal   = 0.d0
    alpha0  = 0.d0
    unsks   = 0.d0
    mdal(:) = 0.d0
!
! - Get parameters
!
    emmag = ds_thm%ds_material%hydr%emmag
    if (ds_thm%ds_elem%l_dof_meca .or. ds_thm%ds_elem%l_weak_coupling) then
! ----- Compute inverse of bulk modulus (solid matrix)
        if (ds_thm%ds_material%biot%type .eq. BIOT_TYPE_ISOT) then
            young  = ds_thm%ds_material%elas%e
            nu     = ds_thm%ds_material%elas%nu
            alpha0 = ds_thm%ds_material%ther%alpha
            cbiot  = tbiot(1)
            k0     = young / 3.d0 / (1.d0-2.d0*nu)
            unsks  = (1.d0-cbiot) / k0
        endif
        if (.not.ds_thm%ds_elem%l_jhms) then
! --------- Compute Biot modulus
            call unsmfi(phi0, tbiot, cs0)
! --------- Compute differential thermal expansion ratio
            call dilata(angl_naut, phi0, tbiot, alphfi)
! --------- Compute thermic quantities
            call thmTherElas(angl_naut, mdal, dalal)
        endif
    else
        if (ds_thm%ds_material%biot%type .eq. BIOT_TYPE_ISOT) then
            cs0   = emmag
            unsks = emmag
            if (emmag .lt. eps) then
                cbiot = phi0
            endif
        else if (ds_thm%ds_material%biot%type .eq. BIOT_TYPE_ISTR) then
            cs0   = emmag
        else if (ds_thm%ds_material%biot%type .eq. BIOT_TYPE_ORTH) then
            cs0   = emmag
        else
            ASSERT(.false.)
        endif
    endif
!
! - Previous volumic strain
!
    epsvm = epsv - depsv
!
end subroutine
