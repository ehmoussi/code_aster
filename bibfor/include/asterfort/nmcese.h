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
    subroutine nmcese(modele         , numedd, ds_material, carele    ,&
                      ds_constitutive, ds_contact, lischa, fonact, ds_measure,&
                      iterat         , sdnume, sdpilo, valinc    , solalg    ,&
                      veelem         , veasse, offset, typsel    , sddisc    ,&
                      licite         , rho   , eta   , etaf      , criter    ,&
                      ldccvg         , pilcvg, matass)
        use NonLin_Datastructure_type
        character(len=24) :: modele
        character(len=24) :: numedd
        type(NL_DS_Material), intent(in) :: ds_material
        character(len=24) :: carele
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        type(NL_DS_Contact), intent(in) :: ds_contact
        character(len=19) :: lischa
        integer :: fonact(*)
        type(NL_DS_Measure), intent(inout) :: ds_measure
        integer :: iterat
        character(len=19) :: sdnume
        character(len=19) :: sdpilo
        character(len=19) :: valinc(*)
        character(len=19) :: solalg(*)
        character(len=19) :: veelem(*)
        character(len=19) :: veasse(*)
        real(kind=8) :: offset
        character(len=24) :: typsel
        character(len=19) :: sddisc
        integer :: licite(2)
        real(kind=8) :: rho
        real(kind=8) :: eta(2)
        real(kind=8) :: etaf
        real(kind=8) :: criter
        integer :: ldccvg
        integer :: pilcvg
        character(len=19) :: matass
    end subroutine nmcese
end interface
