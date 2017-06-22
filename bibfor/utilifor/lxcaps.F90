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

subroutine lxcaps(chaine)
! aslint: disable=
    implicit none
    character(len=*) :: chaine
!
!     ------------------------------------------------------------------
!      TRANSFORME LES MINUSCULES EN MAJUSCULES
!     ------------------------------------------------------------------
! VAR CHAINE CHAINE A TRANSFORMER
!     ROUTINE(S) UTILISEE(S) :
!         -
!     ROUTINE(S) FORTRAN     :
!         CHAR    ICHAR   LEN
!     ------------------------------------------------------------------
! FIN LXCAPS
!     ------------------------------------------------------------------
!
    integer :: mxchar
!-----------------------------------------------------------------------
    integer :: i, ilong
!-----------------------------------------------------------------------
    parameter ( mxchar=255 )
    character(len=1) :: class(0:mxchar)
    character(len=26) :: minus, major
!
    integer :: long, first
    save         class, first
!
!     ------------------------------------------------------------------
    data first/0/
    data minus/'abcdefghijklmnopqrstuvwxyz'/
    data major/'ABCDEFGHIJKLMNOPQRSTUVWXYZ'/
!     ------------------------------------------------------------------
!
    if (first .eq. 0) then
!
!        INITIALISATION DES TABLES DE CONVERSION
!
        first = 1
        do 10 i = 0, mxchar
            class(i) = char(i)
10      continue
!
        do 20 i = 1, 26
            class(ichar(minus(i:i))) = class(ichar(major(i:i)))
20      continue
!        ---------------------------------------------------------------
!-DBG    WRITE(6,'(25X,A)')' *** CONTROLE DE LA TABLE DE CONVERSION ***'
!-DBG    WRITE(6,'(10(1X,4A))') (' * ',CHAR(I),'= ',CLASS(I),I=0,255)
!-DBG    WRITE(6,'(1X,79(''-''))')
!        ---------------------------------------------------------------
    endif
!
    long = len(chaine)
    do 100 ilong = 1, long
        chaine(ilong:ilong) = class(ichar(chaine(ilong:ilong)))
100  end do
!
!     ------------------------------------------------------------------
end subroutine
