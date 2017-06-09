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

subroutine lcmmjc(coeft, ifa, nmat, nbcomm, ir,&
                  is, necrci, dgamms, alphmr, dalpha,&
                  sgnr, daldgr)
    implicit none
#include "asterc/r8prem.h"
    integer :: ifa, nmat, nbcomm(nmat, 3), ir, is
    real(kind=8) :: coeft(nmat), daldgr, dgamms, alphmr, sgnr
    character(len=16) :: necrci
! person_in_charge: jean-michel.proix at edf.fr
! ======================================================================
!  CALCUL DES DERIVEES DES VARIABLES INTERNES DES LOIS MONOCRISTALLINES
!  POUR L'ECROUISSAGE CINEMATIQUE
!       IN  COEFT  :  PARAMETRES MATERIAU
!           IFA    :  NUMERO DE FAMILLE
!           IR     :
!           NBCOMM :  NOMBRE DE COEF MATERIAU PAR FAMILLE
!           IS     :  NUMERO DU SYSTEME DE GLISSEMENT EN COURS
!           IR     :  NUMERO DU SYSTEME DE GLISSEMENT POUR INTERACTION
!           NECRCI :  NOM DE LA LOI D'ECROUISSAGE CINEMATIQUE
!           DGAMMS :  ACCROISS. GLISSEMENT PLASTIQUE
!           ALPHMR :  VAR. ECR. CIN. INST T
!           DALPHA :  DELTA ALPHA
!           SGNR   : DELTA P ACTUEL
!     OUT:
!           DALDGR : dAlpha/dGamma
!
!     ----------------------------------------------------------------
    real(kind=8) :: d, dalpha
    integer :: iec, nuecin
!     ----------------------------------------------------------------
!
!
    iec=nbcomm(ifa,2)
    nuecin=nint(coeft(iec))
    daldgr=0.d0
!
!--------------------------------------------------------------------
!     POUR UN NOUVEL ECROUISSAGE CINEMATIQUE, AJOUTER UN BLOC IF
!--------------------------------------------------------------------
!
!      IF (NECRCI.EQ.'ECRO_CINE1') THEN
    if (nuecin .eq. 1) then
!          D=COEFT(IEC-1+1)
        d=coeft(iec+1)
        daldgr=0.d0
        if (is .eq. ir) then
            daldgr=(1.d0-d*alphmr*sgnr)/(1.d0+d*abs(dgamms))**2
        endif
    endif
!
!      IF (NECRCI.EQ.'ECRO_CINE2') THEN
    if (nuecin .eq. 2) then
        daldgr=0.d0
        if (is .eq. ir) then
            if (abs(dgamms) .gt. r8prem()) then
                daldgr=dalpha/dgamms
            else
                daldgr=1.d0
            endif
        endif
    endif
!
end subroutine
