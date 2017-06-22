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

subroutine op0088()
    implicit none
!     COMMANDE:  DEFI_MAILLAGE
!
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/cargeo.h"
#include "asterfort/infmaj.h"
#include "asterfort/ssdmdm.h"
#include "asterfort/ssdmdn.h"
#include "asterfort/ssdmgn.h"
#include "asterfort/ssdmrc.h"
#include "asterfort/ssdmrg.h"
#include "asterfort/ssdmrm.h"
#include "asterfort/ssdmte.h"
    character(len=8) :: nomu
    character(len=16) :: kbi1, kbi2
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    call infmaj()
    call getres(nomu, kbi1, kbi2)
!
!     --TRAITEMENT DU MOT CLEF 'DEFI_SUPER_MAILLE'
    call ssdmdm(nomu)
!
!     --TRAITEMENT DES MOTS CLEF 'RECO_GLOBAL' ET 'RECO_SUPER_MAILLE'
    call ssdmrc(nomu)
    call ssdmrg(nomu)
    call ssdmrm(nomu)
!
!     --TRAITEMENT DU MOT CLEF 'DEFI_NOEUD'
    call ssdmdn(nomu)
!
!     --TRAITEMENT DU MOT CLEF 'DEFI_GROUP_NO'
    call ssdmgn(nomu)
!
!     --ON TERMINE LE MAILLAGE :
    call ssdmte(nomu)
!
    call cargeo(nomu)
!
end subroutine
