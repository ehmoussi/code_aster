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

subroutine vermot(icl, iv, cv, cnl, ier,&
                  irteti)
    implicit none
#include "asterfort/utmess.h"
!       VERIFIE QUE L ITEM LUT EST UN MOT ( MOT ATTENDU )
!       DIFFERENT DE FIN OU FINSF (RESERVES)
!       ----------------------------------------------------------------
!       MOT             =       IDENTIFICATEUR (LXSCAN) <= 8 CARACTERES
!       IN      ICL     =       CLASSE ITEM
!               IV      =       TAILLE ITEM CARACTERE
!               CNL     =       NUMERO LIGNE
!       OUT     IER     =       0       > VRAI  ( RETURN )
!                       =       1       > FAUX  ( RETURN 1 )
!       ----------------------------------------------------------------
    integer :: icl, iv, ier
    character(len=14) :: cnl
    character(len=16) :: nom
    character(len=8) :: mcl
    character(len=*) :: cv
    character(len=24) :: valk(2)
!
!-----------------------------------------------------------------------
    integer :: irteti, jv
!-----------------------------------------------------------------------
    irteti = 0
    if (icl .ne. 3) then
        if (iv .gt. 16) jv=16
        if (iv .le. 16) jv=iv
        nom = cv(1:jv)
        valk(1) = cnl
        valk(2) = nom(1:jv)
        call utmess('E', 'MODELISA7_81', nk=2, valk=valk)
        ier = 1
        irteti = 1
        goto 9999
    endif
!
    if (iv .gt. 24) then
        call utmess('F', 'MODELISA7_82', sk=cnl)
        ier = 1
        irteti = 1
        goto 9999
    endif
!
    mcl = '        '
    mcl(1:iv) = cv(1:iv)
    if (mcl .eq. 'FIN     ') then
        call utmess('E', 'MODELISA7_83', sk=cnl)
        ier = 1
        irteti = 1
        goto 9999
    endif
    if (mcl .eq. 'FINSF   ') then
        call utmess('E', 'MODELISA7_84', sk=cnl)
        ier = 1
        irteti = 1
        goto 9999
    endif
!
    irteti = 0
9999  continue
end subroutine
