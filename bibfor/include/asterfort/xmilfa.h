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
    subroutine xmilfa(elrefp, ndim, ndime, geom, cnset, nnose, it,&
                      ainter, ip1, ip2, pm2, typma, pinref, pmiref,&
                      ksi, milfa, pintt, pmitt)
        character(len=8) :: elrefp
        character(len=8) :: typma
        integer :: ndim
        integer :: ndime
        integer :: nnose
        integer :: it
        integer :: ip1
        integer :: ip2
        integer :: pm2
        integer :: cnset(*)
        real(kind=8) :: pinref(*)
        real(kind=8) :: pmiref(*)
        real(kind=8) :: geom(*)
        real(kind=8) :: ainter(*)
        real(kind=8) :: ksi(ndime)
        real(kind=8) :: milfa(ndim)
        real(kind=8) :: pintt(*)
        real(kind=8) :: pmitt(*)
    end subroutine xmilfa
end interface 
