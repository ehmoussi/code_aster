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

subroutine nmvexi(sigi, grj2, dj2ds, nb, mate,&
                  nmat, xhi, dxhids)
    implicit none
!
#include "asterc/r8gaem.h"
#include "asterfort/calcj0.h"
#include "asterfort/r8inir.h"
    integer :: nb, nmat
!
    real(kind=8) :: mate(nmat, 2), sigi(nb)
    real(kind=8) :: xhi, dxhids(nb), grj2, dj2ds(nb)
!-----------------------------------------------------------------------
!     MODELE VISCOPLASTIQUE A ECROUISSAGE ISOTRROPE COUPLE A DE
!     L ENDOMMAGEMENT ISOTROPE
!
!    CALCUL DE LA CONTRAINTE EQUIVALENTE D ENDOMMAGEMENT VISCOPLASTIQUE
!    ET DE SA DERIVEE PAR RAPPORT A LA CONTRAINTE ASSOCIEE
!-----------------------------------------------------------------------
!     IN   SIGI(NB)     : INCONNUES ASSOCIEES AUX CONTRAINTES
!          GRJ2         : CONTRAINTE EQUIVALENTE DE VON MISES
!          DJ2DS(NB)    : DERIVEE DE LA CONTRAINTE DE VON MISES
!          NB           : NOMBRE D'INCONNUES ASSOCIEES AUX CONTRAINTES
!          MATE(*,2)    : PARAMETRES MATERIAUX ELASTQUES ET PLASTIQUES
!          NMATE        : NOMBRE DE PARAMETRES MATERIAUX
!     OUT  XHI          : CONTRAINTE EQUIVALENTE D'ENDOMMAGEMENT
!                         VISCOPLASTIQUE
!          DXHIDS(NB)   : DERIVEE DE XHI/SIGI
!-----------------------------------------------------------------------
    integer :: itens, ivec
    real(kind=8) :: trsig, kron(6), tole, dj0ds(6), dj1ds(6)
    real(kind=8) :: grj0, grj1, valp(3)
    real(kind=8) :: sedvp1, sedvp2, zero
!
    data kron  /1.d0, 1.d0, 1.d0, 0.d0, 0.d0, 0.d0/
!-----------------------------------------------------------------------
!-- 1- INITIALISATIONS:
    tole = 1.d0 / r8gaem()
    zero = 0.d0
    call r8inir(nb, 0.d0, dj0ds, 1)
    call r8inir(nb, 0.d0, dj1ds, 1)
!-- COEFFICIENTS MATERIAU
    sedvp1 = mate(2,2)
    sedvp2 = mate(3,2)
!     ----------------------------------------------------------------
!     KD VA SERA CALCULEE PLUS LOIN UNE FOIS QUE XHI
!     (CONTRAINTE EQUIVALENTE D ENDOMMAGEMENT VISCOPLASTIQUE)
!     SERA CALCULEE
!     ----------------------------------------------------------------
    trsig=(sigi(1)+sigi(2)+sigi(3))
!
!-- CALCUL DE GRJ0(SIGI) : MAX DES CONTRAINTES PRINCIPALES
    if (sedvp1 .le. tole) then
        grj0 =zero
        valp(1)=zero
        valp(2)=zero
        valp(3)=zero
    else
        call calcj0(sigi, grj0, valp)
    endif
!
!-- CALCUL DE GRJ1(SIGI) : PREMIER INVARIANT (TRACE)
    grj1= trsig
!
!-- CALCUL DE LA CONTRAINTE EQUIVALENTE DE FLUAGE
    xhi=sedvp1*grj0+sedvp2*grj1+(1-sedvp1-sedvp2)*grj2
!
!-- DERIVEE DE LA CONTRAINTE EQUIVALENTE DE FLUAGE / CONTRAINTE
    do 10 ivec = 1, 3
        if (valp(ivec) .eq. grj0) dj0ds(ivec) = 1.d0
10  end do
!
    do 20 itens = 1, nb
        dj1ds(itens) = kron(itens)
        dxhids(itens)=sedvp1*dj0ds(itens)+sedvp2*dj1ds(itens)+&
        (1-sedvp1-sedvp2)*dj2ds(itens)
20  end do
end subroutine
