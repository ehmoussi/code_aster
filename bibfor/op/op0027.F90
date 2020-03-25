! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine op0027()

!      OPERATEUR :     CALC_H
!
!      BUT:CALCUL DU TAUX DE RESTITUTION D'ENERGIE PAR LA METHODE THETA
!          CALCUL DES FACTEURS D'INTENSITE DE CONTRAINTES
! ======================================================================
! person_in_charge: tanguy.mathieu at edf.fr
!
use calcG_type
!
implicit none
!
!
#include "asterc/getres.h"
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/cgcrtb.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/getvis.h"
#include "asterfort/getvtx.h"
#include "asterfort/infmaj.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/tbajli.h"
#include "asterfort/tbajvi.h"
#include "asterfort/tbajvk.h"
#include "asterfort/tbajvr.h"
#include "asterfort/titre.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/cgVerification.h"
#include "jeveux.h"
!
#include "asterfort/deprecated_algom.h"
#include "asterfort/utimsd.h"
!
    integer, parameter :: nxpara = 15
    character(len=8) :: litypa(nxpara), typfis, k8bid

    integer :: nbmxpa
    parameter (nbmxpa = 20)
!
    integer :: livi(nbmxpa), iord, iadfis
    real(kind=8) :: livr(nbmxpa), time, g(1)
    complex(kind=8) :: livc(nbmxpa)
    character(len=24) :: livk(nbmxpa)
!
    character(len=16) :: option, linopa(nxpara)
    integer :: nbpara, ndim, numfon, ibid, lfond
    aster_logical, parameter :: lmoda = ASTER_FALSE
!
    character(len=24), parameter :: chfond='&&0100.FONDFISS'
!
!
    type(CalcG_field) :: cgField
    type(CalcG_study) :: cgStudy
    type(CalcG_theta) :: cgTheta
!
    call jemarq()
    call infmaj()
    call deprecated_algom('CALC_H')
!
! --- Initialization
!
    call cgField%initialize()
    call cgStudy%initialize()
    call cgTheta%initialize()
!
! --- Verification
!
    call cgVerification(cgField, cgTheta)
!
! --- Compute Theta
!
!    call cgComputeTheta(cgField, cgTheta)












!
!
!     CREATION DE LA cgField%table_out // TEMPORAIRE
!
    call cgcrtb(cgField%table_out, option, ndim, typfis, nxpara, lmoda, nbpara, linopa, litypa)
!
    call getvis('THETA', 'NUME_FOND', iocc=1, scal=numfon, nbret=ibid)

    call tbajvi(cgField%table_out, nbpara, 'NUME_FOND', numfon, livi)
    lfond=10
    if (typfis.ne.'THETA') then
        call wkvect(chfond, 'V V R', lfond, iadfis)
    else
        iadfis=0
    endif
    k8bid = 'K8_BIDON'
   ! call tbajvk(cgField%table_out, nbpara, 'ABSC_CURV_NORM', 0.0, livr)
   ! call tbajvk(cgField%table_out, nbpara, 'TEMP', 0.0, livr)
   ! call tbajvk(cgField%table_out, nbpara, 'COMPORTEMENT', k8bid, livk)


!
    iord = 1
    call tbajvi(cgField%table_out, nbpara, 'NUME_ORDRE', iord, livi)
    time = 2.0
    call tbajvr(cgField%table_out, nbpara, 'INST', time, livr)
!
    call tbajvr(cgField%table_out, nbpara, 'COOR_X', zr(iadfis),   livr)
    call tbajvr(cgField%table_out, nbpara, 'COOR_Y', zr(iadfis+1), livr)

    g(1)= 123456789.0
    call tbajvr(cgField%table_out, nbpara, 'G', g(1), livr)
    call tbajli(cgField%table_out, nbpara, linopa, livi, livr, livc, livk, 0)
!
    !call utimsd(6, 2, .true._1, .true._1,cgField%table_out, 1, ' ')

!
    call titre()
!
    call jedema()
!
end subroutine
