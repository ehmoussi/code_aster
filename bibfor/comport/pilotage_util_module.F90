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

module pilotage_util_module

    implicit none
    private
    public:: SolvePosValCst

#include "asterf_types.h"



contains



! =====================================================================
!  SOLVE Q(ETA) := (POS(A*ETA+B))**2 + L0  = 0
! =====================================================================

subroutine SolvePosValCst(a, b, l0, etam, etap, vide, nsol, sol, sgn)

    implicit none
    real(kind=8), intent(in)  :: a, b, l0, etam, etap
    aster_logical,intent(out) :: vide
    integer, intent(out)      :: nsol, sgn
    real(kind=8), intent(out) :: sol
! ---------------------------------------------------------------------
!  a,b    composantes du terme quadratique
!  l0     terme constant
!  etam   borne min
!  etap   borne max
!  vide   .true. si q tjrs positif dans l'intervalle (etam,etap)
!  nsol   nombre de solutions dans l'intervalle (0 ou 1)
!  sol    valeur eventuelle de la solution (ou non affecte)
!  sgn    signe de dq/deta au point solution (+1 ou -1)
! ---------------------------------------------------------------------
    aster_logical:: apos
    real(kind=8) :: bndmin,bndmax,rhs
! ---------------------------------------------------------------------
    
    ! Initialisation
    apos = a.ge.0
    
    
    ! Existence de solution dans R
    if (l0.ge.0) then
        nsol = 0
        vide = ASTER_TRUE
        goto 999
    end if
    
    
    ! Definition de rhs et l'intervalle associe
    rhs    = sqrt(-l0)-b
    bndmin = a*merge(etam, etap, apos)
    bndmax = a*merge(etap, etam, apos)
    
    
    ! Calcul de la solution
    if (rhs.ge.bndmin .and. rhs.le.bndmax) then
        nsol = 1
        sol  = rhs/a
        sgn  = merge(1, -1, apos)
        vide = ASTER_FALSE
    else
        nsol = 0
        vide = (max(0.d0,a*etam+b)**2 + l0) .ge. 0
    end if
    
    
999 continue
end subroutine SolvePosValCst


end module pilotage_util_module
