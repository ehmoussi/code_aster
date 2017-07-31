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

subroutine tpermh(angmas, permin, tperm, aniso, ndim)
!
    implicit none
! --- DEFINITION DU TENSEUR DE PERMEABILTE DANS LE REPERE GLOBAL -------
! --- CAS ISOTROPE OU ISOTROPE TRANSVERSE ------------------------------
! ======================================================================
#include "asterc/r8dgrd.h"
#include "asterc/r8pi.h"
#include "asterfort/matini.h"
#include "asterfort/matrot.h"
#include "asterfort/utbtab.h"
    integer :: aniso, ndim
    real(kind=8) :: angmas(3), permin(4)
    real(kind=8) :: tperm(ndim, ndim), perml(3, 3)
    real(kind=8) :: passag(3, 3), work(3, 3), tk2(3, 3)
! ======================================================================
! --- INITIALISATION DU TENSEUR DE PERMEABILITE ------------------------
! ======================================================================
!
    call matini(3, 3, 0.d0, work)
    call matini(3, 3, 0.d0, tk2)
    call matini(3, 3, 0.d0, perml)
    call matini(ndim, ndim, 0.d0, tperm)
!
    if (aniso .eq. 0) then
! ======================================================================
! --- CAS ISOTROPE -----------------------------------------------------
! --- CALCUL DU TENSEUR DE PERMEABILITE DANS LE REPERE GLOBAL ----------
! ======================================================================
        tperm(1,1)=permin(1)
        tperm(2,2)=permin(1)
        if (ndim .eq. 3) then
            tperm(3,3)=permin(1)
        endif
    else if (aniso.eq.1) then
! ======================================================================
! --- CAS ISOTROPE TRANSVERSE 3D------------------------------------------
! --- CALCUL DU TENSEUR DE PERMEABILITE DANS LE REPERE GLOBAL ----------
! ======================================================================
        perml(1,1)=permin(2)
        perml(2,2)=permin(2)
        perml(3,3)=permin(3)
! Recupération de la matrice de passage du local au global
        call matrot(angmas, passag)
        call utbtab('ZERO', 3, 3, perml, passag,&
                    work, tperm)
    else if (aniso.eq.2) then
! ======================================================================
! --- CAS ORTHOTROPE 2D ------------------------------------------
! --- CALCUL DU TENSEUR DE PERMEABILITE DANS LE REPERE GLOBAL ----------
! ======================================================================
        perml(1,1)=permin(2)
        perml(2,2)=permin(4)
        call matrot(angmas, passag)
        call utbtab('ZERO', 3, 3, perml, passag,&
                    work, tk2)
        tperm(1,1)= tk2(1,1)
        tperm(2,2)= tk2(2,2)
        tperm(1,2)= tk2(1,2)
        tperm(2,1)= tk2(2,1)
    endif
!
end subroutine
