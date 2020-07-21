! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine imprel(titre, nbterm, coef, lisddl, lisno, beta, epsi)
    implicit none
!
#include "asterfort/infniv.h"
!
! --------------------------------------------------------------------------------------------------
!
    integer, intent(in)             :: nbterm
    real(kind=8), intent(in)        :: coef(nbterm), beta
!
    character(len=8), intent(in)    :: lisddl(nbterm), lisno(nbterm)
    character(len=*), intent(in)    :: titre
!
    real(kind=8), intent(in), optional :: epsi
!
! --------------------------------------------------------------------------------------------------
!
    integer             :: info, ifm, ii
    real(kind=8)        :: norm_coef
    character(len=24)   :: titr24
!
! --------------------------------------------------------------------------------------------------
!
    call infniv(ifm, info)
    if (info .lt. 2) goto 999
!
    titr24 = titre
    norm_coef = 1.0
!
10  format(2x,'    COEF    ','*','   DDL  ','(',' NOEUD  ',')')
20  format(2x,1pe12.5,' * ',a8,'(',a8,')','+')
30  format(2x,'=',1pe12.5)
40  format(2x,'______________________________________')
!
    write(ifm,*) 'RELATION LINEAIRE AFFECTEE PAR '//titr24
    write(ifm,10)
    do ii = 1, nbterm
        write(ifm,20) coef(ii),lisddl(ii),lisno(ii)
        norm_coef = max(norm_coef,abs(coef(ii)))
    enddo
    write(ifm,30) beta
!
    if ( present(epsi) ) then
        write(ifm,*) 'RELATION LINEAIRE NORMALISEE AFFECTEE PAR '//titr24
        write(ifm,10)
        do ii = 1, nbterm
            if ( abs(coef(ii)) .gt. epsi ) then
                write(ifm,20) coef(ii)/norm_coef,lisddl(ii),lisno(ii)
            endif
        enddo
        write(ifm,30) beta/norm_coef
    endif
    write(ifm,40)
!
999 continue
end subroutine
