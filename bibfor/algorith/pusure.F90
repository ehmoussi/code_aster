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

subroutine pusure(nbpt, fn, vt1, vt2, iadh,&
                  t, pusee)
!
!       CALCUL DE LA PUISSANCE D USURE (LOI D ARCHARD)
!
!
!
    implicit none
    real(kind=8) :: fn(*), vt1(*), vt2(*), t(*), pusee
    integer :: iadh(*)
!
!-----------------------------------------------------------------------
    integer :: i, nbpt
!-----------------------------------------------------------------------
    pusee=0.00d00
!
    do 10 i = 1, nbpt-1
        if (iadh(i) .eq. 0) then
            pusee=pusee+ (abs(fn(i+1)*sqrt(vt1(i+1)**2+vt2(i+1)**2))+&
            abs(fn(i)*sqrt(vt1(i)**2+vt2(i)**2)))*(t(i+1)-t(i))
        endif
10  continue
!
    pusee = pusee / 2.d0
    pusee=pusee/(t(nbpt)-t(1))
!
end subroutine
