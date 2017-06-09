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

subroutine cotfac(xyz, n1, n2, n3, n4,&
                  xpt, iret)
    implicit none
!  DESCRIPTION :
!-------------------   DECLARATION DES VARIABLES   ---------------------
!
! ARGUMENTS
! ---------
    integer :: n1, n2, n3, n4, iret
    real(kind=8) :: xyz(3, *), xpt(*)
!
! VARIABLES LOCALES
! -----------------
    real(kind=8) :: v12(3), v23(3), v24(3), v25(3), vno(3)
    real(kind=8) :: ra, rb, rr
    real(kind=8) :: eps
!
!-------------------   DEBUT DU CODE EXECUTABLE    ---------------------
!
    eps=1.d-5
    v12(1)=xyz(1,n2)-xyz(1,n1)
    v12(2)=xyz(2,n2)-xyz(2,n1)
    v12(3)=xyz(3,n2)-xyz(3,n1)
    v23(1)=xyz(1,n3)-xyz(1,n2)
    v23(2)=xyz(2,n3)-xyz(2,n2)
    v23(3)=xyz(3,n3)-xyz(3,n2)
    vno(1) = v23(2) * v12(3) - v23(3) * v12(2)
    vno(2) = v23(3) * v12(1) - v23(1) * v12(3)
    vno(3) = v23(1) * v12(2) - v23(2) * v12(1)
!
    v24(1)=xyz(1,n4)-xyz(1,n2)
    v24(2)=xyz(2,n4)-xyz(2,n2)
    v24(3)=xyz(3,n4)-xyz(3,n2)
!
    v25(1)=xpt(1)-xyz(1,n2)
    v25(2)=xpt(2)-xyz(2,n2)
    v25(3)=xpt(3)-xyz(3,n2)
!
    ra=vno(1)*v24(1)+vno(2)*v24(2)+vno(3)*v24(3)
    rb=vno(1)*v25(1)+vno(2)*v25(2)+vno(3)*v25(3)
    rr=rb/ra
!
    if (rr .gt. eps) then
        iret=1
    else if (rr.gt.-1.d0*eps) then
        iret=0
    else
        iret=-1
    endif
!
end subroutine
