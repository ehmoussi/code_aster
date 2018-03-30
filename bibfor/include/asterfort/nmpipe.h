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
    subroutine nmpipe(modele         , ligrpi    , cartyp, careta, ds_material,&
                      ds_constitutive, ds_contact, valinc, depdel, ddepl0,&
                      ddepl1         , tau       , nbeffe, eta   , pilcvg,&
                      typpil         , carele)
        use NonLin_Datastructure_type
        character(len=24) :: modele
        character(len=19) :: ligrpi
        character(len=19) :: cartyp
        character(len=19) :: careta
        type(NL_DS_Material), intent(in) :: ds_material
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        type(NL_DS_Contact), intent(in) :: ds_contact
        character(len=19) :: valinc(*)
        character(len=19) :: depdel
        character(len=19) :: ddepl0
        character(len=19) :: ddepl1
        real(kind=8) :: tau
        integer :: nbeffe
        real(kind=8) :: eta(2)
        integer :: pilcvg
        character(len=24) :: typpil
        character(len=24) :: carele
    end subroutine nmpipe
end interface
