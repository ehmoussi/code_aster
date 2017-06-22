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

subroutine rcvale_wrap (nommaz, phenom, nbpar, nompar, valpar,&
                        nbres, nomres, valres, icodre, iarret)
    implicit none
!
#include "asterfort/rcvale.h"   
!  
    integer, intent(in) :: nbpar, nbres
    character(len=*), intent(in) :: phenom
    integer, intent(in) :: iarret
    character(len=*), intent(in) :: nommaz
    integer, intent(out) :: icodre(nbres)
    character(len=8), intent(in) :: nompar(nbpar)
    character(len=16), intent(in) :: nomres(nbres)
    real(kind=8), intent(in) :: valpar(nbpar)
    real(kind=8), intent(out) :: valres(nbres)
! ----------------------------------------------------------------------
!     WRAPPER FOR rcvale CALLED IN  C from python
!     CHANGE nomres ARRAY WHITH FIXED LENGTH
!

    call rcvale(nommaz, phenom, nbpar, nompar, valpar, nbres, nomres, valres, icodre, iarret)
!
end subroutine
