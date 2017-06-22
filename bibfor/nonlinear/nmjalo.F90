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

subroutine nmjalo(sddisc, inst, prec, jalon)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit     none
#include "jeveux.h"
#include "asterc/r8vide.h"
#include "asterfort/compr8.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=19) :: sddisc
    real(kind=8) :: inst, prec, jalon
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (UTILITAIRE)
!
! PROCHAIN INSTANT DE PASSAGE DANS LA LISTE DES JALONS
!
! ----------------------------------------------------------------------
!
!
! IN  SDDISC : SD DISCRETISATION TEMPORELLE
! IN  INST   : INSTANT RECHERCHE
! IN  PREC   : PRECISION
! OUT JALON  : VALEUR DE L'INSTANT JALON TROUVE
!              VAUT R8VIDE SI L'INSTANT EST AU DELA DE LA LSITE
!
!
!
!
    character(len=24) :: tpsipo
    integer :: jipo
    integer :: ipo, nipo
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    jalon = r8vide()
!
! --- LISTE DES JALONS
!
    tpsipo = sddisc(1:19)//'.LIPO'
    call jelira(tpsipo, 'LONMAX', ival=nipo)
    call jeveuo(tpsipo, 'L', jipo)
!
! --- RECHERCHE PROCHAIN JALON
!
    do 10 ipo = 1, nipo
        if (compr8(zr(jipo-1+ipo),'GT',inst,prec,1)) then
            jalon = zr(jipo-1+ipo)
            goto 20
        endif
10  end do
20  continue
!
    call jedema()
end subroutine
