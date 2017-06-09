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

subroutine mdgep4(neq, nbexci, psidel, temps, nomfon,&
                  iddl, rep)
    implicit none
#include "asterfort/fointe.h"
#include "asterfort/utmess.h"
    integer :: neq
    real(kind=8) :: psidel(neq, *), temps, rep
    character(len=8) :: nomfon(*)
!    MULTI-APPUIS :
!    CONVERSION LES DDL GENERALISES EN BASE PHYSIQUE : CONTRIBUTION
!    DES DEPLACEMENTS DIFFERENTIELS DES ANCRAGES
!-----------------------------------------------------------------------
! IN  : NEQ    : NB D'EQUATIONS DU SYSTEME ASSEMBLE
! IN  : NBEXCI : NOMBRE D'ACCELERO DIFFERENTS
! IN  : PSIDEL : VALEUR DU VECTEUR PSI*DELTA
! IN  : TEMPS  : INSTANT DE CALCUL DES DEPL_IMPO
! IN  : NOMFON : NOM DE LA FONCTION DEPL_IMPO
! IN  : IDDL   : NUMERO DU DDL TRAITE
! OUT : REP    : VALEUR DE PSIDEL*VALE_NOMFOM(TEMPS)
! .________________.____.______________________________________________.
    character(len=8) :: nompar, blanc
    real(kind=8) :: coef
!
!-----------------------------------------------------------------------
    integer :: iddl, ier, iex, nbexci, cntr
!-----------------------------------------------------------------------
    blanc = '        '
    nompar = 'INST'
    rep = 0.d0
    cntr = 0
    do 10 iex = 1, nbexci
        if (nomfon(iex) .eq. blanc) goto 10

        cntr = cntr + 1
        call fointe('F ', nomfon(iex), 1, [nompar], [temps],&
                    coef, ier)
        rep = rep + psidel(iddl,iex)*coef
        
10  end do

    if (cntr.eq.0) then
        call utmess('A', 'ALGORITH13_44')
    end if
end subroutine
