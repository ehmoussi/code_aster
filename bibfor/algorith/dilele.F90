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

subroutine dilele(option, typmod, npi, ndim, dimuel,&
                  nddls, nddlm, nno, nnos, nnom,&
                  axi, regula, dimcon, ipoids, ipoid2,&
                  ivf, ivf2, interp, idfde, idfde2,&
                  compor, geom, deplp, contp, imate,&
                  dimdef, matuu, vectu)
! ======================================================================
! person_in_charge: romeo.fernandes at edf.fr
! aslint: disable=W1306,W1504
    implicit none
#include "asterf_types.h"
#include "asterfort/cabrp0.h"
#include "asterfort/cabrp1.h"
#include "asterfort/cabrsl.h"
#include "asterfort/dilopt.h"
#include "asterfort/dilpen.h"
#include "asterfort/dilsga.h"
#include "asterfort/equdil.h"
    aster_logical :: axi
    integer :: npi, ipoids, ipoid2, ivf, ivf2, idfde, idfde2, nddls, nddlm
    integer :: imate, dimdef, ndim, nno, nnom, nnos, dimuel, dimcon
    integer :: regula(6)
    real(kind=8) :: vectu(dimuel), matuu(dimuel*dimuel), contp(dimcon*npi)
    real(kind=8) :: geom(ndim, *), deplp(dimuel)
    character(len=2) :: interp
    character(len=8) :: typmod(2)
    character(len=16) :: option, compor(*)
! ======================================================================
! --- BUT : CALCUL ELEMENTAIRE DE LA PARTIE SECOND GRADIENT A ----------
! ---       MICRO-DILATATION AUX POINTS D'INTEGRATION ------------------
! ======================================================================
! --- VARIABLES LOCALES ------------------------------------------------
! ======================================================================
    integer :: i, n, kpi
    real(kind=8) :: b(dimdef, dimuel), poids, poids2, r(dimdef), rpena
    real(kind=8) :: defgep(dimdef), drde(dimcon, dimdef)
! ======================================================================
! --- INITIALISATION DE VECTU, MATUU A 0 SUIVANT OPTION ----------------
! ======================================================================
    rpena = 0.0d0
! ======================================================================
    if (option(1:9) .eq. 'RIGI_MECA') then
        do 30 i = 1, dimuel*dimuel
            matuu(i)=0.0d0
 30     continue
    else if (option(1:9).eq.'RAPH_MECA') then
        do 40 i = 1, dimuel
            vectu(i)=0.0d0
 40     continue
    else if (option(1:9).eq.'FULL_MECA') then
        do 50 i = 1, dimuel*dimuel
            matuu(i)=0.0d0
 50     continue
        do 60 i = 1, dimuel
            vectu(i)=0.0d0
 60     continue
    endif
! ======================================================================
! --- RECUPERATION DU COEFFICIENT DE PENALISATION ----------------------
! ======================================================================
    call dilpen(imate, rpena)
! ======================================================================
! --- BOUCLE SUR LES POINTS D'INTEGRATION ------------------------------
! ======================================================================
    do 100 kpi = 1, npi
! ======================================================================
! --- DEFINITION DE L'OPERATEUR B (DEFINI PAR E=B.U) -------------------
! ======================================================================
        if (interp .eq. 'P0') then
            call cabrp0(kpi, ipoids, ipoid2, ivf, ivf2,&
                        idfde, idfde2, geom, dimdef, dimuel,&
                        ndim, nddls, nddlm, nno, nnos,&
                        nnom, axi, regula, b, poids,&
                        poids2)
        else if (interp.eq.'SL') then
            call cabrsl(kpi, ipoids, ipoid2, ivf, ivf2,&
                        idfde, idfde2, geom, dimdef, dimuel,&
                        ndim, nddls, nddlm, nno, nnos,&
                        nnom, axi, regula, b, poids,&
                        poids2)
        else if (interp.eq.'P1') then
            call cabrp1(kpi, ipoids, ipoid2, ivf, ivf2,&
                        idfde, idfde2, geom, dimdef, dimuel,&
                        ndim, nddls, nddlm, nno, nnos,&
                        nnom, axi, regula, b, poids,&
                        poids2)
        endif
! ======================================================================
! --- CALCUL DES DEFORMATIONS GENERALISEES E=B.U -----------------------
! ======================================================================
        do 10 i = 1, dimdef
            defgep(i)=0.0d0
            do 20 n = 1, dimuel
                defgep(i)=defgep(i)+b(i,n)*deplp(n)
 20         continue
 10     continue
! ======================================================================
! --- CALCUL DES CONTRAINTES VIRTUELLES ET GENERALISEES ----------------
! --- ET DE LEURS DERIVEES ---------------------------------------------
! ======================================================================
        call equdil(imate, option, compor, regula, dimdef,&
                    dimcon, defgep, interp, ndim, contp((kpi-1)*dimcon+1),&
                    rpena, r, drde)
! ======================================================================
        if (option(1:9) .eq. 'RIGI_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
! ======================================================================
! --- CALCUL DE SOM_PG(POIDS_PG*BT_PG*DRDE_PG*B_PG) --------------------
! ======================================================================
            call dilopt(dimdef, dimuel, poids, poids2, b,&
                        drde, matuu)
        endif
! ======================================================================
        if (option(1:9) .eq. 'RAPH_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
! ======================================================================
! --- CALCUL DE SOM_PG(POIDS_PG*BT_PG*R_PG) ----------------------------
! ======================================================================
            call dilsga(dimdef, dimuel, poids, poids2, b,&
                        r, vectu)
        endif
! ======================================================================
100 end do
! ======================================================================
end subroutine
