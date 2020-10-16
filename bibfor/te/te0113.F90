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
!
subroutine te0113(option, nomte)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/get_value_mode_local.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"

    character(len=16) :: option, nomte
!
!     BUT:
!       OPTION : 'ROCH_ELNO'
!       DISPOSER DE PARAMETRES MATERIAU ET DE CARACTERISTIQUES DE POUTRE
!       DANS UN CHAMP ELNO
!       ELEMENTS POU_D_T
! ---------------------------------------------------------------------
!
    integer :: icodre(2), iret
    integer :: imate, nno, nbcmp, ino, ival, ndim, ino2
!
    real(kind=8) :: valres(2), young, k, nexpo
    real(kind=8) :: caragene(4), carageo(4)
    character(len=8)  :: valp(4)
    character(len=16) :: nomres(2)
!
! ----------------------------------------------------------------------
!
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nno)
    ASSERT(nno.eq.2)
    
    call jevech('PMATERC', 'L', imate)
    call jevech('PROCHRR', 'E', ival)
    
    nbcmp = 10

!   parametres elastique
    nomres(1) = 'E'
    call rcvalb('FPG1', 1, 1, '+', zi(imate),&
                ' ', 'ELAS', 0, '', [0.d0],&
                1, nomres, valres, icodre, 1)
    young = valres(1)

!   parametres de RAMBERG_OSGOOD
    nomres(1) = 'FACTEUR'
    nomres(2) = 'EXPOSANT'
    call rcvalb('FPG1', 1, 1, '+', zi(imate),&
                ' ', 'RAMBERG_OSGOOD', 0, '', [0.d0],&
                2, nomres, valres, icodre, 1)
                
    k = valres(1)
    nexpo = valres(2)
    
!   caractéristiques de poutre
    valp = ['A1 ','IY1','A2 ','IY2']
    call get_value_mode_local('PCAGNPO', valp, caragene, iret)
    valp = ['R1 ','EP1','R2 ','EP2']
    call get_value_mode_local('PCAGEPO', valp, carageo, iret)
    
    do ino = 1, nno
        if (ino.eq.1) then
            ino2 = 2
        else
            ino2 = 1
        endif
        zr(ival+(ino-1)*nbcmp-1+1) = young
        zr(ival+(ino-1)*nbcmp-1+2) = k
        zr(ival+(ino-1)*nbcmp-1+3) = nexpo
!       A
        zr(ival+(ino-1)*nbcmp-1+4) = caragene(2*(ino-1)+1)
!       I
        zr(ival+(ino-1)*nbcmp-1+5) = caragene(2*(ino-1)+2)
!       R
        zr(ival+(ino-1)*nbcmp-1+6) = carageo(2*(ino-1)+1)
!       EP
        zr(ival+(ino-1)*nbcmp-1+7) = carageo(2*(ino-1)+2)
!       valeur de l'autre noeud pour réduction
!       I2
        zr(ival+(ino-1)*nbcmp-1+8) = caragene(2*(ino2-1)+2)
!       R2
        zr(ival+(ino-1)*nbcmp-1+9) = carageo(2*(ino2-1)+1)
!       EP        
        zr(ival+(ino-1)*nbcmp-1+10) = carageo(2*(ino2-1)+2)
    enddo
! ----------------------------------------------------------------------
end subroutine
