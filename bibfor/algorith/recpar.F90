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

subroutine recpar(neq, dti, dtmax, vmin, vvar,&
                  cmp, cdp, dtmin, nper, nrmax)
!
    implicit none
#include "asterfort/getvis.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/utmess.h"
    real(kind=8) :: vmin(*), cmp, cpmin, dtmin, dtmax, dti, cdp
    real(kind=8) :: valr(4)
    character(len=8) :: vvar
    character(len=24) :: valk
    integer :: neq, nper, nrmax, i, n1, nv
    integer :: vali(2)
!     RECUPERATION DES PARAMETRES D'ADAPTATION DU PAS
!-----------------------------------------------------------------------
! IN  : NEQ    : NOMBRE D'EQUATION
! IN  : DTI    : PAS INITIAL
! IN  : DTMAX  : PAS MAXIMAL
! OUT : VMIN   : TABLEAU DES VITESSES MINIMALES (PAR DDL)
! OUT : VVAR   : METHODE POUR CALCUL DE LA VITESSE MINIMALE
!                ('NORM' OU 'MAXI')
! OUT : CMP    : COEFFICIENT DE REMONTEE DU PAS DE TEMPS
! OUT : CDP    : COEFFICIENT DE DIVISION DU PAS DE TEMPS
! OUT : DTMIN  : PAS MINIMAL
! OUT : NPER   : NOMBRE DE POINTS PAR PERIODE
! OUT : NRMAX  : NOMBRE MAXIMAL DE REDUCTION DU PAS DE TEMPS
!                PAR PAS DE CALCUL
!
!
!     --- VITESSE DE REFERENCE ---
!
    call getvtx('SCHEMA_TEMPS', 'VITE_MIN', iocc=1, scal=vvar, nbret=nv)
    do i = 1, neq
        vmin(i) = 1.d-15
    end do
!
!     --- COEFFICIENT DE REMONTEE DU PAS DE TEMPS ---
!
    call getvr8('SCHEMA_TEMPS', 'COEF_MULT_PAS', iocc=1, scal=cmp, nbret=n1)
!
!     --- COEFFICIENT DE DIVISION DU PAS DE TEMPS ---
!
    call getvr8('SCHEMA_TEMPS', 'COEF_DIVI_PAS', iocc=1, scal=cdp, nbret=n1)
!
!     --- COEFFICIENT DETERMINANT DT MIN (=DT INIT * CPMIN) --
!
    call getvr8('SCHEMA_TEMPS', 'PAS_MINI', iocc=1, scal=dtmin, nbret=n1)
!
!     --- COEFFICIENT DETERMINANT DT MIN (=DT INIT * CPMIN) --
!
    if (n1 .eq. 0) then
        call getvr8('SCHEMA_TEMPS', 'PAS_LIMI_RELA', iocc=1, scal=cpmin, nbret=n1)
        dtmin = dti * cpmin
    endif
!
!     --- NOMBRE DE POINTS PAR PERIODE
!
    call getvis('SCHEMA_TEMPS', 'NB_POIN_PERIODE', iocc=1, scal=nper, nbret=n1)
!
!     --- NMAX_REDUC_PAS
!
    call getvis('SCHEMA_TEMPS', 'NMAX_ITER_PAS', iocc=1, scal=nrmax, nbret=n1)
!
!
    vali (1) = nper
    vali (2) = nrmax
    valr (1) = cmp
    valr (2) = cdp
    valr (3) = dtmin
    valr (4) = dtmax
    valk = vvar

end subroutine
