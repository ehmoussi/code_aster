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
    subroutine xmelet(nomte, typmai, elrees, elrema, elreco,&
                      ndim, nddl, jnne, jnnm, nnc,&
                      jddle, jddlm, nconta, ndeple, nsinge,&
                      nsingm, nfhe, nfhm)
        character(len=16) :: nomte
        character(len=8) :: typmai
        character(len=8) :: elrees
        character(len=8) :: elrema
        character(len=8) :: elreco
        integer :: ndim
        integer :: nddl
        integer :: jnne(3)
        integer :: jnnm(3)
        integer :: nnc
        integer :: jddle(2)
        integer :: jddlm(2)
        integer :: nconta
        integer :: ndeple
        integer :: nsinge
        integer :: nsingm
        integer :: nfhe
        integer :: nfhm
    end subroutine xmelet
end interface
