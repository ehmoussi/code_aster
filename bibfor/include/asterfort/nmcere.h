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
! aslint: disable=W1504
!
interface
    subroutine nmcere(model          , nume_dof  , ds_material, cara_elem,&
                      ds_constitutive, ds_contact, list_load  , fonact   , ds_measure ,&
                      iterat         , sdnume    , valinc     , solalg   , hval_veelem,&
                      hval_veasse    , offset    , rho        , eta      , residu     ,&
                      ldccvg         , matr_asse)
        use NonLin_Datastructure_type
        integer :: fonact(*)
        integer :: iterat, ldccvg
        real(kind=8) :: eta, rho, offset, residu
        character(len=19) :: list_load, sdnume, matr_asse
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        type(NL_DS_Contact), intent(in) :: ds_contact
        character(len=24) :: model, nume_dof, cara_elem
        type(NL_DS_Material), intent(in) :: ds_material
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=19) :: hval_veelem(*), hval_veasse(*)
        character(len=19) :: solalg(*), valinc(*)
    end subroutine nmcere
end interface
