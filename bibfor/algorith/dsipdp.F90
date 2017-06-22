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

subroutine dsipdp(thmc, adcome, addep1, addep2, dimcon,&
                  dimdef, dsde, dspdp1, dspdp2, pre2tr)
! --- LOI DE COMPORTEMENT DE TYPE HOEK BROWN EN CONTRAINTES TOTALES ----
! --- ELASTICITE ISOTROPE ----------------------------------------------
! --- CRITERE DE PLASTICITE DE HEOK BROWN ------------------------------
! --- ECOULEMENT PLASTIQUE DE DRUCKER PRAGER ---------------------------
! ======================================================================
! OUT DSPDP1  DERIVEE DE SIP  PAR RAPPORT A PRE1
! OUT DSPDP2  DERIVEE DE SIP  PAR RAPPORT A PRE2
! ======================================================================
    implicit none
#include "asterf_types.h"
    aster_logical :: pre2tr
    integer :: adcome, addep1, addep2, dimcon, dimdef
    real(kind=8) :: dspdp1, dspdp2, dsde(dimcon, dimdef)
    character(len=16) :: thmc
! ======================================================================
!    CETTE ROUTINE CALCULE LES DERIVEES DE SIGMAP PAR RAPPORT
!    A P1 ET A P2 SELON LE CAS DE LA LOI DE COUPLAGE HYDRAULIQUE
!
!    INITIALISATIONS
    dspdp1 = 0.0d0
    dspdp2 = 0.0d0
    pre2tr = .false.
! ======================================================================
! --- CAS D'UNE LOI DE COUPLAGE DE TYPE LIQU_SATU ----------------------
! ======================================================================
    if (thmc .eq. 'LIQU_SATU') then
        dspdp1 = dspdp1+dsde(adcome+6,addep1)
        dspdp2 = 0.d0
! ======================================================================
! --- CAS D'UNE LOI DE COUPLAGE DE TYPE GAZ ----------------------------
! ======================================================================
    else if (thmc.eq.'GAZ') then
        dspdp1 = 0.d0
        dspdp2 = dspdp2+dsde(adcome+6,addep1)
        pre2tr = .true.
! ======================================================================
! --- CAS D'UNE LOI DE COUPLAGE DE TYPE LIQU_VAPE ----------------------
! ======================================================================
    else if (thmc.eq.'LIQU_VAPE') then
        dspdp1 = dspdp1+dsde(adcome+6,addep1)
        dspdp2 = 0.d0
! ======================================================================
! --- CAS D'UNE LOI DE COUPLAGE DE TYPE LIQU_VAPE_GAZ ------------------
! ======================================================================
    else if (thmc.eq.'LIQU_VAPE_GAZ') then
        dspdp1 = dspdp1+dsde(adcome+6,addep1)
        dspdp2 = dspdp2+dsde(adcome+6,addep2)
        pre2tr = .true.
! ======================================================================
! --- CAS D'UNE LOI DE COUPLAGE DE TYPE LIQU_GAZ -----------------------
! ======================================================================
    else if (thmc.eq.'LIQU_GAZ') then
        dspdp1 = dspdp1+dsde(adcome+6,addep1)
        dspdp2 = dspdp2+dsde(adcome+6,addep2)
        pre2tr = .true.
! ======================================================================
! --- CAS D'UNE LOI DE COUPLAGE DE TYPE LIQU_GAZ_ATM -------------------
! ======================================================================
    else if (thmc.eq.'LIQU_GAZ_ATM') then
        dspdp1 = dspdp1+dsde(adcome+6,addep1)
        dspdp2 = 0.0d0
! ======================================================================
! --- CAS D'UNE LOI DE COUPLAGE DE TYPE LIQU_AD_GAZ_VAPE ---------------
! ======================================================================
    else if (thmc.eq.'LIQU_AD_GAZ_VAPE') then
        dspdp1 = dspdp1+dsde(adcome+6,addep1)
        dspdp2 = dspdp2+dsde(adcome+6,addep2)
        pre2tr = .true.
! ======================================================================
    endif
! ======================================================================
end subroutine
