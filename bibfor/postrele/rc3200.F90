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

subroutine rc3200()
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/rc32rs.h"
#include "asterfort/rc32si.h"
#include "asterfort/rc32in.h"
#include "asterfort/rc32cm.h"
#include "asterfort/rc32t.h"
#include "asterfort/rc32t2.h"
#include "asterfort/rc32mu.h"
#include "asterfort/rc32ma.h"
#include "asterfort/rc32ac.h"
#include "asterfort/jedetc.h"
#include "asterfort/jemarq.h"
#include "asterfort/jedema.h"
!
!     OPERATEUR POST_RCCM, TRAITEMENT DE FATIGUE_ZE200 et B3200
!
!     ------------------------------------------------------------------
!
    aster_logical :: lfat, lefat
!
! DEB ------------------------------------------------------------------
!
    call jemarq()
!     ------------------------------------------------------------------
!              TRAITEMENT DES SITUATIONS (GROUPES, NOM...)
!     ------------------------------------------------------------------
!
    call rc32si()
!
!     ------------------------------------------------------------------
!              RECUPERATION DES CARACTERISTIQUES MATERIAU
!     ------------------------------------------------------------------
!
    call rc32ma()
!
!     ------------------------------------------------------------------
!              RECUPERATION DES INDICES DE CONTRAINTES 
!              ET DES CARACTERISTIQUES DE LA TUYAUTERIE
!     ------------------------------------------------------------------
!
    call rc32in()
!
!     ------------------------------------------------------------------
!              RECUPERATION DES TENSEURS UNITAIRES SI PRESENTS
!                 ET DES TORSEURS EFFORTS ET MOMENTS
!                  (SOUS RESU_MECA_UNIT et CHAR_MECA) 
!     ------------------------------------------------------------------
!
    call rc32mu()
    call rc32cm()
!
!     ------------------------------------------------------------------
!                  RECUPERATION DES TRANSITOIRES :
!                    - THERMIQUES(si RESU_THER)
!                    - DE PRESSION(si RESU_PRES)
!                    - EFFORTS EXTERNES(si RESU_MECA)
!     ------------------------------------------------------------------
!
    call rc32t()
    call rc32t2()
!
!     ------------------------------------------------------------------
!                        CALCUL DES GRANDEURS
!     ------------------------------------------------------------------
!
    call rc32ac(lfat, lefat)
!
!     ------------------------------------------------------------------
!              AFFICHAGE DES RESULTATS DANS LE .RESU
!     ------------------------------------------------------------------
!
    call rc32rs(lfat, lefat)
!
    call jedetc('V', '&&RC3200', 1)
!
    call jedema()
!
end subroutine
