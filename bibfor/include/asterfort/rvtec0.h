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
            subroutine rvtec0(t,co,sp,absc,x,cmp,nd,sdm,nbpoin,docu,    &
     &nbcmp,padr,nomtab,iocc,xnovar,ncheff,i1)
              real(kind=8) :: t(*)
              integer :: co(*)
              integer :: sp(*)
              real(kind=8) :: absc(*)
              real(kind=8) :: x(*)
              character(len=8) :: cmp(*)
              character(len=8) :: nd(*)
              character(len=24) :: sdm
              integer :: nbpoin
              character(len=4) :: docu
              integer :: nbcmp
              integer :: padr(*)
              character(len=19) :: nomtab
              integer :: iocc
              character(len=24) :: xnovar
              character(len=16) :: ncheff
              integer :: i1
            end subroutine rvtec0
          end interface 
