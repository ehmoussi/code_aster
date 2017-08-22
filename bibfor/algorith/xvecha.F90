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
! aslint: disable=W1504
! person_in_charge: daniele.colombo at ifpen.fr
!
subroutine xvecha(ndim, pla, nnops, saut,&
                  sautm, nd, ffc, w11, w11m, jac,&
                  q1, q1m, q2, q2m, dt, ta, ta1,&
                  dffc, rho11, gradpf, rho11m,&
                  gradpfm, vect)
!
use THM_type
use THM_module
!
implicit none
!
#include "jeveux.h"
#include "asterfort/vecini.h"
!
! ======================================================================

!
!
! ROUTINE MODELE HM-XFEM
! 
! CALCUL DES SECONDS MEMBRES VECT (CONSERVATION DE LA MASSE FLUIDE FRACTURE)
!
! ----------------------------------------------------------------------
!
    integer :: k, i, ndim, pli, pla(27), nnops
    real(kind=8) :: ps, psm, saut(3), sautm(3)
    real(kind=8) :: nd(3), ffc(16), ffi, w11, w11m
    real(kind=8) :: jac, q1, dt, ta, q1m, ta1, q2, q2m
    real(kind=8) :: dffi(3), dffc(16,3), rho11
    real(kind=8) :: mu, gradpf(3), rho11m, gradpfm(3)
    real(kind=8) :: vect(560)
!
    call vecini(3, 0.d0, dffi)
!
    mu     = ds_thm%ds_material%liquid%visc
    ps = 0.d0
    psm = 0.d0
    do k = 1, ndim 
       ps = ps - saut(k)*nd(k)
       psm = psm - sautm(k)*nd(k)
    end do 
!
    do i = 1, nnops
       ffi = ffc(i)
       pli = pla(i)
!
       vect(pli) = vect(pli) - ffi*(w11 - w11m)*jac
!
       vect(pli) = vect(pli) - ffi*q1*dt*ta*jac -&
                               ffi*q1m*dt*ta1*jac
!
       vect(pli) = vect(pli) - ffi*q2*dt*ta*jac -&
                               ffi*q2m*dt*ta1*jac
!
    end do  
!
    do i = 1, nnops
       pli = pla(i)
       do k = 1, ndim
          dffi(k) = dffc(i,k)
!
          vect(pli) = vect(pli) + dffi(k)*(-(rho11*ps**3/(12.d0*mu))*&
                                  gradpf(k))*dt*ta*jac
!
          vect(pli) = vect(pli) + dffi(k)*(-(rho11m*psm**3/(12.d0*mu))*&
                                  gradpfm(k))*dt*ta1*jac
       end do
    end do
end subroutine
