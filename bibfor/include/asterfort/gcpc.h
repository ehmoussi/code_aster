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
            subroutine gcpc(m,in,ip,ac,inpc,perm,ippc,acpc,bf,xp,r,rr,p,&
     &irep,niter,epsi,criter,solveu,matas,istop,iret)
              integer :: m
              integer :: in(m)
              integer(kind=4) :: ip(*)
              real(kind=8) :: ac(m)
              integer :: inpc(m)
              integer :: perm(m)
              integer(kind=4) :: ippc(*)
              real(kind=8) :: acpc(m)
              real(kind=8) :: bf(m)
              real(kind=8) :: xp(m)
              real(kind=8) :: r(m)
              real(kind=8) :: rr(m)
              real(kind=8) :: p(m)
              integer :: irep
              integer :: niter
              real(kind=8) :: epsi
              character(len=19) :: criter
              character(len=19) :: solveu
              character(len=19) :: matas
              integer :: istop
              integer :: iret
            end subroutine gcpc
          end interface 
