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

subroutine srlini(sigf,nr,yd,dy)

!

!!!
!!! MODELE LKR : ROUTINE INITIALISANT DY
!!!

! ===================================================================================
! IN  : SIGF(6)    : PREDICTION ELASTIQUE DES CONTRAINTES (LCELAS)
!     : NR = NDT+3 : DIMENSION VECTEUR INCONNUES
!     : YD(NDT+3)  : VALEUR DES INCONNUES A T
! OUT : DY(NDT+3)  : SOLUTION ESSAI  = ( DSIG DLAMBDA DXIP DXIVP )
! ===================================================================================
    
    implicit   none
    
    !!!
    !!! Variables globales
    !!!
    
    integer :: nr
    real(kind=8) :: sigf(6),yd(nr),dy(nr)
    
    !!!
    !!! Variables locales
    !!!
    
    integer :: ndi,ndt,i
    common /tdim/ ndt,ndi
    
    !!!
    !!! Initialisation de dy
    !!!
    
    do i=1,ndt
        dy(i)=0.d0
    end do
    
    do i=1,ndt
        dy(i)=sigf(i)-yd(i)
    end do

end subroutine
