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

subroutine dtmprep_damp(sd_dtm_)
    implicit none
!
! person_in_charge: hassan.berro at edf.fr
!
! dtmprep_damp : Creation of a pseudo damping matrix from a list of damping coefficients
!                given by the user under the keywords LIST_AMOR and AMOR_MODAL in the 
!                command DYNA_TRAN_MODAL
!
!                The only parameter added/modified in the sd_dtm is : AMOR_DIA
!
#include "jeveux.h"
#include "asterc/r8prem.h"
#include "asterc/r8vide.h"
#include "asterfort/dtmget.h"
#include "asterfort/dtminivec.h"
#include "asterfort/getvid.h"
#include "asterfort/getvr8.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/r8inir.h"
#include "asterfort/rsadpa.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
!
!   -0.1- Input/output arguments
    character(len=*)          , intent(in) :: sd_dtm_
!
!   -0.2- Local variables
    integer           :: n1, n2, n, nbamor, nbmode
    integer           :: vali(3), iamog, iam, idiff
    integer           :: im, lamre
    real(kind=8)      :: rundef, epsi
    character(len=8)  :: sd_dtm, basemo, listam
    character(len=24) :: typeba, valk(1)
    real(kind=8), pointer :: puls(:) => null()
    real(kind=8), pointer :: masgen(:) => null()
    real(kind=8), pointer :: amogen(:) => null()
!
!   0 - Initializations
    sd_dtm = sd_dtm_
    rundef = r8vide()
    epsi   = r8prem()
!
!   1 - Retrieval of some necessary information
    call dtmget(sd_dtm, _NB_MODES, iscal=nbmode)
    call dtmget(sd_dtm, _BASE_MOD, kscal=basemo)
    call dtmget(sd_dtm, _TYP_BASE, kscal=typeba)
!
    call dtmget(sd_dtm, _OMEGA, vr=puls)
    call dtmget(sd_dtm, _MASS_DIA, vr=masgen)
!
    call dtminivec(sd_dtm, _AMOR_DIA, nbmode, vr=amogen)
!
!   2 - Command keywords
    call getvr8('AMOR_MODAL', 'AMOR_REDUIT', iocc=1, nbval=0, nbret=n1)
    call getvid('AMOR_MODAL', 'LIST_AMOR', iocc=1, nbval=0, nbret=n2)
!
!   3 - Filling up the diagonal damping matrix given the user entries
    if ((n1.ne.0) .or. (n2.ne.0)) then
        if (n1 .ne. 0) then
            nbamor = -n1
        else
            call getvid('AMOR_MODAL', 'LIST_AMOR', iocc=1, scal=listam)
            call jelira(listam//'           .VALE', 'LONMAX', nbamor)
        endif
        if (nbamor .gt. nbmode) then
!
            vali (1) = nbmode
            vali (2) = nbamor
            vali (3) = nbmode
            valk (1) = 'PREMIERS COEFFICIENTS'
            call utmess('A', 'ALGORITH16_18', sk=valk(1), ni=3, vali=vali)
            if (n1 .ne. 0) then
                call getvr8('AMOR_MODAL', 'AMOR_REDUIT', iocc=1, nbval=nbmode,&
                            vect=amogen)
            else
                call jeveuo(listam//'           .VALE', 'L', iamog)
                do iam = 1, nbmode
                    amogen(iam) = zr(iamog+iam-1)
                enddo
            endif
        else if (nbamor.lt.nbmode) then
!
            if (n1 .ne. 0) then
                call getvr8('AMOR_MODAL', 'AMOR_REDUIT', iocc=1, nbval=nbamor,&
                            vect=amogen, nbret=n)
            else
                call jeveuo(listam//'           .VALE', 'L', iamog)
                do iam = 1, nbamor
                    amogen(iam) = zr(iamog+iam-1)
                enddo
            endif
            idiff = nbmode - nbamor
            vali (1) = idiff
            vali (2) = nbmode
            vali (3) = idiff
            call utmess('I', 'ALGORITH16_19', ni=3, vali=vali)
            do iam = nbamor + 1, nbmode
                amogen(iam) = amogen(nbamor)
            enddo
        else if (nbamor.eq.nbmode) then
!
            if (n1 .ne. 0) then
                call getvr8('AMOR_MODAL', 'AMOR_REDUIT', iocc=1, nbval=nbamor,&
                            vect=amogen, nbret=n)
            else
                call jeveuo(listam//'           .VALE', 'L', iamog)
                do iam = 1, nbamor
                    amogen(iam) = zr(iamog+iam-1)
                enddo
            endif
        endif
    else
        if (typeba(1:9) .eq. 'MODE_MECA') then
            call rsadpa(basemo, 'L', 1, 'AMOR_REDUIT', 1,&
                        0, sjv=lamre, istop=0)
            if (zr(lamre).ne.rundef) then
                do im = 1, nbmode
                    call rsadpa(basemo, 'L', 1, 'AMOR_REDUIT', im,&
                                0, sjv=lamre)
                    amogen(im) = zr(lamre)
                end do
            else 
                call r8inir(nbmode, 0.d0, amogen, 1)
            end if
        else 
            call r8inir(nbmode, 0.d0, amogen, 1)
        end if
    endif
!
    do im = 1, nbmode
!       --- Static modes : critical damping to avoid artifical dynamics
!           Note : dynamics of static modes are set as follows
!       M = k/omega^2    K = k   C = 2*sqrt(k*M) = Cc   M-1*C = 2*omega 
        if (abs(masgen(im)).lt.epsi) amogen(im)= 1.d0
        amogen(im) = 2.0d0*puls(im)*amogen(im)
    enddo
!
end subroutine
