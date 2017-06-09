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

subroutine mcopco(noma, newgeo, ndim, nummai, ksi1,&
                  ksi2, geom)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
!
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/mmelty.h"
#include "asterfort/mmvalp.h"
    character(len=8) :: noma
    character(len=19) :: newgeo
    integer :: ndim, nummai
    real(kind=8) :: ksi1, ksi2
    real(kind=8) :: geom(3)
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODE CONTINUE - APPARIEMENT - UTILITAIRE)
!
! CALCUL DES COORDONNEES D'UN NOEUD SUR UNE MAILLE A PARTIR
! DE SES COORDONNEES PARAMETRIQUES
!
! ----------------------------------------------------------------------
!
!
! IN  NOMA   : NOM DU MAILLAGE
! IN  NEWGEO : COORDONNEES DE TOUS LES NOEUDS
! IN  NUMMAI : NUMERO ABSOLU DE LA MAILLE DANS LE MAILLAGE
! IN  KSI1   : COORDONNEE PARAMETRIQUE KSI DU PROJETE
! IN  KSI2   : COORDONNEE PARAMETRIQUE ETA DU PROJETE
! OUT GEOM   : COORDONNEES DU NOEUD
!
!
!
!
    integer ::  jdes
    integer :: nno, ino, no(9)
    real(kind=8) :: coor(27)
    character(len=8) :: alias
    real(kind=8), pointer :: vale(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- ACCES AUX CHAMPS
!
    call jeveuo(newgeo(1:19)//'.VALE', 'L', vr=vale)
    call jeveuo(jexnum(noma//'.CONNEX', nummai), 'L', jdes)
!
! --- INITIALISATIONS
!
    geom(1:3) = 0.d0
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
! --- CALCUL DES COORDONNEES
!
    call mmvalp(ndim, alias, nno, 3, ksi1,&
                ksi2, coor, geom)
!
    call jedema()
end subroutine
