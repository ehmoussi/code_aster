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

function exi_fiss(model)
    implicit none
!
#include "jeveux.h"
#include "asterf_types.h"
!
    character(len=8) :: model
    aster_logical :: exi_fiss

!     BUT : VERIFIE L EXISTENCE D UNE FISSURE XFEM AVEC FOND DANS LE MODELE
!     -----------------------------------------------------------------
!
! MODEL IN   K8 : NOM DU MODEL
!
#include "asterfort/jeveuo.h"
#include "asterfort/dismoi.h"
#include "asterfort/jeexin.h"
!
    character(len=8) :: nomfis
    character(len=16) :: typdis
    integer :: jmofis, jnfiss, nfiss, ifiss, iret
!---------------------------------------------------------------------
!
!
    exi_fiss=.false._1
    nfiss=0
    call jeexin(model//'.FISS', iret)
    if (iret.le.0) goto 99
    call jeveuo(model//'.FISS','L',jmofis)
    call jeveuo(model//'.NFIS','L',jnfiss)
    nfiss = zi(jnfiss)
!

    do ifiss = 1,nfiss
        nomfis = zk8(jmofis-1+ifiss)
        call dismoi('TYPE_DISCONTINUITE', nomfis, 'FISS_XFEM', repk=typdis)     
        if(typdis.eq.'FISSURE') then
            exi_fiss=.true.
            exit
        endif
    enddo
!
99  continue
!
end function
