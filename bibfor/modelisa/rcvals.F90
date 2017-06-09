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

subroutine rcvals(iarret, icodre, nbres, nomres)
    implicit none
#include "jeveux.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
    integer, intent(in) :: iarret, nbres
    integer, intent(in) :: icodre(nbres)
    character(len=*), intent(in) :: nomres(nbres)
!
    character(len=24) :: valk
    character(len=16) :: nomail, para
    integer :: ier, iadzi, iazk24, ires
! ----------------------------------------------------------------------
!
!
    if (iarret .ge. 1) then
        ier = 0
        do 200 ires = 1, nbres
            if (icodre(ires) .eq. 1) then
                ier = ier + 1
                para = nomres(ires)
                valk = para
                call utmess('E+', 'MODELISA9_77', sk=valk)
                if (iarret .eq. 1) then
                    call tecael(iadzi, iazk24)
                    nomail = zk24(iazk24-1+3)(1:8)
                    valk = nomail
                    call utmess('E+', 'MODELISA9_78', sk=valk)
                endif
                call utmess('E', 'VIDE_1')
            endif
200      continue
        if (ier .ne. 0) then
            call utmess('F', 'MODELISA6_4')
        endif
    endif
!
end subroutine
