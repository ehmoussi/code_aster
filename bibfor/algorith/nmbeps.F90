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

subroutine nmbeps(axi,r,vff,dff,b)

    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
    aster_logical :: axi
    real(kind=8)  :: r,vff(:),dff(:,:),b(:,:,:)
! ----------------------------------------------------------------------
!  CALCUL DE LA MATRICE B TQ B.U=EPS(U) (DEFORMATION LINEARISEE)
! ----------------------------------------------------------------------
! IN  AXI    .TRUE. SI AXI
! IN  R      RAYON (UTILISE SI AXI)
! IN  VFF    VALEUR DES FONCTIONS DE FORME (UTILISE SI AXI)
! IN  DFF    DERIVEE DES FONCTIONS DE FORME
! OUT B      MATRICE B
! ----------------------------------------------------------------------
    real(kind=8),parameter:: r2 = sqrt(2.d0)/2 
! ----------------------------------------------------------------------
    integer:: ndim,nno,ndimsi
! ----------------------------------------------------------------------

    ! Initialisation
    ndim   = size(dff,2)
    nno    = size(dff,1)
    ndimsi = 2*ndim

    ! Tests de coherence
    ASSERT(ndim.eq.2 .or. ndim.eq.3)
    ASSERT(size(b,1).eq.ndimsi)
    ASSERT(size(b,2).eq.ndim)
    ASSERT(size(b,3).eq.nno)
    if (axi) then
        ASSERT(size(vff).eq.nno)
    end if

    ! Nullite des termes non explicitement affectes
    b = 0

    ! Calcul des termes non nuls
    if (ndim .eq. 2) then
        b(1,1,:) = dff(:,1)
        b(2,2,:) = dff(:,2)
        b(4,1,:) = r2*dff(:,2)
        b(4,2,:) = r2*dff(:,1)
       
        if (axi) b(3,1,:) = vff/r
    else
        b(1,1,:) = dff(:,1)
        b(2,2,:) = dff(:,2)
        b(3,3,:) = dff(:,3)
        b(4,1,:) = r2*dff(:,2)
        b(4,2,:) = r2*dff(:,1)
        b(5,1,:) = r2*dff(:,3)
        b(5,3,:) = r2*dff(:,1)
        b(6,2,:) = r2*dff(:,3)
        b(6,3,:) = r2*dff(:,2)
    endif

end subroutine
