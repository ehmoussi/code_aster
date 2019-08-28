! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
    subroutine behaviourPrepExternal(carcri  , typmod ,&
                                     nno     , npg    , ndim    ,&
                                     jv_poids, jv_func, jv_dfunc,&
                                     geom    , deplm  , ddepl   ,&
                                     coorga)
        use Behaviour_type
        real(kind=8), intent(in) :: carcri(*)
        character(len=8), intent(in) :: typmod(2)
        integer, intent(in) :: nno, npg, ndim
        integer, intent(in) :: jv_poids, jv_func, jv_dfunc
        real(kind=8), intent(in) :: deplm(ndim, nno), ddepl(ndim, nno)
        real(kind=8), intent(in) :: geom(ndim, nno)
        real(kind=8), intent(out) :: coorga(27,3)
    end subroutine behaviourPrepExternal
end interface
