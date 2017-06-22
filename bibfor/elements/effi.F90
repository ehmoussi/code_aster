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

subroutine effi(nomte, sigmtd, vf, dfds, jacp,&
                sina, cosa, r, effint)
    implicit none
!
    character(len=16) :: nomte
    real(kind=8) :: sigmtd(*), sina, cosa, r, vf(*), dfds(*), jacp, effint(*)
    real(kind=8) :: mats(5, 9), effinb(9)
!
!     CALCULS DES EFFORTS INTERIEURS
!
!-----------------------------------------------------------------------
    integer :: i, k
!-----------------------------------------------------------------------
    if (nomte .eq. 'MECXSE3') then
!
        mats(1,1)=-sina*dfds(1)
        mats(1,2)= cosa*dfds(1)
        mats(1,3)= 0.d0
        mats(1,4)=-sina*dfds(2)
        mats(1,5)= cosa*dfds(2)
        mats(1,6)= 0.d0
        mats(1,7)=-sina*dfds(3)
        mats(1,8)= cosa*dfds(3)
        mats(1,9)= 0.d0
!
        mats(2,1)= 0.d0
        mats(2,2)= 0.d0
        mats(2,3)= dfds(1)
        mats(2,4)= 0.d0
        mats(2,5)= 0.d0
        mats(2,6)= dfds(2)
        mats(2,7)= 0.d0
        mats(2,8)= 0.d0
        mats(2,9)= dfds(3)
!
        mats(3,1)= vf(1)/r
        mats(3,2)= 0.d0
        mats(3,3)= 0.d0
        mats(3,4)= vf(2)/r
        mats(3,5)= 0.d0
        mats(3,6)= 0.d0
        mats(3,7)= vf(3)/r
        mats(3,8)= 0.d0
        mats(3,9)= 0.d0
!
        mats(4,1)= 0.d0
        mats(4,2)= 0.d0
        mats(4,3)= -sina*vf(1)/r
        mats(4,4)= 0.d0
        mats(4,5)= 0.d0
        mats(4,6)= -sina*vf(2)/r
        mats(4,7)= 0.d0
        mats(4,8)= 0.d0
        mats(4,9)= -sina*vf(3)/r
!
        mats(5,1)= cosa*dfds(1)
        mats(5,2)= sina*dfds(1)
        mats(5,3)= vf(1)
        mats(5,4)= cosa*dfds(2)
        mats(5,5)= sina*dfds(2)
        mats(5,6)= vf(2)
        mats(5,7)= cosa*dfds(3)
        mats(5,8)= sina*dfds(3)
        mats(5,9)= vf(3)
!
!     CONSTRUCTION DES EFFORTS INTERIEURS
!
        do 10 i = 1, 9
            effinb(i)=0.d0
            do 20 k = 1, 5
                effinb(i)=effinb(i)+mats(k,i)*sigmtd(k)
20          end do
            effint(i)=effint(i)+jacp*effinb(i)
10      end do
!
    else
!
        mats(1,1)=-sina*dfds(1)
        mats(1,2)= cosa*dfds(1)
        mats(1,3)= 0.d0
        mats(1,4)=-sina*dfds(2)
        mats(1,5)= cosa*dfds(2)
        mats(1,6)= 0.d0
        mats(1,7)=-sina*dfds(3)
        mats(1,8)= cosa*dfds(3)
        mats(1,9)= 0.d0
!
        mats(2,1)= 0.d0
        mats(2,2)= 0.d0
        mats(2,3)= dfds(1)
        mats(2,4)= 0.d0
        mats(2,5)= 0.d0
        mats(2,6)= dfds(2)
        mats(2,7)= 0.d0
        mats(2,8)= 0.d0
        mats(2,9)= dfds(3)
!
        mats(3,1)= cosa*dfds(1)
        mats(3,2)= sina*dfds(1)
        mats(3,3)= vf(1)
        mats(3,4)= cosa*dfds(2)
        mats(3,5)= sina*dfds(2)
        mats(3,6)= vf(2)
        mats(3,7)= cosa*dfds(3)
        mats(3,8)= sina*dfds(3)
        mats(3,9)= vf(3)
!
        do 30 i = 1, 9
            effinb(i)=0.d0
            do 40 k = 1, 3
                effinb(i)=effinb(i)+mats(k,i)*sigmtd(k)
40          end do
            effint(i)=effint(i)+jacp*effinb(i)
30      end do
!
    endif
end subroutine
