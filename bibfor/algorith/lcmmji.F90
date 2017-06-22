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

subroutine lcmmji(coeft, ifa, nmat, nbcomm, necris,&
                  nfs, nsg, hsr, is, ir,&
                  pr, drdps)
    implicit none
    integer :: ifa, nmat, nbcomm(nmat, 3), ir, is, nfs, nsg
    real(kind=8) :: coeft(nmat), drdps, hsr(nsg, nsg)
    character(len=16) :: necris
! person_in_charge: jean-michel.proix at edf.fr
! ======================================================================
!  CALCUL DE LA DERIVEE DE LA FONCTION D'ECROUISSAGE dRS/dPR
!       IN  COEFT   :  PARAMETRES MATERIAU
!           IFA     :  NUMERO DE FAMILLE
!           NBCOMM  :  NOMBRE DE COEF MATERIAU PAR FAMILLE
!           NECRIS  :  NOM DE LA LOI D'ECROUISSAGE ISOTROPE
!           IS      :  NUMERO DU SYSTEME DE GLISSEMENT EN COURS
!           IR      :  NUMERO DU SYSTEME DE GLISSEMENT POUR INTERACTION
!           PR      :  DEFORMATION PLASTIQUE CUMULEE POUR INTERACTION
!     OUT:
!           DRSDPR :  D(RS(P))/D(PR)
!     ----------------------------------------------------------------
    real(kind=8) :: q, b, b1, b2, q1, q2, pr
    integer :: iei, nueiso
!     ----------------------------------------------------------------
!
    iei=nbcomm(ifa,3)
    nueiso=nint(coeft(iei))
!
!
!      IF (NECRIS.EQ.'ECRO_ISOT1') THEN
    if (nueiso .eq. 1) then
!
        q=coeft(iei+2)
        b=coeft(iei+3)
!
!        R(PS)=R0+Q*SOMME(HSR*(1-EXP(-B*PR))
!        dRs/dpr
        drdps=b*q*hsr(is,ir)*exp(-b*pr)
!
!      ELSEIF (NECRIS.EQ.'ECRO_ISOT2') THEN
    else if (nueiso.eq.2) then
!
        q1=coeft(iei+2)
        b1=coeft(iei+3)
        q2=coeft(iei+4)
        b2=coeft(iei+5)
!
        drdps=q1*hsr(is,ir)*b1*exp(-b1*pr)
        if (is .eq. ir) then
            drdps=drdps+q2*b2*exp(-b2*pr)
        endif
!
    endif
!
end subroutine
