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

subroutine cabrsl(kpi, ipoids, ipoid2, ivf, ivf2,&
                  idfde, idfde2, geom, dimdef, dimuel,&
                  ndim, nddls, nddlm, nno, nnos,&
                  nnom, axi, regula, b, poids,&
                  poids2)
! aslint: disable=W1306,W1504
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/dfdm3d.h"
#include "asterfort/utmess.h"
!
    aster_logical :: axi
    integer :: kpi, ipoids, ipoid2, idfde, idfde2, ndim, regula(6), dimdef, ivf
    integer :: ivf2, nno, nnos, nnom, nddls, nddlm, dimuel
    real(kind=8) :: geom(ndim, *), poids, poids2, b(dimdef, dimuel)
! ======================================================================
! --- BUT : CALCUL DE L'OPERATEUR B POUR LA MODELISATION SECOND GRADIENT
! ---       A MICRO DILATATION SANS MULTIPLICATEURS DE LAGRANGE --------
! ======================================================================
! --- IN ---------------------------------------------------------------
! --- NBDDL  : VECTEUR DIMENSION DU NOMBRE DE DDLS ---------------------
! --- NBNO   : VECTEUR DIMENSION DU NOMBRE DE NOEUDS -------------------
! --- KPI    : INDICE DU POINT D'INTEGRATION ---------------------------
! --- IPOIDS : ADRESSE DES FONCTIONS POIDS D'ORDRE 2 -------------------
! --- IPOID2 : ADRESSE DES FONCTIONS POIDS D'ORDRE 1 -------------------
! --- IVF2   : ADRESSE DES FONCTIONS DE FORME D'ORDRE 1 ----------------
! --- IDFDE  : ADRESSE DES DERIVEES DES FONCTIONS DE FORME D'ORDRE 2 ---
! --- IDFDE2 : ADRESSE DES DERIVEES DES FONCTIONS DE FORME D'ORDRE 1 ---
! --- GEOM   : CARACTERISTIQUES GEOMETRIQUES DE L'ELEMENT REEL ---------
! --- DIMDEF : DIMENSION DU VECTEUR DES DEFORMATIONS GENERALISEES ------
! --- NDIM   : DIMENSION DU PROBLEME -----------------------------------
! --- OUT --------------------------------------------------------------
! --- B      : OPERATEUR B DEFINI TEL QUE E=B.U ------------------------
! --- POIDS  : POIDS ASSOCIE AUX FONCTIONS DE FORME D'ORDRE 2 ----------
! --- POIDS2 : POIDS ASSOCIE AUX FONCTIONS DE FORME D'ORDRE 1 ----------
! ======================================================================
! ======================================================================
! --- VARIABLES LOCALES ------------------------------------------------
! ======================================================================
    integer :: i, j, n, adder1, adder2
    real(kind=8) :: dfdi(nno, 3), dfdi2(nnos, 3)
! ======================================================================
! --- INITIALISATION DE LA MATRICE B -----------------------------------
! ======================================================================
    do 100 i = 1, dimuel
        do 200 j = 1, dimdef
            b(j,i)=0.d0
200     continue
100 end do
    adder1 = regula(1)
    adder2 = regula(2)
! ======================================================================
! --- CAS 2D -----------------------------------------------------------
! ======================================================================
    if (ndim .eq. 2) then
! ======================================================================
! --- CAS QUADRATIQUES -------------------------------------------------
! ======================================================================
        call dfdm2d(nno, kpi, ipoids, idfde, geom,&
                    poids, dfdi(1, 1), dfdi(1, 2))
! ======================================================================
! --- CAS LINEAIRES ----------------------------------------------------
! ======================================================================
        call dfdm2d(nnos, kpi, ipoid2, idfde2, geom,&
                    poids2, dfdi2(1, 1), dfdi2(1, 2))
    else if (ndim.eq.3) then
! ======================================================================
! --- CAS QUADRATIQUES -------------------------------------------------
! ======================================================================
        call dfdm3d(nno, kpi, ipoids, idfde, geom,&
                    poids, dfdi(1, 1), dfdi(1, 2), dfdi(1, 3))
! ======================================================================
! --- CAS LINEAIRES ----------------------------------------------------
! ======================================================================
        call dfdm3d(nnos, kpi, ipoid2, idfde2, geom,&
                    poids2, dfdi2(1, 1), dfdi2(1, 2), dfdi2(1, 3))
    else
        call utmess('F', 'ALGORITH6_13')
    endif
! ======================================================================
! --- REMPLISSAGE DE L OPERATEUR B -------------------------------------
! ======================================================================
! --- SUR LES NOEUDS SOMMETS -------------------------------------------
! ======================================================================
    do 10 n = 1, nnos
        do 20 i = 1, ndim
            b(adder1,(n-1)*nddls+i) = b(adder1,(n-1)*nddls+i)+dfdi(n, i)
 20     continue
        b(adder1,(n-1)*nddls+ndim+1) = b(adder1, (n-1)*nddls+ndim+1) - zr(ivf2+n+(kpi-1)*nnos-1)
 10 end do
! ======================================================================
! --- SUR LES NOEUDS MILIEUX -------------------------------------------
! ======================================================================
    do 30 n = 1, nnom
        do 40 i = 1, ndim
            b(adder1,nnos*nddls+(n-1)*nddlm+i)= b(adder1,nnos*nddls+(&
            n-1)*nddlm+i)+dfdi(n+nnos,i)
 40     continue
 30 end do
! ======================================================================
! --- POUR LES GRADIENTS DE VARIATIONS VOLUMIQUE ET LES VAR VOL --------
! --- ON UTILISE LES FONCTIONS DE FORME D'ORDRE 1 ----------------------
! ======================================================================
! --- SUR LES NOEUDS SOMMETS -------------------------------------------
! ======================================================================
    do 50 n = 1, nnos
        do 60 i = 1, ndim
            b(adder2-1+i,(n-1)*nddls+ndim+1)= b(adder2-1+i,(n-1)*&
            nddls+ndim+1)+dfdi2(n,i)
 60     continue
 50 end do
! ======================================================================
! --- POUR LE MULTIPLICATEUR DE LAGRANGE -------------------------------
! --- (PRES) -----------------------------------------------------------
! --- ON UTILISE LES FONCTIONS DE FORME D'ORDRE 0 ----------------------
! ======================================================================
! --- SUR LES NOEUDS CENTRAUX ------------------------------------------
! ======================================================================
! ======================================================================
end subroutine
