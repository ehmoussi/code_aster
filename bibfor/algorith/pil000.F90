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

subroutine pil000(typilo, compor, neps, tau, mat,&
                  vim, sigm, epsm, epsp, epsd,&
                  typmod, etamin, etamax, copilo)
!
!
    implicit none
#include "asterc/r8gaem.h"
#include "asterfort/lcmfbo.h"
#include "asterfort/lcmfga.h"
#include "asterfort/lcmfma.h"
#include "asterfort/lcqubo.h"
#include "asterfort/lcquga.h"
#include "asterfort/lcquma.h"
#include "asterfort/pidegv.h"
#include "asterfort/pieigv.h"
#include "asterfort/piesgv.h"
#include "asterfort/utmess.h"
    character(len=8),intent(in) :: typmod(*)
    character(len=16),intent(in) :: compor(*), typilo
    integer,intent(in) :: neps, mat
    real(kind=8),intent(in) :: tau, epsm(neps), epsd(neps), epsp(neps), etamin, etamax
    real(kind=8),intent(in) :: vim(*), sigm(neps)
    real(kind=8),intent(out) :: copilo(2, 2)
!
! ----------------------------------------------------------------------
!     PILOTAGE PRED_ELAS : BRANCHEMENT SELON COMPORTEMENT
! ----------------------------------------------------------------------
! IN  TYPILO  TYPE DE PILOTAGE : 'PRED_ELAS' OU 'DEFORMATION'
! IN  NEPS    DIMENSION DES DEFORMATIONS
! IN  TAU     INCREMENT DE PILOTAGE
! IN  MAT     NATURE DU MATERIAU                             (PRED_ELAS)
! IN  VIM     VARIABLES INTERNES EN T-                       (PRED_ELAS)
! IN  SIGM    CONTRAINTES EN T- (SI NECESSAIRE)              (PRED_ELAS)
! IN  EPSM    CHAMP DE DEFORMATION EN T-
! IN  EPSP    INCREMENT FIXE
! IN  EPSD    INCREMENT PILOTE
! IN  ETAMIN  BORNE INF DU PILOTAGE (SI UTILE)               (PRED_ELAS)
! IN  ETAMAX  BORNE SUP DU PILOTAGE (SI UTILE)               (PRED_ELAS)
! OUT COPILO  COEFFICIENT DE PILOTAGE : F := A0+A1*ETA = TAU
! ----------------------------------------------------------------------
!
!
! MODELISATION A GRADIENT DE VARIABLES INTERNES
    if (typmod(2) .ne. 'GRADVARI') &
        call utmess('F', 'MECANONLINE_61', sk=typmod(2))
!
!
! PILOTAGE 'DEFORMATION'
    if (typilo .eq. 'DEFORMATION') then
        call pidegv(neps, tau, epsm, epsp, epsd, copilo)
!
!
! PILOTAGE 'PRED_ELAS'
    else
        if (etamin .eq. -r8gaem() .or. etamax .eq. r8gaem()) &
            call utmess('F', 'MECANONLINE_60', sk=compor(1))
!
        if (compor(1) .eq. 'ENDO_SCALAIRE') then
            call piesgv(neps, tau, mat, lcquma, vim, epsm, epsp, epsd, typmod, lcquga,&
                        etamin, etamax, lcqubo, copilo)
!
        else if (compor(1).eq.'ENDO_FISS_EXP') then
            call piesgv(neps,tau,mat,lcmfma,vim,epsm,epsp,epsd,typmod,lcmfga,etamin,etamax, &
                        lcmfbo,copilo)
!
        else if (compor(1).eq.'ENDO_ISOT_BETON') then
            call pieigv(neps, tau, mat, vim, epsm, epsp, epsd, typmod, etamin, etamax, copilo)
!
        else
            call utmess('F', 'MECANONLINE_59')
        endif
!
    endif
!
end subroutine
