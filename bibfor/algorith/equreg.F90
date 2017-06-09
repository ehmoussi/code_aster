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

subroutine equreg(imate, option, compor, regula, dimdef,&
                  dimcon, defgep, ndim, contp, r,&
                  drde)
    implicit      none
#include "asterfort/reg2gr.h"
#include "asterfort/regcge.h"
#include "asterfort/regder.h"
    integer :: imate, dimdef, dimcon, regula(6), ndim
    real(kind=8) :: defgep(dimdef), contp(dimcon), r(dimcon)
    real(kind=8) :: drde(dimcon, dimdef)
    character(len=16) :: option, compor(*)
! ======================================================================
! --- BUT : ROUTINE POUR LA RESOLUTION DES LOI DE COMPORTEMENTS --------
! ---       SECOND GRADIENT --------------------------------------------
! ======================================================================
! --- VARIABLES LOCALES ------------------------------------------------
! ======================================================================
    integer :: i
    real(kind=8) :: sigp(ndim*ndim*ndim)
    real(kind=8) :: dsde2g(ndim*ndim*ndim, ndim*ndim*ndim)
! ======================================================================
! --- APPEL A LA RESOLUTION MECANIQUE DE LA LOI REGULARISANTE ----------
! ======================================================================
    call reg2gr(imate, compor, ndim, regula, dimdef,&
                defgep, sigp, dsde2g)
    call regcge(dimdef, dimcon, regula, ndim, defgep,&
                sigp, r)
! ======================================================================
! --- CALCUL DES DERIVEES DES CONTRAINTES GENERALISEES -----------------
! ======================================================================
    call regder(dimdef, dimcon, ndim, regula, dsde2g,&
                drde)
! ======================================================================
! --- RECUPERATION DU VECTEUR CONTRAINTES ------------------------------
! ======================================================================
    if (option(1:9) .eq. 'RAPH_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
        do 40 i = 1, dimcon
            contp(i)=r(i)
40      continue
    endif
! ======================================================================
end subroutine
