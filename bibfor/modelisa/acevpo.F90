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

subroutine acevpo(nbocc, nlm, nlg, ier)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterc/getres.h"
#include "asterfort/assert.h"
#include "asterfort/check_homo_grma.h"
#include "asterfort/check_homo_ratio.h"
#include "asterfort/codent.h"
#include "asterfort/getvr8.h"
#include "asterfort/getvtx.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"
    integer :: nbocc, nlm, nlg, ier
!     AFFE_CARA_ELEM
!     VERIFICATION DES MOTS CLES POUR L'ELEMENT POUTRE
! ----------------------------------------------------------------------
! IN  : NBOCC  : NOMBRE D'OCCURENCE
! OUT : NLM    : NOMBRE TOTAL DE MAILLE
! OUT : NLG    : NOMBRE TOTAL DE GROUPE DE MAILLE
! ----------------------------------------------------------------------
    aster_logical :: bon
    character(len=8) :: nomu, cara(100), kioc
    character(len=16) :: sec, vsec, concep, cmd
    integer :: vali(3)
!     ------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    integer :: i, ioc, nc, ncar, ng, nm, ns
    integer :: nsom, nv, nval, nvs
    real(kind=8) :: vale(100)
!-----------------------------------------------------------------------
    call jemarq()
    call getres(nomu, concep, cmd)
!
    nlm = 0
    nlg = 0
    do 100 ioc = 1, nbocc
        call codent(ioc, 'G', kioc)
        call getvtx('POUTRE', 'GROUP_MA', iocc=ioc, nbval=0, nbret=ng)
        call getvtx('POUTRE', 'MAILLE', iocc=ioc, nbval=0, nbret=nm)
        call getvtx('POUTRE', 'SECTION', iocc=ioc, scal=sec, nbret=ns)
        call getvtx('POUTRE', 'VARI_SECT', iocc=ioc, scal=vsec, nbret=nvs)
        call getvtx('POUTRE', 'CARA', iocc=ioc, nbval=0, nbret=nc)
        ncar = -nc
        call getvtx('POUTRE', 'CARA', iocc=ioc, nbval=ncar, vect=cara)
        call getvr8('POUTRE', 'VALE', iocc=ioc, nbval=0, nbret=nv)
        nval = -nv
!
        if (nval .ne. ncar) then
            vali (1) = ioc
            vali (2) = ncar
            vali (3) = nval
            call utmess('E', 'MODELISA9_31', ni=3, vali=vali)
            ier = ier + 1
        endif
!
        if (sec .eq. 'RECTANGLE') then
            if (vsec .eq. 'AFFINE') then
!
            endif
        else if (sec .eq. 'CERCLE') then
            if (vsec .eq. 'CONSTANT') then
                bon = .false.
                do 20 i = 1, ncar
                    if (cara(i) .eq. 'R') bon = .true.
 20             continue
                if (.not. bon) then
                    call utmess('E', 'MODELISA_66', sk=kioc)
                    ier = ier + 1
                endif
            else if (vsec .eq. 'HOMOTHETIQUE') then
                ASSERT(nval .le. 100)
                if (nm .ne. 0) then
                    call getvr8('POUTRE', 'VALE', iocc=ioc, nbval=nval, vect=vale)
                    call check_homo_ratio(cara, vale, min(nval, ncar))
                else
                    call check_homo_grma(cara, ncar)
                endif
            endif
        endif
!
! ---    GROUP_MA + GROUP_NO + NOEUD + MAILLE
        nsom = ng + nm
        if (nsom .eq. ng .or. nsom .eq. nm) then
            nlm = max(nlm,-nm)
            nlg = max(nlg,-ng)
        endif
!
100 end do
!
    call jedema()
end subroutine
