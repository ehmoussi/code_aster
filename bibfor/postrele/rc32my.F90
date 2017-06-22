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

subroutine rc32my(nbabsc, absc, vale, momen0, momen1)
    implicit   none
    integer :: nbabsc
    real(kind=8) :: absc(*), vale(*), momen0, momen1
!     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE_B3200
!
!     CALCUL DES MOYENNES
!     EXTRAIT DE LA ROUTINE RVPSTM
!
!     ------------------------------------------------------------------
!
    integer :: nbsgt, isgt
    real(kind=8) :: l, s1, s2, s12, t1, t2, t12, smil
! DEB ------------------------------------------------------------------
!
! --- LONGUEUR DU SEGMENT
!
    l = 1.0d0/ ( absc(nbabsc) - absc(1) )
    nbsgt = nbabsc - 1
!
    momen0 = 0.0d0
    momen1 = 0.0d0
!
    do 10, isgt = 1, nbsgt, 1
!
    s1 = absc(isgt) - absc(1)
    s2 = absc(isgt+1) - absc(1)
    s12 = s2 - s1
!
    t1 = vale(isgt)
    t2 = vale(isgt+1)
    t12 = (t1+t2)/2.0d0
!
    smil = (s1+s2)/2.0d0
    momen0 = momen0 + s12*(t1 + t2)
    momen1 = momen1 + s12/3.0d0 * (t1*s1 + 4.0d0*t12*smil + t2*s2)
!
    10 end do
!
    momen0 = momen0*l
    momen1 = momen1*l*l
!
    momen0 = 0.5d0*momen0
    momen1 = 6.0d0*(momen1 - momen0)
!
end subroutine
