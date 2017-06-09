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

subroutine vericp(cmpglo, cmp, nbcmp, iret)
    implicit none
!
!     CETTE ROUTINE VERIFIE SI LA COMPOSANTE CMP FAIT PARTIE DES COMPO-
!     SANTES CMPGLO DE LA GRANDEUR
!
! IN :  CMPGLO:  LISTE DES COMPOSANTES DE LA GRANDEUR
!       CMP   :  NOM DE LA COMPOSANTE
!       NBCMP :  NOMBRE DE COMPOSANTES DE LA GRANDEUR
!
! OUT : IRET = 0 LA COMPOSANTE CMP APPARTIENT A LA GRANDEUR
!       IRET = 1 LA COMPOSANTE CMP N'APPARTIENT PAS A LA GRANDEUR
!
!+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
    character(len=8) :: cmp, cmpglo(1)
    integer :: i, iret, nbcmp
!-----------------------------------------------------------------------
!
    do 1 i = 1, nbcmp
        if (cmp .ne. cmpglo(i)) then
            goto 1
        else
            iret=0
            goto 9999
        endif
 1  continue
!
    iret=1
9999  continue
end subroutine
