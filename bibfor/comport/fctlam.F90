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

subroutine fctlam(x,finalW)
!
    implicit none
#include "asterfort/assert.h"
!
    real(kind=8) :: x, finalW
! ----------------------------------------------------------------------
!
! RESOUT LA FONCTION DE LAMBERT W : 
!              
!                 w*EXP(w)=x avec comme solution w=W(x)
! 
! ON UTILISE LA METHODE ITERATIVE DE NEWTON
! DOC DE REFERENCE (INTERNET juin 2016) :
! https://fr.wikipedia.org/wiki/Fonction_W_de_Lambert#M.C3.A9thodes_de_calcul_de_W0
! ----------------------------------------------------------------------
!
! IN    x        VALEUR D'EVALUATION DE LA FONCTION
!
! OUT   finalW   VALEUR DE SORTIE w = W(x)
!
! ----------------------------------------------------------------------
!
    real(kind=8) :: lastW, currentW, expW, eps
    integer :: n, nmax
!
    eps = 1.d-9
    currentW=0.d0
    n = 0
    nmax = 1000
! - La valeur w0, premier terme de la suite, a un impact fort sur la convergence 
!   lors de l'utilisation de valeur 'x élevées'
!   On lui associe des valeurs précalculées  par le biais d'une régression linéraire
!   pour assurer cette convergence
    
    if (x.lt.8) then
        lastW=1.d0
    elseif (x.ge.8) then
        lastW = 0.7988*log(x) - 0.1091
    endif
    
    
! - ON S'ASSURE DE RESTER SUR LES BRANCHES AUX VALEURS REELLES
    if (x .le. -1.d0/exp(1.d0)) then
        ASSERT(.false.)
    end if
    
    loop:do
        expW = exp(lastW)
        currentW = lastW - (lastW*expW-x)/((1+lastW)*expW)
        if(lastW - currentW < eps) exit loop
        lastW = currentW
        
        n=n+1
        if(n>nmax) then
            ASSERT(.false.)
        end if
        
    end do loop
    
    finalW = currentW

end subroutine
