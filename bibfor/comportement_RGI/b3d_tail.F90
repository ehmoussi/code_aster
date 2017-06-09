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

subroutine b3d_tail(xmat, nmat, ifou, mfr1, nmat0,&
                    nmat1, t33, n33, local)
! person_in_charge: etienne.grimal at edf.fr
!=====================================================================
!=====================================================================
!     chargement des tailles de l element en cours pour la procedure de
!     en fonction de la formulation
!     declarations externes
!=====================================================================
    implicit none
#include "asterf_types.h"
    real(kind=8) :: ray
    integer :: nmat, ifou, mfr1, nmat1, nmat0
    aster_logical :: local
    real(kind=8) :: xmat(nmat)
    real(kind=8) :: n33(3, 3)
    real(kind=8) :: t33(3, 3)
!      print*,'ds b3d_tail:'
!      print*, 'nmat,ifou,mfr1,nmat0,nmat1'
!      print*, nmat,ifou,mfr1,nmat0,nmat1
!     nombre de parametre modele elastique: nmat0
!     nombre de parametres obligatoires endommagement:nmat1
    if ((mfr1.eq.1) .or. (mfr1.eq.33)) then
        if (ifou .eq. 2) then
!       formulation massive 3d
            t33(1,1)=xmat(nmat1+1)
            t33(2,2)=xmat(nmat1+2)
            t33(3,3)=xmat(nmat1+3)
            t33(1,2)=xmat(nmat1+4)
            t33(1,3)=xmat(nmat1+5)
            t33(2,3)=xmat(nmat1+6)
            t33(2,1)=t33(1,2)
            t33(3,1)=t33(1,3)
            t33(3,2)=t33(2,3)
            n33(1,1)=xmat(nmat1+7)
            n33(2,2)=xmat(nmat1+8)
            n33(3,3)=xmat(nmat1+9)
            n33(1,2)=xmat(nmat1+10)
            n33(1,3)=xmat(nmat1+11)
            n33(2,3)=xmat(nmat1+12)
            n33(2,1)=n33(1,2)
            n33(3,1)=n33(1,3)
            n33(3,2)=n33(2,3)
        end if
        if ((ifou.eq.0) .or. (ifou.eq.-1)) then
!       mode axisymetrique ou deformation plane
!       chargement des matrices des tailles de EF
            t33(1,1)=xmat(nmat1+1)
            t33(2,2)=xmat(nmat1+2)
            if (ifou .eq. 0) then
!        cas axisym on recupere le rayon en 8 pour calculer la dim 3
                ray=xmat(nmat1+8)
                t33(3,3)=3.14d0*ray
!         print*,t33(3,3)
            else
!        cas def plane on recupere l epaisseur vraie
                t33(3,3)=xmat(nmat1+8)
            end if
            t33(1,2)=xmat(nmat1+4)
            t33(1,3)=0.d0
            t33(2,3)=0.d0
            t33(2,1)=t33(1,2)
            t33(3,1)=t33(1,3)
            t33(3,2)=t33(2,3)
            n33(1,1)=xmat(nmat1+5)
            n33(2,2)=xmat(nmat1+6)
            n33(3,3)=1.d0
            n33(1,2)=xmat(nmat1+7)
            n33(1,3)=0.d0
            n33(2,3)=0.d0
            n33(2,1)=n33(1,2)
            n33(3,1)=n33(1,3)
            n33(3,2)=n33(2,3)
        end if
    end if
end subroutine
