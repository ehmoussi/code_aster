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

subroutine irrcvx(fami, kpg, ksp, nmat, mater,&
                  sig, vin, seuil)
    implicit none
!
! person_in_charge: jean-luc.flejou at edf.fr
#include "asterfort/lcdevi.h"
#include "asterfort/lcnrts.h"
#include "asterfort/rcvarc.h"
#include "asterfort/utmess.h"
    character(len=*) :: fami
    integer :: kpg, ksp, nmat
    real(kind=8) :: mater(nmat, 2), sig(6), vin(*), seuil
!
! CONVEXE ELASTO PLASTIQUE A T+DT POUR (SIGF , VIND) DONNES
! ----------------------------------------------------------------------
! IN  :  FAMI   :  FAMILLE DES POINTS DE GAUSS
!        KPG    :  NUMERO DU POINT DE GAUSS
!        KSP    :  NUMERO DU SOUS POINT DE GAUSS
!        SIG    :  CONTRAINTE A T+DT
!        VIN    :  VARIABLES INTERNES A T
!        NMAT   :  DIMENSION MATER
!        MATER  :  COEFFICIENTS MATERIAU A T+DT
! OUT :  SEUIL  :  SEUIL  ELASTICITE  A T+DT
!
! ======================================================================
!
    real(kind=8) :: irrad, irraf, p, dev(6), k, n, p0
    real(kind=8) :: pk, penpe, kappa, r02, pe, spe
    integer :: iret
!
    real(kind=8) :: valrm(2)
!
!     RECUPERATION DE L IRRADIATION
    call rcvarc('F', 'IRRA', '-', fami, kpg,&
                ksp, irrad, iret)
    call rcvarc('F', 'IRRA', '+', fami, kpg,&
                ksp, irraf, iret)
! VARIABLES INTERNES
    p = vin(1)
! PARAMETRES MATERIAUX
    k = mater(7,2)
    n = mater(8,2)
    p0 = mater(9,2)
    kappa = mater(10,2)
    r02 = mater(11,2)
    penpe = mater(13,2)
    pk = mater(14,2)
    pe = mater(15,2)
    spe = mater(16,2)
!
    if (irraf .gt. irrad) then
        seuil = 1.d0
        goto 9999
    else if (irrad .gt. irraf*1.00001d0) then
        valrm(1) = irrad
        valrm(2) = irraf
        call utmess('I', 'COMPOR1_56', nr=2, valr=valrm)
    else
        call lcdevi(sig, dev)
        if (p .lt. pk) then
            seuil = lcnrts(dev) - kappa*r02
        else if (p.lt.pe) then
            seuil = lcnrts(dev) - ( spe + penpe*(p - pe) )
        else
            seuil = lcnrts(dev) - k*((p + p0)**n)
        endif
    endif
!
9999  continue
end subroutine
