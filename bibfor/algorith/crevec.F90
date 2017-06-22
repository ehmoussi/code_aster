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

subroutine crevec(nom, carac, dim, jadr)
! person_in_charge: hassan.berro at edf.fr
!
! Create a jeveux vector using a similar syntax to wkvect, but with persistent
! memory allocation, (jeveut). This utility is used in DYNA_VIBRA // mdallo.F90
!
    implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jecreo.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeveut.h"
!
    character(len=*), intent(in) :: nom
    character(len=*), intent(in) :: carac
    integer         , intent(in)  :: dim
    integer         , intent(out) :: jadr
!
    call jecreo(nom, carac)
    call jeecra(nom, 'LONMAX', ival=dim)
    call jeecra(nom, 'LONUTI', ival=dim)
    call jeveut(nom, 'E', jadr)
!
end subroutine
