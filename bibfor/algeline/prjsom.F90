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

function prjsom(nbmat, mater, invare, invars, b,&
                siie, type)
!
    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/cosphi.h"
    aster_logical :: prjsom
    integer :: nbmat
    real(kind=8) :: invare, invars, mater(nbmat, 2), b, siie
    character(len=9) :: type
! --- BUT : TESTER S'IL DOIT Y AVOIR PROJECTION ------------------------
! --------- AU SOMMET DU DOMAINE DE REVERSIBILITE ----------------------
! ======================================================================
! IN  : NBMAT  : NOMBRE DE PARAMETRES MATERIAU -------------------------
! --- : MATER  : PARAMETRES MATERIAU -----------------------------------
! --- : INVARE : PREMIER INVARIANT DU TENSEUR DE CONTRAINTES ELASTIQUES-
! --- : INVARS : PREMIER INVARIANT DU TENSEUR DE CONTRAINTES AU SOMMET -
! --- : B      : PARAMETRE CONTROLANT LE COMPORTEMENT VOLUMIQUE --------
! ------------ : DU MATERIAU -------------------------------------------
! --- : SIIE   : NORME DU DEVIATEUR ------------------------------------
! --- : TYPE   : 'SUPERIEUR' OU 'INFERIEUR' POUR LE CALCUL DE COSPHI ---
! OUT : PRJSOM : TRUE SI LA PROJECTION AU SOMMET EST RETENUE -----------
! --- :        : FALSE SI PROJECTION AU SOMMET DU DOMAINE --------------
! ======================================================================
    real(kind=8) :: mun, zero, deux, trois
    real(kind=8) :: mu, k, gamcjs, costyp, test1, test2
! ======================================================================
! --- INITIALISATION DE PARAMETRES -------------------------------------
! ======================================================================
    parameter       ( mun    = -1.0d0  )
    parameter       ( zero   =  0.0d0  )
    parameter       ( deux   =  2.0d0  )
    parameter       ( trois  =  3.0d0  )
! ======================================================================
! --- INITIALISATION ---------------------------------------------------
! ======================================================================
    mu = mater ( 4,1)
    k = mater ( 5,1)
    gamcjs = mater (12,2)
! ======================================================================
! --- CALCUL A PRIORI DE LA PROJECTION AU SOMMET -----------------------
! ======================================================================
    test1 = invare-invars
    if (type .eq. 'SUPERIEUR') then
        if (b .lt. zero) then
            costyp = cosphi(b, gamcjs, 'MAX')
        else
            costyp = cosphi(b, gamcjs, 'MIN')
        endif
        test2 = mun*trois*k*b*siie*costyp/(deux*mu)
        if (test1 .lt. test2) then
            prjsom = .false.
        else
            prjsom = .true.
        endif
    else if (type.eq.'INFERIEUR') then
        if (b .lt. zero) then
            costyp = cosphi(b, gamcjs, 'MIN')
        else
            costyp = cosphi(b, gamcjs, 'MAX')
        endif
        test2 = mun*trois*k*b*siie*costyp/(deux*mu)
        if (test1 .gt. test2) then
            prjsom = .false.
        else
            prjsom = .true.
        endif
    else
        ASSERT(.false.)
    endif
! ======================================================================
end function
