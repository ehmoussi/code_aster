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

subroutine lcrksg(rela_comp, nvi, vinf, fd, df,&
                  nmat, coefl, sigi)
    implicit none
!     INTEGRATION DE LOIS DE COMPORTEMENT PAR UNE METHODE DE RUNGE KUTTA
!     CALCUL DES CONTRAINTES A PARTIR DES DEFORMATIONS EN GRANDES DEF
!     ----------------------------------------------------------------
!     IN  COMP    :  COMPORTEMENT
!         NVI     :  NOMBRE DE VARIABLES INETRNES DU SYSTEME NL (NVI-12)
!         VINF    :  V.I.
!         FD      :  GRADIENT DE TRANSFORMATION  A T
!         DF      :  INCREMENT DE GRADIENT DE TRANSFORMATION
!         NMAT    :  NOMBRE MAXI DE COEFFICIENTS MATERIAU
!         COEFEL  :  COEFFICENT DE L'OPERATEUR D'ELASTICITE
!     OUT SIGI    :  CONTRAINTES A L'INSTANT COURANT
!     ----------------------------------------------------------------
#include "asterfort/lcgrla.h"
#include "asterfort/lcopli.h"
#include "asterfort/lcprmv.h"
#include "asterfort/matinv.h"
#include "asterfort/pmat.h"
#include "blas/dcopy.h"
    character(len=8) :: mod
    character(len=16) :: rela_comp
    integer :: nmat, nvi
    real(kind=8) :: hook(6, 6), sigi(6), fd(9), df(9), coefl(nmat)
    real(kind=8) :: vinf(*), fp(3, 3), fpm(3, 3), fe(3, 3), detp, f(3, 3)
    real(kind=8) :: epsgl(6)
    integer :: irr, decirr, nbsyst, decal, gdef
    common/polycr/irr,decirr,nbsyst,decal,gdef
!     ----------------------------------------------------------------
!
!     PAS DE CONTRAINTES PLANES NI DE 1D. 3D = D_PLAN = AXIS
    mod='3D'
    if ((rela_comp(1:8) .eq. 'MONOCRIS') .or. (rela_comp(1:8) .eq. 'MONO2RIS')) then
        if (gdef .eq. 1) then
!
!           OPERATEUR D'ELASTICITE DE HOOKE
            if (coefl(nmat) .eq. 0) then
                call lcopli('ISOTROPE', mod, coefl, hook)
            else if (coefl(nmat).eq.1) then
                call lcopli('ORTHOTRO', mod, coefl, hook)
            endif
!           SPECIFIQUE MONICRISTAL : RECUP DE FP
!           Attention, NVI represente ici 6+3*NS+9
            call dcopy(9, vinf(nvi-9+1), 1, fp, 1)
            call matinv('S', 3, fp, fpm, detp)
!
!           F=FE.FP  => FP = DF.F-.(FP)**-1
            call pmat(3, df, fd, f)
            call pmat(3, f, fpm, fe)
            call lcgrla(fe, epsgl)
            call lcprmv(hook, epsgl, sigi)
!
        endif
    endif
!
end subroutine
