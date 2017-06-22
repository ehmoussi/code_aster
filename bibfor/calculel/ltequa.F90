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

function ltequa(elref, enr)
    implicit none
!
!
#include "asterf_types.h"
#include "asterfort/iselli.h"
!---------------------------------------------------------------------
! but : Tester si l'enrichissement quadratique et autorisé pour la lecture/ecriture de ppmilto
!---------------------------------------------------------------------
!     arguments:
!     ----------
!    (o) in  elref (k8) : nom de l'element parent
!    (o) in  enr   (k8) : type d'enrichissement
!-----------------------------------------------------------------------
    character(len=8), intent(in) :: elref
    character(len=8), intent(in) :: enr
!-----------------------------------------------------------------------
!
    aster_logical :: ltequa
!
!----------------------------------------------------------------------
    ltequa=.false.
    if ((enr(1:2).eq.'XH' .or. enr(1:3).eq.'XHT' .or. enr(1:2).eq.'XT' .or.&
         enr(1:3).eq.'XHC'.or. enr(1:3).eq.'XTC'.or. enr(1:4).eq.'XTHC') .and.&
         .not.iselli(elref)) ltequa=.true.
end function
