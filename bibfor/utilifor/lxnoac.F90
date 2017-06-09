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

subroutine lxnoac(chin, chout)
! aslint: disable=
    implicit none
#include "asterfort/lxlgut.h"
    character(len=*) :: chin, chout
!
! ----------------------------------------------------------------------
! --- REMPLACE TOUS LES CARACTERES NON AUTORISES D'UNE CHAINE
!     DE CARACTERES PAR DES '_' (UNDERSCORE).
!      IN : CHIN  = CHAINE EN ENTREE
!     OUT : CHOUT = CHAINE AVEC UNIQUEMENT DES CARACTERES LICITES
! ----------------------------------------------------------------------
!
    integer :: mxchar
    parameter ( mxchar=255 )
    character(len=1) :: class(0:mxchar)
    character(len=255) :: keep
    integer :: i, long, long2
!
    integer :: first
    save         class, first
!
!     ------------------------------------------------------------------
    data first/0/
!                123456789.123456789.123456789.123456789.123456789.12
    data keep/'ABCDEFGHIJKLMONPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz01234567890'/
!     ------------------------------------------------------------------
!
    if (first .eq. 0) then
!
!        INITIALISATION DES TABLES DE CONVERSION
!
        first = 1
        do i = 0, mxchar
            class(i) = '_'
        end do
!
        do i = 1, lxlgut(keep)
            class(ichar(keep(i:i))) = keep(i:i)
        end do
!        ---------------------------------------------------------------
!        WRITE(6,'(25X,A)')' *** CONTROLE DE LA TABLE DE CONVERSION ***'
!        WRITE(6,'(10(1X,4A))') (' * ',CHAR(I),'= ',CLASS(I),I=0,255)
!        WRITE(6,'(1X,79(''-''))')
!        ---------------------------------------------------------------
    endif
!
!       LONG = LEN(CHIN)
    long = lxlgut(chin)
    long2 = len(chout)
    do i = 1, min(long, long2)
        chout(i:i) = class(ichar(chin(i:i)))
    end do
!
!     MISE A BLANC DE LA FIN DE LA CHAINE
    do i = min(long, long2)+1, long2
        chout(i:i) = ' '
    end do
!
!     ------------------------------------------------------------------
end subroutine
