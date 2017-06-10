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

subroutine rccoma(jmat, mater_typez, iarret, mater_keyword, icodre)
!
    implicit none
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
!
    integer, intent(in) :: jmat
    character(len=*), intent(in) :: mater_typez
    integer, intent(in) :: iarret
    character(len=*), intent(out) :: mater_keyword
    integer, optional, intent(out) :: icodre
!
! --------------------------------------------------------------------------------------------------
!
! Comportment utility
!
! Get material keyword factor from type of material parameter
!
! --------------------------------------------------------------------------------------------------
!
! Example:
!      mater_type/mater_keyword
!      'ELAS' -> / 'ELAS'
!                / 'ELAS_ISTR'
!                / 'ELAS_GONF'
!                / ...
!      'ECRO' -> / 'ECRO_PUIS'
!                / 'ECRO_LINE'
!
! In  jmat          : adress to material parameters
! In  mater_type    : type of material parameter
! In  iarret        : 0 to set return code ICODRE and no error message
!                     1 stop and error message
! Out mater_keyword : keyword factor linked to type of material parameter
! Out icodre        : 0 everything is OK
!                     1 no mater_keyword found
!                     2 several DIFFERTENT mater_keyword found
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nbmat, im, imat, icomp, ind, icodre_in
    character(len=16) :: mater_type
!
! --------------------------------------------------------------------------------------------------
!
    ASSERT(jmat.ne.1)
    ASSERT((iarret.eq.0) .or. (iarret.eq.1))
!
    mater_type = mater_typez
    ind = index(mater_type,'_FO')
    ASSERT(ind.eq.0)
    if (iarret.eq.0) then
        ASSERT((present(icodre)))
    endif
!
    icodre_in = 1
    mater_keyword = ' '
    nbmat    = zi(jmat)
    do im = 1, nbmat
        imat = jmat+zi(jmat+nbmat+im)
        do icomp = 1, zi(imat+1)
            if (mater_type .eq. zk32(zi(imat)+icomp-1)(1:len(mater_typez))) then
                if (mater_keyword .eq. ' ') then
                    mater_keyword=zk32(zi(imat)+icomp-1)
                    icodre_in = 0
                else
                    if (mater_keyword.ne.zk32(zi(imat)+icomp-1) .and.&
                        mater_keyword .ne. 'ELAS_GONF') then
                        if (iarret .eq. 1) then
                            call utmess('F', 'COMPOR5_56', sk=mater_type)
                        else
                            icodre_in = 2
                        endif
                    endif
                endif
            endif
        end do
    end do
!
    if (( icodre_in .eq. 1 ) .and. ( iarret .eq. 1 )) then
        call utmess('F', 'COMPOR5_57', sk=mater_type)
    endif
    if (present(icodre)) then
        icodre = icodre_in
    endif
!
end subroutine
