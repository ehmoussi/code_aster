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
    subroutine xmmjeu(ndim, jnnm, jnne, ndeple, nsinge,&
                      nsingm, ffe, ffm, norm, jgeom,&
                      jdepde, jdepm, fk_escl, fk_mait, jddle,&
                      jddlm, nfhe, nfhm, lmulti, heavn, heavfa,&
                      jeu)
        integer :: ndim
        integer :: jnnm(3)
        integer :: jnne(3)
        integer :: ndeple
        integer :: nsinge
        integer :: nsingm
        real(kind=8) :: ffe(20)
        real(kind=8) :: ffm(20)
        real(kind=8) :: norm(3)
        integer :: jgeom
        integer :: jdepde
        integer :: jdepm
        real(kind=8) :: fk_escl(27,3,3)
        real(kind=8) :: fk_mait(27,3,3)
        integer :: jddle(2)
        integer :: jddlm(2)
        integer :: nfhe
        integer :: nfhm
        aster_logical :: lmulti
        integer :: heavn(*)
        integer :: heavfa(*)
        real(kind=8) :: jeu
    end subroutine xmmjeu
end interface
