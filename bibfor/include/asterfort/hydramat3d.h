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
      subroutine hydramat3d(hyd0,hydr,hyds,young00,young,&
                nu00,nu,rt00,rt,ref00,&
                ref,rc00,rc,delta00,delta,&
                beta00,beta,gft00,gft,ept00,&
                ept,pglim,epsm00,epsm,xnsat00,&
                xnsat,biotw00,biotw,brgi00,brgi,&
                krgi00,krgi,iso,lambda,mu,&
                rt33,rtg33,ref33,raideur66,souplesse66,&
                xmt,dtiso,err1)
        real(kind=8) :: hyd0
        real(kind=8) :: hydr
        real(kind=8) :: hyds
        real(kind=8) :: young00
        real(kind=8) :: young
        real(kind=8) :: nu00
        real(kind=8) :: nu
        real(kind=8) :: rt00
        real(kind=8) :: rt
        real(kind=8) :: ref00
        real(kind=8) :: ref
        real(kind=8) :: rc00
        real(kind=8) :: rc
        real(kind=8) :: delta00
        real(kind=8) :: delta
        real(kind=8) :: beta00
        real(kind=8) :: beta
        real(kind=8) :: gft00
        real(kind=8) :: gft
        real(kind=8) :: ept00
        real(kind=8) :: ept
        real(kind=8) :: pglim
        real(kind=8) :: epsm00
        real(kind=8) :: epsm
        real(kind=8) :: xnsat00
        real(kind=8) :: xnsat
        real(kind=8) :: biotw00
        real(kind=8) :: biotw
        real(kind=8) :: brgi00
        real(kind=8) :: brgi
        real(kind=8) :: krgi00
        real(kind=8) :: krgi
        aster_logical :: iso
        real(kind=8) :: lambda
        real(kind=8) :: mu
        real(kind=8) :: rt33(3,3)
        real(kind=8) :: rtg33(3,3)
        real(kind=8) :: ref33(3,3)
        real(kind=8) :: raideur66(6,6)
        real(kind=8) :: souplesse66(6,6)
        real(kind=8) :: xmt
        aster_logical :: dtiso
        integer :: err1
    end subroutine hydramat3d
end interface
