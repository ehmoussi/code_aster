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

!
!
interface
    subroutine elrefe_info(elrefe, fami, ndim, nno,&
                      nnos, npg, jpoids, jcoopg, jvf,&
                      jdfde, jdfd2, jgano)
        character(len=*), intent(in), optional :: elrefe
        character(len=*), intent(in) :: fami
        integer, intent(out), optional :: ndim
        integer, intent(out), optional  :: nno
        integer, intent(out), optional  :: nnos
        integer, intent(out), optional  :: npg
        integer, intent(out), optional  :: jpoids
        integer, intent(out), optional  :: jcoopg
        integer, intent(out), optional  :: jvf
        integer, intent(out), optional  :: jdfde
        integer, intent(out), optional  :: jdfd2
        integer, intent(out), optional  :: jgano
    end subroutine elrefe_info
end interface
