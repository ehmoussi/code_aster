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

subroutine pusur2(jdg, nbpt, ang, fn, vt1,&
                  vt2, angle, t, puse, noccur)
!
!       CALCUL DE LA PUISSANCE D USURE (LOI D ARCHARD)
!
!
!
!-----------------------------------------------------------------------
!
    implicit none
    real(kind=8) :: ang(*), fn(*), vt1(*), vt2(*), angle(*), t(*), puse, tmp
!
!-----------------------------------------------------------------------
    integer :: i, jdg, nbpt, noccur
    real(kind=8) :: zero
!-----------------------------------------------------------------------
    zero=0.00d00
    tmp=0.00d00
    puse=0.00d00
    noccur=0
!
    do 10 i = 1, nbpt-1
        if ((angle(i).le.ang(jdg+1)) .and. ((angle(i).gt.ang(jdg)))) then
            puse=puse+ (abs(fn(i+1)*sqrt(vt1(i+1)**2+vt2(i+1)**2))+&
            abs(fn(i)*sqrt(vt1(i)**2+vt2(i)**2)))*(t(i+1)-t(i))
            tmp=tmp+t(i+1)-t(i)
            noccur=noccur+1
        endif
10  continue
!
    puse = puse / 2.d0
    if (tmp .eq. zero) then
        puse = zero
    else
        puse=puse/tmp
    endif
!
end subroutine
