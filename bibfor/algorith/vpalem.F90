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

function vpalem(x)
    implicit none
    real(kind=8) :: x
    real(kind=8) :: vpalem
!
!DEB
!---------------------------------------------------------------
!     FONCTION A(X)  :  CAS DE LA LOI DE LEMAITRE
!---------------------------------------------------------------
! IN  X     :R: ARGUMENT RECHERCHE LORS DE LA RESOLUTION SCALAIRE
!---------------------------------------------------------------
!     L'ETAPE LOCALE DU CALCUL VISCOPLASTIQUE (CALCUL DU TERME
!       ELEMENTAIRE DE LA MATRICE DE RIGIDITE TANGENTE) COMPORTE
!       LA RESOLUTION D'UNE EQUATION SCALAIRE NON LINEAIRE:
!
!           A(X) = 0
!
!       (DPC,SIELEQ,DEUXMU,DELTAT JOUENT LE ROLE DE PARAMETRES)
!---------------------------------------------------------------
!FIN
!     COMMON POUR LES PARAMETRES DES LOIS VISCOPLASTIQUES
    common / nmpavp / dpc,sieleq,deuxmu,deltat,tschem,prec,theta,niter
    real(kind=8) :: dpc, sieleq, deuxmu, deltat, tschem, prec, theta, niter
!
!     COMMON POUR LES PARAMETRES DE LA LOI DE LEMAITRE (NON IRRADIEE)
    common / nmpale / unsurk,unsurm,valden
    real(kind=8) :: unsurk, unsurm, valden
!
    real(kind=8) :: g
!
    if (unsurk .eq. 0.d0 .or. x .eq. 0.d0) then
        g = 0.d0
    else
        if (unsurm .eq. 0.d0) then
            g = log(x*unsurk)
            g = exp(valden*g)
            g = g*theta
        else
            g = log(x*unsurk)-unsurm*log(dpc+(sieleq-x)/(1.5d0*deuxmu) )
            g = exp(valden*g)
            g = g*theta
        endif
    endif
    vpalem = 1.5d0*deuxmu*deltat*g + x - sieleq
end function
