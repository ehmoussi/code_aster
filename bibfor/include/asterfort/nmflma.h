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
#include "asterf_types.h"
!
interface
    subroutine nmflma(typmat, mod45 , l_hpp  , ds_algopara, modelz,&
                      ds_material, carele, sddisc, sddyna     , fonact,&
                      numins, valinc, solalg, lischa     ,&
                      numedd, numfix,&
                      ds_constitutive, ds_measure, meelem,&
                      measse, veelem, nddle , ds_posttimestep, modrig,&
                      ldccvg, matass, matgeo)
        use NonLin_Datastructure_type
        character(len=16) :: typmat
        character(len=4) :: mod45
        aster_logical, intent(in) :: l_hpp
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        character(len=*) :: modelz
        type(NL_DS_Material), intent(in) :: ds_material
        character(len=24) :: carele
        character(len=19) :: sddisc
        character(len=19) :: sddyna
        integer :: fonact(*)
        integer :: numins
        character(len=19) :: valinc(*)
        character(len=19) :: solalg(*)
        character(len=19) :: lischa
        character(len=24) :: numedd
        character(len=24) :: numfix
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        type(NL_DS_Measure), intent(inout) :: ds_measure
        character(len=19) :: meelem(*)
        character(len=19) :: measse(*)
        character(len=19) :: veelem(*)
        integer :: nddle
        type(NL_DS_PostTimeStep), intent(in) :: ds_posttimestep
        character(len=16) :: modrig
        integer :: ldccvg
        character(len=19) :: matass
        character(len=19) :: matgeo
    end subroutine nmflma
end interface
