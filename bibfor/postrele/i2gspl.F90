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

subroutine i2gspl(debspl, tvois1, tvois2, tplace, schm,&
                  achm, pts, pta)
    implicit none
#include "asterf_types.h"
!
!
!******************************************************************
!
!         REPERAGE DANS LE GROUPE DE MAILLE D' UN CHEMIN
!         SIMPLE CONNAISSANT SA MAILLE DE DEPART.
!
!         DEBSPL (IN)      : MAILLE DE DEPART
!
!         TVOISI (IN)      : TABLES DES VOISINS
!
!         TPLACE (IN-OUT)  : TABLE DES MAILLES DEJA PLACEES
!
!         SCHM   (OUT)     : TABLE DE STRUCTURATION DES CHEMINS
!
!         ACHM   (OUT)     : TABLE D 'ACCES A SCHM
!
!         PTS    (IN-OUT)  : POINTEUR SUR SCHM
!
!         PTA    (IN-OUT)  : POINTEUR SUR ACHM
!
!******************************************************************
!
    aster_logical :: tplace(*)
    integer :: debspl, tvois1(*), tvois2(*)
    integer :: schm(*), achm(*), pts, pta
!
    aster_logical :: fini
!
    integer :: s, s1, s2
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    fini = .false.
!
    s1 = 0
!
    s2 = 0
!
    s = debspl
!
    schm(pts) = s
    achm(pta) = pts
!
    tplace(s) = .true.
!
    pts = pts + 1
    pta = pta + 1
!
    if (tvois1(s) .eq. 0) then
!
        schm(pts) = 0
!
        pts = pts + 1
!
        fini = .true.
!
    endif
!
 10 continue
    if (.not. fini) then
!
        s1 = tvois1(s)
        s2 = tvois2(s)
!
        if (.not. tplace(s1)) then
!
            s = s1
!
            tplace(s) = .true.
!
        else
!
            s = s2
!
            if (s2 .ne. 0) then
!
                tplace(s) = .true.
!
            else
!
                fini = .true.
!
            endif
!
        endif
!
        schm(pts) = s
!
        pts = pts + 1
!
        goto 10
!
    endif
!
end subroutine
