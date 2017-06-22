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

subroutine nmlssv(mode, lischa, nbsst)
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterc/getfac.h"
#include "asterfort/assert.h"
#include "asterfort/getvid.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"
    character(len=4) :: mode
    integer :: nbsst
    character(len=19) :: lischa
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (CALCUL - SOUS-STRUCTURATION)
!
! LECTURE ET PREPARATION POUR SOUS_STRUCT
!
! ----------------------------------------------------------------------
!
!
! IN  MODE   : TYPE d'OPERATION
!              'LECT' LIT LE MOT-CLEF 'SOUS_STRUC'
!              'INIT' CREE LE VECTEUR DES CHARGES POUR SOUS_STRUC
! IN  LISCHA : SD L_CHARGES
! OUT NBSST  : NOMBRE de SOUS-STRUCTURES
!
!
!
!
    character(len=24) :: fomul2
    integer :: jfomu2
    integer :: i, ibid
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    nbsst = 0
    if (mode .eq. 'LECT') then
        call getfac('SOUS_STRUC', nbsst)
    else if (mode.eq.'INIT') then
        call getfac('SOUS_STRUC', nbsst)
        if (nbsst .gt. 0) then
            fomul2 = lischa(1:19)//'.FCSS'
            call wkvect(fomul2, 'V V K24', nbsst, jfomu2)
            do 1 i = 1, nbsst
                call getvid('SOUS_STRUC', 'FONC_MULT', iocc=i, scal=zk24(jfomu2+i-1), nbret=ibid)
                if (ibid .eq. 0) then
                    zk24(jfomu2+i-1) = '&&CONSTA'
                endif
 1          continue
        endif
    else
        ASSERT(.false.)
    endif
    call jedema()
!
end subroutine
