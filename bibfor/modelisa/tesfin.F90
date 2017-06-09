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

subroutine tesfin(icl, iv, cv, irteti)
    implicit none
!       ----------------------------------------------------------------
!       TESTE SI  L ITEM LUT EN DEBUT DE LIGNE EST
!       LE MOT CLE FIN OU LE MOT CLE FINSF ( EVENTUALITE )
!       ----------------------------------------------------------------
!       IN      ICL     =       CLASSE ITEM
!               IV      =       TAILLE ITEM CARACTERE
!               CV      =       ITEM A TESTER
!       OUT     ( RETURN )      MOT CLE FIN ET FINSF NON RECONNUS
!               ( RETURN 1 )    MOT CLE FIN RECONNU
!               ( RETURN 2 )    MOT CLE FINSF RECONNU
!       ----------------------------------------------------------------
    integer :: icl, iv
    character(len=*) :: cv
    character(len=8) :: mcl
!-----------------------------------------------------------------------
    integer :: irteti
!-----------------------------------------------------------------------
    irteti = 0
!
    if (icl .eq. 3 .and. iv .le. 8) then
        mcl='        '
        mcl(1:iv)=cv(1:iv)
        if (mcl .eq. 'FIN     ') then
            irteti = 1
            goto 9999
        endif
        if (mcl .eq. 'FINSF   ') then
            irteti = 2
            goto 9999
        endif
    endif
!
    irteti = 0
9999  continue
end subroutine
