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

subroutine enlird(dateur)
! ......................................................................
    implicit none
!   - FONCTION REALISEE:
!       ECRITURE DE LA D.A.T.E D'AUJOURD'HUI SUR LA VARIABLE DATEUR
!   - OUT :
!       DATEUR : CHARACTER*24
!   - AUTEUR : PRIS A SIVA POUR ASTER
! ......................................................................
#include "asterc/kloklo.h"
    integer :: i, date9(9)
    character(len=2) :: jour2(0:6), date2(2:7)
    character(len=4) :: mois4(12), annee
    character(len=*) :: dateur
    character(len=24) :: dateuz
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    data jour2/'LU','MA','ME','JE','VE','SA','DI'/
    data mois4/'JANV','FEVR','MARS','AVRI','MAI ','JUIN',&
     &           'JUIL','AOUT','SEPT','OCTO','NOVE','DECE'/
!     APPEL A LA GENERALE
    call kloklo(date9)
    date2(2) = '00'
    if (date9(2) .lt. 10) then
        write(date2(2)(2:2),'(I1)') date9(2)
    else
        write(date2(2)(1:2),'(I2)') date9(2)
    endif
    write(annee,'(I4)') date9(4)
    do 1 i = 5, 7
        date2(i) = '00'
        if (date9(i) .lt. 10) then
            write(date2(i)(2:2),'(I1)') date9(i)
        else
            write(date2(i)(1:2),'(I2)') date9(i)
        endif
 1  end do
    write (dateuz,101) jour2(date9(1)),date2(2),&
     &      mois4(date9(3)),annee,(date2(i),i=5,7)
    dateur = dateuz
    101 format(a2,'-',a2,'-',a4,'-',a4,1x,a2,':',a2,':',a2)
end subroutine
