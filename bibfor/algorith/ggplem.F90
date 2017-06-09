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

subroutine ggplem(s, dpc, valden, unsurk, unsurm,&
                  theta, deuxmu, g, dgdst, dgdev)
    implicit none
!
!DEB
!---------------------------------------------------------------
!     VITESSE DE DEF. VISQUEUSE ET SA DERIVEE PAR RAPPORT A SIGMA
!---------------------------------------------------------------
! IN  S     :R: CONTRAINTE EQUIVALENTE SIGMA
!     DPC   :R: SCALAIRE RESUMANT L'ETAT VISCOPLASTIQUE DU POINT
!               CONSIDERE DU MATERIAU (DEFORM. PLASTIQUE CUMULEE)
!     VALDEN:R: VALEUR DE N
!     UNSURK:R: PARAMETRE 1/K
!     UNSURM:R: PARAMETRE 1/M
!     THETA :R: PARAMETRE DU SCHEMA D'INTEGRATION (0.5 OU 1)
!                  THETA = 0.5 -> SEMI-IMPLICITE
!                  THETA = 1.0 -> IMPLICITE
! OUT G     :R: VALEUR DE LA FONCTION G
!     DGDST :R: DERIVEE TOTALE DE G PAR RAPPORT A SIGMA
!     DGDEV :R: DERIVEE PARTIELLE DE G PAR RAPPORT A EV (I.E. DPC)
!---------------------------------------------------------------
!            DANS LE CAS DE LA LOI DE LEMAITRE,
!     CETTE ROUTINE CALCULE LA FONCTION G DE LA FORMULATION
!       "STRAIN HARDENING" DE L'ECOULEMENT VISCOPLASTIQUE
!       (LOI DONNEE SOUS FORME "STRAIN HARDENING")
!            .
!            EV = G(SIGMA,LAMBDA)
!
!     ET LA DERIVEE TOTALE DE CETTE FONCTION G PAR RAPPORT A SIGMA
!---------------------------------------------------------------
!FIN
!
!-----------------------------------------------------------------------
    real(kind=8) :: deuxmu, dgdev, dgdst, dpc, g, s, theta
    real(kind=8) :: unsurk, unsurm, valden
!-----------------------------------------------------------------------
    if (s .eq. 0.d0 .or. dpc .eq. 0.d0 .or. unsurk .eq. 0.d0) then
        g = 0.d0
        dgdst = 0.d0
        dgdev = 0.d0
        goto 99
    else
        if (unsurm .eq. 0.d0) then
            g = exp(valden*log(s*unsurk))
            dgdst = valden*g/s
            dgdev = 0.d0
        else
            g = exp(valden*(log(s*unsurk)-unsurm*log(dpc)))
            dgdst = valden*(1.d0/s+unsurm/(1.5d0*deuxmu*dpc))*g
            dgdev = - valden*g*unsurm/dpc
        endif
    endif
    g = g*theta
    dgdst = dgdst*theta
    dgdev = dgdev*theta
99  continue
!
end subroutine
