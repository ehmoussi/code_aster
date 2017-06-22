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

subroutine rvopti(mcf, iocc, nch19, nomgd, typegd,&
                  option)
    implicit none
!
#include "asterc/getexm.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvtx.h"
    character(len=*) :: mcf
    character(len=19) :: nch19
    character(len=16) :: option
    character(len=8) :: nomgd
    character(len=4) :: typegd
!
!     RECUPERATION DE L' OPTION DE CALCUL DU CHAMP_19 DE NOM NCH19
!     ------------------------------------------------------------------
! IN  NCH19  : K : NOM DU CHAMP_19
! IN  NOMGD  : K : NOM DE LA GRANDEUR
! IN  TYPEGD : K : VAUT 'CHNO' OU 'CHLM'
! OUT OPTION : K : NOM OPTION POUR CHLM OU ADAPTATION CHNO
!     ------------------------------------------------------------------
!
    integer :: iocc, nc
    integer :: lnch
!
!======================================================================
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    option = '                '
!
    if (typegd .eq. 'CHML') then
!
        call dismoi('NOM_OPTION', nch19, 'CHAMP', repk=option)
!
    else if (typegd .eq. 'CHNO') then
!
! ------ POUR LES OPTIONS XXXX_NOEU_XXXX, ON RECUPERE L'OPTION
!        PAR LE MOT CLE "NOM_CHAM"
!
        lnch = getexm ( mcf, 'NOM_CHAM' )
        if (lnch .eq. 1) then
            call getvtx(mcf, 'NOM_CHAM', iocc=iocc, scal=option, nbret=nc)
            if (option(6:9) .eq. 'NOEU') goto 999
        endif
!
        if (nomgd .eq. 'SIEF_R') then
            option = 'SIEF_NOEU_DEPL  '
        else if (nomgd .eq. 'EPSI_R') then
            option = 'EPSI_NOEU  '
        else if (nomgd .eq. 'FLUX_R') then
            option = 'FLUX_NOEU  '
        else if (nomgd .eq. 'DEPL_R') then
            option = 'DEPL_NOEU_DEPL  '
        else if (nomgd .eq. 'FORC_R') then
            option = 'FORC_NOEU_FORC  '
        endif
    endif
999 continue
end subroutine
