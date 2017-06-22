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

subroutine b3d_dth(theta, dth, dt80)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!=====================================================================
!     calcul de lendommagement thermique    
!=====================================================================
    implicit none
!     declarations externes
    real(kind=8) :: theta
    real(kind=8) :: dth
    real(kind=8) :: dt80, dth0, theta_ref, dtheta, dth1, dtheta_k
!     endommagement thermique initial
    dth0=dth
!     parametres de la loi d endommagement thermique
    theta_ref=50.d0
    if ((theta_ref.lt.80.d0) .and. (dt80.lt.1.) .and. (dt80.gt.0.)) then
!      calcul de dtheta_k fonction de dt80 impose
        dtheta_k=-(80.d0-theta_ref)/log(1.d0-dt80)
!      endommagement thermique      
        dtheta=max(theta-theta_ref,0.d0)
        dth1=1.d0-exp(-(dtheta/dtheta_k))
    else
!      pas d'endo thermique
        dth1=0.d0
    end if
!     condition de croissance de l endo thermique
    dth=min(max(dth1,dth0),0.99999d0)
end subroutine
