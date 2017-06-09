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

subroutine srsige(nmat, materd, deps, sigd, sigf)

!

!!!
!!! MODELE LKR : INTEGRATION ELASTIQUE NON LINEAIRE SUR DT POUR LKR
!!!

! ===================================================================================
! IN  : MOD            : MODELISATION
!     : NMAT           : DIMENSION MATER
!     : MATERD(NMAT,2) : COEFFICIENTS MATERIAU A T
!     : SIGD(6)        : CONTRAINTE  A T
!     : DEPS(6)        : INCREMENT DE DEFORMATION
! OUT : SIGF(6)        : CONTRAINTE ELASTIQUE A T+DT
! ===================================================================================
    
    implicit none

#include "asterfort/lcdevi.h"
#include "asterfort/srelas.h"

    !!!
    !!! Variables globales
    !!!
    
    integer :: nmat, ndt, ndi
    real(kind=8) :: materd(nmat,2)
    real(kind=8) :: sigd(6), sigf(6)
    real(kind=8) :: deps(6)
    
    !!!
    !!! Variables locales
    !!!
    
    integer :: i
    real(kind=8) :: dsde(6,6), kk, mu, depsv, kron(6)
    real(kind=8) :: i1ml, iel, devsig(6), depsd(6)
    real(kind=8) :: sigdt(6), sigft(6), depst(6)
    
    common /tdim/   ndt  , ndi
    data   kron /1.d0 , 1.d0 , 1.d0 , 0.d0 ,0.d0 ,0.d0/
    
    !!!
    !!! Convention meca. sol
    !!!
    
    do i = 1, ndt
        sigdt(i)=-sigd(i)
        depst(i)=-deps(i)
    end do
    
    !!!
    !!! Marice elastique
    !!!
    
    call srelas(ndi, ndt, nmat, materd, sigdt, dsde, kk, mu)
    
    !!! Increment de def. vol.
    depsv=depst(1)+depst(2)+depst(3)

    !!! Premier invariant de sigma et deviateur
    i1ml=sigdt(1)+sigdt(2)+sigdt(3)
    iel=i1ml+3.d0*kk*depsv
    
    call lcdevi(sigdt, devsig)
    
    !!! Deviateur des def.
    call lcdevi(depst, depsd)
    
    !!! Deviateur de sigma elastique
    do i=1, ndt
        devsig(i)=devsig(i)+2.d0*mu*depsd(i)
    end do
    
    !!! Tenseur des sigma elastique
    do i=1, ndt
        sigft(i)=devsig(i)+iel/3.d0*kron(i)
    end do
    
    !!! Retour a la convention mmc
    do i=1, ndt
        sigf(i)=-sigft(i)
    end do
    
end subroutine
