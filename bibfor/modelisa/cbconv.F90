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

subroutine cbconv(char)
    implicit none
!
! BUT : CREATION ET CHARGEMENT DE L'OBJET 'CHAR'.CHTH.CONVE.VALE
!       CONTENANT LE NOM DU CHAMP DE VITESSE DE TRANSPORT
!       DANS LE CAS DE L'EQUATION DE DIFFUSION-CONVECTION
!
! SORTIE EN ERREUR : SI LE MOT FACTEUR CONVECTION SE TROUVE PLUS D'UNE
!                    FOIS DANS LA COMMANDE
!
! ARGUMENT D'ENTREE:
!      CHAR  : NOM UTILISATEUR DU RESULTAT DE CHARGE
!
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/chpver.h"
#include "asterfort/getvid.h"
#include "asterfort/jecreo.h"
#include "asterfort/jedema.h"
#include "asterfort/jeecra.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
    character(len=8) :: char, vitess
    character(len=19) :: carte
!
!     CREATION ET CHARGEMENT DE L'OBJET 'CHAR'.CHTH.CONVE
!
!-----------------------------------------------------------------------
    integer ::  ier, nconv, nvites
    character(len=8), pointer :: vale(:) => null()
!-----------------------------------------------------------------------
    call jemarq()
    vitess = '        '
    call getfac('CONVECTION', nconv)
    if (nconv .gt. 1) then
        call utmess('F', 'MODELISA3_60')
    else if (nconv.eq.1) then
        carte = char//'.CHTH.CONVE'
        call jecreo(carte//'.VALE', 'G V K8')
        call jeecra(carte//'.VALE', 'LONMAX', 1)
        call jeveuo(carte//'.VALE', 'E', vk8=vale)
        call getvid('CONVECTION', 'VITESSE', iocc=1, scal=vitess, nbret=nvites)
        vale(1) = vitess
        call chpver('F', vale(1), 'NOEU', 'DEPL_R', ier)
    endif
    call jedema()
end subroutine
