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

subroutine calamr(phib24, phi1j, bi, num, j,&
                  cij2)
    implicit none
!
!ROUTINE STOCKANT LE VECTEUR PRESSION ISSUE D UNE RESOLUTION DE LAPLACE
! IN : VECSOL : VECTEUR SOLUTION K*
! OUT : VESTO : VECTEUR STOCKE K*
!---------------------------------------------------------------------
#include "jeveux.h"
#include "asterfort/calci.h"
#include "asterfort/chnucn.h"
#include "asterfort/codent.h"
    character(len=3) :: incr
    character(len=8) :: k8bid
    character(len=14) :: num
    character(len=19) :: phi1j, ph1plo, phib19
    character(len=24) :: phib24, bi
    real(kind=8) :: cij2
! ---------------------------------------------------------------
!
!--------- CALCUL DE LA MASSE AJOUTEE POUR UN FLUIDE-------------
!-------------------N AYANT PAS FORCEMENT------------------------
!-----------------LA MEME DENSITE PARTOUT------------------------
!
!-----------PLONGEMENT DE LA PRESSION----
!---------------SUR LE MODELE THERMIQUE D INTERFACE--------------
!-----------------------------------------------------------------------
    integer :: j
!-----------------------------------------------------------------------
    phib19='PHIB19'
    incr='BID'
    call chnucn(phib24(1:19), num, 0, k8bid, 'V',&
                phib19)
    call codent(j, 'D0', incr)
    ph1plo='PHPLO'//incr
    call chnucn(phi1j, num, 0, k8bid, 'V',&
                ph1plo)
!-------------------CALCUL DE L'AMORTISSEMENT AJOUTE-------------------
!---------------SUR LE MODELE THERMIQUE D INTERFACE--------------
!
    call calci(phib19, ph1plo, bi(1:19), cij2)
!       CALL JEDETC('V',PH1PLO,1)
!       CALL JEDETC('V',BI(1:19),1)
!
end subroutine
