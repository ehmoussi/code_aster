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

subroutine srelas(ndi,ndt,nmat,mater,sigd,de,k,mu)

!

!!!
!!! MODELE LKR : MATRICE HYPOELASTIQUE
!!!

! ===================================================================================
! IN  : NDI           : DIMENSION DE L ESPACE
!     : NDT           : 2*NDI POUR LE CALCUL TENSORIEL
!     : NMAT          : DIMENSION MATER
!     : MATER(NMAT,2) : COEFFICIENTS MATERIAU
!     : DEPS(6)       : INCREMENT DE DEFORMATION
!     : SIGD(6)       : CONTRAINTE A -
! OUT : DE            : MATRICE HYPOELASTIQUE
!     : K             : MODULE DE COMPRESSIBILITE
!     : G             : MODULE DE CISAILLEMENT
! ===================================================================================

    implicit none

#include "asterfort/r8inir.h"
#include "asterfort/trace.h"

   !!!
   !!! Varibles globales
   !!!

    integer :: ndi,ndt,nmat
    real(kind=8) :: mater(nmat,2),sigd(6),de(6,6),mu,k
    
    !!!
    !!! Variables locales
    !!!
    
    integer :: i,j
    real(kind=8) :: mue,ke,pa,nelas,invar1
    
    !!!
    !!! Recuperation des parametres materiaux
    !!!
    
    mue=mater(4,1)
    ke=mater(5,1)
    pa=mater(1,2)
    nelas=mater(2,2)
    
    !!!
    !!! calcul des parametres a t -
    !!!
    
    invar1=trace(ndi,sigd)
        
    if (invar1/3.d0.le.pa) then
        k=ke
        mu=mue
    else
        k=ke*(invar1/3.d0/pa)**nelas
        mu=mue*(invar1/3.d0/pa)**nelas
    endif
    
    !!! stockage
    mater(12,1)=k
    mater(13,1)=mu
    
    !!!
    !!! Definitin de la matrice hypoelastique
    !!!
    
    call r8inir(6*6,0.d0,de,1)
    
    do i=1,ndi
        do j=1,ndi
            de(i,j)=k-2.d0*mu/3.d0
        end do
    end do
    
    do i=1,ndt
        de(i,i)=de(i,i)+2.d0*mu
    end do

end subroutine
