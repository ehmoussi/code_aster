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

subroutine tesmcl(icl, iv, cv, mtcl, irteti)
    implicit none
!       ----------------------------------------------------------------
!       TESTE SI L ITEM LU EN DEBUT DE LIGNE  EST
!       LE MOT CLE RECHERCHE (EVENTUALITE)
!       ----------------------------------------------------------------
!       MOT CLE         =       MOT / RECONNU / EN DEBUT DE LIGNE
!
!       IN      IV      =       TAILLE ITEM CARACTERE
!               CV      =       ITEM LU
!               MTCL    =       MOT CLE RECHERCHE
!
!       OUT     (RETURN 1)      FAUX    MOT # MOT CLE RECHERCHE
!               (RETURN )       VRAI    MOT = MOT CLE RECHERCHE
!       ----------------------------------------------------------------
    integer :: iv
    character(len=*) :: cv
    character(len=8) :: mtcl, mcl
!
!-----------------------------------------------------------------------
    integer :: icl, irteti
!-----------------------------------------------------------------------
    irteti = 0
    if (icl .eq. 3 .and. iv .le. 8 .and. iv .ne. 0) then
        mcl = '        '
        mcl(1:iv) = cv(1:iv)
        if (mcl .eq. mtcl) then
            irteti = 0
            goto 9999
        endif
    endif
!
    irteti = 1
9999  continue
end subroutine
