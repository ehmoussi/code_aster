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
    subroutine mm_cycl_adaf(adap_type, tole_stick, tole_slide, coef_init, pres_frot, &
                            dist_frot, coef_adap, stat_adap)
        character(len=8) , intent(in) :: adap_type
        real(kind=8), intent(in) :: tole_stick
        real(kind=8), intent(in) :: tole_slide
        real(kind=8), intent(in)  :: coef_init
        real(kind=8), intent(in)  :: pres_frot(3)
        real(kind=8), intent(in)  :: dist_frot(3)
        real(kind=8), intent(out) :: coef_adap
        integer, intent(out) :: stat_adap
    end subroutine mm_cycl_adaf
end interface
