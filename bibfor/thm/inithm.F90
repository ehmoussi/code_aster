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

subroutine inithm(imate, yachai, yamec, phi0, em,&
                  cs, tbiot, t, epsv, depsv,&
                  epsvm, angmas, aniso, mdal, dalal,&
                  alphfi, cbiot, unsks, alpha0, ndim)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/calela.h"
#include "asterfort/dilata.h"
#include "asterfort/rccoma.h"
#include "asterfort/rcvala.h"
#include "asterfort/tebiot.h"
#include "asterfort/unsmfi.h"
#include "asterfort/utmess.h"
!
!
    integer :: nelas, ndim
    parameter    ( nelas=4 )
    real(kind=8) :: elas(nelas)
    character(len=16) :: ncra1(nelas)
    integer :: icodre(nelas)
    aster_logical :: yachai
    integer :: imate, yamec, i, aniso
    real(kind=8) :: phi0, em, cs, tbiot(6), epsvm, epsv, depsv
    real(kind=8) :: angmas(3), t, eps, dalal, mdal(6), young, nu
    real(kind=8) :: alphfi, rbid(6, 6), cbiot, unsks, alpha0, k0
!
    parameter  ( eps = 1.d-21 )
! ======================================================================
! --- DONNEES POUR RECUPERER LES CARACTERISTIQUES MECANIQUES -----------
! ======================================================================
    data ncra1/'E','NU','ALPHA','RHO'/
!
! =====================================================================
! --- SI PRESENCE DE MECANIQUE OU DE CHAINAGE -------------------------
! =====================================================================
    if ((yamec.eq.1) .or. yachai) then
        if (aniso .eq. BIOT_TYPE_ISOT) then
!

! - Coefficients élastiques à température courante
            call rcvala(imate, ' ', 'ELAS', 1, 'TEMP',&
                        [t], 3, ncra1(1), elas( 1), icodre,&
                        2)
!
            young = elas(1)
            nu = elas(2)
            alpha0 = elas(3)
            cbiot = tbiot(1)
            k0 = young / 3.d0 / (1.d0-2.d0*nu)
            unsks = (1.0d0-cbiot) / k0
!
        else if (aniso .eq. BIOT_TYPE_ISTR) then
        
        else if (aniso .eq. BIOT_TYPE_ORTH) then

        endif
! =====================================================================
! --- CALCUL DES GRANDEURS MECANIQUES DANS LE CAS GENERAL -------------
! =====================================================================
        call unsmfi(imate, phi0, cs, t, tbiot,&
                    aniso, ndim)
        call dilata(imate, phi0, alphfi, t, aniso,&
                    angmas, tbiot)
        call calela(imate, angmas, mdal, dalal, t,&
                    aniso, rbid, ndim)             
!
! =====================================================================
! --- SI ABSENCE DE MECANIQUE -----------------------------------------
! =====================================================================
    else
        if (aniso .eq. BIOT_TYPE_ISOT) then
! =====================================================================
! --- CALCUL CAS ISOTROPE ---------------------------------------------
! =====================================================================
            alphfi = 0.0d0
            cs = em
            dalal = 0.d0
            alpha0 = 0.0d0
            unsks = em
            do i = 1, 6
                mdal(i) = 0.d0
            end do
            if (em .lt. eps) then
                cbiot =phi0
                ds_thm%ds_material%biot_coef = phi0
                ds_thm%ds_material%biot_l    = phi0
                ds_thm%ds_material%biot_t    = phi0
                ds_thm%ds_material%biot_t    = phi0
                call tebiot(angmas, tbiot)
            endif
        else if (aniso.eq. BIOT_TYPE_ISTR) then
! =====================================================================
! --- CALCUL CAS ISOTROPE TRANSVERSE-----------------------------------
! =====================================================================
            if (ndim .ne. 3) then
                call utmess('F', 'ALGORITH17_38')
            endif
            alphfi = 0.0d0
            cs = em
            dalal = 0.d0
            do i = 1, 6
                mdal(i) = 0.d0
            end do
            if (em .lt. eps) then
                ds_thm%ds_material%biot_coef = phi0
                ds_thm%ds_material%biot_l    = phi0
                ds_thm%ds_material%biot_t    = phi0
                ds_thm%ds_material%biot_t    = phi0
                call tebiot(angmas, tbiot)
            endif
        else if (aniso .eq. BIOT_TYPE_ORTH) then
! =====================================================================
! --- CALCUL CAS ORTHO 2D-----------------------------------
! =====================================================================
            if (ndim .ne. 2) then
                call utmess('F', 'ALGORITH17_37')
            endif
            alphfi = 0.0d0
            cs = em
            dalal = 0.d0
            do i = 1, 6
                mdal(i) = 0.d0
            end do
            if (em .lt. eps) then
                ds_thm%ds_material%biot_coef = phi0
                ds_thm%ds_material%biot_l    = phi0
                ds_thm%ds_material%biot_t    = phi0
                ds_thm%ds_material%biot_t    = phi0
                call tebiot(angmas, tbiot)
            endif
        endif
    endif
! =====================================================================
! --- CALCUL EPSV AU TEMPS MOINS --------------------------------------
! =====================================================================
    epsvm = epsv - depsv
! =====================================================================
end subroutine
