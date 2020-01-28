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

subroutine cbchei(char, noma, ligrmo, fonree)
    implicit   none
#include "asterc/getfac.h"
#include "asterfort/cachei.h"
#include "asterfort/alcart.h"
#include "asterfort/getvid.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nocart.h"
#include "asterfort/utmess.h"
    character(len=4) :: fonree
    character(len=8) :: char, noma
    character(len=*) :: ligrmo
    integer :: nbfac, iepsi, ncmp
    character(len=5) :: para
    character(len=16) :: motfac
    character(len=19) :: carte
    character(len=24) :: chepsi
    character(len=8), pointer :: valv(:) => null()
    character(len=8), pointer :: vncmp(:) => null()
!     ------------------------------------------------------------------
!
    motfac = 'PRE_EPSI'
    call getfac(motfac, nbfac)
!
    if (nbfac .ne. 0) then
        para = 'EPSIN'
        
        iepsi = 0
        if (fonree .eq. 'REEL') then
            call getvid(motfac, 'EPSI', iocc=1, scal=chepsi, nbret=iepsi)
        endif
        
        if (iepsi .eq. 0) then
            call cachei(char, ligrmo, noma, fonree, para,&
                        motfac)
        else
            if (nbfac.gt.1) call utmess('F', 'CHARGES_5')
!
            carte = char//'.CHME.'//para
!
! ---            MODELE ASSOCIE AU LIGREL DE CHARGE
!
            call alcart('G', carte, noma, 'NEUT_K8')
            call jeveuo(carte//'.NCMP', 'E', vk8=vncmp)
            call jeveuo(carte//'.VALV', 'E', vk8=valv)
!
            ncmp = 1
            vncmp(1) = 'Z1'
            valv(1) = chepsi
            call nocart(carte, 1, ncmp)
        endif
    endif
!
end subroutine
