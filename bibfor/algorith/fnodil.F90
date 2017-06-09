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

subroutine fnodil(dimuel, dimdef, nno, nnos, nnom,&
                  ndim, npi, dimcon, geom, ipoids,&
                  ipoid2, ivf, ivf2, interp, idfde,&
                  idfde2, nddls, nddlm, axi, regula,&
                  deplm, contm, imate, vectu)
! ======================================================================
! person_in_charge: romeo.fernandes at edf.fr
! aslint: disable=W1306,W1504
    implicit none
#include "asterf_types.h"
#include "asterfort/cabrp0.h"
#include "asterfort/cabrp1.h"
#include "asterfort/cabrsl.h"
#include "asterfort/dilcge.h"
#include "asterfort/dilpen.h"
#include "asterfort/dilsga.h"
    aster_logical :: axi
    integer :: dimuel, dimdef, nno, nnos, nnom, ndim, npi, dimcon, ipoids
    integer :: ipoid2, ivf, ivf2, idfde, idfde2, nddls, nddlm, imate
    integer :: regula(6)
    real(kind=8) :: geom(ndim, *), deplm(dimuel), vectu(dimuel)
    real(kind=8) :: contm(dimcon*npi)
    character(len=2) :: interp
! ======================================================================
! --- BUT : FORCES NODALES ---------------------------------------------
! ======================================================================
! --- VARIABLES LOCALES ------------------------------------------------
! ======================================================================
    integer :: i, kpi, n
    real(kind=8) :: b(dimdef, dimuel), poids, poids2, defgem(dimdef), r(dimdef)
    real(kind=8) :: rpena
! ======================================================================
    rpena = 0.0d0
! ======================================================================
    do 10 i = 1, dimuel
        vectu(i)=0.0d0
 10 end do
! ======================================================================
! --- RECUPERATION DU COEFFICIENT DE PENALISATION ----------------------
! ======================================================================
    call dilpen(imate, rpena)
! ======================================================================
! --- BOUCLE SUR LES POINTS DE GAUSS -----------------------------------
! ======================================================================
    do 100 kpi = 1, npi
! ======================================================================
! --- INITIALISATION DE R ----------------------------------------------
! ======================================================================
        do 22 i = 1, dimdef
            r(i) = 0.0d0
 22     continue
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
        do 110 i = 1, dimdef
            defgem(i)=0.0d0
            do 120 n = 1, dimuel
                defgem(i)=defgem(i)+b(i,n)*deplm(n)
120         continue
110     continue
! ======================================================================
! --- CALCUL DES CONTRAINTES GENERALISEES FINALES ----------------------
! ======================================================================
        call dilcge(interp, dimdef, dimcon, regula, ndim,&
                    defgem, contm(( kpi-1)*dimcon+1), rpena, r)
! ======================================================================
        call dilsga(dimdef, dimuel, poids, poids2, b,&
                    r, vectu)
! ======================================================================
100 end do
! ======================================================================
end subroutine
