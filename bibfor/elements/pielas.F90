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

subroutine pielas(ndim, npg, kpg, compor, typmod,&
                  mate, elgeom, lgpg, vim, epsm,&
                  epsp, epsd, sigma, etamin, etamax,&
                  tau, copilo)
!
!
    implicit none
#include "jeveux.h"
#include "asterc/r8gaem.h"
#include "asterfort/pipedo.h"
#include "asterfort/pipedp.h"
#include "asterfort/pipeds.h"
#include "asterfort/pipeef.h"
#include "asterfort/pipepl.h"
#include "asterfort/utmess.h"
#include "blas/daxpy.h"
    integer :: ndim, kpg, npg
    integer :: mate
    character(len=8) :: typmod(*)
    character(len=16) :: compor(*)
    integer :: lgpg
    real(kind=8) :: vim(lgpg, npg)
    real(kind=8) :: epsm(6), epsp(6), epsd(6)
    real(kind=8) :: copilo(5, npg)
    real(kind=8) :: etamin, etamax, tau
    real(kind=8) :: sigma(6)
    real(kind=8) :: elgeom(10, *)
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (PILOTAGE - PRED_ELAS/DEFORMATION)
!
! PILOTAGE PAR PREDICTION ELASTIQUE
!
! ----------------------------------------------------------------------
!
!
! IN  NDIM   : DIMENSION DE L'ESPACE
! IN  NPG    : NOMBRE DE POINTS DE GAUSS
! IN  KPG    : NUMERO DU POINT DE GAUSS
! IN  TYPMOD : TYPE DE MODELISATION
! IN  MATE   : MATERIAU CODE
! IN  ELGEOM : TABLEAUX DES ELEMENTS GEOMETRIQUES SPECIFIQUES AUX LOIS
!              DE COMPORTEMENT (DIMENSION MAXIMALE FIXEE EN DUR, EN
!              FONCTION DU NOMBRE MAXIMAL DE POINT DE GAUSS)
! IN  COMPOR : COMPORTEMENT
! IN  LGPG   : "LONGUEUR" DES VARIABLES INTERNES POUR 1 POINT DE GAUSS
!             CETTE LONGUEUR EST UN MAJORANT DU NBRE REEL DE VAR. INT.
! IN  VIM    : VARIABLES INTERNES EN T-
! IN  EPSM   : DEFORMATIONS AU TEMPS MOINS
! IN  EPSP   : CORRECTION DE DEFORMATIONS DUES AUX CHARGES FIXES
! IN  EPSD   : CORRECTION DE DEFORMATIONS DUES AUX CHARGES PILOTEES
! IN  SIGMA  : CONTRAINTES AVEC SQRT(2)
! IN  ETAMIN : BORNE INF. PILOTAGE
! IN  ETAMAX : BORNE SUP. PILOTAGE
! IN  TAU    : 2ND MEMBRE DE L'EQUATION F(ETA)=TAU
! OUT COPILO : COEFFICIENTS A0 ET A1 POUR CHAQUE POINT DE GAUSS
!
!
!
!
    integer :: ndimsi
!
! ----------------------------------------------------------------------
!
!
!
! --- INITIALISATIONS
!
    ndimsi = 2*ndim
!
! --- CALCUL SUIVANT COMPORTEMENT
!
    if (compor(1) .eq. 'ENDO_FRAGILE') then
        call daxpy(ndimsi, 1.d0, epsm, 1, epsp,&
                   1)
        call pipeef(ndim, typmod, tau, mate, vim(1, kpg),&
                    epsp, epsd, copilo(1, kpg), copilo(2, kpg), copilo(3, kpg),&
                    copilo(4, kpg), copilo(5, kpg))
!
        else if (compor(1).eq.'VMIS_ISOT_TRAC' .or. compor(1)&
    .eq.'VMIS_ISOT_LINE') then
        call pipepl(ndim, compor(1), typmod, tau, mate,&
                    sigma, vim(1, kpg), epsp, epsd, copilo(1, kpg),&
                    copilo(2, kpg), copilo(3, kpg), copilo(4, kpg), copilo(5, kpg))
!
    else if (compor(1).eq.'ENDO_ISOT_BETON') then
        call daxpy(ndimsi, 1.d0, epsm, 1, epsp,&
                   1)
!
        if (etamin .eq. -r8gaem() .or. etamax .eq. r8gaem()) then
            call utmess('F', 'MECANONLINE_60', sk=compor(1))
        endif
!
        call pipeds(ndim, typmod, tau, mate, vim(1, kpg),&
                    epsm, epsp, epsd, etamin, etamax,&
                    copilo(1, kpg), copilo(2, kpg), copilo(3, kpg), copilo(4, kpg),&
                    copilo(5, kpg))
!
    else if (compor(1).eq.'ENDO_ORTH_BETON') then
        call daxpy(ndimsi, 1.d0, epsm, 1, epsp,&
                   1)
!
        if (etamin .eq. -r8gaem() .or. etamax .eq. r8gaem()) then
            call utmess('F', 'MECANONLINE_60', sk=compor(1))
        endif
!
        call pipedo(ndim, typmod, tau, mate, vim(1, kpg),&
                    epsm, epsp, epsd, etamin, etamax,&
                    copilo(1, kpg), copilo(2, kpg), copilo(3, kpg), copilo(4, kpg),&
                    copilo(5, kpg))
    else if (compor(1).eq.'BETON_DOUBLE_DP') then
        call daxpy(ndimsi, 1.d0, epsm, 1, epsp,&
                   1)
!
        call pipedp(kpg, 1, ndim, typmod, mate,&
                    epsm, sigma, vim(1, kpg), epsp, epsd,&
                    elgeom(1, kpg), copilo(1, kpg), copilo(2, kpg))
!
    else
        call utmess('F', 'PILOTAGE_88', sk=compor(1))
    endif
end subroutine
