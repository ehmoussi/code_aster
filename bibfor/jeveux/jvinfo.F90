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

function jvinfo(kactio, info)
    implicit none
    integer :: jvinfo
    character(len=*) :: kactio
    integer :: info
! ----------------------------------------------------------------------
! DEFINITION DU NIVEAU DES IMPRESSIONS JEVEUX
!
! IN  KACTIO  = AFFECT AFFECTATION DU NIVEAU DES IMPRESSIONS
!             = INIT   MISE A 0
!             = RECUP  RECUPERATION DU NIVEAU DES IMPRESSIONS
! IN  INFO   VALEUR DU NIVEAU DES IMPRESSIONS (AFFECT UNIQUEMENT)
! ----------------------------------------------------------------------
    integer :: ifnivo, nivo
    common /jvnivo/  ifnivo, nivo
! DEB ------------------------------------------------------------------
    character(len=8) :: k8ch
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    k8ch=kactio
    if (ifnivo .ne. 22021986) then
        nivo = 0
        ifnivo = 22021986
    endif
    if (k8ch(1:6) .eq. 'AFFECT') then
        nivo = info
    else if (k8ch(1:4) .eq. 'INIT') then
        nivo = 0
    else if (k8ch(1:5) .eq. 'RECUP') then
    endif
    jvinfo = nivo
! FIN ------------------------------------------------------------------
end function
