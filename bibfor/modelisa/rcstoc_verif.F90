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

subroutine rcstoc_verif(nomfcz, nomclz, nomrz, nbmax)
    implicit none
#include "jeveux.h"
#include "asterfort/foverf.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"

    character(len=*) :: nomfcz
    character(len=*) :: nomclz
    character(len=*) :: nomrz
    integer :: nbmax
! ----------------------------------------------------------------------
!
    real(kind=8) :: e1, ei, precma, valrr(4)
    character(len=24) :: valkk(2)
    character(len=19) :: nomfct
    character(len=8) :: nomcle
    character(len=32) :: nomrc
    integer :: vali
    integer :: k, i, ii, jrpv, nbcoup
    integer :: iret, nbfct, nbpts, nbptm
    character(len=24), pointer :: prol(:) => null()
! ----------------------------------------------------------------------
!
    call jemarq()
!
    nomfct = nomfcz
    nomcle = nomclz
    nomrc = nomrz
    call jeveuo(nomfct//'.PROL', 'L', vk24=prol)
    if (prol(1)(1:1) .eq. 'F') then
        call jelira(nomfct//'.VALE', 'LONMAX', nbptm)
        if (nomrc(1:8) .eq. 'TRACTION') then
            if (nbptm .lt. 4) then
                call utmess('F', 'MODELISA6_71', sk=nomcle)
            endif
        endif
        if (nomrc(1:13) .eq. 'META_TRACTION') then
            if (nbptm .lt. 2) then
                call utmess('F', 'MODELISA6_72', sk=nomcle)
            endif
        endif
        nbcoup = nbptm / 2
        if (nbptm .ge. nbmax) nbmax = nbptm
!
        call jeveuo(nomfct//'.VALE', 'L', jrpv)
        if (zr(jrpv) .le. 0.d0) then
            valkk (1) = nomcle
            valkk (2) = nomfct
            valrr (1) = zr(jrpv)
            call utmess('F', 'MODELISA9_59', nk=2, valk=valkk, sr=valrr(1))
        endif
        if (zr(jrpv+nbptm/2) .le. 0.d0) then
            valkk (1) = nomcle
            valkk (2) = nomfct
            valrr (1) = zr(jrpv+nbptm/2)
            call utmess('F', 'MODELISA9_60', nk=2, valk=valkk, sr=valrr(1))
        endif
!        VERIF ABSCISSES CROISSANTES (AU SENS LARGE)
        iret=2
        call foverf(zr(jrpv), nbcoup, iret)
        iret = 0
        e1 = zr(jrpv+nbcoup) / zr(jrpv)
        precma = 1.d-10
!
        do i = 1, nbcoup-1
            ei = (zr(jrpv+nbcoup+i) - zr(jrpv+nbcoup+i-1) ) / ( zr(jrpv+i) - zr(jrpv+i-1)&
                    )
            if (ei .gt. e1) then
                iret = iret + 1
                valkk (1) = nomcle
                valrr (1) = e1
                valrr (2) = ei
                valrr (3) = zr(jrpv+i)
                call utmess('E', 'MODELISA9_61', sk=valkk(1), nr=3, valr=valrr)
            else if ((e1-ei)/e1 .le. precma) then
                valkk (1) = nomcle
                valrr (1) = e1
                valrr (2) = ei
                valrr (3) = precma
                valrr (4) = zr(jrpv+i)
                call utmess('A', 'MODELISA9_62', sk=valkk(1), nr=4, valr=valrr)
            endif
        enddo
        if (iret .ne. 0) then
            call utmess('F', 'MODELISA6_73')
        endif
!
    else if (prol(1)(1:1) .eq. 'N') then
        call jelira(nomfct//'.VALE', 'NUTIOC', nbfct)
        nbptm = 0
        do k = 1, nbfct
            call jelira(jexnum(nomfct//'.VALE', k), 'LONMAX', nbpts)
            nbcoup = nbpts / 2
            if (nbpts .ge. nbmax) nbmax = nbpts
            if (nomrc(1:8) .eq. 'TRACTION') then
                if (nbpts .lt. 4) then
                    call utmess('F', 'MODELISA6_74')
                endif
            endif
            if (nomrc(1:13) .eq. 'META_TRACTION') then
                if (nbpts .lt. 2) then
                    call utmess('F', 'MODELISA6_75', sk=nomcle)
                endif
            endif
            call jeveuo(jexnum(nomfct//'.VALE', k), 'L', jrpv)
            if (zr(jrpv) .le. 0.d0) then
                vali = k
                valkk (1) = nomcle
                valkk (2) = nomfct
                valrr (1) = zr(jrpv)
                call utmess('F', 'MODELISA9_63', nk=2, valk=valkk, si=vali,&
                            sr=valrr(1))
            endif
            if (zr(jrpv+nbpts/2) .le. 0.d0) then
                vali = k
                valkk (1) = nomcle
                valkk (2) = nomfct
                valrr (1) = zr(jrpv+nbpts/2)
                call utmess('F', 'MODELISA9_64', nk=2, valk=valkk, si=vali,&
                            sr=valrr(1))
            endif

!           verif abscisses croissantes (au sens large)
            iret=2
            call foverf(zr(jrpv), nbcoup, iret)
            iret = 0
            e1 = zr(jrpv+nbcoup) / zr(jrpv)
            do i = 1, nbcoup-1
                ei = (&
                        zr(jrpv+nbcoup+i) - zr(jrpv+nbcoup+i-1) ) / ( zr(jrpv+i) - zr(jrpv+i&
                        &-1)&
                        )
                if (ei .gt. e1) then
                    iret = iret + 1
                    valkk (1) = nomcle
                    valrr (1) = e1
                    valrr (2) = ei
                    valrr (3) = zr(jrpv+i)
                    call utmess('E', 'MODELISA9_65', sk=valkk(1), nr=3, valr=valrr)
                endif
            enddo
            if (iret .ne. 0) then
                call utmess('F', 'MODELISA6_73')
            endif
        enddo
!
    else
        call utmess('F', 'MODELISA6_76')
    endif
!
    call jedema()
end subroutine
