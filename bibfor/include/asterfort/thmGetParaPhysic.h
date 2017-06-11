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
    subroutine thmGetParaPhysic(mecani, press1, press2, tempe,&
                                yamec_, addeme_,&
                                yate_, addete_,&
                                yap1_, addep1_,&
                                yap2_, addep2_)
        integer, intent(in) :: mecani(5)
        integer, intent(in) :: press1(7)
        integer, intent(in) :: press2(7)
        integer, intent(in) :: tempe(5)
        integer, optional, intent(out) :: yamec_
        integer, optional, intent(out) :: addeme_
        integer, optional, intent(out) :: yate_
        integer, optional, intent(out) :: addete_
        integer, optional, intent(out) :: yap1_
        integer, optional, intent(out) :: addep1_
        integer, optional, intent(out) :: yap2_
        integer, optional, intent(out) :: addep2_
    end subroutine thmGetParaPhysic
end interface
