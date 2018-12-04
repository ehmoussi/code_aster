! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
    subroutine mmmvas(ndim  , nne   , nnm   , nnl   , nbdm, nbcps,&
                      vectce, vectcm, vectfe, vectfm,&
                      vectcc, vectff,&
                      vcont , vfric)
        integer, intent(in) :: nbdm, ndim, nnl, nne, nnm, nbcps
        real(kind=8), intent(in) :: vectce(27), vectcm(27)
        real(kind=8), intent(in) :: vectfe(27), vectfm(27)
        real(kind=8), intent(in) :: vectcc(9), vectff(18)
        real(kind=8), intent(inout) :: vcont(81), vfric(81)
    end subroutine mmmvas
end interface
