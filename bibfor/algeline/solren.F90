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

subroutine solren(sn, nbmat, mater, q, codret)
!
    implicit   none
#include "asterfort/calcq.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
    integer :: nbmat, codret
    real(kind=8) :: sn(6), mater(nbmat, 2), q(6)
! --- BUT : CALCUL DE Q ------------------------------------------------
! ======================================================================
! IN  : NDT    : NOMBRE DE COMPOSANTES TOTAL DU TENSEUR ----------------
! --- : SN     : TENSEUR DU DEVIATEUR DES CONTRAINTES ------------------
! --- : NBMAT  : NOMBRE DE PARAMETRES MATERIAU -------------------------
! --- : MATER  : PARAMETRES MATERIAU -----------------------------------
! OUT : Q      : DERIVEE Q = DG/DSIG -----------------------------------
! ======================================================================
    real(kind=8) :: gamcjs, pref, epssig
! ======================================================================
! --- INITIALISATION DE PARAMETRE --------------------------------------
! ======================================================================
    parameter       ( epssig  =  1.0d-8  )
! ======================================================================
    call jemarq()
! ======================================================================
! --- RECUPERATION DE PARAMETRES MATERIAU ------------------------------
! ======================================================================
    gamcjs = mater(12,2)
    pref = mater(15,2)
! ======================================================================
! --- CALCUL DE Q ------------------------------------------------------
! ======================================================================
    call calcq(sn, gamcjs, pref, epssig, q,&
               codret)
! ======================================================================
    call jedema()
! ======================================================================
end subroutine
