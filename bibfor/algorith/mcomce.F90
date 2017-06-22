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

subroutine mcomce(noma, newgeo, nummai, coor, alias,&
                  nno)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit     none
#include "jeveux.h"
!
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/mmelty.h"
    character(len=8) :: noma
    character(len=19) :: newgeo
    integer :: nummai
    real(kind=8) :: coor(27)
    character(len=8) :: alias
    integer :: nno
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - APPARIEMENT - UTILITAIRE)
!
! CALCUL DES COORDONNEES DES NOEUDS D'UNE MAILLE
!
! ----------------------------------------------------------------------
!
!
! IN  NOMA   : NOM DU MAILLAGE
! IN  NEWGEO : COORDONNES DE TOUS LES NOEUDS
! IN  NUMMAI : NUMERO ABSOLU DE LA MAILLE DANS LE MAILLAGE
! OUT COOR   : COORDONNEES DES NOEUDS DE LA MAILLE
! OUT ALIAS  : TYPE DE LA MAILLE
! OUT NNO    : NOMBRE DE NOEUDS DE LA MAILLE
!
!
!
!
    integer ::  jdes
    integer :: ino, no(9)
    real(kind=8), pointer :: vale(:) => null()
!
!-----------------------------------------------------------------------
!
    call jemarq()
!
    call jeveuo(newgeo(1:19)//'.VALE', 'L', vr=vale)
    call jeveuo(jexnum(noma//'.CONNEX', nummai), 'L', jdes)
!
! --- INITIALISATIONS
!
    coor(1:27) = 0.d0
!
! --- INFOS SUR LA MAILLE
!
    call mmelty(noma, nummai, alias, nno)
!
! --- NUMEROS ABSOLUS DES NOEUDS DE LA MAILLE
!
    do ino = 1, nno
        no(ino) = zi(jdes+ino-1)
    end do
!
! --- COORDONNEES DES NOEUDS DE LA MAILLE
!
    do ino = 1, nno
        coor(3*(ino-1)+1) = vale(1+3*(no(ino)-1))
        coor(3*(ino-1)+2) = vale(1+3*(no(ino)-1)+1)
        coor(3*(ino-1)+3) = vale(1+3*(no(ino)-1)+2)
    end do
!
    call jedema()
end subroutine
