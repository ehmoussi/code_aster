! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
!
subroutine pmmaco(nommat, nbmat, codi)
!
implicit none
!
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveut.h"
#include "asterfort/matcod.h"
#include "asterfort/wkvect.h"
!
character(len=8) :: nommat(*)
integer :: nbmat
character(len=19) :: codi

!-----------------------------------------------------------------------
! OPERATEUR CALC_POINT_MAT : MATERIAU CODE COMME RCMACO MAIS SANS MODELE
!-----------------------------------------------------------------------
!
!     BUT: CREER L'OBJET NOMMAT//'      .CODI' ,LE REMPLIR ET RENVOYER
!          SON ADRESSE PAR RAPPORT A ZI
!
! IN   NOMMAT : NOM DU MATERIAU
! OUT  CODI   : OBJET MATERIAU CODE (VOIR DESCRIPTION DANS MATCOD)
!
! ----------------------------------------------------------------------
!
    aster_logical :: l_ther
    integer :: indmat, imate, igrp, ingrp, i
    character(len=8) :: nommats, matercod
! ----------------------------------------------------------------------
!
    call jemarq()
!
! - Only mechanic !
!
    l_ther = ASTER_FALSE
!
    nommats = '&chpoint'

    call jedetr(nommats//'.MATE_CODE.GRP')
    call jedetr(nommats//'.MATE_CODE.NGRP')
    call wkvect(nommats//'.MATE_CODE.GRP', 'V V K8', nbmat, igrp)
    call wkvect(nommats//'.MATE_CODE.NGRP', 'V V I', 1, ingrp)
    do i=1,nbmat
        zk8(igrp-1+i)=nommat(i)
    enddo
    zi(ingrp)=1
!
    call jeveut(nommats//'.MATE_CODE.GRP', 'L', igrp)
!
    codi=' '
    indmat=0
!   imate : numero de groupe ?
    imate=1
    matercod='matcod'
    call matcod(nommats, indmat, nbmat, imate, igrp,&
                matercod, codi, l_ther)
    call jedema()
!
end subroutine
