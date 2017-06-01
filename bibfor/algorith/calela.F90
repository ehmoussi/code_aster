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
subroutine calela(angmas, mdal, dalal, aniso, d)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterc/r8dgrd.h"
#include "asterfort/assert.h"
#include "asterfort/dpassa.h"
#include "asterfort/matini.h"
#include "asterfort/matrot.h"
#include "asterfort/utbtab.h"
#include "asterfort/utmess.h"
#include "asterfort/vecini.h"
    integer :: i, j, irep
    integer :: aniso
    real(kind=8) :: un, zero
    real(kind=8) :: young, nu, g
    real(kind=8) :: young1, young3, nu12, nu21, nu13, nu31, nu23, nu32
    real(kind=8) :: young2, g13, g12
    real(kind=8) :: d(6, 6), al(6), dorth(6, 6), c1, delta, repere(7)
    real(kind=8) :: mdal(6), dalal, angmas(3), work(6, 6)
    real(kind=8) :: passag(6, 6), pass(3, 3), tal(3, 3), talg(3, 3)
!
    zero = 0.d0
    un   = 1.d0
!
    call vecini(6, zero, mdal)
    call vecini(6, zero, al)
    call vecini(7, zero, repere)
    call matini(6, 6, zero, d)
    call matini(3, 3, zero, tal)
    call matini(3, 3, zero, talg)
    call matini(6, 6, zero, passag)
    call matini(6, 6, zero, dorth)
    call matini(6, 6, zero, work)
!
! matrice de passage du local au global
    call matrot(angmas, pass)
! ======================================================================
! ----   CALCUL DE LA MATRICE DE PASSAGE DU REPERE LOCAL D'ORTHOTROPIE A
! ----   REPERE GLOBAL POUR LE TENSEUR D'ELASTICITE
!
    repere(1) = 1.d0
    repere(2) = angmas(1)
    repere(3) = angmas(2)
    repere(4) = angmas(3)
!
!
    call dpassa(repere, irep, passag)
! ======================================================================
! --- ON CALCUL DANS UN PREMIERS TEMPS LA MATRICE DE COMPLAISANCE ET ---
! --- LE TENSEUR DE DILATATION TERMIQUE DANS LE REPERE LOCAL ----------
! ======================================================================
! ======================================================================
! --- CALCUL DE LA MATRICE DE COMPLAISANCE DANS LE REPERE LOCAL -------
! ======================================================================
! ======================================================================
! --- CALCUL CAS ISOTROPE ----------------------------------------------
! ======================================================================
    if (aniso .eq. 0) then
        young  = ds_thm%ds_material%e
        nu     = ds_thm%ds_material%nu
        g      = young/(2.d0*(1.d0+nu))
        al(1)  = ds_thm%ds_material%alpha
        al(2)  = ds_thm%ds_material%alpha
        al(3)  = ds_thm%ds_material%alpha
!
        dorth(1,1) = young*(1.d0-nu)/ ((1.d0+nu)*(1.-2.d0*nu))
        dorth(2,2) = dorth(1,1)
        dorth(3,3) = dorth(1,1)
!
        dorth(1,2) = young*nu/ ((1.d0+nu)*(1.d0-2.d0*nu))
        dorth(1,3) = dorth(1,2)
        dorth(2,1) = dorth(1,2)
        dorth(2,3) = dorth(1,2)
        dorth(3,1) = dorth(1,2)
        dorth(3,2) = dorth(1,2)
!
        dorth(4,4) = g
        dorth(5,5) = dorth(4,4)
        dorth(6,6) = dorth(4,4)
! ======================================================================
! --- CALCUL CAS ISOTROPE TRANSVERSE------------------------------------
! ======================================================================
    else if (aniso.eq.1) then
        if (ds_thm%ds_material%elas_keyword.eq.'ELAS_ISTR') then
            young1   = ds_thm%ds_material%e_l
            young3   = ds_thm%ds_material%e_n
            nu12     = ds_thm%ds_material%nu_lt
            nu13     = ds_thm%ds_material%nu_ln
            g13      = ds_thm%ds_material%g_ln
            tal(1,1) = ds_thm%ds_material%alpha_l
            tal(2,2) = ds_thm%ds_material%alpha_l
            tal(3,3) = ds_thm%ds_material%alpha_n
            al(1) = talg(1,1)
            al(2) = talg(2,2)
            al(3) = talg(3,3)
            al(4) = talg(1,2)
            al(5) = talg(1,3)
            al(6) = talg(2,3)
        else
            ASSERT(.false.)
        endif
        nu31 = nu13*young3/young1
        c1 = young1/ (1.d0+nu12)
        delta = 1. - nu12 - 2.d0*nu13*nu31
        dorth(1,1) = c1* (1.d0-nu13*nu31)/delta
        dorth(1,2) = c1* ((1.d0-nu13*nu31)/delta-1.d0)
        dorth(1,3) = young3*nu13/delta
        dorth(2,1) = dorth(1,2)
        dorth(2,2) = dorth(1,1)
        dorth(2,3) = dorth(1,3)
        dorth(3,1) = dorth(1,3)
        dorth(3,2) = dorth(2,3)
        dorth(3,3) = young3* (1.d0-nu12)/delta
        dorth(4,4) = 0.5d0*c1
        dorth(5,5) = g13
        dorth(6,6) = dorth(5,5)
! ======================================================================
! --- CALCUL CAS ORTHOTROPE 2D ------------------------------------
! ======================================================================
    else if (aniso.eq.2) then
        if (ds_thm%ds_material%elas_keyword.eq.'ELAS_ORTH') then
            young1 = ds_thm%ds_material%e_l
            young3 = ds_thm%ds_material%e_n
            young2 = ds_thm%ds_material%e_t
            nu12   = ds_thm%ds_material%nu_lt
            nu13   = ds_thm%ds_material%nu_ln
            nu23   = ds_thm%ds_material%nu_tn
            g12    = ds_thm%ds_material%g_lt
            tal(1,1) = ds_thm%ds_material%alpha_l
            tal(2,2) = ds_thm%ds_material%alpha_t
            tal(3,3) = ds_thm%ds_material%alpha_n
            call utbtab('ZERO', 3, 3, tal, pass,&
                        work, talg)
            al(1) = talg(1,1)
            al(2) = talg(2,2)
            al(3) = talg(3,3)
            al(4) = talg(1,2)
            al(5) = talg(1,3)
            al(6) = talg(2,3)
        else
            ASSERT(.false.)
        endif
        nu21 = nu12*young2/young1
        nu31 = nu13*young3/young1
        nu32 = nu23*young3/young2
        delta = un-nu23*nu32-nu31*nu13-nu21*nu12-2.d0*nu23*nu31*nu12
!
        dorth(1,1) = (un - nu23*nu32)*young1/delta
        dorth(1,2) = (nu21 + nu31*nu23)*young1/delta
        dorth(1,3) = (nu31 + nu21*nu32)*young1/delta
!
        dorth(2,1) = dorth(1,2)
        dorth(2,2) = (un - nu13*nu31)*young2/delta
        dorth(2,3) = (nu32 + nu31*nu12)*young2/delta
!
        dorth(3,1) = (nu13+nu12*nu23)*young3/delta
        dorth(3,2) = (nu23+nu21*nu13)*young3/delta
        dorth(3,3) = (un - nu21*nu12)*young3/delta
!
        dorth(4,4) = g12
        dorth(5,5) = g12
        dorth(6,6) = g12
!
    endif
! ======================================================================
! --- PASSAGE DANS LE REPERE GLOBAL -------
! ======================================================================
! Calcul de la matrice de passage
!
    d = dorth
    if ((aniso.eq.1) .or. (aniso.eq.2)) then
        if (irep .eq. 1) then
            call utbtab('ZERO', 6, 6, dorth, passag,&
                        work, d)
        endif
    endif
!
! ======================================================================
! --- CALCUL DES PRODUITS TENSORIELS D:AL:AL ET DE D:AL-----------------
! ======================================================================
    dalal= 0.d0
    do i = 1, 6
        do j = 1, 6
            mdal(i) = mdal(i) +d(i,j)*al(j)
        end do
    end do
    do i = 1, 6
        dalal=dalal+mdal(i)*al(i)
    end do
end subroutine
