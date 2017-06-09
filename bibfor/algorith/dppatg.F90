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

function dppatg(mater, pplus, plas)
!
    implicit      none
#include "asterc/r8nnem.h"
    real(kind=8) :: mater(5, 2), pplus, plas, dppatg
! --- BUT : INITIALISATION POUR L OPERATEUR TANGENT POUR LA LOI --------
! --- DRUCKER-PRAGER PARABOLIQUE ---------------------------------------
! ======================================================================
    real(kind=8) :: un, deux, trois, young, nu, troisk, deuxmu, phi, c, pult
    real(kind=8) :: alpha1, alpha, douze
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
    alpha = deux*sin(phi)/(trois-sin(phi))
    dppatg = r8nnem()
    if (plas .eq. 1.0d0) then
        if (pplus .lt. pult) then
            dppatg = trois*deuxmu/deux + trois*troisk*alpha*alpha - douze*c*cos(phi)/(trois-sin(p&
                     &hi))* (un-(un-alpha1)/pult* pplus)*(un-alpha1)/pult
        else
            dppatg = trois*deuxmu/deux + trois*troisk*alpha*alpha
        endif
    else if (plas.eq.2.0d0) then
        if (pplus .lt. pult) then
            dppatg = trois*troisk*alpha*alpha - douze*c*cos(phi)/( trois-sin(phi))* (un-(un-alpha&
                     &1)/pult*pplus)*(un-alpha1)/ pult
        else
            dppatg = trois*troisk*alpha*alpha
        endif
    endif
! ======================================================================
end function
