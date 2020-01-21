! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
!
subroutine maveElemCreate(base, phenom, mave_elemz, model_, mate_, cara_elem_)
!
implicit none
!
#include "asterfort/memare.h"
#include "asterfort/reajre.h"
!
character(len=1), intent(in) :: base
character(len=4), intent(in) :: phenom
character(len=*), intent(in) :: mave_elemz
character(len=*), optional, intent(in) :: model_, mate_, cara_elem_
!
! --------------------------------------------------------------------------------------------------
!
! Elementary vectors and matrices
!
! Create a new elementary vector/matrix
!
! --------------------------------------------------------------------------------------------------
!
! In  base             : JEVEUX base to create object
! In  phenom           : phenomenon (mechanics, thermics, ...)
! In  mave_elem        : name of matr_elem or vect_elem
! In  model            : name of model
! In  mate             : name of material characteristics (field)
! In  cara_elem        : name of elementary characteristics (field)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=19) :: mave_elem, mate = ' ', model = ' ', cara_elem = ' '
!
! --------------------------------------------------------------------------------------------------
!
    mave_elem = mave_elemz
    if (present(model_)) then
        model = model_
    endif
    if (present(cara_elem_)) then
        cara_elem = cara_elem_
    endif
    if (present(mate_)) then
        mate = mate_
    endif
    call memare(base, mave_elem, model, mate, cara_elem, 'CHAR_'//phenom)
    call reajre(mave_elem, ' ', base)
!
end subroutine
