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
    subroutine dlnewi(result, force0, force1, lcrea, lamort,&
                      iinteg, neq, imat, masse, rigid,&
                      amort, dep0, vit0, acc0, fexte,&
                      famor, fliai, t0, nchar, nveca,&
                      liad, lifo, modele, mate, carele,&
                      charge, infoch, fomult, numedd, nume,&
                      solveu, criter, chondp, nondp, numrep, ds_energy)
        use NonLin_Datastructure_type
        integer :: nondp
        character(len=8) :: result
        character(len=19) :: force0
        character(len=19) :: force1
        aster_logical :: lcrea
        aster_logical :: lamort
        integer :: iinteg
        integer :: neq
        integer :: imat(3)
        character(len=8) :: masse
        character(len=8) :: rigid
        character(len=8) :: amort
        real(kind=8) :: dep0(*)
        real(kind=8) :: vit0(*)
        real(kind=8) :: acc0(*)
        real(kind=8) :: fexte(*)
        real(kind=8) :: famor(*)
        real(kind=8) :: fliai(*)
        real(kind=8) :: t0
        integer :: nchar
        integer :: nveca
        integer :: liad(*)
        character(len=24) :: lifo(*)
        character(len=24) :: modele
        character(len=24) :: mate
        character(len=24) :: carele
        character(len=24) :: charge
        character(len=24) :: infoch
        character(len=24) :: fomult
        character(len=24) :: numedd
        integer :: nume
        character(len=19) :: solveu
        character(len=24) :: criter
        character(len=8) :: chondp(nondp)
        integer :: numrep
        type(NL_DS_Energy), intent(inout) :: ds_energy
    end subroutine dlnewi
end interface
