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

function dppat2(mater, pmoins, pplus, plas)
!
    implicit none
#include "asterfort/betaps.h"
#include "asterfort/utmess.h"
    real(kind=8) :: mater(5, 2), pmoins, pplus, plas, dppat2
! --- BUT : INITIALISATION POUR L OPERATEUR TANGENT POUR LA LOI --------
! --- DRUCKER-PRAGER PARABOLIQUE ---------------------------------------
! ======================================================================
    real(kind=8) :: un, deux, trois, young, nu, troisk, deuxmu, phi, c, pult
    real(kind=8) :: alpha1, alpha, douze, psi, beta, betam, dp
! ======================================================================
    parameter  ( un    =  1.0d0 )
    parameter  ( deux  =  2.0d0 )
    parameter  ( trois =  3.0d0 )
    parameter  ( douze = 12.0d0 )
! ======================================================================
    young = mater(1,1)
    nu = mater(2,1)
    troisk = young / (un-deux*nu)
    deuxmu = young / (un+nu)
    alpha1 = mater(1,2)
    phi = mater(2,2)
    c = mater(3,2)
    pult = mater(4,2)
    psi = mater(5,2)
    alpha = deux*sin(phi)/(trois-sin(phi))
    beta = deux*sin(psi)/(trois-sin(psi))
    dp = pplus - pmoins
    if (plas .eq. 1.0d0) then
        if (pplus .lt. pult) then
            betam = betaps (beta, pmoins, pult)
            dppat2 = trois*deuxmu/deux + trois*troisk*alpha*betam - 6.0d0*troisk*alpha*dp*beta/pu&
                     &lt - douze*c*cos(phi)/(trois- sin(phi))* (un-(un-alpha1)/pult*pplus)*(un-al&
                     &pha1)/pult
        else
            dppat2 = trois*deuxmu/deux
        endif
    else if (plas.eq.2.0d0) then
        call utmess('F', 'ALGORITH3_43')
        if (pplus .lt. pult) then
            betam = betaps (beta, pmoins, pult)
            dppat2 = trois*troisk*alpha*betam - douze*c*cos(phi)/( trois-sin(phi))* (un-(un-alpha&
                     &1)/pult*pplus)*(un-alpha1)/ pult
        else
            dppat2 = 0.0d0
        endif
    else
        dppat2 = 0.0d0
    endif
! ======================================================================
end function
