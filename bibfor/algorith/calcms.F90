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

subroutine calcms(nbphas, nbcomm, cpmono, nmat, pgl2,&
                  coeft, angmas, nfs, nsg, toutms)
    implicit none
#include "asterc/r8dgrd.h"
#include "asterfort/lcmmsg.h"
#include "asterfort/matrot.h"
#include "asterfort/promat.h"
#include "asterfort/utmess.h"
    integer :: nmat, nbcomm(nmat, 3), nfs, nbphas, nsg
    real(kind=8) :: pgl(3, 3), toutms(nbphas, nfs, nsg, 7), coeft(nmat)
    real(kind=8) :: q(3, 3)
!
! person_in_charge: jean-michel.proix at edf.fr
!       IN
!         NBCOMM :  NOMBRE DE COEF COEFTIAU PAR FAMILLE
!         CPMONO :  NOMS DES LOIS COEFTIAU PAR FAMILLE
!   PGL2   : MATRICE DE PASSAGE GLOBAL LOCAL DU POLYCRSTAL (a faire)
!     OUT:
!           TOUTMS  :  TOUS LES TENSEURS MS
! INTEGRATION DES LOIS POLYCRISTALLINES PAR UNE METHODE DE RUNGE KUTTA
!
!     CETTE ROUTINE FOURNIT LA DERIVEE DE L ENSEMBLE DES VARIABLES
!     INTERNES DU MODELE
!
!     ----------------------------------------------------------------
    character(len=16) :: nomfam
    character(len=24) :: cpmono(5*nmat+1)
    real(kind=8) :: ang(3), angmas(3), pgl1(3, 3), pgl2(3, 3)
    real(kind=8) :: ms(6), ng(3), lg(3)
    integer :: nbfsys, i, ifa, nbsys, is, indori, indcp, ir
    integer :: indpha, iphas
!     ----------------------------------------------------------------
    ir=0
!         CALCUl DES TENSEURS MS POUR GAGNER DU TEMPS
    do 1 iphas = 1, nbphas
!        INDPHA indice debut phase IPHAS dans NBCOMM
        indpha=nbcomm(1+iphas,1)
!         recuperer l'orientation de la phase et la proportion
        indori=nbcomm(1+iphas,3)+1
        ang(1)=coeft(indori)*r8dgrd()
        ang(2)=coeft(indori+1)*r8dgrd()
        ang(3)=coeft(indori+2)*r8dgrd()
        call matrot(ang, pgl1)
        call matrot(angmas, pgl2)
        call promat(pgl1, 3, 3, 3, pgl2,&
                    3, 3, 3, pgl)
        nbfsys=nbcomm(indpha,1)
        indcp=nbcomm(1+iphas,2)
        if (nbfsys .gt. nfs) then
            call utmess('F', 'ALGORITH_69')
        endif
!        Nombre de variables internes de la phase (=monocristal)
        do 2 ifa = 1, nbfsys
            nomfam=cpmono(indcp+5*(ifa-1)+1)
            call lcmmsg(nomfam, nbsys, 0, pgl, ms,&
                        ng, lg, ir, q)
            if (nbsys .eq. 0) then
                call utmess('F', 'ALGORITH_70')
            endif
!           indice de la famille IFA
!            INDFA=INDPHA+IFA
!
            do 3 is = 1, nbsys
!              CALCUL DE LA SCISSION REDUITE =
!              PROJECTION DE SIG SUR LE SYSTEME DE GLISSEMENT
!              TAU      : SCISSION REDUITE TAU=SIG:MS
                call lcmmsg(nomfam, nbsys, is, pgl, ms,&
                            ng, lg, ir, q)
                do 4 i = 1, 6
                    toutms(iphas,ifa,is,i)=ms(i)
 4              continue
 3          continue
            toutms(iphas,ifa,1,7)=nbsys
 2      continue
!
 1  end do
end subroutine
