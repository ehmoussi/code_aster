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

subroutine solrei(gamp, s, i1n, parame, nbmat,&
                  mater, q, vecn, codret)
!
    implicit   none
#include "asterfort/bprime.h"
#include "asterfort/calcn.h"
#include "asterfort/calcq.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    integer :: nbmat, codret
    real(kind=8) :: s(6), i1n, parame(5), mater(nbmat, 2), q(6), vecn(6), gamp
! --- BUT : CALCUL DE Q ET DE N ----------------------------------------
! ======================================================================
! IN  : NDT    : NOMBRE DE COMPOSANTES TOTAL DU TENSEUR ----------------
! --- : NDI    : NOMBRE DE COMPOSANTES DIAGONALES DU TENSEUR -----------
! --- : S      : TENSEUR DU DEVIATEUR DES CONTRAINTES ------------------
! --- : I1N    : PREMIER INVARIANT DES CONTRAINTES --------------------
! --- : PARAME : VARIABLES D'ECROUISSAGES ------------------------------
! --- : NBMAT  : NOMBRE DE PARAMETRES MATERIAU -------------------------
! --- : MATER  : PARAMETRES MATERIAU -----------------------------------
! OUT : Q      : DERIVEE Q = DG/DSIG -----------------------------------
! --- : VECN   : VECTEUR N POUR PROJECTION SUR LE DOMAINE --------------
! ======================================================================
    integer :: ndt, ndi
    real(kind=8) :: zero, gamult, gamcjs, pref, epssig
    real(kind=8) :: b
! ======================================================================
! --- INITIALISATION DE PARAMETRE --------------------------------------
! ======================================================================
    parameter       ( zero     =  0.0d0   )
    parameter       ( epssig   =  1.0d-8  )
! ======================================================================
    common /tdim/   ndt , ndi
! ======================================================================
    call jemarq()
! ======================================================================
! --- RECUPERATION DE PARAMETRES MATERIAU ------------------------------
! ======================================================================
    gamult = mater( 1,2)
    gamcjs = mater(12,2)
    pref = mater(15,2)
! ======================================================================
! --- CALCUL DE Q ------------------------------------------------------
! ======================================================================
    call calcq(s, gamcjs, pref, epssig, q,&
               codret)
    if (codret .ne. 0) goto 100
! ======================================================================
! --- CALCUL DE N ------------------------------------------------------
! ======================================================================
! --- CAS OU GAMP > GAMULT(1-EPS) --------------------------------------
! ======================================================================
    if (gamp .gt. gamult) then
        b = zero
    else
! ======================================================================
! --- CAS OU GAMP <= GAMULT(1-EPS) -------------------------------------
! ======================================================================
        b = bprime(nbmat, mater, parame, i1n, s, epssig)
    endif
    call calcn(s, b, vecn)
! ======================================================================
100  continue
    call jedema()
! ======================================================================
end subroutine
