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

subroutine reajre(matr_vect_elemz, resu_elemz, base)
!
implicit none
!
#include "asterfort/exisd.h"
#include "asterfort/jeecra.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/juveca.h"
#include "asterfort/wkvect.h"
!
!
    character(len=*), intent(in) :: matr_vect_elemz
    character(len=*), intent(in) :: resu_elemz
    character(len=1), intent(in) :: base
!
! --------------------------------------------------------------------------------------------------
!
! RESU_ELEM Management
!
! Add a new elementary result (resu_elem) in matr_elem or vect_elem (elementary matrix or vector)
!
! --------------------------------------------------------------------------------------------------
!
! In  matr_vect_elem : name of matr_elem or vect_elem
! In  resu_elem      : name of resu_elem (if ' ', just init matr_vect_elem)
! In  base           : JEVEUX basis
!
! --------------------------------------------------------------------------------------------------
!
    integer :: ndim
    parameter (ndim=10)
!
    integer :: iret, nlmax, nluti, iret1, iret2
    character(len=19) :: matr_vect_elem, resu_elem
    character(len=24), pointer :: p_relr(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    resu_elem      = resu_elemz
    matr_vect_elem = matr_vect_elemz
!
! - Create RELR object
!
    call jeexin(matr_vect_elem//'.RELR', iret)
    if (iret .eq. 0) then
        call wkvect(matr_vect_elem//'.RELR', base//' V K24', ndim, vk24 = p_relr)
        call jeecra(matr_vect_elem//'.RELR', 'LONUTI', 0)
    endif
!
! - Add resu_elem
!
    if (resu_elem .ne. ' ') then
        call exisd('RESUELEM', resu_elem, iret1)
        call exisd('CHAM_NO' , resu_elem, iret2)
        if ((iret1.ne.0) .or. (iret2.ne.0)) then
!
! --------- Increase size if necessary
!
            call jelira(matr_vect_elem//'.RELR', 'LONMAX', nlmax)
            call jelira(matr_vect_elem//'.RELR', 'LONUTI', nluti)
            if (nlmax .eq. nluti) then
                call juveca(matr_vect_elem//'.RELR', nlmax+ndim)
            endif
!
! --------- Add resu_elem
!
            call jeveuo(matr_vect_elem//'.RELR', 'E', vk24 = p_relr)
            p_relr(nluti+1) = resu_elem
            call jeecra(matr_vect_elem//'.RELR', 'LONUTI', nluti+1)
        endif
    endif
!
end subroutine
