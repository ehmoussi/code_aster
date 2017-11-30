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


subroutine ptfop1(itype, nc, coef1, coef2, xl, qq, fe)
!
!
!
! --------------------------------------------------------------------------------------------------
!
!
! --------------------------------------------------------------------------------------------------
!
    implicit none
!
    integer :: itype, nc
    real(kind=8) :: coef1, coef2, xl, fe(18), qq(18)
!
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: sect1, sect2, coef
!
! --------------------------------------------------------------------------------------------------
!
    sect1 = coef1
    sect2 = coef2
!   Les moments repartis sont autorises que pour les poutres droites a section constante
    if (itype .eq. 1 .or. itype .eq. 2) then
        if (qq(4) .ne. 0.d0 .or. qq(10) .ne. 0.d0 .or. qq(5) .ne. 0.d0 .or. qq(11) .ne.&
            0.d0 .or. qq(6) .ne. 0.d0 .or. qq(12) .ne. 0.d0) then
            call utmess('F', 'ELEMENTS2_59')
        endif
    endif
!
!   Calcul des forces nodales equivalentes en repere local
    if (itype .eq. 0 .or. itype .eq. 30 .or. itype .eq. 20) then
!       elements droits a section constante : on tient compte des efforts tranchants
!       La charge est constante ou varie lineairement
        if (sect1 .ne. 1.d0) then
            if (qq(4) .ne. 0.d0 .or. qq(4+nc) .ne. 0.d0 .or. qq(5) .ne. 0.d0 .or. qq(5+nc) .ne.&
                0.d0 .or. qq(6) .ne. 0.d0 .or. qq(6+nc) .ne. 0.d0) then
                ASSERT(.false.)
            endif
        endif
!
        coef = sect1 * xl
        fe(1)  = (qq(1)/3.d0 +  qq(1+nc)/6.d0)*coef
        fe(1+nc)  = (qq(1)/6.d0 +  qq(1+nc)/3.d0)*coef
        fe(2)  = (7.d0*qq(2) + 3.d0* qq(2+nc))*coef/20.d0 - (qq(6)+ qq(6+nc))/2.d0
        fe(2+nc)  = (3.d0*qq(2) + 7.d0* qq(2+nc))*coef/20.d0 + (qq(6)+ qq(6+nc))/2.d0
        fe(3)  = (7.d0*qq(3) + 3.d0* qq(3+nc))*coef/20.d0 + (qq(5)+ qq(5+nc))/2.d0
        fe(3+nc)  = (3.d0*qq(3) + 7.d0* qq(3+nc))*coef/20.d0 - (qq(5)+ qq(5+nc))/2.d0
        fe(4)  = (qq(4)/3.d0 + qq(4+nc)/6.d0)*xl
        fe(4+nc) = (qq(4)/6.d0 + qq(4+nc)/3.d0)*xl        
      
        if (nc.gt.6) then
           fe(7) = (qq(7)/3.d0 +  qq(7+nc)/6.d0)*coef
           fe(7+nc) = (qq(7)/6.d0 +  qq(7+nc)/3.d0)*coef
           fe(8) = (qq(8)/3.d0 +  qq(8+nc)/6.d0)*coef
           fe(8+nc) = (qq(8)/6.d0 +  qq(8+nc)/3.d0)*coef
           fe(9) = (qq(9)/3.d0 +  qq(9+nc)/6.d0)*coef
           fe(9+nc) = (qq(9)/6.d0 +  qq(9+nc)/3.d0)*coef
        end if
!
        coef = coef * xl
        fe(5)  = -(qq(3)/20.d0 + qq(3+nc)/30.d0)* coef - (qq(5+nc)-qq(5))*xl/12.d0
        fe(5+nc) =  (qq(3)/30.d0 + qq(3+nc)/20.d0)* coef + (qq(5+nc)-qq(5))*xl/12.d0
        fe(6)  =  (qq(2)/20.d0 + qq(2+nc)/30.d0)* coef - (qq(6+nc)-qq(6))*xl/12.d0
        fe(6+nc) = -(qq(2)/30.d0 + qq(2+nc)/20.d0)* coef + (qq(6+nc)-qq(6))*xl/12.d0
!
    else if (itype .eq. 1) then
!       elements droits a section variable type 1 : on ne tient pas compte des efforts tranchants
        fe(1)  =  qq(1)*(sect1/3.d0 + sect2/6.d0)*xl
        fe(2)  =  qq(2)*(7.d0*sect1 + 3.d0*sect2)*xl/ 20.d0
        fe(3)  =  qq(3)*(7.d0*sect1 + 3.d0*sect2)*xl/ 20.d0
        fe(4)  =  0.d0
        fe(5)  = -qq(3)*(sect1/20.d0 + sect2/30.d0)*xl*xl
        fe(6)  =  qq(2)*(sect1/20.d0 + sect2/30.d0)*xl*xl
        fe(7)  =  qq(7)*(sect1/6.d0 + sect2/3.d0)*xl
        fe(8)  =  qq(8)*(3.d0*sect1 + 7.d0*sect2)*xl/20.d0
        fe(9)  =  qq(9)*(3.d0*sect1 + 7.d0*sect2)*xl/20.d0
        fe(10) =  0.d0
        fe(11) =  qq(9)*(sect1/30.d0 + sect2/20.d0)*xl*xl
        fe(12) = -qq(8)*(sect1/30.d0 + sect2/20.d0)*xl*xl
    else if (itype .eq. 2) then
!       elements droits a section variable type 2: on ne tient pas compte des efforts tranchants
        coef   = sqrt( sect1*sect2)
        fe(1)  = qq(1) * (sect1/4.d0+sect2/12.d0+coef/6.d0) * xl
        fe(2)  = qq(2) * (8.d0*sect1+2.d0*sect2+5.d0*coef) * xl/30.d0
        fe(3)  = qq(3) * (8.d0*sect1+2.d0*sect2+5.d0*coef) * xl/30.d0
        fe(4)  = 0.d0
        fe(5)  = -qq(3) * (2.d0*sect1+sect2+2.d0*coef)*xl*xl/60.d0
        fe(6)  = qq(2) * (2.d0*sect1+sect2+2.d0*coef)*xl*xl/60.d0
        fe(7)  = qq(7) * (sect1/12.d0+sect2/4.d0+coef/6.d0) * xl
        fe(8)  = qq(8) * (2.d0*sect1+8.d0*sect2+5.d0*coef) * xl/30.d0
        fe(9)  = qq(9) * (2.d0*sect1+8.d0*sect2+5.d0*coef) * xl/30.d0
        fe(10) = 0.d0
        fe(11) = qq(9) * (sect1+2.d0*sect2+2.d0*coef)*xl*xl/60.d0
        fe(12) = -qq(8) * (sect1+2.d0*sect2+2.d0*coef)*xl*xl/60.d0
    else
        call utmess('F', 'ELEMENTS2_48')
    endif
!
end subroutine
