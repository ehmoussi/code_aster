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

subroutine bussetta_algorithm(dist_cont_curr, dist_cont_prev,dist_max, coef_bussetta)

!
implicit none
!
#include "asterfort/assert.h"
!
! person_in_charge: ayaovi-dzifa.kudawoo at edf.fr
!

    real(kind=8), intent(in) :: dist_cont_curr
    real(kind=8), intent(in) :: dist_cont_prev
    real(kind=8), intent(in) :: dist_max
    real(kind=8), intent(inout) :: coef_bussetta
 
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Solve - Cycling
!
! Optimal search of penalization coefficient : WARNING CYCLAGE il faut commenter
!
! --------------------------------------------------------------------------------------------------
!
! In  
! Out 
!
! --------------------------------------------------------------------------------------------------
!


    if (dist_cont_prev*dist_cont_curr .lt. 0.0) then
       if (dist_cont_prev .gt. dist_max) then 
           if (abs(dist_cont_curr) .gt. 0.0d0 .and. &
               abs(dist_cont_curr-dist_cont_prev) .gt. 0) &
               coef_bussetta = abs((coef_bussetta*dist_cont_prev)/dist_cont_curr*&
                                   (abs(dist_cont_curr)+dist_max)/(dist_cont_curr-dist_cont_prev))
       else
            if (abs(dist_cont_curr) .gt. 0) &
                coef_bussetta = abs((coef_bussetta*dist_cont_prev)/(10*dist_cont_curr))
       endif

    elseif (dist_cont_curr .gt. dist_max) then
        if (abs(dist_cont_curr-dist_cont_prev) .gt. &
            max(dist_cont_curr/10,dist_cont_prev/10,5*dist_max)) then
            coef_bussetta = 2*coef_bussetta
        elseif  (abs(dist_cont_curr) .lt. 10*dist_max) then 
            coef_bussetta = coef_bussetta*(sqrt(abs(dist_cont_curr)/dist_max -1.0)+1)**2
        elseif (abs(dist_cont_curr) .gt. (abs(dist_cont_prev)+0.01*abs(dist_cont_curr))) then 
            coef_bussetta = 2.0*coef_bussetta*(dist_cont_prev/dist_cont_curr)
        else 
            coef_bussetta = coef_bussetta*(sqrt(abs(dist_cont_curr)/dist_max -1.0)+1)
        endif
    
    endif
    
end subroutine
