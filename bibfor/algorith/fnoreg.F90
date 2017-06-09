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

subroutine fnoreg(dimuel, dimdef, nno, nnos, nnom,&
                  ndim, npi, dimcon, geom, ipoids,&
                  ipoid2, ivf, ivf2, idfde, idfde2,&
                  nddls, nddlm, axi, regula, deplm,&
                  contm, imate, vectu)
! aslint: disable=W1306,W1504
    implicit none
#include "asterf_types.h"
#include "asterfort/cabr2g.h"
#include "asterfort/dilsga.h"
#include "asterfort/regcge.h"
    aster_logical :: axi
    integer :: dimuel, dimdef, nno, nnos, nnom, ndim, npi, dimcon, ipoids
    integer :: ipoid2, ivf, ivf2, idfde, idfde2, nddls, nddlm, imate
    integer :: regula(6)
    real(kind=8) :: geom(ndim, *), deplm(dimuel), vectu(dimuel)
    real(kind=8) :: contm(dimcon*npi)
! ======================================================================
! --- BUT : CALCUL DES FORCES NODALES A PARTIR DE RIGI_MECA ------------
! ======================================================================
! --- VARIABLES LOCALES ------------------------------------------------
! ======================================================================
    integer :: i, kpi, n
    real(kind=8) :: b(dimdef, dimuel), poids, poids2, defgem(dimdef), r(dimdef)
! ======================================================================
    do 10 i = 1, dimuel
        vectu(i)=0.0d0
 10 end do
!
    do 100 kpi = 1, npi
! ======================================================================
! --- INITIALISATION DE R ----------------------------------------------
! ======================================================================
        do 22 i = 1, dimdef
            r(i) = 0.0d0
 22     continue
! ======================================================================
        call cabr2g(kpi, ipoids, ipoid2, ivf, ivf2,&
                    idfde, idfde2, geom, dimdef, dimuel,&
                    ndim, nddls, nddlm, nno, nnos,&
                    nnom, axi, regula, b, poids,&
                    poids2)
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
        call regcge(dimdef, dimcon, regula, ndim, defgem,&
                    contm((kpi-1)* dimcon+1), r)
! ======================================================================
        call dilsga(dimdef, dimuel, poids, poids2, b,&
                    r, vectu)
! ======================================================================
100 end do
! ======================================================================
end subroutine
