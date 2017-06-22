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

subroutine fgpic2(method, rtrv, point, npoint, pic,&
                  npic)
!       REARRANGEMENT ET EXTRACTION DES PICS
!       ----------------------------------------------------------------
!       IN  POINT VECTEUR DES POINTS
!           NPOINT NOMBRE DE POINTS
!           RTRV VECTEUR DE TRAVAIL REEL
!           METHOD METHODE DE DEXTRACTION DES PICS EMPLOYEE
!       OUT PIC VECTEUR DES PICS
!           NPIC NOMBRE DE PICS (NPIC = NPOINT AU MAXIMUM)
!       ----------------------------------------------------------------
!
    implicit none
#include "asterfort/utmess.h"
    integer :: i, npoint, npic, nmax, ntrv
    real(kind=8) :: point(*), pic(*), rtrv(*), pmax, pinter
    real(kind=8) :: dp1, dp2, epsi
    character(len=*) :: method
    character(len=16) :: k16b
!
    epsi = 1.0d-6
!
!     ----------------------------------------------------------------
! -   EXTRACTION DES PICS POUR RAINFLOW=PIC LE PLUS GRAND EN DEBUT
!     ----------------------------------------------------------------
    if (( method.eq.'RAINFLOW' ) .or. ( method.eq.'RFLO_MAX' )) then
!
! -     RECHERCHE DU POINT LE PLUS GRAND EN VALEUR ABSOLUE
!
        pmax = abs(point(1))
        nmax = 1
        do 10 i = 2, npoint
            if (abs(point(i)) .gt. pmax*(1.0d0+epsi)) then
                pmax = abs(point(i))
                nmax = i
            endif
10      continue
        pmax = point(nmax)
!
! -     REARANGEMENT AVEC POINT LE PLUS GRAND AU DEBUT ET A LA FIN
!
        do 20 i = nmax, npoint
            rtrv(i-nmax+1) = point(i)
20      continue
        do 30 i = 1, nmax-1
            rtrv(npoint-nmax+1+i) = point(i)
30      continue
        ntrv = npoint
!
! -     EXTRACTION DES PICS SUR LE VECTEUR REARANGE
!
! -      LE PREMIER POINT EST UN PIC
        npic = 1
        pic(1) = rtrv(1)
        pinter = rtrv(2)
!
! -     ON RECHERCHE TOUS LES PICS
        do 40 i = 3, ntrv
            dp1 = pinter - pic(npic)
            dp2 = rtrv(i) - pinter
!
! -         ON CONSERVE LE POINT INTERMEDIAIRE COMME UN PIC
            if (dp2*dp1 .lt. 0.d0) then
                npic = npic+1
                pic(npic) = pinter
            endif
!
! -         LE DERNIER POINT DEVIENT POINT INTERMEDIAIRE
            pinter = rtrv(i)
40      continue
!
! -      LE DERNIER POINT EST UN PIC
        npic = npic+1
        pic(npic) = rtrv(ntrv)
    else
        k16b = method(1:16)
        call utmess('F', 'PREPOST_4', sk=k16b)
    endif
!
end subroutine
