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

subroutine nmcrpc(result)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit     none
#include "asterfort/exisd.h"
#include "asterfort/infdbg.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/ltcrsd.h"
#include "asterfort/ltnotb.h"
#include "asterfort/tbajpa.h"
#include "asterfort/tbcrsd.h"
    character(len=8) :: result
!
! ----------------------------------------------------------------------
!
! ROUTINE *_NON_LINE (STRUCTURES DE DONNES)
!
! CREATION DE LA TABLE DES PARAMETRES CALCULES
!
! ----------------------------------------------------------------------
!
! IN  RESULT : NOM SD RESULTAT
!
! ----------------------------------------------------------------------
!
    integer :: nbpar
    parameter   (nbpar=8)
    character(len=2) :: typpar(nbpar)
    character(len=10) :: nompar(nbpar)
! ----------------------------------------------------------------------
    integer :: ifm, niv, iret
    character(len=19) :: tablpc
    data         nompar / 'NUME_REUSE','INST'      ,'TRAV_EXT  ',&
     &                      'ENER_CIN'  ,'ENER_TOT'  ,'TRAV_AMOR ',&
     &                      'TRAV_LIAI' ,'DISS_SCH'/
    data         typpar / 'I'         ,'R'         ,'R'         ,&
     &                      'R'         ,'R'         ,'R'         ,&
     &                      'R'         ,'R'/
!
! ----------------------------------------------------------------------
!
    call jemarq()
    call infdbg('MECA_NON_LINE', ifm, niv)
!
! --- CREATION DE LA LISTE DE TABLES SI ELLE N'EXISTE PAS
!
    call jeexin(result//'           .LTNT', iret)
    if (iret .eq. 0) call ltcrsd(result, 'G')
!
! --- RECUPERATION DU NOM DE LA TABLE CORRESPONDANT
!     AUX PARAMETRE CALCULES
!
    tablpc = ' '
    call ltnotb(result, 'PARA_CALC', tablpc)
!
! --- LA TABLE PARA_CALC EXISTE-T-ELLE ?
!
    call exisd('TABLE', tablpc, iret)
!
! --- NON, ON LA CREE
!
    if (iret .eq. 0) then
        call tbcrsd(tablpc, 'G')
        call tbajpa(tablpc, nbpar, nompar, typpar)
    endif
!
    call jedema()
!
end subroutine
