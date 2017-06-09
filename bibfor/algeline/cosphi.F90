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

function cosphi(coefb, gamcjs, type)
!
    implicit none
#include "asterc/r8prem.h"
#include "asterfort/assert.h"
#include "asterfort/utmess.h"
    real(kind=8) :: coefb, gamcjs, cosphi
    character(len=3) :: type
! --- BUT : CALCUL DE COS(PHI) POUR LA PROJECTION AU SOMMET DU DOMAINE -
! ======================================================================
! IN  : COEFB  : COEFFICIENT BPRIME OBTENU LORS DU CALCUL DE LA NORMALE
! --- : GAMCJS : DONNEE MATERIAU ---------------------------------------
! --- : TYPE   : TYPE DE L'ENCADREMENT ---------------------------------
! ------------ : 'MIN' : MINORANT --------------------------------------
! ------------ : 'MAX' : MAJORANT --------------------------------------
! OUT : COSPHI = 3/( (COEFB**2+3) * ------------------------------------
! ------------ :      SQRT( (3/(COEFB**2+3))**2 - 1/2 ------------------
! ------------ :          + 1/(2*(1+LAMBDA*GAMCJS)) --------------------
! ------------ :          + GAMCJS**2/(2*(1+LAMBDA*GAMCJS))**2 )) ------
! ------------ : AVEC LAMBDA =  1 SI TYPE = 'MAX' ----------------------
! ------------ :      LAMBDA = -1 SI TYPE = 'MIN' ----------------------
! ======================================================================
    real(kind=8) :: un, trois, quatre, neuf, epstol
    real(kind=8) :: fact1, fact3, fact4, racine
! ======================================================================
! --- INITIALISATION DE PARAMETRES -------------------------------------
! ======================================================================
    parameter       ( un     =  1.0d0  )
    parameter       ( trois  =  3.0d0  )
    parameter       ( quatre =  4.0d0  )
    parameter       ( neuf   =  9.0d0  )
! ----------------------------------------------------------------------
    epstol = r8prem()
    if (type .eq. 'MAX') then
        cosphi = un
    else if (type.eq.'MIN') then
! ======================================================================
! --- CALCUL DE FACT1 = 1/(2*(1+LAMBDA*GAMCJS)) ------------------------
! ======================================================================
        if ((un-gamcjs*gamcjs) .lt. epstol) then
            call utmess('F', 'ALGELINE_4')
        endif
        fact1 = (gamcjs*gamcjs)/(quatre*(un-gamcjs*gamcjs))
! ======================================================================
! --- CALCUL DE FACT4 = (3/(COEFB**2+3))**2 - 1/2 ----------------------
! ======================================================================
        fact3 = coefb*coefb + trois
        fact4 = neuf/(fact3*fact3)
! ======================================================================
! --- CALCUL FINAL DE COSPHI -------------------------------------------
! ======================================================================
        racine = sqrt(fact4 + fact1)
        cosphi = trois/(fact3*racine)
    else
        ASSERT(.false.)
    endif
! ======================================================================
end function
