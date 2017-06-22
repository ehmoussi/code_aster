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

subroutine search_opt_coef(coef, indi, pres_cont, dist_cont,&
                                      coef_opt , terminate)

!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/mmstac.h"
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!
    real(kind=8), intent(in) :: coef(2)
    integer       :: indi(2)
    real(kind=8), intent(inout) :: pres_cont(2)
    real(kind=8), intent(inout) :: dist_cont(2)
    real(kind=8), intent(out) :: coef_opt
    aster_logical, intent(out) :: terminate
 
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve - Cycling
!
! Optimal search of coefficient : WARNING CYCLAGE
!
! --------------------------------------------------------------------------------------------------
!
! In  
! Out 
!
! --------------------------------------------------------------------------------------------------
!
    integer      :: indi_curr,indi_prev, it,mode_cycl = 1
    real(kind=8) :: save_coefficient, coefficient
    real(kind=8) :: valmin, valmax
    
    terminate   = .false.
    coefficient = coef(1)
    save_coefficient = coefficient
    valmin      = coef(1)
    valmax      = coef(2)
    it = 1 
    
    do while ( (coefficient .lt. valmax) .and. (.not. terminate))
       
! Optimalite du coefficient : 
!     (pres_prev -coef*dist_prev)*(pres_curr -coef*dist_curr) > 0
       if (mode_cycl .eq. 1) then
           if (dist_cont(1) .gt. 1.d-6 )   dist_cont(1) = 0.0
           if (pres_cont(1) .gt. 1.d-6 )  pres_cont(1) = -1.d-15
           if (dist_cont(2) .gt. 1.d-6 )  dist_cont(1) = 0.0
           if (pres_cont(2) .gt. 1.d-6 )  pres_cont(1) = -1.d-15
       endif
       call mmstac(dist_cont(1), pres_cont(1),coefficient,indi_curr)
       call mmstac(dist_cont(2), pres_cont(2),coefficient,indi_prev)
        
       if ((indi_curr + indi_prev .eq. 0) .or.&
           (indi_curr + indi_prev .eq. 2)     ) then 
           terminate = .true.
           indi(1)   = indi_prev
           indi(2)   = indi_curr
           
       elseif (indi_curr + indi_prev .eq. 1) then 
           terminate = .false.
           
       else  
           ASSERT(.false.)
           
       endif
       
! Dichotomie : continue iteration using dichotomie 
       if (terminate .and. (it .lt. 500)) then
           it = it + 1 
           save_coefficient = coefficient  
           valmax = (log(coefficient) + log(valmax)) / 2
           if (valmax .lt. log(coef(2))) then 
               valmax = 10**valmax
               terminate = .false. 
           else 
               terminate = .true.
           endif
           
       else
           save_coefficient = coefficient
           
       endif
      coefficient = coefficient *4.0d0     
! Dichotomie :
      
    end do
    
    coef_opt = save_coefficient
    
end subroutine
