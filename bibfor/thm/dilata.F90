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

subroutine dilata(imate, phi, alphfi, t, aniso,&
                  angmas, tbiot)
!
use THM_type
use THM_module
!
implicit none
!
#include "asterc/r8pi.h"
#include "asterfort/matini.h"
#include "asterfort/matrot.h"
#include "asterfort/rcvala.h"
#include "asterfort/utbtab.h"
!
! --- CALCUL DE ALPHAFI ------------------------------------------------
! ======================================================================

    integer :: nelas2
    integer :: nelas1, nelas3
    parameter  ( nelas1=1 )
    parameter  ( nelas2=2 )
    parameter  ( nelas3=3 )
    real(kind=8) :: elas1(nelas1), elas2(nelas2), elas3(nelas3)
    character(len=8) :: ncra1(nelas1)
    character(len=8) :: ncra2(nelas2)
    character(len=8) :: ncra3(nelas3)
    integer :: icodre1(nelas1), icodre2(nelas2), icodre3(nelas3)
    integer :: imate, aniso, i, anisoi
    real(kind=8) :: phi, t, tbiot(6), alpha(6)
    real(kind=8) :: kron(6), angmas(3), alphfi
    real(kind=8) :: talpha(3, 3), talphal(3, 3)
    real(kind=8) :: passag(3, 3), work(3, 3)
! =====================================================================
! --- DONNEES POUR RECUPERER LES CARACTERISTIQUES MECANIQUES ----------
! =====================================================================
    data ncra1 /'ALPHA'/
    data ncra2 /'ALPHA_L','ALPHA_N'/
    data ncra3 /'ALPHA_L','ALPHA_N','ALPHA_T'/
    anisoi = aniso
! ======================================================================
! --- INITIALISATION DU TENSEUR ----------------------------------------
! ======================================================================
    call matini(3, 3, 0.d0, work)
    call matini(3, 3, 0.d0, talpha)
    call matini(3, 3, 0.d0, talphal)
    call matini(3, 3, 0.d0, passag)
! =====================================================================
! --- DEFINITION DU SYMBOLE DE KRONECKER UTILE POUR LA SUITE ----------
! =====================================================================
    do i = 1, 3
        kron(i) = 1.d0
    end do
    do i = 4, 6
        kron(i) = 0.d0
    end do
!
! =====================================================================
! --- CALCUL CAS ISOTROPE ---------------------------------------------
! =====================================================================
999  continue
    if (anisoi .eq. 0) then
! =====================================================================
! --- RECUPERATION DES COEFFICIENTS MECANIQUES ------------------------
! =====================================================================
        call rcvala(imate, ' ', 'ELAS', 1, 'TEMP',&
                    [t], 1, ncra1(1), elas1(1), icodre1,&
                    0)
        talpha(1,1)=elas1(1)
        talpha(2,2)=elas1(1)
        talpha(3,3)=elas1(1)
!
! =====================================================================
! --- CALCUL CAS ISOTROPE TRANSVERSE 3D-------------------------------
! =====================================================================
    else if (anisoi.gt.0) then
        if (ds_thm%ds_material%elas_keyword .eq. 'ELAS') then
            anisoi=0
            goto 999
        else if (ds_thm%ds_material%elas_keyword.eq.'ELAS_ISTR') then
            call rcvala(imate, ' ', 'ELAS_ISTR', 1, 'TEMP',&
                        [t], 2, ncra2(1), elas2(1), icodre2,&
                        0)
            talpha(1,1)=elas2(1)
            talpha(2,2)=elas2(1)
            talpha(3,3)=elas2(2)
        else if (ds_thm%ds_material%elas_keyword.eq.'ELAS_ORTH') then
            call rcvala(imate, ' ', 'ELAS_ORTH', 1, 'TEMP',&
                        [t], 3, ncra3(1), elas3(1), icodre3,&
                        0)
            talpha(1,1)=elas3(1)
            talpha(2,2)=elas3(3)
            talpha(3,3)=elas3(2)
        endif
    endif
!
! matrice de passage du local au global
    call matrot(angmas, passag)
! ======================================================================
! --- CALCUL DU TENSEUR DE ALPHA BGL DANS LE REPERE GLOBAL -------------
! ======================================================================
    call utbtab('ZERO', 3, 3, talpha, passag,&
                work, talphal)
! =====================================================================
! --- DEFINITION DU TENSEUR DE CONDUCTIVITE THERMIQUE -----------------
! =====================================================================
    alpha(1)=talphal(1,1)
    alpha(2)=talphal(2,2)
    alpha(3)=talphal(3,3)
    alpha(4)=talphal(1,2)
    alpha(5)=talphal(1,3)
    alpha(6)=talphal(2,3)
! =====================================================================
! --- DEFINITION DU COEFFICIENT DE DILATATION DIFFERENTIEL ------------
! =====================================================================
    alphfi = 0.d0
    do i = 1, 6
        alphfi = alphfi+(tbiot(i)-phi*kron(i))*alpha(i)/3.d0
    enddo
end subroutine
