! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

subroutine dgendo1(em, ea, sya, b, syt, h, fcj, epsi_c, num,&
                   gt, gc, syc, alpha_c)
!
    implicit none
!
! PARAMETRES ENTRANTS
#include "asterfort/zerop3.h"
    real(kind=8), intent(in) :: em, ea, sya, b, syt, h, fcj
    real(kind=8), intent(in) :: epsi_c, num
    real(kind=8), intent(inout) :: gt
    real(kind=8), intent(out) :: gc, syc, alpha_c
! ----------------------------------------------------------------------
! PARAMETRES INTERMEDIAIRES
    integer :: ns, ii
    real(kind=8) :: c0, c1, c2, c3, x(3)
    real(kind=8) :: na, dm, nyu, dd
    
    alpha_c = 1.d0
    na = b/ea*sya
    dm = (na-syt)/(syt*gt)
    nyu = h*fcj + b*epsi_c 
    if ((dm.gt.0.d0) .and. (gt.lt.1.d0))then     
        dd = dm/(h*em*epsi_c-nyu)
        c0 = dd*num**2*(1-gt)
        c1 = (1-num)*(1+2*num)/c0
        c2 = -dd*(1-gt)*(1-num)*(1+2*num)*syt**2/c0
        c3 = -syt**2*num**2/c0    
        call zerop3(c1, c2, c3, x, ns)
        do ii = 1, ns
            if ((x(ii) .gt. 0.d0)) then
                syc=x(ii)
            endif
        enddo
        gc = (nyu-syc)/(h*em*epsi_c-syc)
        alpha_c = dd*syc*(1-gc)
    else    
        gt = 0.d0 
        dm = h*em/(b)-1.d0
        dd = dm/(h*em*epsi_c-nyu)
        c0 = dd*num**2*(1-gt)
        c1 = (1-num)*(1+2*num)/c0
        c2 = -dd*(1-gt)*(1-num)*(1+2*num)*syt**2/c0    
        c3 = -syt**2*num**2/c0
        call zerop3(c1, c2, c3, x, ns)    
        do ii = 1, ns
            if ((x(ii) .gt. 0.d0)) then
                syc=x(ii)
            endif
        enddo
        gc = (nyu-syc)/(h*em*epsi_c-syc)
        alpha_c = dd*syc*(1-gc)
    endif 
!
end subroutine
