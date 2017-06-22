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

subroutine epsreg(npi, ipoids, ipoid2, ivf, ivf2,&
                  idfde, idfde2, geom, dimdef, dimuel,&
                  ndim, nddls, nddlm, nno, nnos,&
                  nnom, axi, regula, deplp, defgep)
! aslint: disable=W1306
    implicit none
#include "asterf_types.h"
#include "asterfort/cabr2g.h"
    aster_logical :: axi
    integer :: npi, ipoids, ipoid2, ivf, ivf2, idfde, idfde2, dimdef, dimuel
    integer :: ndim, nddls, nddlm, nno, nnos, nnom, regula(6)
    real(kind=8) :: geom(ndim, *), deplp(dimuel), defgep(npi*dimdef)
! ======================================================================
! --- BUT : CALCUL DE EPSI_ELGA -----------------------------------
! ======================================================================
    integer :: kpi, i, n
    real(kind=8) :: poids, poids2, b(dimdef, dimuel)
! ======================================================================
! --- BOUCLE SUR LES POINTS D'INTEGRATION ------------------------------
! ======================================================================
    do 100 kpi = 1, npi
! ======================================================================
! --- DEFINITION DE L'OPERATEUR B (DEFINI PAR E=B.U) -------------------
! ======================================================================
        call cabr2g(kpi, ipoids, ipoid2, ivf, ivf2,&
                    idfde, idfde2, geom, dimdef, dimuel,&
                    ndim, nddls, nddlm, nno, nnos,&
                    nnom, axi, regula, b, poids,&
                    poids2)
! ======================================================================
! --- CALCUL DES DEFORMATIONS GENERALISEES E=B.U -----------------------
! ======================================================================
        do 10 i = 1, dimdef
            defgep((kpi-1)*dimdef+i)=0.0d0
            do 20 n = 1, dimuel
                defgep((kpi-1)*dimdef+i) = defgep( (kpi-1)*dimdef+i) + b(i,n)*deplp(n)
 20         continue
 10     continue
100 end do
! ======================================================================
end subroutine
