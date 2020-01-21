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
interface
    subroutine varcCalcMeta(modelz,&
                            nbin  , nbout     ,&
                            lpain , lchin     ,&
                            lpaout, lchout    ,&
                            base  , vect_elemz)
        character(len=*), intent(in) :: modelz
        integer, intent(in) :: nbin, nbout
        character(len=8), intent(in) :: lpain(*), lpaout(*)
        character(len=19), intent(in) :: lchin(*)
        character(len=19), intent(inout) :: lchout(*)
        character(len=1), intent(in) :: base
        character(len=*), intent(in) :: vect_elemz
    end subroutine varcCalcMeta
end interface
