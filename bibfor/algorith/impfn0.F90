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

subroutine impfn0(isor, ibl, fnmoyt, fnmoyc, fnrmst,&
                  fnrmsc, fmax)
!
!     IMPRESSION DES FORCES NORMALES AMV
!
!
!
    implicit none
    integer :: isor
    real(kind=8) :: fnmoyt, fnmoyc, fnrmst, fnrmsc, fmax
!
!
!-----------------------------------------------------------------------
    integer :: ibl
!-----------------------------------------------------------------------
    if (ibl .eq. 1) then
        write(isor,*)
        write(isor,*) ' ***** STATISTIQUES FORCE NORMALE *****'
        write(isor,*)  '+--+-------------+-------------+-------------+',&
     &                '-------------+-------------+'
        write(isor,*)  '!IB! FN MOY TTOT ! FN MOY TCHOC! FN RMS TTOT !',&
     &                   ' FN RMS TCHOC! FN MAX      !'
        write(isor,*)  '+--+-------------+-------------+-------------+',&
     &                '-------------+-------------+'
    else if (ibl.eq.0) then
        write(isor,*)
        write(isor,*) ' ***** STATISTIQUES GLOBALES FNORM *****'
        write(isor,*)  '+--+-------------+-------------+-------------+',&
     &                '-------------+-------------+'
        write(isor,*)  '!IB! FN MOY TTOT ! FN MOY TCHOC! FN RMS TTOT !',&
     &                   ' FN RMS TCHOC! FN MAX      !'
        write(isor,*)  '+--+-------------+-------------+-------------+',&
     &                '-------------+-------------+'
    endif
    write(isor,10) ibl,fnmoyt,fnmoyc,fnrmst,fnrmsc,fmax
!
    10 format(' !',i2,'!',1pe12.5,' !',1pe12.5,' !',1pe12.5,' !',&
     &        1pe12.5,' !',1pe12.5 ,' !')
end subroutine
