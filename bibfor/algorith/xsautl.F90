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

subroutine xsautl(ndim, nd, tau1, tau2, saut, sautm, p, am, ad)

    implicit none

#include "asterfort/matini.h"
#include "asterfort/vecini.h"
#include "asterfort/prmave.h"
   
! person_in_charge: daniele.colombo at ifpen.fr
! ======================================================================
!
! ROUTINE MODELE HM-XFEM (CAS DE LA FRACTURE)
!
! CALCUL DU CHANGEMENT DE BASE POUR LE SAUT DE DEPLACEMENT 
!
! ----------------------------------------------------------------------

    integer :: i, ndim, ier1, ier2
    real(kind=8) :: p(3,3), nd(3), tau1(3), tau2(3)
    real(kind=8) :: saut(3), sautm(3), am(3), ad(3)
    
    call matini(3, 3, 0.d0, p) 
    call vecini(3, 0.d0, am)
    call vecini(3, 0.d0, ad)
!
! --- ON CONSTRUIT P MATRICE DE PASSAGE BASE FIXE --> BASE COVARIANTE
!
    do i = 1, ndim
        p(1,i) = nd(i)
    end do
    do i = 1, ndim
        p(2,i) = tau1(i)
    end do
    if (ndim.eq.3) then
       do i = 1, ndim
            p(3,i) = tau2(i)
       end do
    endif    
!
! --- CALCUL SAUT DE DEPLACEMENT + EN BASE LOCALE {AM}=[P]{SAUT+}
!
    call prmave(0, p, 3, ndim, ndim,&
                saut, ndim, am, ndim, ier1)
!
! --- CALCUL SAUT DE DEPLACEMENT - EN BASE LOCALE {AD}=[P]{SAUT-}
!
    call prmave(0, p, 3, ndim, ndim,&
                sautm, ndim, ad, ndim, ier2)
end subroutine
