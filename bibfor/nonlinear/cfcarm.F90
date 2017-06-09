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

subroutine cfcarm(noma, defico, newgeo, posmai, typmai,&
                  nummai, alias, nommai, ndim, nnomam,&
                  coorma)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit     none
#include "jeveux.h"
!
#include "asterfort/assert.h"
#include "asterfort/cfnben.h"
#include "asterfort/cfnumm.h"
#include "asterfort/cftypm.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jenuno.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnum.h"
#include "asterfort/mmtypm.h"
    character(len=8) :: noma, alias
    character(len=24) :: defico
    character(len=19) :: newgeo
    integer :: posmai, nummai
    integer :: nnomam, ndim
    real(kind=8) :: coorma(27)
    character(len=8) :: nommai
    character(len=4) :: typmai
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (METHODES MAILLEES - UTILITAIRE)
!
! CARACTERISTIQUES DE LA MAILLE
!
! ----------------------------------------------------------------------
!
!
! IN  NOMA   : NOM DU MAILLAGE
! IN  DEFICO : SD DE CONTACT (DEFINITION)
! IN  NEWGEO : COORDONNEES REACTUALISEES DES NOEUDS DU MAILLAGE
! IN  POSMAI : INDICE DE LA MAILLE (DANS SD CONTACT)
! OUT TYPMAI : TYPE DE LA MAILLE (MAITRE OU ESCLAVE)
! OUT NUMMAI : INDICE ABSOLU DE LA MAILLE (DANS SD MAILLAGE)
! OUT NNOMAM : NOMBRE DE NOEUDS DE LA MAILLE (AU SENS DES SD CONTACT)
! OUT NDIM   : DIMENSION DE LA MAILLE
! OUT ALIAS  : TYPE GEOMETRIQUE DE LA MAILLE
! OUT NOMMAI : NOM DE LA MAILLE
! OUT COORMA : COORDONNEES DES NOEUDS DE LA MAILLE
!
!
!
!
    integer :: nbnmax
    parameter   (nbnmax = 9)
!
    integer :: no(nbnmax)
    integer :: ino, jdec
    real(kind=8), pointer :: vale(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- RECUPERATION DE QUELQUES DONNEES
!
    call jeveuo(newgeo(1:19)//'.VALE', 'L', vr=vale)
!
! --- INITIALISATIONS
!
    coorma(1:27) = 0.d0
!
! --- TYPE DE LA MAILLE
!
    call cftypm(defico, posmai, typmai)
!
! --- NUMERO ABSOLU DE LA MAILLE
!
    call cfnumm(defico, posmai, nummai)
!
! --- NOMBRE DE NOEUDS DE LA MAILLE
!
    call cfnben(defico, posmai, 'CONNEX', nnomam)
    if (nnomam .gt. nbnmax) then
        ASSERT(.false.)
    endif
!
! --- TYPE DE LA MAILLE
!
    call mmtypm(noma, nummai, nnomam, alias, ndim)
!
! --- NUMEROS ABSOLUS DES NOEUDS DE LA MAILLE
!
    call jeveuo(jexnum(noma//'.CONNEX', nummai), 'L', jdec)
    do ino = 1, nnomam
        no(ino) = zi(jdec+ino-1)
    end do
!
! --- COORDONNEES DES NOEUDS DE LA MAILLE
!
    do ino = 1, nnomam
        coorma(3*(ino-1)+1) = vale(1+3*(no(ino)-1))
        coorma(3*(ino-1)+2) = vale(1+3*(no(ino)-1)+1)
        coorma(3*(ino-1)+3) = vale(1+3*(no(ino)-1)+2)
    end do
!
! --- NOM DE LA MAILLE
!
    call jenuno(jexnum(noma//'.NOMMAI', nummai), nommai)
!
    call jedema()
!
end subroutine
