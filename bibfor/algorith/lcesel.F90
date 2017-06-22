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

subroutine lcesel(eps,rigi,elas,prece,sigela,sigelu,dsade,dsude)
    implicit none
#include "asterf_types.h"
#include "asterfort/lcesun.h"
#include "asterfort/lcesus.h"
#include "asterfort/lcvalp.h"
#include "asterfort/lcesme.h"

    aster_logical,intent(in) :: rigi,elas
    real(kind=8),intent(in) :: eps(6),prece
    real(kind=8),intent(out):: sigela(6),sigelu(6),dsade(6,6),dsude(6,6)
! --------------------------------------------------------------------------------------------------
!    CONTRAINTES ELASTIQUES ET DERIVEES / EPS AVEC RESTAURATION DE RIGIDITE (ENDO_FISS_EXP)
! --------------------------------------------------------------------------------------------------
! IN  EPS     DEFORMATION
! IN  RIGI    CALCUL OU NON DES MATRICES TANGENTES
! IN  ELAS    MODE SECANT (.TRUE.) OU TANGENT (.FALSE.)
! IN  PRECE   PRECISION RELATIVE PAR RAPPORT AUX COMPOSANTES DE DEFORMATIONS
! OUT SIGELA  CONTRAINTE AFFECTEE PAR L'ENDOMMAGEMENT
! OUT SIGELU  CONTRAINTE NON AFFECTEE PAR L'ENDOMMAGEMENT
! OUT DSADE  DERIVEE DE LA CONTRAINTE SIGELA PAR RAPPORT A LA DEFORMATION
! OUT DSUDE  DERIVEE DE LA CONTRAINTE SIGELU PAR RAPPORT A LA DEFORMATION
! --------------------------------------------------------------------------------------------------
    integer:: i
    real(kind=8), dimension(6), parameter :: kr = (/1.d0,1.d0,1.d0,0.d0,0.d0,0.d0/)
    real(kind=8)::eigeps(3),unieps(6),dereps(6,6),treps,se(6),unitr,dertr
    real(kind=8)::dsede(6,6)
    real(kind=8)::safe=1.d2
! --------------------------------------------------------------------------------------------------
    real(kind=8) :: lambda, deuxmu, troisk, gamma, rigmin, pc, pr, epsth
    common /lcee/ lambda,deuxmu,troisk,gamma,rigmin,pc,pr,epsth
! --------------------------------------------------------------------------------------------------

!   TENSEUR E
    treps  = eps(1)+eps(2)+eps(3)
    
!   PARTIE POSITIVE DES DEFORMATIONS ET DERIVEE
    if (.not. elas) then
        call lcesun(treps,unitr,dertr)
        call lcvalp(eps,eigeps)
        call lcesme(eps,eigeps,lcesun,prece/safe,unieps,dereps)
    else
        call lcesus(treps,unitr,dertr)
        call lcvalp(eps,eigeps)
        call lcesme(eps,eigeps,lcesus,prece/safe,unieps,dereps)
    end if


!   VALEUR DES CONTRAINTES

    se = lambda*treps*kr + deuxmu*eps
    sigelu = lambda*unitr*kr + deuxmu*unieps
    sigela = se - sigelu



!   DERIVEES
    if (rigi) then

!      Matrice elastique
        dsede = 0.d0
        dsede(1:3,1:3) = lambda
        do i = 1,6
            dsede(i,i) = dsede(i,i) + deuxmu
        end do

!      Matrice materiau casse
        dsude = deuxmu*dereps
        dsude(1:3,1:3) = dsude(1:3,1:3) + lambda*dertr
        dsade = dsede - dsude
    end if

end subroutine lcesel
