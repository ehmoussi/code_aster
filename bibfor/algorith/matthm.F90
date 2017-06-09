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

subroutine matthm(ndim, axi, nno1, nno2, dimuel,&
                  dimdef, iu, ip, ipf, iq,&
                  yap1, yap2, yate, addep1, addep2,&
                  addlh1, vff1, vff2, dffr2, wref,&
                  geom, ang, wi, q)
!
!
!
! =====================================================================
!.......................................................................
!
!     BUT:  CALCUL DE LA MATRICE DE PASSAGE DES DDL A LA DEFORMATION
!           GENERALISEES
!.......................................................................
! =====================================================================
! IN NDIM    : DIMENSION DE L'ESPACE
! IN AXI     : .TRUE. SI AXISYMETRIE
! IN NNO1    : NOMBRE DE NOEUDS DE LA FAMILLE 1
! IN NNO2    : NOMBRE DE NOEUDS DE LA FAMILLE 2
! IN DIMUEL  : NOMBRE DE DDL
! IN DIMDEF  : DIMENSION DU VECTEUR DEFORMATIONS GENERALISEES
! IN IU      : DECALAGE D'INDICE POUR ACCEDER AUX DDL DE DEPLACEMENT
! IN IP      : DECALAGE D'INDICE POUR ACCEDER AUX DDL DE PRESSION MILIEU
! IN IPF     : DECALAGE D'INDICE POUR ACCEDER AUX DDL DE PRESSION FACES
! IN IQ      : DECALAGE D'INDICE POUR ACCEDER AUX DDL DE LAGRANGE HYDRO
! IN YAP1    : SI=1 : EQUATION SUR LA PRESSION 1
! IN YAP2    : SI=1 : EQUATION SUR LA PRESSION 2
! IN YATE    : SI=1 : EQUATION SUR LA TEMPERATURE
! IN ADDEP1  : ADRESSE DES DEFORMATIONS PRESSION 1
! IN ADDEP2  : ADRESSE DES DEFORMATIONS PRESSION 2
! IN ADDLH1  : ADRESSE DES DEFORMATIONS LAGRANGE PRESSION 1
! IN VFF1    : VALEUR DES FONCTIONS DE FORME (FAMILLE 1)
! IN VFF2    : VALEUR DES FONCTIONS DE FORME (FAMILLE 2)
! IN DFFR2   : DERIVEES DES FONCTIONS DE FORME (FAMILLE 2)
! IN WREF    : POIDS DE REFERENCE DU POINT D'INTEGRATION
! IN GEOM    : COORDONNEES DES NOEUDS (FAMILLE 1)
! IN ANG     : ANGLES D'EULER NODAUX (FAMILLE 1)
! =====================================================================
! OUT WI     : POIDS REEL DU POINT D'INTEGRATION
! OUT Q      : MATRICE DE PASSAGE DDL -> DEFORMATIONS GENERALISEES
!......................................................................
!
!
! aslint: disable=W1306,W1504
    implicit none
!
! - VARIABLES ENTREE
#include "asterf_types.h"
#include "asterfort/dfdm1d.h"
#include "asterfort/eicine.h"
    integer :: ndim, nno1, nno2, dimuel, dimdef, yap1, yap2, yate
    integer :: iu(3, 18), ip(2, 9), ipf(2, 2, 9), iq(2, 2, 9)
    integer :: addep1, addep2, addlh1
    real(kind=8) :: vff1(nno1), vff2(nno2), dffr2(ndim-1, nno2)
    real(kind=8) :: wref, geom(ndim, nno2), ang(24)
    aster_logical :: axi
!
! - VARIABLES SORTIE
!
    real(kind=8) :: q(dimdef, dimuel), wi
!
! - VARIABLES LOCALES
    integer :: i, j, n, kj, f
    real(kind=8) :: b(3, 3, 2*nno1), cour, jacp, sina, cosa, dfdx(nno2)
!
! ======================================================================
! --- INITIALISATION ----------------------------------------------
! ======================================================================
    do 108 i = 1, dimdef
        do 109 j = 1, dimuel
            q(i,j)=0.d0
109     continue
108 continue
!
! ======================================================================
! --- CALCUL DE Q ET WI ----------------------------------------------
! ======================================================================
!
! - CALCUL DES DERIVEES DES FONCTIONS DE FORME / ABSCISSE CURVILIGNE
!
    call dfdm1d(nno2, wi, dffr2, geom, dfdx,&
                cour, jacp, cosa, sina)
!
! - CALCUL DE LA MATRICE DE PASSAGE U GLOBAL -> SAUT DE U LOCAL
!
    call eicine(ndim, axi, nno1, nno2, vff1,&
                vff2, wref, dffr2, geom, ang,&
                wi, b)
!
!
    do 10 i = 1, ndim
        do 11 j = 1, ndim
            do 12 n = 1, 2*nno1
                kj=iu(j,n)
                q(i,kj) = b(i,j,n)
 12         continue
 11     continue
 10 end do
!
!
!
! - LIGNES PRESS1
!
    if (yap1 .eq. 1) then
        do 30 n = 1, nno2
            q(addep1,ip(1,n)) = vff2(n)
            do 31 i = 1, ndim-1
                q(addep1+i,ip(1,n)) = dfdx(n)
 31         continue
            do 32 f = 1, 2
                q(addlh1+f-1,ipf(1,f,n)) = vff2(n)
                q(addlh1+f+1,iq(1,f,1)) = 1
 32         continue
 30     continue
    endif
!
!
end subroutine
