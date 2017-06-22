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

subroutine norton(nvi, vini, coeft, nmat, sigi,&
                  dvin, iret)
    implicit none
!      MODELE VISCOPLASTIQUE DE NORTON
! ==================================================================
!     CETTE ROUTINE FOURNIT LA DERIVEE DE L ENSEMBLE DES VARIABLES
!     INTERNES DU MODELE
!       IN  NVI     :  NOMBRE DE VARIABLES INTERNES
!           VINI    :  VARIABLES INTERNES A T
!           COEFT   :  COEFFICIENTS MATERIAU INELASTIQUE A T
!           NMAT    :  DIMENSION MAXI DE COEFT
!           SIGP    :  CONTRAINTES A L'INSTANT COURANT, AVEC SQRT(2)
!           DEPS    :  INCREMENT DE DEFORMATIONS, AVEC SQRT(2)
!     OUT:
!           DVIN    :  DERIVEES DES VARIABLES INTERNES A T
!           IRET    :  CODE RETOUR =0 SI OK, =1 SI PB
!     ----------------------------------------------------------------
#include "asterc/r8miem.h"
#include "asterfort/lcdevi.h"
#include "asterfort/lcnrts.h"
#include "asterfort/r8inir.h"
    integer :: iret, itens, ndi, nmat, nvi, ndt
    real(kind=8) :: coeft(nmat), vini(nvi), dvin(nvi), smx(6), sigi(6)
    real(kind=8) :: dp, n, unsurk, grj2v, epsi
!     ----------------------------------------------------------------
    common /tdim/   ndt,    ndi
!     ----------------------------------------------------------------
!
    iret=0
!     INITIALISATION DES DERIVEES DES VARIABLES INTERNES A ZERO
    call r8inir(7, 0.d0, dvin, 1)
!
! --    COEFFICIENTS MATERIAU
    n = coeft(1)
    unsurk = coeft(2)
!
!     ZERO NUMERIQUE ABSOLU
    epsi=r8miem()
!
!------------ CALCUL DU TENSEUR DEVIATORIQUE DES CONTRAINTES ---
!
    call lcdevi(sigi, smx)
!
!------------CALCUL DU DEUXIEME INVARIANT DE CONTRAINTE  -------
!
    grj2v = lcnrts(smx )
!
!------ EQUATION DONNANT LA DERIVEE DE LA DEF VISCO PLAST
!
    if (grj2v .gt. epsi) then
!
        dp=(grj2v*unsurk)**n
!
!        INUTILE DE CALCULER DES DEFORMATIONS PLASTIQUES MINUSCULES
        if (dp .gt. 1.d-10) then
!
            do 12 itens = 1, ndt
                dvin(itens)=1.5d0*dp*smx(itens)/grj2v
12          continue
            dvin(7)=dp
!
        endif
!
    endif
end subroutine
