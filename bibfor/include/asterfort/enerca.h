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
#include "asterf_types.h"
!
interface
    subroutine enerca(valinc, dep0, vit0, depl1, vite1,&
                      masse, amort, rigid, fexte, famor,&
                      fliai, fnoda, fcine, lamort, ldyna,&
                      lexpl, ds_energy, schema)
        use NonLin_Datastructure_type
        character(len=19) :: valinc(*)
        real(kind=8) :: dep0(*)
        real(kind=8) :: vit0(*)
        real(kind=8) :: depl1(*)
        real(kind=8) :: vite1(*)
        character(len=19) :: masse
        character(len=19) :: amort
        character(len=19) :: rigid
        real(kind=8) :: fexte(*)
        real(kind=8) :: famor(*)
        real(kind=8) :: fliai(*)
        real(kind=8) :: fnoda(*)
        real(kind=8) :: fcine(*)
        aster_logical :: lamort
        aster_logical :: ldyna
        aster_logical :: lexpl
        type(NL_DS_Energy), intent(inout) :: ds_energy
        character(len=8) :: schema
    end subroutine enerca
end interface
