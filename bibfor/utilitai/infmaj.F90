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

subroutine infmaj()
    implicit none
!      MOT CLE INFO
!-----------------------------------------------------------------------
!      UTILITAIRE DE MISE A JOUR POUR LE MOT CLE INFO
!-----------------------------------------------------------------------
!      ---PAS D'ARGUMENTS
!-----------------------------------------------------------------------
!
!------DEBUT DU COMMON INF001-------------------------------------------
!      NIVUTI    :NIVEAU DEMANDE PAR L'UTILISATEUR  : 1 OU 2
!      NIVPGM    :NIVEAU ACCESSIBLE AU PROGRAMMEUR  : 0 , 1 OU 2
!      UNITE     :UNITE LOGIQUE DU FICHIER MESSAGE
!
#include "asterc/getexm.h"
#include "asterfort/getvis.h"
#include "asterfort/iunifi.h"
    integer :: nivuti, nivpgm, unite
    common / inf001 / nivuti , nivpgm , unite
!-----FIN DE INF001-----------------------------------------------------
!
    integer :: info, nbval
    integer :: linfo
!
    info = 1
!
    linfo = getexm ( ' ' , 'INFO' )
!
    if (linfo .eq. 1) then
        call getvis(' ', 'INFO', scal=info, nbret=nbval)
    endif
!
    nivuti = info
    nivpgm = info
    unite = iunifi('MESSAGE')
!
end subroutine
