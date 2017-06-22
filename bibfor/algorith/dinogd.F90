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

function dinogd(nocham)
!
!
    implicit none
    character(len=8) :: dinogd
    character(len=16) :: nocham
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE
!
! CONNAISSANT LE NOM DU CHAMP, ON RENVOIT LE NOM DE LA GRANDEUR
!
! ----------------------------------------------------------------------
!
!
! IN  NOCHAM : NOM DU CHAMP
! OUT DINOGD : NOM DE LA GRANDEUR
!
    if (nocham .eq. 'DEPL') dinogd = 'DEPL_R'
    if (nocham .eq. 'VITE') dinogd = 'DEPL_R'
    if (nocham .eq. 'ACCE') dinogd = 'DEPL_R'
    if (nocham .eq. 'CONT_NOEU') dinogd = 'INFC_R'
    if (nocham .eq. 'SIEF_ELGA') dinogd = 'SIEF_R'
    if (nocham .eq. 'VARI_ELGA') dinogd = 'VARI_R'
    if (nocham .eq. 'TEMP') dinogd = 'TEMP_R'
    if (nocham .eq. 'FORC_NODA') dinogd = 'FORC_R'
!
end function
