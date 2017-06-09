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
    subroutine xitghm(modint, mecani, press1, ndim, nno,&
                      nnos, nnom, npi, npg, nddls,&
                      nddlm, dimuel, ddld, ddlm, nnop,&
                      nnops, nnopm, ipoids, ivf, idfde, ddlp,&
                      ddlc)
        character(len=3) :: modint
        integer :: mecani(5)
        integer :: press1(7)
        integer :: ndim
        integer :: nno
        integer :: nnos
        integer :: nnom
        integer :: npi
        integer :: npg
        integer :: nddls
        integer :: nddlm
        integer :: dimuel
        integer :: ddld
        integer :: ddlm
        integer :: nnop
        integer :: nnops
        integer :: nnopm
        integer :: ipoids
        integer :: ivf
        integer :: idfde
        integer :: ddlp
        integer :: ddlc
    end subroutine xitghm
end interface 
