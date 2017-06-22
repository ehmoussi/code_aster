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

subroutine impdep(isor, idep, ibl, dmoy, detyp,&
                  drms, dmax, dmin)
!
!     IMPRESSION DES DEPLACEMENTS
!
    implicit none
    integer :: isor, idep
    real(kind=8) :: dmoy, detyp, drms, dmax, dmin
!
!
!-----------------------------------------------------------------------
    integer :: ibl
!-----------------------------------------------------------------------
    if (idep .eq. 1) then
        if (ibl .eq. 1) then
            write(isor,*)
            write(isor,*) ' ***** STATISTIQUES DEPLACEMENTS X LOCAL *****'
            write(isor,*)
            write(isor,*) '---------------------------------------------',&
     &                '----------------------------'
            write(isor,*)  '!IB! DX MOYEN    ! DX E.TYPE   !',&
     &                ' DX RMS      ! DX MAX      ! DX MIN      !'
            write(isor,*) '---------------------------------------------',&
     &                '----------------------------'
        else if (ibl.eq.0) then
            write(isor,*)
            write(isor,*) ' ***** STATISTIQUES GLOBALES  DEPX *****'
            write(isor,*)
            write(isor,*) '---------------------------------------------',&
     &                '----------------------------'
            write(isor,*)'!IB! DX MOYEN    ! DX E.TYPE   ! DX RMS      !',&
     &                ' DX MAX      ! DX MIN      !'
            write(isor,*)'---------------------------------------------',&
     &                '----------------------------'
        endif
        write(isor,10) ibl,dmoy,detyp,drms,dmax,dmin
    else if (idep.eq.2) then
        if (ibl .eq. 1) then
            write(isor,*)
            write(isor,*)' ***** STATISTIQUES DEPLACEMENTS Y LOCAL *****'
            write(isor,*)
            write(isor,*)'---------------------------------------------',&
     &                '----------------------------'
            write(isor,*)'!IB! DY MOYEN    ! DY E.TYPE   ! DY RMS      !',&
     &                ' DY MAX      ! DY MIN      !'
            write(isor,*)'---------------------------------------------',&
     &                '----------------------------'
        else if (ibl.eq.0) then
            write(isor,*)
            write(isor,*) ' ***** STATISTIQUES GLOBALES  DEPY *****'
            write(isor,*)
            write(isor,*)'---------------------------------------------',&
     &                '----------------------------'
            write(isor,*)'!IB! DY MOYEN    ! DY E.TYPE   ! DY RMS      !',&
     &                ' DY MAX      ! DY MIN      !'
            write(isor,*)'---------------------------------------------',&
     &                '----------------------------'
        endif
        write(isor,10) ibl,dmoy,detyp,drms,dmax,dmin
    else if (idep.eq.3) then
        if (ibl .eq. 1) then
            write(isor,*)
            write(isor,*)' ***** STATISTIQUES DEPLACEMENTS Z LOCAL *****'
            write(isor,*)
            write(isor,*)'----------------------------------------------',&
     &                '----------------------------'
            write(isor,*)'!IB! DZ MOYEN    ! DZ E.TYPE   ! DZ RMS      !',&
     &                ' DZ MAX      ! DZ MIN      !'
            write(isor,*)'----------------------------------------------',&
     &                '----------------------------'
        else if (ibl.eq.0) then
            write(isor,*)
            write(isor,*) ' ***** STATISTIQUES GLOBALES  DEPZ *****'
            write(isor,*)
            write(isor,*)'----------------------------------------------',&
     &                '----------------------------'
            write(isor,*)'!IB! DZ MOYEN    ! DZ E.TYPE   ! DZ RMS      !',&
     &                ' DZ MAX      ! DZ MIN      !'
            write(isor,*)'----------------------------------------------',&
     &                '----------------------------'
        endif
        write(isor,10) ibl,dmoy,detyp,drms,dmax,dmin
    else if (idep.eq.4) then
        if (ibl .eq. 1) then
            write(isor,*)
            write(isor,*)' *****  STATISTIQUES DEPLACEMENT  RADIAL *****'
            write(isor,*)
            write(isor,*)'----------------------------------------------',&
     &                '----------------------------'
            write(isor,*)'!IB! R  MOYEN    ! R  E.TYPE   ! R  RMS      !',&
     &                ' R  MAX      ! R  MIN      !'
            write(isor,*)'----------------------------------------------',&
     &                '----------------------------'
        else if (ibl.eq.0) then
            write(isor,*)
            write(isor,*) ' ***** STATISTIQUES GLOBALES DEPL RADIAL ****'
            write(isor,*)
            write(isor,*)'----------------------------------------------',&
     &                '----------------------------'
            write(isor,*)'!IB! R  MOYEN    ! R  E.TYPE   ! R  RMS      !',&
     &                ' R  MAX      ! R  MIN      !'
            write(isor,*)'----------------------------------------------',&
     &                '----------------------------'
        endif
        write(isor,10) ibl,dmoy,detyp,drms,dmax,dmin
    else if (idep.eq.5) then
        if (ibl .eq. 1) then
            write(isor,*)
            write(isor,*)' ***** STATISTIQUES DEPLACEMENT ANGULAIRE ****'
            write(isor,*)
            write(isor,*)'----------------------------------------------',&
     &                '----------------------------'
            write(isor,*)'!IB! THETA MOYEN ! THETA E.TYP ! THETA RMS   !',&
     &                ' THETA MAX   ! THETA MIN   !'
            write(isor,*)'----------------------------------------------',&
     &                '----------------------------'
        else if (ibl.eq.0) then
            write(isor,*)
            write(isor,*) ' ***** STATISTIQUES GLOBALES DEPL ANGLE  ****'
            write(isor,*)
            write(isor,*)'----------------------------------------------',&
     &                '----------------------------'
            write(isor,*)'!IB! THETA MOYEN ! THETA E.TYP ! THETA RMS   !',&
     &                ' THETA MAX   ! THETA MIN   !'
            write(isor,*)'----------------------------------------------',&
     &                '----------------------------'
        endif
        write(isor,10) ibl,dmoy,detyp,drms,dmax,dmin
    endif
!
!
    10 format(' !',i2,'!',1pe12.5,' !',1pe12.5,' !',1pe12.5,' !',&
     &         1pe12.5,' !',1pe12.5,' !')
end subroutine
