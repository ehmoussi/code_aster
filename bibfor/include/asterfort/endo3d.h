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

!
#include "asterf_types.h"
interface 
       subroutine endo3d(wpl3,vwpl33,vwpl33t,wplx3,vwplx33,vwplx33t,&
           gft,gfr,iso,sigf6,sigf6d,rt33,ref33,&
           souplesse66,epspg6,eprg00,a,b,x,ipzero,ngf,&
           ekdc,epspc6,dt3,dr3,dgt3,dgc3,dc,wl3,xmt,dtiso,rt,dtr,&
           dim3,ndim,ifour,epeqpc)


        real(kind=8) :: wpl3(3)
        real(kind=8) :: vwpl33(3,3)
        real(kind=8) :: vwpl33t(3,3)
        real(kind=8) :: wplx3(3)
        real(kind=8) :: vwplx33(3,3)
        real(kind=8) :: vwplx33t(3,3)
        real(kind=8) :: gft
        real(kind=8) :: gfr
        aster_logical :: iso
        real(kind=8) :: sigf6(6)
        real(kind=8) :: sigf6d(6)
        real(kind=8) :: rt33(3,3)
        real(kind=8) :: ref33(3,3)
        real(kind=8) :: souplesse66(6,6)
        real(kind=8) :: epspg6(6)
        real(kind=8) :: eprg00
        real(kind=8) :: a(ngf,(ngf+1))
        real(kind=8) :: b(ngf)
        real(kind=8) :: x(ngf)
        integer :: ipzero(ngf)
        integer :: ngf
        real(kind=8) :: ekdc
        real(kind=8) :: epspc6(6)
        real(kind=8) :: dt3(3)
        real(kind=8) :: dr3(3)
        real(kind=8) :: dgt3(3)
        real(kind=8) :: dgc3(3)
        real(kind=8) :: dc
        real(kind=8) :: wl3(3)
        real(kind=8) :: xmt
        aster_logical :: dtiso
        real(kind=8) :: rt
        real(kind=8) :: dtr
        real(kind=8) :: dim3
        integer :: ndim
        integer :: ifour
        real(kind=8) :: epeqpc
    end subroutine endo3d
end interface
