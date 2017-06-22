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

subroutine lcmmdc(coeft, ifa, nmat, nbcomm, alphap,&
                  is, ceff, dcdals)
    implicit none
    integer :: ifa, nmat, nbcomm(nmat, 3), is
    real(kind=8) :: coeft(*), alphap(12), ceff, dcdals
! person_in_charge: jean-michel.proix at edf.fr
! ======================================================================
!  CALCUL DE LA FONCTION Ceffectif POUR LA LOI D'ECOULEMENT  DD-CFC
!       IN  COEFT   :  PARAMETRES MATERIAU
!           IFA     :  NUMERO DE FAMILLE
!           NBCOMM  :  NOMBRE DE COEF MATERIAU PAR FAMILLE
!           NMAT    :  NOMBRE DE MATERIAUX
!           ALPHAP  :  ALPHA =RHO*B**2 (TOTAL) A T+DT
!     OUT:
!           CEFF    :  Coefficeint pour passer de A_ij a Aeff_ij
!     ----------------------------------------------------------------
    real(kind=8) :: alpha, beta, rhoref, omegat
    integer :: iei, i
!     ----------------------------------------------------------------
!
    iei=nbcomm(ifa,3)
    alpha =coeft(iei+1)
    beta  =coeft(iei+2)
    rhoref=coeft(iei+3)
    ceff=1.d0
    dcdals=0.d0
    if (alpha .gt. 0.d0) then
        omegat=0.d0
        do 10 i = 1, 12
            if (alphap(i) .gt. 0.d0) then
                omegat=omegat+alphap(i)
            endif
10      continue
!        PARTIE POSITIVE
        if (omegat .gt. 0.d0) then
            ceff=0.2d0+0.8d0*log(alpha*sqrt(omegat))/ log(alpha*beta*&
            sqrt(rhoref))
            if (alphap(is) .gt. 0.d0) then
                dcdals=0.8d0/2.d0/log(alpha*beta*sqrt(rhoref))/omegat
            endif
        endif
    endif
!
end subroutine
