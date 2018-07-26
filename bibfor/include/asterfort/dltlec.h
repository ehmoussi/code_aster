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
#include "asterf_types.h"
!
interface
    subroutine dltlec(result, modele, numedd, materi, mate,&
                      carael, carele, imat, masse, rigid,&
                      amort, lamort, nchar, nveca, lischa,&
                      charge, infoch, fomult, iaadve, ialifo,&
                      nondp, iondp, solveu, iinteg, t0,&
                      nume, numrep)
        character(len=8) :: result
        character(len=24) :: modele
        character(len=24) :: numedd
        character(len=8) :: materi
        character(len=24) :: mate
        character(len=8) :: carael
        character(len=24) :: carele
        integer :: imat(3)
        character(len=8) :: masse
        character(len=8) :: rigid
        character(len=8) :: amort
        aster_logical :: lamort
        integer :: nchar
        integer :: nveca
        character(len=19) :: lischa
        character(len=24) :: charge
        character(len=24) :: infoch
        character(len=24) :: fomult
        integer :: iaadve
        integer :: ialifo
        integer :: nondp
        integer :: iondp
        character(len=19) :: solveu
        integer :: iinteg
        real(kind=8) :: t0
        integer :: nume
        integer :: numrep
    end subroutine dltlec
end interface
