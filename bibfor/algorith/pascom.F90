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

subroutine pascom(meca, sddyna, sddisc)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/ndynlo.h"
#include "asterfort/ndynre.h"
#include "asterfort/rsadpa.h"
#include "asterfort/utdidt.h"
#include "asterfort/utmess.h"
    character(len=8) :: meca
    character(len=19) :: sddyna, sddisc
!
! ----------------------------------------------------------------------
!
! ROUTINE DYNA_NON_LINE (UTILITAIRE)
!
! EVALUATION DU PAS DE TEMPS DE COURANT POUR LE MODELE
! PRISE EN COMPTE D'UNE BASE MODALE
!
! ----------------------------------------------------------------------
!
!
!
! IN  MECA   : BASE MODALE (MODE_MECA)
! IN  SDDYNA : SD DEDIEE A LA DYNAMIQUE (CF NDLECT)
! IN  SDDISC : SD DISCRETISATION
!
!
!
!
    integer :: n1, i
    integer :: iad, nbinst
    integer :: nbmode
    integer :: iorol
    real(kind=8) :: dtcou, phi, dt
    character(len=8) :: k8bid, stocfl
    integer, pointer :: ordr(:) => null()
    real(kind=8), pointer :: ditr(:) => null()
!
! ---------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
!
!     INITIALISATION DE DTCOU
!
    dtcou = -1.d0
!
!     --- RECUPERATION DES FREQUENCES PROPRES
!
    call jelira(meca//'           .ORDR', 'LONUTI', nbmode)
    call jeveuo(meca//'           .ORDR', 'L', vi=ordr)
    iorol = ordr(1)
    call rsadpa(meca, 'L', 1, 'OMEGA2', iorol,&
                0, sjv=iad, styp=k8bid)
    if (zr(iad) .lt. 0.d0 .or. abs(zr(iad)) .lt. r8prem( )) then
        dtcou = 1.d0 / r8prem( )
    else
        dtcou = 1.d0 / sqrt(zr(iad))
    endif
    do i = 1, nbmode-1
        iorol = ordr(1+i)
        call rsadpa(meca, 'L', 1, 'OMEGA2', iorol,&
                    0, sjv=iad, styp=k8bid)
        if (zr(iad) .lt. 0.d0 .or. abs(zr(iad)) .lt. r8prem( )) then
            dt = 1.d0 / r8prem( )
        else
            dt = 1.d0 / sqrt(zr(iad))
        endif
!       DT = 1.D0 / SQRT(ZR(IAD))
        if (dt .lt. dtcou) dtcou = dt
    end do
!
    call getvtx('SCHEMA_TEMPS', 'STOP_CFL', iocc=1, scal=stocfl, nbret=n1)
!
!     VERIFICATION DE LA CONFORMITE DE LA LISTE D'INSTANTS
    call utdidt('L', sddisc, 'LIST', 'NBINST',&
                vali_ = nbinst)
    call jeveuo(sddisc//'.DITR', 'L', vr=ditr)
!
    if (ndynlo(sddyna,'DIFF_CENT')) then
        dtcou =dtcou/(2.d0)
        call utmess('I', 'DYNAMIQUE_7', sr=dtcou)
    else
        if (ndynlo(sddyna,'TCHAMWA')) then
            phi=ndynre(sddyna,'PHI')
            dtcou = dtcou/(phi*2.d0)
            call utmess('I', 'DYNAMIQUE_8', sr=dtcou)
        else
            call utmess('F', 'DYNAMIQUE_1')
        endif
    endif
!
    do i = 1, nbinst-1
        if (ditr(i+1)-ditr(i) .gt. dtcou) then
            if (stocfl(1:3) .eq. 'OUI') then
                call utmess('F', 'DYNAMIQUE_2')
            else
                call utmess('A', 'DYNAMIQUE_2')
            endif
        endif
    end do
!
    call jedema()
!
end subroutine
