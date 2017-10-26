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
    subroutine mmconv(noma , ds_contact, valinc, solalg, vfrot,&
                      nfrot, vgeom     , ngeom, vpene)
        use NonLin_Datastructure_type
        character(len=8), intent(in) :: noma
        type(NL_DS_Contact), intent(inout) :: ds_contact
        character(len=19), intent(in) :: valinc(*)
        character(len=19), intent(in) :: solalg(*)
        real(kind=8), intent(out) :: vfrot
        character(len=16), intent(out) :: nfrot
        real(kind=8), intent(out) :: vgeom
        real(kind=8), intent(out) :: vpene
        character(len=16), intent(out) :: ngeom
    end subroutine mmconv
end interface
