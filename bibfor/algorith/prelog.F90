! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine prelog(ndim, lgpg, vim, gn, lamb,&
                  logl, fm, fp, epsml, deps,&
                  tn, resi, iret)
!
    implicit none
!
#include "asterf_types.h"
#include "asterfort/deflog.h"
#include "asterfort/lcdetf.h"
#include "asterc/r8prem.h"
#include "blas/dcopy.h"
!
    integer, intent(in) :: ndim
    integer, intent(in) :: lgpg
    real(kind=8), intent(in) :: vim(lgpg)
    real(kind=8), intent(in) :: fm(3, 3)
    real(kind=8), intent(in) :: fp(3, 3)
    real(kind=8), intent(out) :: epsml(6)
    real(kind=8), intent(out) :: tn(6)
    real(kind=8), intent(out) :: deps(6)
    real(kind=8), intent(out) :: gn(3, 3)
    real(kind=8), intent(out) :: lamb(3)
    real(kind=8), intent(out) :: logl(3)
    integer, intent(out) :: iret
    aster_logical, intent(in) :: resi
! --------------------------------------------------------------------------------------------------
!
!  BUT:  CALCUL DES GRANDES DEFORMATIONS  LOG 2D (D_PLAN ET AXI) ET 3D
!     SUIVANT ARTICLE MIEHE APEL LAMBRECHT CMAME 2002
! --------------------------------------------------------------------------------------------------
! IN  NDIM    : DIMENSION DE L'ESPACE
! IN  LGPG    : DIMENSION DU VECTEUR DES VAR. INTERNES POUR 1 PT GAUSS
! IN  VIM     : VARIABLES INTERNES EN T-
! OUT GN      : TERMES UTILES AU CALCUL DE TL DANS POSLOG
! OUT LAMB    : TERMES UTILES AU CALCUL DE TL DANS POSLOG
! OUT LOGL    : TERMES UTILES AU CALCUL DE TL DANS POSLOG
! IN FM      : GRADIENT TRANSFORMATION EN T-
! IN FP      : GRADIENT TRANSFORMATION EN T+
! OUT EPSML   : DEFORAMTIONS LOGARITHMIQUES EN T-
! OUT DEPS    : ACCROISSEEMENT DE DEFORMATIONS LOGARITHMIQUES
! OUT TN      : CONTRAINTES ASSOCIEES AUX DEF. LOGARITHMIQUES EN T-
! OUT IRET    : 0=OK, 1=vp(Ft.F) trop petites (compression infinie)
! IN  RESI    : .TRUE. SI FULL_MECA/RAPH_MECA .FALSE. SI RIGI_MECA_TANG
!---------------------------------------------------------------------------------------------------
    integer :: ivtn
    real(kind=8) :: epspl(6), detf
! --------------------------------------------------------------------------------------------------
    deps = 0.d0
    tn = 0.d0
    iret = 0
!
!   DETERMINANT DE LA MATRICE Fm
    call lcdetf(ndim, fm, detf)
!
!    PERTINENCE DES GRANDEURS
    if (detf .le. r8prem()) then
        iret = 1
        goto 999
    endif
!
    call deflog(ndim, fm, epsml, gn, lamb, logl, iret)
    if (iret.ne.0) goto 999
!
    if (resi) then
!       DETERMINANT DE LA MATRICE Fp
        call lcdetf(ndim, fp, detf)
!
!       PERTINENCE DES GRANDEURS
        if (detf .le. r8prem()) then
            iret = 1
            goto 999
        endif
!
        call deflog(ndim, fp, epspl, gn, lamb, logl, iret)
        if (iret.ne.0) goto 999
!
        deps(1:6) = epspl(1:6) - epsml(1:6)
    endif
!
!     --------------------------------
!     CALCUL DES CONTRAINTES TN INSTANT PRECEDENT
!     pour gagner du temps : on stocke TN comme variable interne
!     --------------------------------
    ivtn=lgpg-6+1
    call dcopy(2*ndim, vim(ivtn), 1, tn, 1)
!
999 continue
!
end subroutine
