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

subroutine prelog(ndim, lgpg, vim, gn, lamb,&
                  logl, fm, fp, epsml, deps,&
                  tn, resi, iret)
!  BUT:  CALCUL DES GRANDES DEFORMATIONS  LOG 2D (D_PLAN ET AXI) ET 3D
!     SUIVANT ARTICLE MIEHE APEL LAMBRECHT CMAME 2002
! ----------------------------------------------------------------------
! IN  NDIM    : DIMENSION DE L'ESPACE
! IN  LGPG    : DIMENSION DU VECTEUR DES VAR. INTERNES POUR 1 PT GAUSS
! IN  VIM     : VARIABLES INTERNES EN T-
! OUT GN      : TERMES UTILES AU CALCUL DE TL DANS POSLOG
! OUT LAMB    : TERMES UTILES AU CALCUL DE TL DANS POSLOG
! OUT LOGL    : TERMES UTILES AU CALCUL DE TL DANS POSLOG
! OUT FM      : GRADIENT TRANSFORMATION EN T-
! OUT FP      : GRADIENT TRANSFORMATION EN T+
! OUT EPSML   : DEFORAMTIONS LOGARITHMIQUES EN T-
! OUT DEPS    : ACCROISSEEMENT DE DEFORMATIONS LOGARITHMIQUES
! OUT TN      : CONTRAINTES ASSOCIEES AUX DEF. LOGARITHMIQUES EN T-
! IN  RESI    : .TRUE. SI FULL_MECA/RAPH_MECA .FALSE. SI RIGI_MECA_TANG
!
    implicit none
#include "asterf_types.h"
#include "asterfort/deflog.h"
#include "asterfort/r8inir.h"
#include "blas/dcopy.h"
    integer :: i, ndim, lgpg, ivtn, iret
    real(kind=8) :: vim(lgpg)
    real(kind=8) :: fm(3, 3), fp(3, 3), epsml(6), epspl(6)
    real(kind=8) :: tn(6), deps(6), gn(3, 3), lamb(3), logl(3)
    aster_logical :: resi
! ---------------------------------------------------------------------
!
    call deflog(ndim, fm, epsml, gn, lamb,&
                logl, iret)
!
    if (resi) then
        call deflog(ndim, fp, epspl, gn, lamb,&
                    logl, iret)
        do 35 i = 1, 6
            deps(i)=epspl(i)-epsml(i)
 35     continue
    else
        do 34 i = 1, 6
            deps(i)=0.d0
 34     continue
    endif
!
!     --------------------------------
!     CALCUL DES CONTRAINTES TN INSTANT PRECEDENT
!     pour gagner du temps : on stocke TN comme variable interne
!     --------------------------------
    ivtn=lgpg-6+1
    call r8inir(6, 0.d0, tn, 1)
    call dcopy(2*ndim, vim(ivtn), 1, tn, 1)
!
end subroutine
