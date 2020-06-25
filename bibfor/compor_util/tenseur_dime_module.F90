! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

module tenseur_dime_module

! =====================================================================
!  Utilitaires pour l'usage des tenseurs
! =====================================================================

    implicit none
    private
    public:: rs,kron,proten
    
#include "asterfort/assert.h"
    
    real(kind=8),parameter,dimension(6)::KRONECKER = [1.d0,1.d0,1.d0,0.d0,0.d0,0.d0]


contains


! =====================================================================
!  Extension d'un vecteur a la taille n complete par des zeros
! =====================================================================

function rs(nout,vin) result(vout)
    implicit none
    integer, intent(in)                  :: nout
    real(kind=8),dimension(:),intent(in) :: vin
    real(kind=8),dimension(nout)         :: vout
! ---------------------------------------------------------------------
    integer nin
! ---------------------------------------------------------------------
    nin = size(vin)
    if (nin.le.nout) then
        vout         = 0
        vout(1:nin) = vin
    else
        vout = vin(1:nout)
    end if

end function rs



! =====================================================================
!  Kronecker en representation vectorielle (1:ndimsi)
! =====================================================================

function kron(ndimsi) result(kr)
    
    implicit none
    integer,intent(in)            ::ndimsi
    real(kind=8),dimension(ndimsi):: kr
! ---------------------------------------------------------------------
    ASSERT(ndimsi.eq.4 .or. ndimsi.eq.6)
    kr = KRONECKER(1:ndimsi)

end function kron    


    
! =====================================================================
!  Produit tensoriel de deux vecteurs de dimension quelconque
! =====================================================================
    
function proten(u,v) result(w)
    implicit none
    real(kind=8),dimension(:),intent(in) :: u,v
    real(kind=8),dimension(size(u),size(v)) :: w
! ---------------------------------------------------------------------
    integer :: i,j
! ---------------------------------------------------------------------
    do i =1, size(u)
        do j =1, size(v)
            w(i,j) = u(i)*v(j)
        end do
    end do

 end function proten
    

end module tenseur_dime_module
