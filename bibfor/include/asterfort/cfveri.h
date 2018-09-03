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
!
interface
    subroutine cfveri(mesh        , ds_contact  , time_curr   , nt_ncomp_poin,&
                      v_ncomp_jeux, v_ncomp_loca, v_ncomp_enti, v_ncomp_zone)
        use NonLin_Datastructure_type
        character(len=8), intent(in) :: mesh
        type(NL_DS_Contact), intent(in) :: ds_contact
        real(kind=8), intent(in) :: time_curr
        integer, intent(in) :: nt_ncomp_poin
        real(kind=8), pointer :: v_ncomp_jeux(:)
        integer, pointer :: v_ncomp_loca(:)
        character(len=16), pointer :: v_ncomp_enti(:)
        integer, pointer :: v_ncomp_zone(:) 
    end subroutine cfveri
end interface
