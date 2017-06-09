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

subroutine utrcyl(point, dire, orig, p)
    implicit none
!
    real(kind=8) :: point(3), dire(3), orig(3), p(3, 3)
    real(kind=8) :: sca, xnorm
!-----------------------------------------------------------------------
!
    sca=(point(1)-orig(1))*dire(1)+&
     &    (point(2)-orig(2))*dire(2)+&
     &    (point(3)-orig(3))*dire(3)
!
    p(3,1)=(point(1)-orig(1))-sca*dire(1)
    p(3,2)=(point(2)-orig(2))-sca*dire(2)
    p(3,3)=(point(3)-orig(3))-sca*dire(3)
!
    xnorm=sqrt(p(3,1)**2+p(3,2)**2+p(3,3)**2)
    p(3,1)=p(3,1)/xnorm
    p(3,2)=p(3,2)/xnorm
    p(3,3)=p(3,3)/xnorm
!
    xnorm=sqrt(dire(1)**2+dire(2)**2+dire(3)**2)
    p(1,1)=dire(1)/xnorm
    p(1,2)=dire(2)/xnorm
    p(1,3)=dire(3)/xnorm
!
    p(2,1)= p(3,2)*p(1,3)-p(3,3)*p(1,2)
    p(2,2)= p(3,3)*p(1,1)-p(3,1)*p(1,3)
    p(2,3)= p(3,1)*p(1,2)-p(3,2)*p(1,1)
!
end subroutine
