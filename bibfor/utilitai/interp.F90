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

subroutine interp(tabx, taby, necr, x, y,&
                  iseg)
!     AUTEUR : C. DUVAL DEPT AMV
!     ----------------------------------------------------------------
!
!     BUT: FAIT L'INTERPOLATION LINEAIRE ENTRE 2 POINTS D'UNE FONCTION
!
!     ----------------------------------------------------------------
!
!     TABX,TABY /IN/:PARAMETRES ET VALEURS DE LA FONCTION
!     NECR         /IN/:NOMBRE DE POINTS DE LA FONCTION
!     X            /IN/:VALEUR A INTERPOLER
!
!     Y            /OUT/:VALEUR DE LA FONCTION EN X
!     ISEG         /OUT/:RANG DU SEGMENT DE LA FONCTION CONTENANT X
!
!     ----------------------------------------------------------------
!
    implicit none
    real(kind=8) :: tabx(*), taby(*)
    integer :: ipt, iseg, necr
    real(kind=8) :: x, x1, x2, y, y1, y2
!-----------------------------------------------------------------------
    do 1 ,ipt=2,necr
    x1=tabx(ipt-1)
    x2=tabx(ipt)
    if (((x-x1)*(x-x2)) .le. 0.d0) then
        iseg=ipt
        y1=taby(ipt-1)
        y2=taby(ipt)
        if (x1 .eq. x2) then
            y=y1
        else
            y=y1+(x-x1)*(y1-y2)/(x1-x2)
        endif
        goto 9999
    endif
    1 end do
9999  continue
end subroutine
