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

subroutine pmpitp(typfib,flp, nbpout, yj, zj, fl)
    implicit none
! -----------------------------------------------------------
! ---  INTEGRATION DES CONTRAINTES SUR LA SECTION MULTIPOUTRE
!      (CALCUL DES FORCES INTERIEURES)
! --- IN 
!       flp(12,*) : tableau de forces elementaires sur sous-poutres
!       nbpout    : nombre d assemblages de fibres
!       yi(*)     : position Y des sous-poutres
!       zi(*)     : position Z des sous-poutres
!
! --- OUT
!       fl(12)    : forces elementaires
! -----------------------------------------------------------
#include "asterfort/codent.h"
#include "asterfort/utmess.h"
#include "asterfort/r8inir.h"
    integer :: i, nbpout, typfib
    real(kind=8) :: fl(*), flp(12,*), yj(*), zj(*)
!
    if (typfib.eq.2) then        
      call r8inir(12, 0.d0, fl, 1)
      do  i = 1, nbpout
        fl(1)=fl(1)+flp(1,i)
        fl(2)=fl(2)+flp(2,i)
        fl(3)=fl(3)+flp(3,i)
        fl(4)=fl(4)+flp(4,i)+flp(3,i)*yj(i)-flp(2,i)*zj(i)
        fl(5)=fl(5)+flp(5,i)+flp(1,i)*zj(i)
        fl(6)=fl(6)+flp(6,i)-flp(1,i)*yj(i)
        fl(7)=fl(7)+flp(7,i)
        fl(8)=fl(8)+flp(8,i)
        fl(9)=fl(9)+flp(9,i)
        fl(10)=fl(10)+flp(10,i)+flp(9,i)*yj(i)-flp(8,i)*zj(i)
        fl(11)=fl(11)+flp(11,i)+flp(7,i)*zj(i)
        fl(12)=fl(12)+flp(12,i)-flp(7,i)*yj(i)
      enddo
   else if (typfib .eq. 3) then     
      call r8inir(18, 0.d0, fl, 1)
      do  i = 1, nbpout
        fl(1)=fl(1)+flp(1,i)
        fl(2)=fl(2)+flp(2,i)
        fl(3)=fl(3)+flp(3,i)
        fl(4)=fl(4)+flp(4,i)
        fl(5)=fl(5)+flp(5,i)
        fl(6)=fl(6)+flp(6,i)
        fl(7)=fl(7)+flp(3,i)*yj(i)-flp(2,i)*zj(i)
        fl(8)=fl(8)+flp(1,i)*zj(i)
        fl(9)=fl(9)-flp(1,i)*yj(i)
        fl(10)=fl(10)+flp(7,i)
        fl(11)=fl(11)+flp(8,i)
        fl(12)=fl(12)+flp(9,i)
        fl(13)=fl(13)+flp(10,i)
        fl(14)=fl(14)+flp(11,i)
        fl(15)=fl(15)+flp(12,i)
        fl(16)=fl(16)+flp(9,i)*yj(i)-flp(8,i)*zj(i)
        fl(17)=fl(17)+flp(7,i)*zj(i)
        fl(18)=fl(18)-flp(7,i)*yj(i)
      enddo
   end if 
!
end subroutine
