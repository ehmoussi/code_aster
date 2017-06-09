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

subroutine impc0(isor, ibl, nbc, tcm, tcmax,&
                 tcmin, nrebo, trebm, tct, t,&
                 nbpt)
!     IMPRESSION DES CHOCS
!
!
    implicit none
    integer :: isor, nbc, nrebo, nbpt
    real(kind=8) :: tcm, tcmax, tcmin, trebm, tct
    real(kind=8) :: t(*), dt, tacqui
!
!-----------------------------------------------------------------------
    integer :: ibl, nrepc
!-----------------------------------------------------------------------
    dt=t(2)-t(1)
    tacqui = t(nbpt) - t(1)
    if (nbc .ne. 0) then
        nrepc=nrebo/nbc
    else
        nrepc=0
    endif
    if (ibl .eq. 1) then
        write(isor,*)' '
        write(isor,*)' ***** STATISTIQUES DES CHOCS    ***** '
!
        write(isor,*) '------------------------------'
        write(isor,*) '! PAS ACQUIS  ! DUREE ACQUIS !'
        write(isor,9) dt,tacqui
        write(isor,*) '------------------------------'
        write(isor,*) '-----------------------------------------'//&
        '--------------------------------------------'
        write(isor,*) '!IB! CHOC/S ! REB/CH ! TCHOC MOYEN !'//&
     &         ' TCHOC MAX   ! TCHOC MIN   ! T REBOND MOY!%T. CHOC!'
        write(isor,*) '-----------------------------------------'//&
        '--------------------------------------------'
    else if (ibl.eq.0) then
        write(isor,*)' '
        write(isor,*)' ***** STATISTIQUES GLOBALES DES CHOCS    ***** '
!
        write(isor,*) '------------------------------'
        write(isor,*) '! PAS ACQUIS  ! DUREE ACQUIS !'
        write(isor,9) dt,tacqui
        write(isor,*) '------------------------------'
        write(isor,*) '-------------------------------'//&
     & '------------------------------------------------------'
        write(isor,*) '!IB! CHOC/S ! REB/CH ! TCHOC MOYEN !'//&
     &         ' TCHOC MAX   ! TCHOC MIN   ! T REBOND MOY!%TEMPS CHOC!'
        write(isor,*) '-----------------------------------------'//&
        '--------------------------------------------'
    endif
    write(isor,8) ibl,int(nbc/tacqui),nrepc,tcm,tcmax,tcmin,trebm,&
     &                  (100.d0*tct/tacqui)
!
    8 format(' !',i2,'!',i5,'   !',i5,'   !',1pd12.5,' !',&
     &          1pd12.5,' !',1pd12.5,' !',1pd12.5,' !',1pd12.5,' %!')
    9 format(' !',1pd12.5,' !',1pd12.5,' !')
!
end subroutine
