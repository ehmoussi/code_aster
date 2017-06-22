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

subroutine cjsncn(roucjs, essmax, ndt, nvi, umess,&
                  relax, rotagd, epsd, deps, sigd,&
                  vind)
!
!  DUMP EN CAS NON CNVERGENCE RELAXATGION NORMALES CJS
!
    implicit none
#include "asterfort/utmess.h"
    character(len=*) :: roucjs
    integer :: essmax, ndt, nvi, umess
    real(kind=8) :: relax(essmax), rotagd(essmax)
    real(kind=8) :: epsd(ndt), deps(ndt), sigd(ndt), vind(nvi)
!
    integer :: i
    write(umess,3001)
    3001     format(&
     &       t3,' ESSAI',t10,' RELAX',t30,' ROTAGD')
    do 400 i = 1, essmax
        write(umess,3002) i,relax(i),rotagd(i)
400  continue
    3002     format(&
     &       t3,i4,t10,e12.5,t30,e12.5)
    call utmess('F', 'ALGORITH2_17')
    write(umess,*) ' EPSD '
    write(6,1002) (i,epsd(i),i = 1 , ndt)
    write(umess,*) ' DEPS '
    write(6,1002) (i,deps(i),i = 1 , ndt)
    write(umess,*) ' SIGD '
    write(6,1002) (i,sigd(i),i = 1 , ndt)
    write(umess,*) ' VIND '
    write(6,1002) (i,vind(i),i = 1 , nvi)
    1002 format(2x,i5,2x,e12.5)
end subroutine
