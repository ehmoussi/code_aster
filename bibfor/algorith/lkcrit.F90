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

function lkcrit(amat, mmat, smat, gamcjs, sigc,&
                h0ext, rcos3t, invar, sii)
    implicit none
#include "asterfort/lkhlod.h"
    real(kind=8) :: lkcrit, amat, mmat, smat, gamcjs, sigc, h0ext, rcos3t, invar
    real(kind=8) :: sii
! =================================================================
! --- FONCTION ADAPTEE AU POST-TRAITEMENT DE LA LOI LETK, QUI -----
! --- CALCULE LA POSITION D'UN ETAT DE CONTRAINTE PAR -------------
! --- RAPPORT A UN SEUIL VISCOPLASTIQUE ---------------------------
! =================================================================
    real(kind=8) :: un, deux, trois, six, kseuil, h0c, h0e, aseuil, bseuil
    real(kind=8) :: dseuil, fact1, fact2, fact3, ucrit, htheta, hlode
    parameter( un     =  1.0d0   )
    parameter( deux   =  2.0d0   )
    parameter( trois  =  3.0d0   )
    parameter( six    =  6.0d0   )
! =================================================================
! --- CALCUL DES CRITERES D'ECROUISSAGE ---------------------------
! =================================================================
    kseuil = (deux/trois)**(un/deux/amat)
    h0c = (un - gamcjs)**(un/six)
    h0e = (un + gamcjs)**(un/six)
    aseuil = - mmat * kseuil/sqrt(six)/sigc/h0c
    bseuil = mmat * kseuil/trois/sigc
    dseuil = smat * kseuil
! =================================================================
    fact1 = (h0c + h0ext)/deux
    fact2 = (h0c - h0ext)/deux
    hlode = lkhlod(gamcjs,rcos3t)
    fact3 = (deux*hlode-(h0c+h0e))/(h0c-h0e)
    htheta = fact1+fact2*fact3
! =================================================================
    ucrit = aseuil*sii*htheta + bseuil*invar+dseuil
    if (ucrit .lt. 0.0d0) then
        ucrit=0.0d0
    endif
    lkcrit = sii*htheta - sigc*h0c*(ucrit)**amat
end function
