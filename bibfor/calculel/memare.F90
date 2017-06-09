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

subroutine memare(base  , matr_vect_elemz, modelz, mate, cara_elem,&
                  suropt)
!
implicit none
!
#include "asterfort/assert.h"
#include "asterfort/jedetr.h"
#include "asterfort/wkvect.h"
!
!
    character(len=1), intent(in) :: base
    character(len=*), intent(in) :: matr_vect_elemz
    character(len=*), intent(in) :: modelz
    character(len=*), intent(in) :: mate
    character(len=*), intent(in) :: cara_elem
    character(len=*), intent(in) :: suropt
!
! --------------------------------------------------------------------------------------------------
!
! RESU_ELEM Management
!
! Create RERR object for matr_elem or vect_elem
!
! --------------------------------------------------------------------------------------------------
!
! In  base           : JEVEUX basis
! In  matr_vect_elem : name of matr_elem or vect_elem
! In  modelz         : name of model
! In  mate           : name of material characteristics (field)         
! In  cara_elem      : name of elementary characteristics (field)
! In  suropt         : name of "SUR_OPTION"
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: model
    character(len=19) :: matr_vect_elem
    character(len=24), pointer :: p_rerr(:) => null()
!
! --------------------------------------------------------------------------------------------------
!
    matr_vect_elem = matr_vect_elemz
    model          = modelz
    ASSERT(model.ne.' ')
!
    call jedetr(matr_vect_elem//'.RERR')
    call wkvect(matr_vect_elem//'.RERR', base//' V K24', 5, vk24 = p_rerr)
    p_rerr(1) = model
    p_rerr(2) = suropt
    p_rerr(3) = 'NON_SOUS_STRUC'
    p_rerr(4) = mate
    p_rerr(5) = cara_elem
!
end subroutine
