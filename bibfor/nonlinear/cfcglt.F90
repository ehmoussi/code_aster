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

subroutine cfcglt(resoco, iliai, glis)
!
!
    implicit     none
#include "jeveux.h"
!
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
    character(len=24) :: resoco
    integer :: iliai
    real(kind=8) :: glis
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (RESOLUTION)
!
! CALCUL DU GLISSEMENT - CAS PENALISE: JEU TOTAL
!
! ----------------------------------------------------------------------
!
!
! IN  RESOCO : SD DE TRAITEMENT NUMERIQUE DU CONTACT
! IN  ILIAI  : INDICE DE LA LIAISON COURANTE
! OUT GLIS   : GLISSEMENT TANGENT
!
!
!
!
    character(len=24) :: jeuite, jeux
    integer :: jjeuit, jjeux
    real(kind=8) :: jexold, jeyold, jexini, jeyini, jexnew, jeynew
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- LECTURE DES STRUCTURES DE DONNEES DE CONTACT
!
    jeuite = resoco(1:14)//'.JEUITE'
    jeux = resoco(1:14)//'.JEUX'
    call jeveuo(jeuite, 'L', jjeuit)
    call jeveuo(jeux, 'L', jjeux)
!
! --- JEUX TANGENTS AVANT ITERATION DE NEWTON
!
    jexold = zr(jjeuit+3*(iliai-1)+2-1)
    jeyold = zr(jjeuit+3*(iliai-1)+3-1)
!
! --- INCR. JEUX TANGENTS DEPUIS LE DEBUT DU PAS DE TEMPS SANS CORR.
!
    jexini = zr(jjeux+3*(iliai-1)+2-1)
    jeyini = zr(jjeux+3*(iliai-1)+3-1)
!
! --- JEU TANGENT RESULTANT
!
    jexnew = jexold - jexini
    jeynew = jeyold - jeyini
    glis = sqrt(jexnew**2+jeynew**2)
!
    call jedema()
!
end subroutine
