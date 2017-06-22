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

subroutine imprel(titre, nbterm, coef, lisddl, lisno,&
                  beta)
    implicit none
#include "asterfort/infniv.h"
    character(len=*) :: titre
    integer :: info, nbterm, ifm, i
    character(len=8) :: lisddl(nbterm), lisno(nbterm)
    character(len=24) :: titr24
    real(kind=8) :: coef(nbterm), beta
!
    call infniv(ifm, info)
    if (info .lt. 2) goto 9999
!
    titr24=titre
!
    10 format(2x,'    COEF    ','*','   DDL  ','(',' NOEUD  ',')')
    20 format(2x,1pe12.5,' * ',a8,'(',a8,')','+')
    30 format(2x,'=',1pe12.5)
    40 format(2x,'______________________________________')
!
    write(ifm,*) 'RELATION LINEAIRE AFFECTEE PAR '//titr24
    write(ifm,10)
    do 100 i = 1, nbterm
        write(ifm,20) coef(i),lisddl(i),lisno(i)
100  end do
    write(ifm,30) beta
    write(ifm,40)
9999  continue
end subroutine
